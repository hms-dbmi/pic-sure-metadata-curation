DO LANGUAGE Plpgsql
$$
    BEGIN
        RAISE INFO 'starting creation of table for answerdata metadata';
    END
$$;
CREATE OR REPLACE FUNCTION clean_path(
    concept_path text
) RETURNS text
AS
$$
DECLARE
    study_id text;
BEGIN
    SELECT value INTO study_id FROM resources.meta_utils WHERE key = 'study_id' LIMIT 1;
--remove stray spaces and quotes from ends of path
    concept_path = TRIM(BOTH ' "' FROM concept_path);
    IF (concept_path ~ '^\\')
    THEN
        --assume correct formatting for front of path and just prepend phs
        concept_path = '\' || study_id || '' || concept_path;
    ELSE
        --add the missing backslash
        concept_path = '\' || study_id || '\' || concept_path;
    END IF;
    IF (concept_path !~ '\\$')
    THEN
        --append missing backslash to end
        concept_path = concept_path || '\';
    END IF;
    IF (concept_path ~ '\\ ')
    THEN
        --append missing backslash to end
        concept_path = REGEXP_REPLACE(concept_path, '\\ ', '\\', 'g');
    END IF;
    concept_path = REGEXP_REPLACE(concept_path, '""', '', 'g');
    RETURN concept_path;
END
$$ LANGUAGE Plpgsql;

CREATE SCHEMA IF NOT EXISTS processing_metadata;
DROP TABLE IF EXISTS processing_metadata.answerdata_meta;
--answerdata
CREATE TABLE processing_metadata.answerdata_meta AS select distinct * from (select meta_utils_id.value                                                         AS dataset_ref,
                                                            LOWER(concept_code_rollup)                                                         AS name,
                                                            concept_name_rollup                                                         AS display,
                                                            '' AS concept_type,
                                                            clean_path(concept_path_rollup)                                                    AS concept_path,
                                                            JSON_BUILD_OBJECT(
                                                                --metadata key: description
                                                                    'description',
                                                                    'Answerdata Form: ' || form_name || ' Field: ' ||
                                                                    concepts.field_name ||
                                                                    (CASE
                                                                         WHEN concept_code_rollup ~ 'dt$' OR concept_name_rollup ~* '.*date.*'
                                                                             THEN ' Dates have been shifted to protect anonymity.'
                                                                         ELSE ''
                                                                        END),
                                                                --metadata key: drs_uri
                                                                    'drs_uri',
                                                                    drs.uri)::TEXT                                                            AS metadata
                                                     FROM input.concepts
                                                              LEFT JOIN (SELECT value
                                                                         FROM resources.meta_utils
                                                                         WHERE key = 'study_id') AS meta_utils_id
                                                                        ON TRUE
                                                              LEFT JOIN (SELECT value
                                                                         FROM resources.meta_utils
                                                                         WHERE key = 'dataset_name') AS meta_utils_name
                                                                        ON TRUE
                                                              LEFT JOIN (SELECT ARRAY_TO_JSON(ARRAY_AGG(ga4gh_drs_uri))::text AS uri
                                                                         FROM resources.manifest
                                                                         where (file_name ~* 'answerdata' OR file_name ~* 'concepts')
                                                                           and ((file_name ~*
                                                                                (select value from resources.meta_utils where key = 'dataset_name'))
                                                                             OR (file_name ~*
                                                                                (select (replace(value, '_', '') || '_')
                                                                                 from resources.meta_utils
                                                                                 where key = 'dataset_name')))) AS drs
                                                                        ON TRUE)metaq;
--TODO make an output of these vars
DELETE
FROM processing_metadata.answerdata_meta
WHERE name NOT IN (SELECT column_name
                   FROM information_schema.columns
                   WHERE table_schema = 'output_answerdata'
                     AND column_name != 'participant_id');

DO LANGUAGE Plpgsql
$$
    BEGIN
        RAISE INFO 'completed creation of table for answerdata metadata';
    END
$$;
