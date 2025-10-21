CREATE OR REPLACE FUNCTION get_derived_symptoms_subtables()
    returns void as
$$
DECLARE
    table_names          varchar[];
    column_list          varchar[];
    update_col_statement text;
    table_statement      text;
    t_name               text;
    decoder              record;
BEGIN


    drop table if exists input.derived_symptoms_decoded;
    create table input.derived_symptoms_decoded as TABLE input.derived_symptoms;

    --Create temporary table for mappings
    DROP TABLE IF EXISTS symptom_decoding_map;
    CREATE TEMP TABLE symptom_decoding_map as
    SELECT ds.variable as variable_name,
           kv.key      as key_value,
           kv.value    as decoded_value
    FROM dictionary_files.derived_symptoms ds,
         LATERAL jsonb_array_elements(ds.decoding_values::jsonb) AS elem,
         LATERAL jsonb_each_text(elem) AS kv
    WHERE ds.decoding_values IS NOT NULL;


    CREATE INDEX ON symptom_decoding_map (variable_name, key_value);
    FOR decoder IN
        SELECT DISTINCT variable_name
        FROM symptom_decoding_map
        LOOP
            update_col_statement := format(
                    'UPDATE input.derived_symptoms_decoded
                     SET %1$I = tdm.decoded_value
                     FROM symptom_decoding_map tdm
                     WHERE %1$I = tdm.key_value
                     AND tdm.variable_name = %2$L',
                    decoder.variable_name,
                    decoder.variable_name
                                    );

            EXECUTE update_col_statement;
        END LOOP;

    --Clean up
    DROP TABLE IF EXISTS symptom_decoding_map;


    drop schema if exists output_derived_symptoms cascade;
    create schema output_derived_symptoms;

    select array_agg(table_prop)
    into table_names
    from (select lower(infect_yn_curr || '_' || visit_month_curr) as table_prop
          from input.derived_symptoms_decoded
          where infect_yn_curr || '_' || visit_month_curr is not null
          group by infect_yn_curr || '_' || visit_month_curr) innie;
    FOR i IN 1 .. array_upper(table_names, 1)
        LOOP
            t_name = table_names[i];
            select array_agg(column_string)
            into column_list
            from (select ("column_name" || ' as ' || "column_name" || '_' || t_name ||
                          meta_utils_suffix.value) as column_string
                  from information_schema.columns
                           left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix
                                     on true
                  where "table_schema" = 'input'
                    and "table_name" = 'derived_symptoms'
                    and "column_name" != 'record_id') innie;
            raise notice 'Table: %
                          Columns: %', t_name, array_to_string(column_list, ', ');
            table_statement = 'drop table if exists ' || quote_ident('derived_symptoms_' || t_name) || ';
                              create table output_derived_symptoms.' || quote_ident('derived_symptoms_' || t_name) || ' as
                (select record_id as participant_id, ' || array_to_string(column_list, ', ') ||
                              ' from input.derived_symptoms_decoded where lower(infect_yn_curr || ''_'' || visit_month_curr) = ' ||
                              quote_literal(t_name) || ')';
            execute table_statement;
        end loop;
END
$$ LANGUAGE Plpgsql;
select *
from get_derived_symptoms_subtables();

