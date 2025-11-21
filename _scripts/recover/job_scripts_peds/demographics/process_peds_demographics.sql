do LANGUAGE Plpgsql $$BEGIN
raise INFO 'starting curation of demographics data';
END$$;
CREATE OR REPLACE FUNCTION copy_demographics_table()
returns void as
$$
DECLARE column_names varchar[];
DECLARE table_statement text;
BEGIN
	drop schema if exists output_demographics cascade;
	create schema output_demographics;
    raise INFO 'Starting creation of table from demographics file for dataset';
	select array_agg(column_string) into column_names from
                (select ('replace(' ||column_name || '::text,''\'',''/'') as ' || column_name || '_demo' || meta_utils_suffix.value) as column_string
                    from information_schema.columns
                    left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix on true
                    where
                        table_schema = 'input' and table_name = 'demographics' and column_name != 'participant_id'
                ) as subquery;
    table_statement = 'create table if not exists output_demographics.demographics as
        SELECT participant_id, '|| array_to_string(column_names, ', ') ||' FROM input.demographics';
    execute table_statement;
    raise INFO 'Successfully created table from demographics file for dataset';
END
$$ LANGUAGE Plpgsql;
select * from copy_demographics_table();
do LANGUAGE Plpgsql $$BEGIN
raise INFO 'successfully completed curation of demographics data';
END$$;

do LANGUAGE Plpgsql $$
BEGIN
raise INFO 'starting creation of table for demographics metadata';
END
$$;
drop table if exists processing_metadata.demographics_meta;
create table processing_metadata.demographics_meta as
(
select
    meta_utils_id.value as dataset_ref,
    colname as name,
    regexp_replace(colname, '_demo', '') || ' (demographics)' as display,
    'categorical' as concept_type,
            '\' || meta_utils_id.value || '\' || meta_utils_name.value ||  '\demographics\' || lower(colname)|| '\' as concept_path,
     json_build_object(
            --metadata key: description
            'description',
            'Sourced from demographics.tsv.' ||
                case when (colname ~ 'date') or (colname ~ 'dt') then
                    ' Dates have been shifted to protect anonymity.'
                else ''
                end
            ,
            --metadata key: drs_uri
            'drs_uri',
            drs.uri
        )::TEXT  as metadata
    FROM output_demographics.demographics
    CROSS JOIN LATERAL json_each_text(row_to_json(demographics)) AS j(colname,val)

        left join  (select value from resources.meta_utils where key = 'study_id') as meta_utils_id on true
        left join (select value from resources.meta_utils where key = 'dataset_name') as meta_utils_name on true
        left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix on true
        left join (select array_to_json(array_agg(ga4gh_drs_uri))::text as uri
        from resources.manifest
        where (file_name ~* 'demographics')
                          and  file_name ~* (select value || '/' from resources.meta_utils where key = 'file_substring')) as drs on true
    where colname != 'participant_id'
    group by colname, meta_utils_id.value, meta_utils_name.value, drs.uri

);
do LANGUAGE Plpgsql $$BEGIN
raise INFO 'successfully established table for demographics metadata';
END$$
