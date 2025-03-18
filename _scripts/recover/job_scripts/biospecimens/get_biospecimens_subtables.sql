CREATE OR REPLACE FUNCTION get_biospecimens_subtables()
	returns void as
	$$
	DECLARE concept_names varchar[];
	DECLARE table_statement text;
    DECLARE concept_name varchar;
    DECLARE concept_name_norm varchar;
    DECLARE dataset_suffix varchar;
    DECLARE table_count int = 0;
	BEGIN
	    drop schema if exists output_biospecimens cascade;
	    create schema output_biospecimens;
		select array_agg(concept_cd) into concept_names from (SELECT distinct(specimen_concept_cd) as concept_cd from input.biospecimens
            group by specimen_concept_cd order by specimen_concept_cd)innie;
        select value into dataset_suffix from resources.meta_utils where key = 'dataset_suffix';
        raise notice 'Starting creation of % table(s) of kit ids from biospecimens', array_upper(concept_names, 1);
        FOR i IN 1 .. array_upper(concept_names, 1)
        LOOP
        concept_name=concept_names[i];
        concept_name_norm = lower(regexp_replace(concept_name, ':', '_')) ;
     	table_statement='create table output_biospecimens."'|| concept_name_norm ||'"
            as (select participant_id, kit_id as "'|| concept_name_norm ||'_kit_id' || dataset_suffix|| '" from input.biospecimens
            where specimen_concept_cd = '''|| concept_name ||''')';
        raise notice '%', table_statement;
        execute table_statement;
        table_count = table_count + 1;
        end loop;
        raise notice 'Successfully created % table(s) of kit ids from biospecimens', table_count;
	END
	$$ LANGUAGE Plpgsql;
	select * from get_biospecimens_subtables();
