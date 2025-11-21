-- Create recommended indexes first
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_derived_symptoms_metadata 
ON input.derived_symptoms (infect_yn_curr, visit_month_curr, record_id);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_meta_utils_key 
ON resources.meta_utils (key);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_manifest_derived_visits 
ON resources.manifest (file_name) 
WHERE file_name ~* '.*derived.*visits.*';

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_dict_derived_symptoms_var 
ON dictionary_files.derived_symptoms (variable);

CREATE OR REPLACE FUNCTION create_derived_symptoms_metadata()
RETURNS void AS
$$
DECLARE
    study_id_val text;
    dataset_name_val text;
    dataset_suffix_val text;
    drs_uri_val text;
BEGIN
    RAISE INFO 'Starting curation of derived symptoms metadata';
    

    SELECT value INTO study_id_val FROM resources.meta_utils WHERE key = 'study_id';
    SELECT value INTO dataset_name_val FROM resources.meta_utils WHERE key = 'dataset_name';
    SELECT value INTO dataset_suffix_val FROM resources.meta_utils WHERE key = 'dataset_suffix';

    SELECT array_to_json(array_agg(ga4gh_drs_uri))::text 
    INTO drs_uri_val
    FROM resources.manifest
    WHERE (file_name ~* '.*derived.*visits.*')
      AND (
          (file_name ~* dataset_name_val) OR 
          (file_name ~* (replace(dataset_name_val, '_', '') || '_'))
      );
    
    -- Create schema and table
    CREATE SCHEMA IF NOT EXISTS processing_metadata;
    DROP TABLE IF EXISTS processing_metadata.derived_symptoms_meta;
    

    CREATE TABLE processing_metadata.derived_symptoms_meta AS
    SELECT 
        study_id_val as dataset_ref,
        lower(colname || '_' || infect_yn_curr || '_' || replace(visit_month_curr::text, '-','minus')) || dataset_suffix_val as name,
        colname || ' (Biostats Derived Symptoms ' || infect_yn_curr || ', ' || visit_month_curr || ' Months Post Index)' as display,
        (CASE
            WHEN data_type = 'numeric' THEN 'continuous'
            ELSE 'categorical'
         END) as concept_type,
        '\' || study_id_val || '\' || dataset_name_val || '\biostats_derived\symptoms\' || colname || '\' ||
        infect_yn_curr || '\' || replace(visit_month_curr::text, '-','minus') || '\' as concept_path,
        json_build_object(
            'description',
            COALESCE(full_desc || ' ', '') || 'Participants are ' || infect_yn_curr || ' and '||visit_month_curr||' months past index date. '|| 'Derived from biostats_derived_symptoms source tsv.' ||
            CASE
                WHEN (colname ~ 'date') OR (colname ~ 'dt') THEN
                    ' Dates have been shifted to protect anonymity.'
                ELSE ''
            END,
            'drs_uri',
            drs_uri_val
        )::TEXT as metadata
    FROM input.derived_symptoms_decoded
    CROSS JOIN LATERAL json_each_text(row_to_json(derived_symptoms_decoded)) AS j(colname, val)
    LEFT JOIN information_schema.columns
        ON table_schema = 'input' 
        AND table_name = 'derived_symptoms' 
        AND column_name = colname
    LEFT JOIN (
        SELECT 
            variable,
            COALESCE(redcap_desc || ' ', '') || COALESCE(description, '') as full_desc
        FROM dictionary_files.derived_symptoms
    ) as dict ON dict.variable = column_name
    WHERE colname != 'record_id'
      AND colname != 'participant_id'
    GROUP BY colname, data_type, infect_yn_curr, visit_month_curr, full_desc;
    
    RAISE INFO 'Successfully completed curation of derived symptoms metadata';
END;
$$ LANGUAGE plpgsql;

SELECT create_derived_symptoms_metadata();
