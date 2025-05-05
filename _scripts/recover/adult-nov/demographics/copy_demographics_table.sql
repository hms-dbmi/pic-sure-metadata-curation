
CREATE OR REPLACE FUNCTION copy_demographics_table()
	returns void as
	$$
	BEGIN
	create schema if not exists output_demographics;
create table if not exists output_demographics.demographics as
SELECT *
	FROM adult.demographics;
	END
$$ LANGUAGE Plpgsql;
