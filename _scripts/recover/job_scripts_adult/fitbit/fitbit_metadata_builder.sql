do LANGUAGE Plpgsql $$BEGIN
raise INFO 'starting curation of fitbit metadata';
END$$;
CREATE SCHEMA IF NOT EXISTS processing_metadata;
DROP TABLE IF EXISTS processing_metadata.fitbit_meta;
CREATE TABLE processing_metadata.fitbit_meta AS (
    SELECT meta_utils_id.value AS dataset_ref,
        LOWER(fitbit_concept_cd) AS name,
        CASE
            WHEN fitbit_concept_cd ~* '.*weekly.*'
                THEN concept_name || ' (Available weekly summary count)'
            ELSE concept_name
        END AS display,
        '' AS concept_type,
        '\' || meta_utils_id.value || '\' || meta_utils_name.value || '\fitbit\' || LOWER(fitbit_concept_cd) || '\' AS concept_path,
        JSON_BUILD_OBJECT(
            --metadata key: description
        'description', CASE
                           WHEN fitbit_concept_cd ~* '.*weekly.*'
                               THEN 'Number of weekly summaries for participant available in source fitbit tsv.'
                           WHEN fitbit_concept_cd ~* '.*alltime.*'
                               THEN 'Alltime summary sourced from fitbit.tsv.'
                           ELSE 'Fitbit device'
                       END,
            --metadata key: drs_uri
        'drs_uri', drs.uri)::TEXT  AS metadata
        FROM (
            SELECT fitbit_concept_cd, concept_name FROM input.fitbit GROUP BY fitbit_concept_cd, concept_name
             ) AS fitbit
            LEFT JOIN (
                SELECT value
                    FROM resources.meta_utils
                    WHERE key = 'study_id'
                      ) AS meta_utils_id ON TRUE
            LEFT JOIN (
                SELECT value
                    FROM resources.meta_utils
                    WHERE key = 'dataset_name'
                      ) AS meta_utils_name ON TRUE
            LEFT JOIN (
                SELECT value
                    FROM resources.meta_utils
                    WHERE key = 'dataset_suffix'
                      ) AS meta_utils_suffix ON TRUE
            LEFT JOIN (
                SELECT ARRAY_TO_JSON(ARRAY_AGG(ga4gh_drs_uri))::text AS uri
                    FROM resources.manifest
                    WHERE
                        (file_name ~* 'fitbit')
                                              and (file_name ~* (select value from resources.meta_utils where key = 'dataset_name')
                                              OR file_name ~* (select replace(value, '_', '')||'_' from resources.meta_utils where key = 'dataset_name'))) AS drs ON TRUE
                                                );
do LANGUAGE Plpgsql $$BEGIN
raise INFO 'successfully completed curation of fitbit metadata';
END$$;
