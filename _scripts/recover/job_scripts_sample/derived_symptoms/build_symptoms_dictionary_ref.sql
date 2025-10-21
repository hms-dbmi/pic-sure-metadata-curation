--NOTE: This only needs to be run when there is an update to either the derived dictionary file (DataDictionary_Core_20230615.xlsx) or we receive an updated source REDCAP dictionary

/*alter table dictionary_files.derived_symptoms
drop column redcap_desc;*/

alter table dictionary_files.derived_symptoms
add column redcap_desc text;

update dictionary_files.derived_symptoms set
redcap_desc =
regexp_substr(field_label, '[^\<]*') from dictionary_files.redcap where variable_field_name = variable
and type ~ 'REDCap';

update dictionary_files.derived_symptoms set
redcap_desc =
  regexp_substr(concept_name, '[^\[]*') from sample.concepts where field_name != variable and variable = data_field_name
                                      and type ~ 'REDCap';
                                      
/*alter table dictionary_files.derived_symptoms
drop column decoding_values;*/

alter table dictionary_files.derived_symptoms
add column decoding_values json;

update dictionary_files.derived_symptoms set
decoding_values = decoding_vals from
(select json_agg(
    json_build_object(
        regexp_substr(split_label, '[^,]*'),
        trim(regexp_substr(split_label, '(?<=,).*'))
    )
) as decoding_vals, variable_field_name
FROM dictionary_files.redcap,
LATERAL unnest(regexp_split_to_array(choices_calculations_or_slider_labels, '\|')) AS split_label
where choices_calculations_or_slider_labels !~ '(NA)|^(if *\()|(^\[)'
group by variable_field_name
)ini
where variable_field_name = variable  and type ~ 'REDCap';

--NOTE: manually set all the checkbox vars (ie. race___0) to 1=Yes, 0=No because it was just easier

update dictionary_files.derived_symptoms set
decoding_values = decoding_vals from
--setting the decoding values for non-redcap vars to parsed levels from dictionary
(select json_agg(
    json_build_object(
        regexp_substr(split_label, '[^:]*'),
        trim(regexp_substr(split_label, '(?<=:).*'))
    )
) as decoding_vals, variable
FROM dictionary_files.derived_symptoms,
LATERAL unnest(regexp_split_to_array(levels, '\n')) AS split_label
where levels is not null and strpos(levels, ':') >0
group by variable
)ini
where ini.variable = derived_symptoms.variable  and type !~ 'REDCap';

