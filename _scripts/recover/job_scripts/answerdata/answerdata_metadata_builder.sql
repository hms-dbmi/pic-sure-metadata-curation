do LANGUAGE Plpgsql $$BEGIN
raise notice 'starting creation of table for answerdata metadata';
END$$;
CREATE OR REPLACE FUNCTION clean_path(concept_path text)
	returns text as
	$$
	DECLARE study_id text;
BEGIN
select value into study_id from resources.meta_utils where key = 'study_id' limit 1;
--remove stray spaces and quotes from ends of path
concept_path = trim(both ' "' from concept_path);
	    if(concept_path ~ '^\\') then
            --assume correct formatting for front of path and just prepend phs
            concept_path = '\' || study_id || '' || concept_path;
else
            --add the missing backslash
             concept_path = '\' || study_id || '\' || concept_path;
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
        meta_utils_id.value as dataset_ref,
    lower(concept_code) || '_' || meta_utils_name.value as name,
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
        drs.uri
    ) as metadata
    from input.concepts left join
    (select concept_cd, min(field_type) as field_type, array_agg(distinct(answer_label)) as answer_label,
    min(answer_numeric_val::numeric) as min_numeric, max(answer_numeric_val::numeric) as max_numeric, array_agg(distinct(answer_text_val)) as text_val
    from input.answerdata
    group by concept_cd) as ad on ad.concept_cd = concepts.concept_code
                        left join  (select value from resources.meta_utils where key = 'study_id') as meta_utils_id on true
                        left join (select value from resources.meta_utils where key = 'dataset_name') as meta_utils_name on true
                        left join (select array_to_json(array_agg(ga4gh_drs_uri))::text as uri
                                   from resources.manifest
                                   where (file_name ~* 'answerdata' or file_name ~* 'concepts')
                                     and file_name ~* (select value from resources.meta_utils where key = 'dataset_name')) as drs on true
);

delete from processing_metadata.answerdata_meta where name not in
                                                           (select column_name from information_schema.columns where
                                                               table_schema = 'output_answerdata' and column_name != 'participant_id')

    do LANGUAGE Plpgsql $$BEGIN
    raise notice 'completed creation of table for answerdata metadata';
    END$$;