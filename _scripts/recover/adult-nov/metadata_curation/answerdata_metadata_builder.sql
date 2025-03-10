CREATE OR REPLACE FUNCTION clean_path(concept_path text)
	returns text as
	$$
	BEGIN
	    --remove stray spaces and quotes from ends of path
	    concept_path = trim(both ' "' from concept_path);
	    if(concept_path ~ '^\\') then
            --assume correct formatting for front of path and just prepend phs
            concept_path = '\phs003463' || concept_path;
        else
            --add the missing backslash
             concept_path = '\phs003463\' || concept_path;
        end if;
        if(concept_path !~ '\\$') then
            --append missing backslash to end
            concept_path = concept_path || '\';
        end if;
       if(concept_path ~ '\\ ') then
            --append missing backslash to end
            concept_path = regexp_replace(concept_path, '\\ ', '\\', 'g');
        end if;
        if(concept_path ~ ' \\') then
            --append missing backslash to end
            concept_path = regexp_replace(concept_path, ' \\', '\\', 'g');
        end if;
        concept_path = regexp_replace(concept_path, '""', '', 'g');
        return concept_path;
	END
	$$ LANGUAGE Plpgsql;

drop table if exists processing_metadata.answerdata_meta;
--answerdata
create table processing_metadata.answerdata_meta as (
    select lower(concept_code) as varname,
    concept_name as vardesc,
    null::text as docfile,
    field_type as type,
    (case when field_type = 'text' then array_to_string(text_val, '|')
    when field_type = 'choice' then array_to_string(answer_label, '|')
    end) as values,
    'Answerdata Form: ' || form_name || ' Field: ' || concepts.data_field_name ||
    (case when concept_code ~ 'dt$' or concept_name ~* '.*date.*'
    then ' Dates have been shifted to protect anonymity.'
    else '' end) as comment1,
    max_numeric as max,
    min_numeric as min,
    clean_path(concept_path) as picsure_concept_path,
    '["drs://dg.4503:dg.4503%2Fb413cdeb-6a0c-45e6-9c5e-61c6e2af4278","drs://dg.4503:dg.4503%2F90ac4ee5-5dec-442a-9e76-eb68df9e50d6"]' as drs_uri
    from processing.concepts left join
    (select conecpt_cd, min(field_type) as field_type, array_agg(distinct(answer_label)) as answer_label, min(answer_numeric_val::numeric) as min_numeric, max(answer_numeric_val::numeric) as max_numeric, array_agg(distinct(answer_text_val)) as text_val
    from adult.answerdata
    group by conecpt_cd) as ad on ad.conecpt_cd = concepts.concept_code
);