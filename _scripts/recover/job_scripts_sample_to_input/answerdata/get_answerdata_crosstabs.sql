DROP SCHEMA IF EXISTS output_answerdata CASCADE;
CREATE SCHEMA output_answerdata;

-- Pre-create indexes (run this once before the function)
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_answerdata_form_field
ON input.answerdata (form_name, field_name) WHERE form_name IS NOT NULL;

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_answerdata_form_field_concept
ON input.answerdata (form_name, field_name, concept_code_rollup);

-- Increase work_mem for this session if possible
SET work_mem = '1GB';


CREATE OR REPLACE FUNCTION get_answerdata_crosstabs()
RETURNS void AS
$$
DECLARE
    form_field_record record;
    table_sql text;
    total_tables int := 0;
    column_defs text;
BEGIN
    RAISE INFO 'Starting table creation';

    SELECT COUNT(DISTINCT (form_name, field_name)) INTO total_tables
    FROM input.answerdata;

    RAISE INFO 'Creating % answerdata tables', total_tables;

    FOR form_field_record IN
        SELECT DISTINCT form_name, field_name
        FROM input.answerdata
        ORDER BY form_name, field_name
    LOOP
        SELECT string_agg(
            quote_ident(lower(concept_code_rollup)) || ' varchar',
            ', '
        ) INTO column_defs
        FROM (
            SELECT DISTINCT concept_code_rollup
            FROM input.answerdata
            WHERE form_name = form_field_record.form_name
              AND field_name = form_field_record.field_name
            ORDER BY concept_code_rollup
        ) concepts;

        table_sql := format(
            'CREATE TABLE output_answerdata.%I AS '
            'SELECT * FROM crosstab('
                '%L, '
                '%L'
            ') AS ct(participant_id varchar, %s)',
            form_field_record.form_name || '_' || form_field_record.field_name,
            format(
                'SELECT participant_id, concept_code_rollup, '
                'CASE '
                    'WHEN field_type = ''numeric'' THEN trim_scale(answer_numeric_val::numeric)::text '
                    'WHEN field_type = ''text'' THEN answer_text_val '
                    'ELSE answer_label '
                'END '
                'FROM input.answerdata '
                'WHERE form_name = %L AND field_name = %L',
                form_field_record.form_name,
                form_field_record.field_name
            ),
            format(
                'SELECT DISTINCT concept_code_rollup FROM input.answerdata '
                'WHERE form_name = %L AND field_name = %L '
                'ORDER BY 1',
                form_field_record.form_name,
                form_field_record.field_name
            ),
            column_defs
        );

        EXECUTE table_sql;
        --RAISE INFO 'Created table: %', form_field_record.form_name || '_' || form_field_record.field_name;
    END LOOP;

    RAISE INFO 'Completed all % tables', total_tables;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_answerdata_crosstabs();
