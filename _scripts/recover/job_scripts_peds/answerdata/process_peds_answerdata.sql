DO LANGUAGE Plpgsql
$$
    BEGIN
        RAISE INFO 'starting curation of answerdata to rollup concept paths, concept codes, and names and normalize on visit type';
    END
$$;

alter table input.concepts
    drop column if exists concept_path_rollup,
    drop column if exists concept_code_rollup,
    drop column if exists concept_name_rollup,
    add concept_path_rollup text,
    add concept_code_rollup text,
    add concept_name_rollup text;
alter table input.answerdata
    drop column if exists concept_code_rollup,
    add concept_code_rollup text;

create or replace function get_val(data_field_name TEXT)
    returns TEXT
as
$$
BEGIN
--finds the values as defined in the data_field_name after 3-4 underscores for ease of replacement in name, path, and code
    return coalesce(
            case
                when data_field_name ~ '_{4}'
                    then '-' || regexp_substr(
                        data_field_name, '(?<=_{4}).*')
                else
                    regexp_substr(
                            data_field_name,
                            '(?<=_{3,4}).*'
                    ) end,
            ''
           );
END
$$
    LANGUAGE Plpgsql;

drop table if exists input.updated_concepts;
create table input.updated_concepts as
    (select field_name,
            data_field_name,
            form_name,
            --concept code with values rolled up and visit type appended
            coalesce(
                    replace(concept_code, data_field_name, field_name) || '_' || get_clean_visit_type(visit_type),
                    concept_code || '_' || get_clean_visit_type(visit_type))
                                                 as concept_code_rollup,
            --concept name with value specific info removed and visit type appended in parentheses
            case
                when data_field_name != field_name
                    then
                    (regexp_replace(concept_name, ('\(' || get_val(data_field_name) || '\,.*\)'), ''))
                else
                    concept_name
                end || ' (' || visit_type || ')' as concept_name_rollup,
            --concept path with values rolled up and visit type appended
            (replace(concept_path,
                     '\' || get_val(data_field_name) || '\',
                     '\'
             ) || visit_type || '\')             as concept_path_rollup
     from input.concepts
              join (select distinct visit_type from input.answerdata) visits on true);
update input.answerdata
set concept_code_rollup = coalesce(
        replace(concept_cd, data_field_name, field_name) || '_' || get_clean_visit_type(visit_type),
        concept_cd || '_' || get_clean_visit_type(visit_type));

--Clear out the old concept paths that duplicate definitions for the same concept
delete from input.updated_concepts where concept_path_rollup ~ 'cw_pss' and updated_concepts.concept_code_rollup in
(select concept_code_rollup from input.updated_concepts group by concept_code_rollup having count(distinct concept_path_rollup) > 1);

delete from input.updated_concepts where concept_path_rollup ~ 'hcq_rel' and concept_code_rollup in(
select concept_code_rollup from input.updated_concepts
group by concept_code_rollup having count(distinct concept_path_rollup) > 1);

DO LANGUAGE Plpgsql
$$
    BEGIN
        RAISE INFO 'finished curation of answerdata to rollup concept paths, concept codes, and names and normalize on visit type';
    END
$$;

DROP SCHEMA IF EXISTS output_answerdata CASCADE;
CREATE SCHEMA output_answerdata;

-- Pre-create indexes (run this once before the function)
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_answerdata_form_field
ON input.answerdata (form_name, field_name) WHERE form_name IS NOT NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_answerdata_form_field_concept
ON input.answerdata (form_name, field_name, concept_code_rollup);

-- Increase work_mem for this session if possible
SET work_mem = '1GB';


CREATE OR REPLACE FUNCTION get_answerdata_crosstabs()
RETURNS void AS
$$
DECLARE
    form_field_record record;
    table_sql text;
    total_tables int := 0;
    column_defs text;
BEGIN
    RAISE INFO 'Starting answerdata data curation';

    SELECT COUNT(DISTINCT (form_name, field_name)) INTO total_tables
    FROM input.answerdata;

    RAISE INFO 'Creating % answerdata tables', total_tables;

    FOR form_field_record IN
        SELECT DISTINCT form_name, field_name
        FROM input.answerdata
        ORDER BY form_name, field_name
    LOOP
        SELECT string_agg(
            quote_ident(lower(concept_code_rollup)) || ' varchar',
            ', '
        ) INTO column_defs
        FROM (
            SELECT DISTINCT concept_code_rollup
            FROM input.answerdata
            WHERE form_name = form_field_record.form_name
              AND field_name = form_field_record.field_name
            ORDER BY concept_code_rollup
        ) updated_concepts;

        table_sql := format(
            'CREATE TABLE output_answerdata.%I AS '
            'SELECT * FROM crosstab('
                '%L, '
                '%L'
            ') AS ct(participant_id varchar, %s)',
            form_field_record.form_name || '_' || form_field_record.field_name,
            format(

                'SELECT participant_id, concept_code_rollup, '
                'CASE '
                    'WHEN field_type = ''numeric'' THEN trim_scale(answer_numeric_val::numeric)::text '
                    'WHEN field_type = ''text'' THEN regexp_replace(replace(answer_text_val, ''\'', ''/''), E''[\\n\\r]+'', '' '', ''g'')'
                    'ELSE answer_label '
                'END as answer_value '
                'FROM input.answerdata '
                'WHERE form_name = %L AND field_name = %L ORDER BY 1,2',
                form_field_record.form_name,
                form_field_record.field_name
            ),
            format(
                'SELECT DISTINCT concept_code_rollup FROM input.answerdata '
                'WHERE form_name = %L AND field_name = %L '
                'ORDER BY 1',
                form_field_record.form_name,
                form_field_record.field_name
            ),
            column_defs
        );

        EXECUTE table_sql;
        --RAISE INFO 'Created table: %', form_field_record.form_name || '_' || form_field_record.field_name;
    END LOOP;

    RAISE INFO 'Completed curation of all % tables', total_tables;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_answerdata_crosstabs();





