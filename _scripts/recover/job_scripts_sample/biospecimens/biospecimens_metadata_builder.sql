do LANGUAGE Plpgsql $$BEGIN
raise INFO 'starting creation of table for biospecimens metadata';
END$$;
drop table if exists processing_metadata.biospecimens_meta;
create table processing_metadata.biospecimens_meta as (
    select
        meta_utils_id.value as dataset_ref,
    lower(regexp_replace(biospecimens.mpi_cd, ':', '_')) || '_kit_id' || meta_utils_suffix.value as name,
    mpi_type as display,
    'categorical' as concept_type,
    '\' || meta_utils_id.value || '\' || meta_utils_name.value || '\biospecimens\' ||  lower(regexp_replace(biospecimens.mpi_cd, ':', '_')) || '_kit_id' || '\' as concept_path,
    json_build_object(
        --metadata key: description
        'description',
        'Kit Ids corresponding to specimen of type "' || mpi_type || '".' ||
            (case when min_volume is not null and max_volume is not null
                then ' Min volume among samples was ' || min_volume::numeric || ' ' || unit || ' and max volume was ' || max_volume::numeric || ' ' || unit || '. '
                else '' end)
        || ' See biospecimen.tsv file for further specimen information.' ,
        --metadata key: drs_uri
        'drs_uri',
        drs.uri
    ) as metadata
    from
    (select mpi_cd, mpi_type from sample.biospecimens group by mpi_cd, mpi_type)  as biospecimens
    left join
        (select mpi_cd,
        array_agg(distinct(kit_id)) as text_val,
        min(specimen_volume) as min_volume,
        max(specimen_volume) as max_volume,
        min(specimen_volume_units) as unit
        from sample.biospecimens
        group by mpi_cd) as ad
    on ad.mpi_cd = biospecimens.mpi_cd
    left join  (select value from resources.meta_utils where key = 'study_id') as meta_utils_id on true
    left join (select value from resources.meta_utils where key = 'dataset_name') as meta_utils_name on true
    left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix on true
    left join (select array_to_json(array_agg(ga4gh_drs_uri))::text as uri
               from resources.manifest
               where (file_name ~* 'biospecimens')
                          and (file_name ~* (select value from resources.meta_utils where key = 'dataset_name')
                          OR file_name ~* (select replace(value, '_', '')||'_' from resources.meta_utils where key = 'dataset_name')))
                 as drs on true
);
do LANGUAGE Plpgsql $$BEGIN
raise INFO 'successfully established table for biospecimens metadata';
END$$
