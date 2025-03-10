drop table if exists processing_metadata.demographics_meta;
create table processing_metadata.demographics_meta as
(
select 'phs003768' as dataset_ref,
colname as name,
regexp_replace(colname, '_demo', '') || ' (demographics)' as display,
'categorical' as concept_type,
'\phs003768\RECOVER_Autopsy\demographics\' || lower(colname)|| '\' as concept_path,
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
        '["drs://dg.4503:dg.4503%2Fd0a45055-bc73-47b1-be13-0d9528adf81d"]'
    ) as metadata
FROM output_demographics.demographics
CROSS JOIN LATERAL json_each_text(row_to_json(demographics)) AS j(colname,val)
where colname != 'participant_id'
group by colname
)
