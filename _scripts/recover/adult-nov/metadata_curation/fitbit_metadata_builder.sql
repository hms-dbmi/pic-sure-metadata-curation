drop table if exists processing_metadata.fitbit_meta;
create table processing_metadata.fitbit_meta as (
   select varname, vardesc, docfile, type, values, comment1, max, min, picsure_concept_path, drs_uri from (select lower(fitbit.fitbit_concept_cd) as varname,
    concept_name || ' (Available weekly summary count)' as vardesc,
    '' as docfile,
    'numeric' as type,
    null as values,
    'Number of weekly summaries for participant available in fitbit.tsv.' as comment1,
    '\phs003463\RECOVER_Adult\fitbit\' || lower(fitbit.fitbit_concept_cd)|| '\' as picsure_concept_path,
    '["drs://dg.4503:dg.4503%2F93b4509a-7e78-42a5-9303-9db457c65fdf"]' as drs_uri
    from
adult.fitbit where fitbit.fitbit_concept_cd ~* '.*weekly.*' group by fitbit.fitbit_concept_cd, concept_name)fitbit
left join (select fitbit_concept_cd, max(occurence_count) as max, min(occurence_count) as min from (select fitbit_concept_cd, count(summary_value) as occurence_count
                       from adult.fitbit group by fitbit_concept_cd, participant_id)ini group by fitbit_concept_cd) as fitbit_agg on lower(fitbit_agg.fitbit_concept_cd) = fitbit.varname

UNION

select lower(fitbit_concept_cd) as varname,
    concept_name as vardesc,
    '' as docfile,
    'numeric' as type,
    null as values,
    'Alltime summary sourced from fitbit.tsv.' as comment1,
    max(summary_value::numeric) as max,
    min(summary_value::numeric) as min,
    '\phs003463\RECOVER_Adult\fitbit\' || lower(fitbit.fitbit_concept_cd)|| '\' as picsure_concept_path,
    '["drs://dg.4503:dg.4503%2F93b4509a-7e78-42a5-9303-9db457c65fdf"]' as drs_uri
from adult.fitbit
where fitbit.fitbit_concept_cd ~* '.*alltime*' group by fitbit_concept_cd, concept_name

);