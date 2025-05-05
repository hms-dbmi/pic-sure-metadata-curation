select varname as variable_id, vardesc as variable_name, type as variable_type, comment1 as variable_description,
picsure_concept_path as data_hierarchy, drs_uri
from processing_metadata.demographics_meta;

select dataset_ref, name, display, concept_type, concept_path,
json_build_object('description', description,'drs_uri', drs_uri) as metadata from
(select 'phs003463' as dataset_ref, varname as name, vardesc as display, '' as concept_type, picsure_concept_path as concept_path,
comment1 as description, drs_uri
from metadata_output.recover_adult_metadata)innie



