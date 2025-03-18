create schema if not exists processing_metadata;
drop table if exists processing_metadata.fitbit_meta;
create table processing_metadata.fitbit_meta as (
    select meta_utils_id.value as dataset_ref,
        lower(fitbit_concept_cd) as name,
        case
            when fitbit_concept_cd ~* '.*weekly.*'
                then
                concept_name || ' (Available weekly summary count)'
            else
                concept_name
        end as display,
        '' as concept_type,
        '\' || meta_utils_id.value || '\' || meta_utils_name.value || '\fitbit\' || lower(fitbit_concept_cd) || '\' as concept_path,
        json_build_object(
            --metadata key: description
        'description',
        case
            when fitbit_concept_cd ~* '.*weekly.*'
                then
                'Number of weekly summaries for participant available in source fitbit tsv.'
            when fitbit_concept_cd ~* '.*alltime.*'
                then
                'Alltime summary sourced from fitbit.tsv.'
            else
                'Fitbit device'
        end,
            --metadata key: drs_uri
        'drs_uri',
        drs.uri
        ) as metadata
        from
            (
                select fitbit_concept_cd, concept_name
                    from input.fitbit
                    group by fitbit_concept_cd, concept_name
            )
                as fitbit
                left join (
                select value
                    from resources.meta_utils
                    where key = 'study_id'
                          ) as meta_utils_id
                on true
                left join (
                select value
                    from resources.meta_utils
                    where key = 'dataset_name'
                          ) as meta_utils_name
                on true
                left join (
                select value
                    from resources.meta_utils
                    where key = 'dataset_suffix'
                          ) as meta_utils_suffix
                on true
                left join (
                select array_to_json(array_agg(ga4gh_drs_uri))::text as uri
                    from resources.manifest
                    where
                        (file_name ~* 'fitbit') and
                        file_name ~* (
                            select value
                                from resources.meta_utils
                                where key = 'dataset_name'
                                     )
                          ) as drs
                on true
                                                );