do LANGUAGE Plpgsql $$BEGIN
raise notice 'starting curation of demographics data';
END$$;
CREATE OR REPLACE FUNCTION copy_demographics_table()
returns void as
$$
DECLARE column_names varchar[];
DECLARE table_statement text;
BEGIN
	drop schema if exists output_demographics cascade;
	create schema output_demographics;
    raise notice 'Starting creation of table from demographics file for dataset';
	select array_agg(column_string) into column_names from
                (select (column_name || ' as ' || column_name || '_demo' || meta_utils_suffix.value) as column_string
                    from information_schema.columns
                    left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix on true
                    where
                        table_schema = 'input' and table_name = 'demographics' and column_name != 'participant_id'
                ) as subquery;
    table_statement = 'create table if not exists output_demographics.demographics as
        SELECT participant_id, '|| array_to_string(column_names, ', ') ||' FROM input.demographics';
    execute table_statement;
    raise notice 'Successfully created table from demographics file for dataset';
END
$$ LANGUAGE Plpgsql;
select * from copy_demographics_table();
do LANGUAGE Plpgsql $$BEGIN
raise notice 'successfully completed curation of demographics data';
END$$;