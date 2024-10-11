CREATE TABLE pediatric.fitbit();
ALTER TABLE pediatric.fitbit
ADD COLUMN participant_id varchar;
CREATE OR REPLACE FUNCTION get_fitbit_columns()
	returns void as
	$$
	DECLARE column_names varchar[];
	DECLARE p_array varchar[];
	DECLARE alter_statement text := '';
	BEGIN
		SELECT array_agg(fitbit_concept_cd) into column_names from
		(select fitbit_concept_cd from peds.fitbit group by fitbit_concept_cd) fitbit;
		
		select array_agg(participant_id) from (select distinct(participant_id) from peds.fitbit)inb into p_array;
		
     	FOR i IN 1 .. array_upper(column_names, 1)
       		LOOP
			alter_statement:= 'Alter table pediatric.fitbit
			add column "' || column_names[i] || '" varchar';
			EXECUTE alter_statement;
			end loop;
		for j in 1 .. array_upper(p_array, 1)
		LOOP
			execute 'INSERT into pediatric.fitbit (participant_id) VALUES (''' || p_array[j] || ''') on conflict DO NOTHING';
		END LOOP;
	END
	$$ LANGUAGE Plpgsql;

create or replace function update_summaries_fitbit() returns void as
$$
DECLARE carray varchar[];
DECLARE insert_statement text := '';
DECLARE field text := '';
DECLARE val text := '';
BEGIN

	select array_agg(fitbit_concept_cd) from (select distinct(fitbit_concept_cd) from peds.fitbit where
	       (fitbit_concept_cd ~ '.*alltime.*'))inb into carray;

	for i in 1 .. array_upper(carray, 1)
	LOOP
		field := carray[i];

		insert_statement:= 'UPDATE pediatric.fitbit SET "' || field || '"= "summary_value" from
		(
			SELECT fitbit_concept_cd, participant_id, summary_value FROM peds.fitbit where fitbit_concept_cd = ''' || field || '''
		)ini
			where ini.participant_id=pediatric.fitbit.participant_id;';
		raise notice '%', insert_statement;
		execute insert_statement;
	END LOOP;
	END
$$ LANGUAGE Plpgsql;

create or replace function update_weeklies_fitbit() returns void as
$$
DECLARE carray varchar[];
DECLARE insert_statement text := '';
DECLARE field text := '';
DECLARE val text := '';
BEGIN

	select array_agg(fitbit_concept_cd) from (select distinct(fitbit_concept_cd) from peds.fitbit where fitbit_concept_cd ~ '.*weekly.*')inb into carray;

	for i in 1 .. array_upper(carray, 1)
	LOOP
		field := carray[i];

		insert_statement:= 'UPDATE pediatric.fitbit SET "' || field || '"= "concept_count" from
		(
			SELECT fitbit_concept_cd, participant_id, count(*) as concept_count FROM peds.fitbit where fitbit_concept_cd = ''' || field || '''
			group by participant_id,fitbit_concept_cd
		)ini
			where ini.participant_id=pediatric.fitbit.participant_id;';
		raise notice '%', insert_statement;
		execute insert_statement;
	END LOOP;
	END
$$ LANGUAGE Plpgsql;


select * from get_fitbit_columns();
select * from update_summaries_fitbit();
select * from update_weeklies_fitbit();
UPDATE pediatric.fitbit SET "mhp:device"= "device_type" from
		(
			SELECT fitbit_concept_cd, participant_id, device_type FROM peds.fitbit where fitbit_concept_cd =
			                                                                             'mhp:device'
		)ini
			where ini.participant_id=pediatric.fitbit.participant_id;