--METATADATA PROCESSING

DO LANGUAGE Plpgsql
$$
    BEGIN
        RAISE INFO 'starting creation of table for answerdata metadata';
    END
$$;

CREATE SCHEMA IF NOT EXISTS processing_metadata;
DROP TABLE IF EXISTS processing_metadata.answerdata_meta;
--answerdata
CREATE TABLE processing_metadata.answerdata_meta AS select distinct * from (select meta_utils_id.value                                                         AS dataset_ref,
                                                            LOWER(concept_code_rollup)                                                         AS name,
                                                            concept_name_rollup                                                         AS display,
                                                            '' AS concept_type,
                                                                                   '\' || meta_utils_id.value || concept_path_rollup                                                 AS concept_path,
                                                            JSON_BUILD_OBJECT(
                                                                --metadata key: description
                                                                    'description',
                                                                    'Answerdata Form: ' || form_name || ' Field: ' ||
                                                                    updated_concepts.field_name ||
                                                                    (CASE
                                                                         WHEN concept_code_rollup ~ 'dt$' OR concept_name_rollup ~* '.*date.*'
                                                                             THEN ' Dates have been shifted to protect anonymity.'
                                                                         ELSE ''
                                                                        END),
                                                                --metadata key: drs_uri
                                                                    'drs_uri',
                                                                    drs.uri)::TEXT                                                            AS metadata
                                                     FROM input.updated_concepts
                                                              LEFT JOIN (SELECT value
                                                                         FROM resources.meta_utils
                                                                         WHERE key = 'study_id') AS meta_utils_id
                                                                        ON TRUE
                                                              LEFT JOIN (SELECT value
                                                                         FROM resources.meta_utils
                                                                         WHERE key = 'dataset_name') AS meta_utils_name
                                                                        ON TRUE
                                                              LEFT JOIN (SELECT ARRAY_TO_JSON(ARRAY_AGG(ga4gh_drs_uri))::text AS uri
                                                                         FROM resources.manifest
                                                                         where (file_name ~* 'answerdata' OR file_name ~* 'concepts')
                                                                           and ((file_name ~*
                                                                                (select value || '/'
                                                                                 from resources.meta_utils
                                                                                 where key = 'file_substring')))) AS drs
                                                                        ON TRUE)metaq;
--TODO make an output of these vars, removes any concepts that were in concepts table but not in actual metadata
DELETE
FROM processing_metadata.answerdata_meta
WHERE name NOT IN (SELECT column_name
                   FROM information_schema.columns
                   WHERE table_schema = 'output_answerdata'
                     AND column_name != 'participant_id');




DO LANGUAGE Plpgsql
$$
    BEGIN
        RAISE INFO 'completed curation of answerdata metadata';
    END
$$;
