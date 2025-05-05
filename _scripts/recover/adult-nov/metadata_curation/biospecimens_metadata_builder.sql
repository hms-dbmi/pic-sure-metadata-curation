
create table processing_metadata.biospecimens_meta as (
    select lower(biospecimens.specimen_concept_cd) || '_kit_id' as varname,
    specimen_type as vardesc,
    '' as docfile,
    'text' as type,
    array_to_string(text_val, '|') as values,
    'Kit Ids corresponding to specimen of type "' || specimen_type || '".' ||
    (case when min_volume is not null and max_volume is not null
    then ' Min volume among samples was ' || min_volume::numeric || ' ' || unit || ' and max volume was ' || max_volume::numeric || ' ' || unit || '. '
    else '' end)
    || ' See biospecimen.tsv file for further specimen information.' as comment1,
    null::numeric as max,
    null::numeric as min,
    '\phs003463\RECOVER_Adult\biospecimens\' || lower(biospecimens.specimen_concept_cd) || '_kit_id' || '\' as picsure_concept_path,
    '["drs://dg.4503:dg.4503%2Fffe5e79c-e7de-47f3-9d32-7ad278d29824"]' as drs_uri
    from
    (select specimen_concept_cd, specimen_type from adult.biospecimens group by specimen_concept_cd, specimen_type)  as biospecimens
    left join
        (select specimen_concept_cd,
        array_agg(distinct(kit_id)) as text_val,
        min(specimen_volume) as min_volume,
        max(specimen_volume) as max_volume,
        min(specimen_volume_units) as unit
        from adult.biospecimens
        group by specimen_concept_cd) as ad
    on ad.specimen_concept_cd = biospecimens.specimen_concept_cd
);