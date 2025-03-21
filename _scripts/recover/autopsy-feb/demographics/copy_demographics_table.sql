
CREATE OR REPLACE FUNCTION copy_demographics_table()
returns void as
$$
DECLARE column_names varchar[];
DECLARE table_statement text;
BEGIN
	drop schema if exists output_demographics cascade;
	create schema output_demographics;
	select array_agg(column_string) into column_names from
                (select (column_name || ' as ' || column_name || '_demo') as column_string
                    from information_schema.columns where
                        table_schema = 'input' and table_name = 'demographics' and column_name != 'participant_id'
                ) as subquery;
    table_statement = 'create table if not exists output_demographics.demographics as
        SELECT participant_id, '|| array_to_string(column_names, ', ') ||' FROM input.demographics';
    execute table_statement;
END
$$ LANGUAGE Plpgsql;
select * from copy_demographics_table();