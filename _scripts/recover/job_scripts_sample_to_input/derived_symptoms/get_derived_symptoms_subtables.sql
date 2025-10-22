
CREATE OR REPLACE FUNCTION get_derived_symptoms_decoded()
    returns void as
$$
DECLARE
    decoder              record;
BEGIN

    raise INFO 'Started building decoded data table for derived symptoms';
    drop table if exists input.derived_symptoms_decoded;
    CREATE TABLE input.derived_symptoms_decoded AS TABLE input.derived_symptoms;

    -- Create temporary table for mappings
    DROP TABLE IF EXISTS symptom_decoding_map;
    CREATE TEMP TABLE symptom_decoding_map AS
    SELECT ds.variable as variable_name,
           kv.key as key_value,
           kv.value as decoded_value
    FROM dictionary_files.derived_symptoms ds,
         LATERAL jsonb_array_elements(ds.decoding_values::jsonb) AS elem,
         LATERAL jsonb_each_text(elem) AS kv
    WHERE ds.decoding_values IS NOT NULL;

    -- Create index for better performance
    CREATE INDEX idx_symptom_decoding_map_lookup ON symptom_decoding_map (variable_name, key_value);


    FOR decoder IN
        SELECT DISTINCT variable_name
        FROM symptom_decoding_map
        LOOP
            EXECUTE format(
                  'UPDATE input.derived_symptoms_decoded
                   SET %1$I = COALESCE(tdm.decoded_value, %1$I)
                   FROM symptom_decoding_map tdm
                   WHERE %1$I::text = tdm.key_value
                     AND tdm.variable_name = %2$L',
                  decoder.variable_name,
                  decoder.variable_name);
        END LOOP;

    --Clean up
    DROP TABLE IF EXISTS symptom_decoding_map;
    raise INFO 'Finished building decoded data table for derived symptoms';
END
$$ LANGUAGE Plpgsql;


CREATE OR REPLACE FUNCTION get_derived_symptoms_subtables()
    returns void as
$$
DECLARE
    table_names          varchar[];
    table_statement      text;
    t_name               text;
    decoder              record;
BEGIN
    raise INFO 'Building subtables for derived symptoms from decoded data';
    drop schema if exists output_derived_symptoms cascade;
    create schema output_derived_symptoms;

    SELECT ARRAY_AGG(DISTINCT table_prop)
    INTO table_names
    FROM (SELECT LOWER(infect_yn_curr || '_' || REPLACE(visit_month_curr::text, '-', 'minus')) as table_prop
          FROM input.derived_symptoms_decoded
          WHERE infect_yn_curr IS NOT NULL
            AND visit_month_curr IS NOT NULL) subq;

    WITH column_template AS (SELECT string_agg(
                                            format('%I as %I',
                                                   column_name,
                                                   column_name || '_' || '%s' ||
                                                   (SELECT value FROM resources.meta_utils WHERE key = 'dataset_suffix')
                                            ), ', '
                                    ) as template
                             FROM information_schema.columns
                             WHERE table_schema = 'input'
                               AND table_name = 'derived_symptoms'
                               AND column_name != 'record_id')

    SELECT template
    INTO table_statement
    FROM column_template;

    FOREACH t_name IN ARRAY table_names
        LOOP
            EXECUTE format(
                    'CREATE TABLE output_derived_symptoms.%I AS
                     SELECT record_id as participant_id, ' || table_statement || '
             FROM input.derived_symptoms_decoded
             WHERE LOWER(infect_yn_curr || ''_'' || REPLACE(visit_month_curr::text, ''-'',''minus'')) = %L',
                    'derived_symptoms_' || t_name,
                    t_name
                    );
        END LOOP;
    raise INFO 'Finished building subtables for derived symptoms from decoded data';
END
$$ LANGUAGE Plpgsql;
select *
from get_derived_symptoms_decoded();
select *
from get_derived_symptoms_subtables();

