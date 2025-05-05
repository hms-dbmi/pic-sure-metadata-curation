
CREATE OR REPLACE FUNCTION copy_derived_core_table()
	returns void as
	$$
	BEGIN
	create schema if not exists output_biostats_derived_core_proc;
    create table if not exists output_biostats_derived_core_proc.biostats_derived_core_proc as
    SELECT *
	    FROM adult.biostats_derived_core_proc;
	END
$$ LANGUAGE Plpgsql;
select * from copy_derived_core_table();