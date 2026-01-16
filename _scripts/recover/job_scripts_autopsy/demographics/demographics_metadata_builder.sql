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
                          and (file_name ~* (select value from resources.meta_utils where key = 'dataset_name')
                          OR file_name ~* (select replace(value, '_', '')||'_' from resources.meta_utils where key = 'dataset_name'))) as drs on true
    where colname != 'participant_id'
    group by colname, meta_utils_id.value, meta_utils_name.value, drs.uri

);
do LANGUAGE Plpgsql $$BEGIN
raise INFO 'successfully established table for demographics metadata';
END$$
