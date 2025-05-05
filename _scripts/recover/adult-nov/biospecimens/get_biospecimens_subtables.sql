CREATE OR REPLACE FUNCTION get_biospecimens_subtables()
	returns void as
	$$
	DECLARE concept_names varchar[];
	DECLARE table_statement text;
    DECLARE concept_name varchar;
	BEGIN
	    create schema if not exists output_biospecimens;
		select array_agg(concept_cd) into concept_names from (SELECT distinct(specimen_concept_cd) as concept_cd from adult.biospecimens
            group by specimen_concept_cd order by specimen_concept_cd)innie;

        FOR i IN 1 .. array_upper(concept_names, 1)
        LOOP
        concept_name=concept_names[i];
        raise notice '%', concept_name;
     	table_statement='drop table if exists output_biospecimens."'|| concept_name ||'";
     	                create table output_biospecimens."'|| concept_name ||'"
            as (select participant_id, kit_id as "'|| concept_name ||'_kit_id" from adult.biospecimens
            where specimen_concept_cd = '''|| concept_name ||''')';
        raise notice '%', table_statement;
        execute table_statement;
        end loop;
	END
	$$ LANGUAGE Plpgsql;
	select * from get_biospecimens_subtables();
