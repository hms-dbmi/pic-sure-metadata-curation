DO LANGUAGE Plpgsql $$
    BEGIN
        RAISE INFO 'starting curation of derived core proc metadata';
    END
$$;
CREATE SCHEMA IF NOT EXISTS processing_metadata;
DROP TABLE IF EXISTS processing_metadata.derived_core_meta;
CREATE TABLE IF NOT EXISTS processing_metadata.derived_core_meta AS SELECT
                                                                        meta_utils_id.value AS dataset_ref,
                                                                        colname || '_derived_core' || meta_utils_suffix.value AS name,
                                                                        colname || ' (biostats derived core proc)' AS display,
                                                                        (CASE WHEN data_type = 'numeric' THEN 'continuous' ELSE 'categorical' END) AS concept_type,
                                                                        '\' || meta_utils_id.value || '\' || meta_utils_name.value || '\biostats_derived_core_proc\'
                                                                        || LOWER(colname) || meta_utils_suffix.value || '\' AS concept_path,
                                                                        JSON_BUILD_OBJECT(
                                                                            --metadata key: description
                                                                        'description', 'Derived from biostats_derived_core_proc source tsv.' || CASE
                                                                                                                                                WHEN (colname ~ 'date') OR (colname ~ 'dt')
                                                                                                                                                    THEN ' Dates have been shifted to protect anonymity.'
                                                                                                                                                ELSE ''
                                                                                                                                                END,
                                                                            --metadata key: drs_uri
                                                                        'drs_uri', drs.uri) AS metadata
                                                                        FROM sample.derived_core
                                                                            CROSS JOIN LATERAL JSON_EACH_TEXT(ROW_TO_JSON(derived_core)) AS j(colname, val)
                                                                            LEFT JOIN information_schema.columns
                                                                                ON table_schema = 'sample' AND table_name = 'derived_core' AND column_name = colname
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
                                                                                        (file_name ~* 'derived_core') AND (file_name ~* (
                                                                                            SELECT value
                                                                                                FROM resources.meta_utils
                                                                                                WHERE key = 'dataset_name'
                                                                                                                                        )
                                                                                        OR file_name ~* (
                                                                                                SELECT REPLACE(value, '_', '') || '_'
                                                                                                    FROM resources.meta_utils
                                                                                                    WHERE key = 'dataset_name'
                                                                                                        ))
                                                                                      ) AS drs ON TRUE
                                                                        WHERE colname != 'record_id' AND colname != 'participant_id'
                                                                        GROUP BY colname, data_type, meta_utils_id.value, meta_utils_name.value,
                                                                            meta_utils_suffix.value, drs.uri;

DO LANGUAGE Plpgsql $$
    BEGIN
        RAISE INFO 'successfully completed curation of derived core proc metadata';
    END
$$;

