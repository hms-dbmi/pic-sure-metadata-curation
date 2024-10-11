SELECT
participant_id, 
visit_id,
form_name,
field_name,
field_type,
CASE WHEN field_type = 'choice'
THEN answer_label
else 
case when field_type = 'numeric'
then
answer_numeric_val::text
else
answer_text_val
end 
end
as answer,
conecpt_cd,
trim(trailing ':' from regexp_replace(regexp_replace(concept_name, ' \([-]*[0-9].*\)', ''), '\(.*,.*\)', ''))
 as concept_name,
CONCAT('\phs003461\recover_pediatric_caregiver\', replace(trim(both ' ' from visit_id), ' ', '_'), '\', form_name, '\',
       field_name, '\') as
    concept_path,
CONCAT('\phs003461\recover_pediatric_caregiver\', replace(trim(both ' ' from visit_id), ' ', '_'), '\', form_name, '\') as
    concept_path_parent
INTO
peds_caregiver.answers_curated
FROM peds_caregiver.answerdata

