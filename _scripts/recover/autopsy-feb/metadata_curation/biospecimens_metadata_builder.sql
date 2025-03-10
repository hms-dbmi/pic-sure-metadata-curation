drop table if exists processing_metadata.biospecimens_meta;
create table processing_metadata.biospecimens_meta as (
    select
    'phs003768' as dataset_ref,
    lower(regexp_replace(biospecimens.specimen_concept_cd, ':', '_')) || '_kit_id' as name,
    specimen_type as display,
    'categorical' as concept_type,
    '\phs003768\RECOVER_Autopsy\biospecimens\' ||  lower(regexp_replace(biospecimens.specimen_concept_cd, ':', '_')) || '_kit_id' || '\' as concept_path,
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
        '["drs://dg.4503:dg.4503%2F1933aeae-c9ea-472f-8925-5d69d5edccd4"]'
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
);