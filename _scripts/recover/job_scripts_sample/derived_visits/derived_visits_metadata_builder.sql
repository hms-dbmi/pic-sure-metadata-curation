do LANGUAGE Plpgsql $$BEGIN
raise INFO 'starting curation of derived visits metadata';
END$$;
create schema if not exists processing_metadata;
drop table if exists processing_metadata.derived_visits_meta;
create table if not exists processing_metadata.derived_visits_meta as

select
    meta_utils_id.value as dataset_ref,
    colname|| '_derived_visits' || '_' || redcap_event_name || meta_utils_suffix.value as name,
    colname || ' (biostats derived visits ' || redcap_event_name ||')' as display,
    (case when data_type = 'numeric' then 'continuous'
          else 'categorical'
        end) as concept_type,
    '\' || meta_utils_id.value || '\' || meta_utils_name.value || '\biostats_derived_visits\' || colname|| '_derived_visits' || '_' || redcap_event_name || meta_utils_suffix.value|| '\' as concept_path,
    json_build_object(
        --metadata key: description
            'description',
            'Derived from biostats_derived_visits source tsv.' ||
            case when (colname ~ 'date') or (colname ~ 'dt') then
                     ' Dates have been shifted to protect anonymity.'
                 else ''
                end
        ,
        --metadata key: drs_uri
            'drs_uri',
            drs.uri
    ) as metadata
from sample.derived_visits
         CROSS JOIN LATERAL json_each_text(row_to_json(derived_visits)) AS j(colname,val)
         left join information_schema.columns on table_schema = 'input' and table_name = 'derived_visits' and column_name = colname
         left join  (select value from resources.meta_utils where key = 'study_id') as meta_utils_id on true
         left join (select value from resources.meta_utils where key = 'dataset_name') as meta_utils_name on true
         left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix on true
         left join (select array_to_json(array_agg(ga4gh_drs_uri))::text as uri
                    from resources.manifest
                    where (file_name ~* '.*derived.*visits.*')
                      and (file_name ~* (select value from resources.meta_utils where key = 'dataset_name') OR file_name ~* (select replace(value, '_', '') from resources.meta_utils where key = 'dataset_name'))) as drs on true
where colname != 'record_id' and colname != 'participant_id'
group by colname, data_type, meta_utils_id.value, meta_utils_name.value,meta_utils_suffix.value, drs.uri, redcap_event_name;

do LANGUAGE Plpgsql $$BEGIN
raise INFO 'successfully completed curation of derived visits metadata';
END$$;

