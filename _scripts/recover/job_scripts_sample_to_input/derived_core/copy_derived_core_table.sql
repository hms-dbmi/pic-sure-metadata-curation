do LANGUAGE Plpgsql
$$
    BEGIN
        raise INFO 'starting curation of derived core proc data';
    END
$$;
CREATE OR REPLACE FUNCTION copy_derived_core_table()
    returns void as
$$
DECLARE
    column_names         varchar[];
    table_statement      text;
    decoder              record;
    update_col_statement text;
BEGIN
    drop table if exists input.derived_core_decoded;
    create table input.derived_core_decoded as TABLE input.derived_core;

    --Create temporary table for mappings
    DROP TABLE IF EXISTS core_decoding_map;
    CREATE TEMP TABLE core_decoding_map as
    SELECT ds.variable as variable_name,
           kv.key      as key_value,
           kv.value    as decoded_value
    FROM dictionary_files.derived_core ds,
         LATERAL jsonb_array_elements(ds.decoding_values::jsonb) AS elem,
         LATERAL jsonb_each_text(elem) AS kv
    WHERE ds.decoding_values IS NOT NULL
      and ds.variable in (select columns.column_name
                          from information_schema.columns
                          where table_name = 'derived_core' and table_schema = 'input');


    CREATE INDEX ON core_decoding_map (variable_name, key_value);
    FOR decoder IN
        SELECT DISTINCT variable_name
        FROM core_decoding_map
        LOOP
            update_col_statement := format(
                    'UPDATE input.derived_core_decoded
                     SET %1$I = tdm.decoded_value
                     FROM core_decoding_map tdm
                     WHERE %1$I = tdm.key_value
                     AND tdm.variable_name = %2$L',
                    decoder.variable_name,
                    decoder.variable_name
                                    );

            EXECUTE update_col_statement;
        END LOOP;

    --Clean up
    DROP TABLE IF EXISTS core_decoding_map;


    drop schema if exists output_biostats_derived_core_proc cascade;
    create schema if not exists output_biostats_derived_core_proc;
    select array_agg(column_string)
    into column_names
    from (select (column_name || ' as ' || column_name || meta_utils_suffix.value) as column_string
          from information_schema.columns
                   left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix
                             on true
          where table_schema = 'input'
            and table_name = 'derived_core_decoded'
            and column_name != 'record_id') as subquery;
    table_statement = 'create table output_biostats_derived_core_proc.derived_core as
        SELECT record_id as participant_id, ' || array_to_string(column_names, ', ') || ' FROM input.derived_core_decoded';
    execute table_statement;
END
$$ LANGUAGE Plpgsql;
select *
from copy_derived_core_table();
do LANGUAGE Plpgsql
$$
    BEGIN
        raise INFO 'successfully completed curation of derived core proc data';
    END
$$;
