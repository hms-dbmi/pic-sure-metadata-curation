drop table if exists processing_metadata.biospecimens_meta;
create table processing_metadata.biospecimens_meta as (
    select
        meta_utils_id.value as dataset_ref,
    lower(regexp_replace(biospecimens.specimen_concept_cd, ':', '_')) || '_kit_id' || meta_utils_suffix.value as name,
    specimen_type as display,
    'categorical' as concept_type,
    '\' || meta_utils_id.value || '\' || meta_utils_name.value || '\biospecimens\' ||  lower(regexp_replace(biospecimens.specimen_concept_cd, ':', '_')) || '_kit_id' || '\' as concept_path,
    json_build_object(
        --metadata key: description
        'description',
        'Kit Ids corresponding to specimen of type "' || specimen_type || '".' ||
            (case when min_volume is not null and max_volume is not null
                then ' Min volume among samples was ' || min_volume::numeric || ' ' || unit || ' and max volume was ' || max_volume::numeric || ' ' || unit || '. '
                else '' end)
        || ' See biospecimen.tsv file for further specimen information.' ,
        --metadata key: drs_uri
        'drs_uri',
        drs.uri
    ) as metadata
    from
    (select specimen_concept_cd, specimen_type from input.biospecimens group by specimen_concept_cd, specimen_type)  as biospecimens
    left join
        (select specimen_concept_cd,
        array_agg(distinct(kit_id)) as text_val,
        min(specimen_volume) as min_volume,
        max(specimen_volume) as max_volume,
        min(specimen_volume_units) as unit
        from input.biospecimens
        group by specimen_concept_cd) as ad
    on ad.specimen_concept_cd = biospecimens.specimen_concept_cd
    left join  (select value from resources.meta_utils where key = 'study_id') as meta_utils_id on true
    left join (select value from resources.meta_utils where key = 'dataset_name') as meta_utils_name on true
    left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix on true
    left join (select array_to_json(array_agg(ga4gh_drs_uri))::text as uri
               from resources.manifest
               where (file_name ~* 'biospecimens')
                 and file_name ~* (select value from resources.meta_utils where key = 'dataset_name')) as drs on true
);
