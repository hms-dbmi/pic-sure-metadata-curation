CREATE OR REPLACE FUNCTION get_derived_visits_decoded()
    returns void as
$$
DECLARE
    decoder record;
BEGIN

    raise INFO 'Started building decoded data table for derived visits';
    drop table if exists input.derived_visits_decoded;
    CREATE TABLE input.derived_visits_decoded AS TABLE input.derived_visits;

    -- Create temporary table for mappings
    DROP TABLE IF EXISTS visits_decoding_map;
    CREATE TEMP TABLE visits_decoding_map AS
    SELECT ds.variable as variable_name,
           kv.key      as key_value,
           kv.value    as decoded_value
    FROM dictionary_files.derived_visits ds,
         LATERAL jsonb_array_elements(ds.decoding_values::jsonb) AS elem,
         LATERAL jsonb_each_text(elem) AS kv
    WHERE ds.decoding_values IS NOT NULL;

    -- Create index for better performance
    CREATE INDEX idx_visits_decoding_map_lookup ON visits_decoding_map (variable_name, key_value);


    FOR decoder IN
        SELECT DISTINCT variable_name
        FROM visits_decoding_map
        LOOP
            EXECUTE format(
                    'UPDATE input.derived_visits_decoded
                     SET %1$I = COALESCE(tdm.decoded_value, %1$I)
                     FROM visits_decoding_map tdm
                     WHERE %1$I::text = tdm.key_value
                       AND tdm.variable_name = %2$L',
                    decoder.variable_name,
                    decoder.variable_name);
        END LOOP;

    --Clean up
    DROP TABLE IF EXISTS visits_decoding_map;
    raise INFO 'Finished building decoded data table for derived visits';
END
$$ LANGUAGE Plpgsql;


CREATE OR REPLACE FUNCTION get_derived_visits_subtables()
    returns void as
$$
DECLARE
    table_names     varchar[];
    table_statement text;
    t_name          text;
    col_update_statement text;
BEGIN
    raise INFO 'Building subtables for derived visits from decoded data';
    drop schema if exists output_derived_visits cascade;
    create schema output_derived_visits;

    SELECT ARRAY_AGG(DISTINCT table_prop)
    INTO table_names
    FROM (SELECT LOWER(infect_yn_curr || '_' || REPLACE(visit_month_curr::text, '-', 'minus')) as table_prop
          FROM input.derived_visits_decoded
          WHERE infect_yn_curr IS NOT NULL
            AND visit_month_curr IS NOT NULL) subq;

    WITH column_template AS (SELECT string_agg(
                                            format('%I as %I',
                                                   column_name,
                                                   coalesce(column_name || '_' || (SELECT value FROM resources.meta_utils WHERE key = 'dataset_suffix' and value != ''), column_name)
                                            ), ', '
                                    ) as template
                             FROM information_schema.columns
                             WHERE table_schema = 'input'
                               AND table_name = 'derived_visits_decoded'
                               AND column_name != 'record_id')

    SELECT template
    INTO table_statement
    FROM column_template;

    FOREACH t_name IN ARRAY table_names
        LOOP
            EXECUTE format(
                    'CREATE TABLE output_derived_visits.%I AS
                     SELECT record_id as participant_id, ' || table_statement || '
             FROM input.derived_visits_decoded
             WHERE LOWER(infect_yn_curr || ''_'' || REPLACE(visit_month_curr::text, ''-'',''minus'')) = %L',
                    'derived_visits_' || t_name,
                    t_name
                    );
        END LOOP;
        select string_agg(('alter table ' ||table_schema || '.' || table_name || ' rename column ' || old_name || ' to ' || new_name), '; ') into col_update_statement from
                                (select column_name as old_name, column_name || '_' || replace(table_name, 'derived_visits_', '') as new_name, table_schema, table_name from information_schema.columns
                                where table_schema = 'output_derived_visits' and column_name != 'participant_id')ini;
        execute col_update_statement;
    raise INFO 'Finished building subtables for derived visits from decoded data';
END
$$ LANGUAGE Plpgsql;
select *
from get_derived_visits_decoded();
select *
from get_derived_visits_subtables();

