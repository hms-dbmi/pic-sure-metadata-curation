do LANGUAGE Plpgsql $$BEGIN
raise INFO 'starting curation of derived core proc data';
END$$;
CREATE OR REPLACE FUNCTION copy_derived_core_table()
    returns void as
$$
DECLARE column_names varchar[];
    DECLARE table_statement text;
BEGIN
    drop schema if exists output_biostats_derived_core_proc cascade;
    create schema if not exists output_biostats_derived_core_proc;
    select array_agg(column_string) into column_names from
        (select (column_name || ' as ' || column_name || '_derived_core' || meta_utils_suffix.value) as column_string
         from information_schema.columns
                  left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix on true
         where
             table_schema = 'sample' and table_name = 'derived_core' and column_name != 'record_id'
        ) as subquery;
    table_statement = 'create table output_biostats_derived_core_proc.derived_core as
        SELECT record_id as participant_id, '|| array_to_string(column_names, ', ') ||' FROM sample.derived_core';
    execute table_statement;
END
$$ LANGUAGE Plpgsql;
select * from copy_derived_core_table();
do LANGUAGE Plpgsql $$BEGIN
raise INFO 'successfully completed curation of derived core proc data';
END$$;
