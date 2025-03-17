drop table if exists processing_metadata.visits_meta;
create table if not exists processing_metadata.visits_meta as

select '' || study_id || '' as dataset_ref,
colname|| '_' || visit_id as name,
colname || ' (' || visit_id || ')' as display,
(case when data_type = 'numeric' then 'continuous'
    else 'categorical'
    end) as concept_type,
'\' || study_id || '\RECOVER_Autopsy\visits\' || lower(colname|| '_' || visit_id)|| '\' as concept_path,
 json_build_object(
        --metadata key: description
        'description',
        'Derived from visits.tsv.' ||
            case when (colname ~ 'date') or (colname ~ 'dt') then
                ' Dates have been shifted to protect anonymity.'
            else ''
            end
        ,
        --metadata key: drs_uri
        'drs_uri',
        '["drs://dg.4503:dg.4503%2F912285ec-f103-4e5a-9338-f10750a77ab7"]'
    ) as metadata
from input.visits
CROSS JOIN LATERAL json_each_text(row_to_json(visits)) AS j(colname,val)
left join information_schema.columns on table_schema = 'input' and table_name = 'visits' and column_name = colname
where colname != 'participant_id'
group by colname, visit_id, data_type;



