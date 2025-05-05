create or replace function merge_metadata_tables()
	returns void as
	$$
	declare table_statements text[];
	declare merge_statement text;
	BEGIN
    create schema if not exists output_metadata;
    drop table if exists metadata_output.recover_adult_metadata;
    select array_agg(distinct('select * from processing_metadata.' || table_name)) into table_statements from information_schema.tables where table_schema = 'processing_metadata';

	merge_statement = 'create table metadata_output.recover_adult_metadata as (' || array_to_string(table_statements,
'
UNION
') || ')';
	raise notice '%', merge_statement;
    execute merge_statement;
	END
$$ LANGUAGE Plpgsql;
update metadata_output.recover_adult_metadata set picsure_concept_path = clean_path(picsure_concept_path);
select * from merge_metadata_tables();