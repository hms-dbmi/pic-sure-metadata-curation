CREATE OR REPLACE FUNCTION get_visits_subtables_with_visit_type()
	returns void as
	$$
	DECLARE table_names varchar[];
	DECLARE table_statement text;
    DECLARE t_name text;
    DECLARE column_names varchar[];
    DECLARE dataset_suffix varchar;
    DECLARE table_count int = 0;
	BEGIN
	    drop schema if exists output_visits cascade;
	    create schema output_visits;
        select array_agg(distinct(get_clean_visit_type(visit_type))) into table_names from input.visits;
        select value into dataset_suffix from resources.meta_utils where key = 'dataset_suffix';
        raise INFO 'Starting creation of % table(s) from visits table', array_upper(table_names, 1);
        FOR i IN 1 .. array_upper(table_names, 1)
        LOOP
            t_name=table_names[i];
            select array_agg(column_string) into column_names from
                (select (column_name || ' as ' || column_name || '_' || t_name || dataset_suffix ) as column_string
                from information_schema.columns where
                 table_schema = 'input' and table_name = 'visits' and column_name != 'participant_id')innie;

            table_statement = 'create table output_visits.' || quote_ident(t_name) || ' as
                (select participant_id, '||
                    array_to_string(column_names, ', ')
                 ||
                    ' from input.visits where get_clean_visit_type(visit_type) = ' || quote_literal(t_name) || ')';
            --raise INFO '%', table_statement;
            execute table_statement;
            table_count = table_count + 1;
        end loop;
        raise INFO 'Successfully created % table(s) from visits table', table_count;
	END
	$$ LANGUAGE Plpgsql;
	select * from get_visits_subtables_with_visit_type();

DO LANGUAGE Plpgsql $$
    BEGIN
        RAISE INFO 'starting curation of visits metadata';
    END
$$;
CREATE SCHEMA IF NOT EXISTS processing_metadata;
DROP TABLE IF EXISTS processing_metadata.visits_meta;
CREATE TABLE IF NOT EXISTS processing_metadata.visits_meta AS
      SELECT meta_utils_id.value AS dataset_ref,
      colname || '_' || get_clean_visit_type(visit_type) || meta_utils_suffix.value AS name,
      colname || ' (' || TRIM(visit_type) || ')' AS display,
      (CASE WHEN data_type = 'numeric' THEN 'continuous' ELSE 'categorical' END) AS concept_type,
      '\' || meta_utils_id.value || '\' || meta_utils_name.value || '\visits\'
      || LOWER(colname || '_' || TRIM(visit_type)) || '\' AS concept_path,
      JSON_BUILD_OBJECT(
          --metadata key: description
      'description', 'Derived from visits.tsv.' || CASE
                                                       WHEN (colname ~ 'date') OR (colname ~ 'dt')
                                                           THEN ' Dates have been shifted to protect anonymity.'
                                                       ELSE ''
                                                   END,
          --metadata key: drs_uri
      'drs_uri', drs.uri)::TEXT  AS metadata
      FROM input.visits
          CROSS JOIN LATERAL JSON_EACH_TEXT(ROW_TO_JSON(visits)) AS j(colname, val)
          LEFT JOIN information_schema.columns
              ON table_schema = 'input' AND table_name = 'visits' AND column_name = colname
          LEFT JOIN (
              SELECT value
                  FROM resources.meta_utils
                  WHERE key = 'study_id'
                    ) AS meta_utils_id ON TRUE
          LEFT JOIN (
              SELECT value
                  FROM resources.meta_utils
                  WHERE key = 'dataset_name'
                    ) AS meta_utils_name ON TRUE
          LEFT JOIN (
              SELECT value
                  FROM resources.meta_utils
                  WHERE key = 'dataset_suffix'
                    ) AS meta_utils_suffix ON TRUE
          LEFT JOIN (
              SELECT ARRAY_TO_JSON(ARRAY_AGG(ga4gh_drs_uri))::text AS uri
                  FROM resources.manifest
                  WHERE
                      file_name ~* 'visits' and file_name !~* 'derived'
                                            and (file_name ~* (select value || '/' from resources.meta_utils where key = 'file_substring')
                                           ))
                     AS drs ON TRUE
      WHERE colname != 'participant_id'
      GROUP BY colname, visit_type, data_type, meta_utils_id.value,
          meta_utils_name.value, meta_utils_suffix.value, visit_type, drs.uri;
DO LANGUAGE Plpgsql $$
    BEGIN

        RAISE INFO 'successfully completed curation of visits metadata';
    END
$$;
