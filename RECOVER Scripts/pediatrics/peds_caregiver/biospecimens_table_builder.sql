CREATE TABLE IF NOT EXISTS pediatric_caregiver.biospecimens();
ALTER TABLE pediatric_caregiver.biospecimens
ADD COLUMN participant_id varchar;
CREATE OR REPLACE FUNCTION get_caregiver_biospecimens_columns()
	returns void as
	$$
	DECLARE column_names varchar[];
	DECLARE alter_statement text := '';
	BEGIN
		SELECT array_agg(specimen_concept_cd) into column_names from
		(select specimen_concept_cd from peds_caregiver.biospecimens group by specimen_concept_cd) specimen;
		
     	FOR i IN 1 .. array_upper(column_names, 1)
       		LOOP
			alter_statement:= 'Alter table pediatric_caregiver.biospecimens
			add column "' || column_names[i] || '" varchar';
			EXECUTE alter_statement;
			end loop;
	END
	$$ LANGUAGE Plpgsql;

create or replace function insert_data_caregiver_biospecimens() returns void as
$$
DECLARE plist varchar[];
DECLARE clist varchar[];
DECLARE insert_statement text := '';
DECLARE columnlist text := '';
DECLARE valuelist text := '';
DECLARE val boolean;
BEGIN
	SELECT array_agg(participant_id) into plist from
		(select distinct(participant_id) from peds_caregiver.biospecimens order by participant_id) plister;
	SELECT array_agg(specimen_concept_cd) into clist from
		(select distinct(specimen_concept_cd) from peds_caregiver.biospecimens order by specimen_concept_cd) clister;

	FOR i IN 1 .. array_upper(plist, 1)
        LOOP
		FOR j in 1 .. array_upper(clist, 1)
			LOOP
				columnlist:= columnlist || ', "' || clist[j] || '"';
				select (coalesce ((select count(*) from peds_caregiver.biospecimens
					where participant_id=plist[i] and specimen_concept_cd=clist[j]
					group by participant_id, specimen_concept_cd), 0))!=0 into val;
				valuelist:= valuelist || ', ' || val;
			END LOOP;
				insert_statement:= 'Insert into pediatric_caregiver.biospecimens (participant_id' || columnlist || ')
				VALUES (''' || plist[i] || '''' || valuelist || ')';
				raise notice '%', insert_statement;
				EXECUTE insert_statement;
				columnlist := '';
				valuelist := '';
		END LOOP;
END
$$ LANGUAGE Plpgsql;

select * from get_caregiver_biospecimens_columns();
select * from insert_data_caregiver_biospecimens();