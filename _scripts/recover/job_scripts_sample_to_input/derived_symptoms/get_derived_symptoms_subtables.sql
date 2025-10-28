CREATE OR REPLACE FUNCTION get_derived_symptoms_decoded()
RETURNS void AS
$$
DECLARE
    update_sql text := '';
    col_record record;
BEGIN

    DROP TABLE IF EXISTS input.derived_symptoms_decoded;
    CREATE TABLE input.derived_symptoms_decoded AS
    SELECT * FROM input.derived_symptoms;

    FOR col_record IN
        SELECT DISTINCT variable
        FROM dictionary_files.symptom_decoding_lookup
    LOOP
        IF length(update_sql) > 0 THEN
            update_sql := update_sql || ', ';
        END IF;

        update_sql := update_sql || format('
            %1$I = COALESCE(
                (SELECT decoded_value
                 FROM dictionary_files.symptom_decoding_lookup
                 WHERE variable = %2$L AND original_value = %1$I::text),
                %1$I::text
            )',
            col_record.variable,
            col_record.variable
        );
    END LOOP;

    EXECUTE 'UPDATE input.derived_symptoms_decoded SET ' || update_sql || ';';

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_derived_symptoms_subtables()
    returns void as
$$
DECLARE
    table_names     varchar[];
    table_statement text;
    t_name          text;
    decoder         record;
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
                                            format('%I as %I_%s',
                                                   column_name,
                                                   column_name,
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

