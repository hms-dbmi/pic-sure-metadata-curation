
CREATE OR REPLACE FUNCTION clean_path(concept_path text)
	returns text as
	$$
	BEGIN
	    --remove stray spaces and quotes from ends of path
	    concept_path = trim(both ' "' from concept_path);
	    if(concept_path ~ '^\\') then
            --assume correct formatting for front of path and just prepend phs
            concept_path = '\phs003768' || concept_path;
        else
            --add the missing backslash
             concept_path = '\phs003768\' || concept_path;
        end if;
        if(concept_path !~ '\\$') then
            --append missing backslash to end
            concept_path = concept_path || '\';
        end if;
       if(concept_path ~ '\\ ') then
            --append missing backslash to end
            concept_path = regexp_replace(concept_path, '\\ ', '\\', 'g');
        end if;
        concept_path = regexp_replace(concept_path, '""', '', 'g');
        return concept_path;
	END
	$$ LANGUAGE Plpgsql;

create schema if not exists processing_metadata;
drop table if exists processing_metadata.answerdata_meta;
--answerdata
create table processing_metadata.answerdata_meta as (
    select
    'phs003768' as dataset_ref,
    lower(concept_code) as name,
    concept_name as display,
    (case when field_type = 'numeric' then 'continuous'
    else 'categorical'
    end) as concept_type,
    clean_path(concept_path) as concept_path,
    json_build_object(
        --metadata key: description
        'description',
        'Answerdata Form: ' || form_name || ' Field: ' || coalesce(concepts.data_field_name, concepts.field_name) ||
        (case when concept_code ~ 'dt$' or concept_name ~* '.*date.*'
        then ' Dates have been shifted to protect anonymity.'
        else '' end) ,
        --metadata key: drs_uri
        'drs_uri',
        '["drs://dg.4503:dg.4503%2F3f47e1d5-c686-422f-b8cc-7e0d66d441b6","drs://dg.4503:dg.4503%2F1a8e12d1-e5a6-4564-824b-ceb0f84e7d1b"]'
    ) as metadata
    from input.concepts left join
    (select concept_cd, min(field_type) as field_type, array_agg(distinct(answer_label)) as answer_label,
    min(answer_numeric_val::numeric) as min_numeric, max(answer_numeric_val::numeric) as max_numeric, array_agg(distinct(answer_text_val)) as text_val
    from input.answerdata
    group by concept_cd) as ad on ad.concept_cd = concepts.concept_code
);

delete from processing_metadata.answerdata_meta where name not in
(select column_name from information_schema.columns where
table_schema = 'output_answerdata' and column_name != 'participant_id')

