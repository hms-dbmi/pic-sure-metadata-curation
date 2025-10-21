do LANGUAGE Plpgsql
$$
    BEGIN
        raise INFO 'starting curation of derived symptoms metadata';
    END
$$;
create schema if not exists processing_metadata;
drop table if exists processing_metadata.derived_symptoms_meta;
create table if not exists processing_metadata.derived_symptoms_meta as

select meta_utils_id.value                                                                           as dataset_ref,
       lower(colname || '_' || infect_yn_curr || '_' || visit_month_curr) || meta_utils_suffix.value        as name,
       colname || ' (Biostats Derived Symptoms ' || infect_yn_curr || ', ' || visit_month_curr || ' Months Post Index)' as display,
       (case
            when data_type = 'numeric' then 'continuous'
            else 'categorical'
           end)                                                                                      as concept_type,
       '\' || meta_utils_id.value || '\' || meta_utils_name.value || '\biostats_derived\symptoms\' || colname || '_' ||
       infect_yn_curr || '_' || visit_month_curr || meta_utils_suffix.value || '\'                   as concept_path,
       json_build_object(
           --metadata key: description
               'description',
               coalesce(full_desc || ' ', '') || 'Participants are ' || infect_yn_curr || ' and '||visit_month_curr||' months past index date. '|| 'Derived from biostats_derived_symptoms source tsv.' ||
               case
                   when (colname ~ 'date') or (colname ~ 'dt') then
                       ' Dates have been shifted to protect anonymity.'
                   else ''
                   end
           ,
           --metadata key: drs_uri
               'drs_uri',
               drs.uri
       )::TEXT                                                                                              as metadata
from input.derived_symptoms
         CROSS JOIN LATERAL json_each_text(row_to_json(derived_symptoms)) AS j(colname, val)
         left join information_schema.columns
                   on table_schema = 'input' and table_name = 'derived_symptoms' and column_name = colname
         left join (select value from resources.meta_utils where key = 'study_id') as meta_utils_id on true
         left join (select value from resources.meta_utils where key = 'dataset_name') as meta_utils_name on true
         left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix on true
         LEFT JOIN (select coalesce(redcap_desc || ' ', '') || coalesce(description, '') as full_desc, variable
                             from dictionary_files.derived_symptoms) as dict on dict.variable = column_name
         left join (select array_to_json(array_agg(ga4gh_drs_uri))::text as uri
                    from resources.manifest
                    where (file_name ~* '.*derived.*visits.*')
                      and (file_name ~* (select value from resources.meta_utils where key = 'dataset_name')
                        OR file_name ~* (select replace(value, '_', '') || '_'
                                         from resources.meta_utils
                                         where key = 'dataset_name'))) as drs on true
where colname != 'record_id'
  and colname != 'participant_id'
group by colname, data_type, meta_utils_id.value, meta_utils_name.value, meta_utils_suffix.value, drs.uri,
         infect_yn_curr, visit_month_curr, full_desc;

do LANGUAGE Plpgsql
$$
    BEGIN
        raise INFO 'successfully completed curation of derived symptoms metadata';
    END
$$;

