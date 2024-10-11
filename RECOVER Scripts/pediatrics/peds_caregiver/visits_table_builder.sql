CREATE OR REPLACE FUNCTION get_visits_tables_caregiver()
	returns void as
	$$
	DECLARE table_names varchar[];
	DECLARE create_statement text := '';
	BEGIN
		SELECT array_agg(visit_id) into table_names from
		(select lower(replace(trim(both ' ' from visit_id), ' ', '_')) as visit_id
		 from peds_caregiver.visits group by visit_id)
		    visits;

     	FOR i IN 1 .. array_upper(table_names, 1)
       		LOOP
			create_statement:= 'Create table pediatric_caregiver."'|| table_names[i] || '.visits_data" ();
			Alter table pediatric_caregiver."'|| table_names[i] || '.visits_data"
			add column "participant_id" varchar,
			add column "visit_type" varchar,
			add column "visit_site_id" integer,
			add column "visit_start_date" varchar';
			EXECUTE create_statement;
			end loop;
	END
	$$ LANGUAGE Plpgsql;

create or replace function insert_participants_visits_caregiver() returns void as
$$
DECLARE arr varchar[];
DECLARE insert_statement text := '';
DECLARE val boolean;
BEGIN
	select array_agg(distinct(visit_id)) from peds_caregiver.visits into arr;
	for i in 1 .. array_upper(arr, 1)
	LOOP
		insert_statement:= 'INSERT INTO pediatric_caregiver."' ||
		                   lower(replace(trim(both ' ' from arr[i]), ' ', '_')) || '.visits_data"
		select distinct(participant_id) from peds_caregiver.visits where visit_id=''' || arr[i] || '''';
		raise notice '%', insert_statement;
		EXECUTE insert_statement;
	END LOOP;

END
$$ LANGUAGE Plpgsql;
create or replace function insert_data_visits_caregiver() returns void as
$$
DECLARE arr varchar[];
DECLARE insert_statement text := '';
DECLARE table_title text := '';
DECLARE visit text := '';
BEGIN
	select array_agg(distinct(visit_id)) from peds_caregiver.visits into arr;
		for i in 1 .. array_upper(arr, 1)
	LOOP
		visit := arr[i];
		table_title := lower(replace(trim(both ' ' from arr[i]), ' ', '_')) || '.visits_data';
		insert_statement:= 'UPDATE pediatric_caregiver."' || table_title ||
		'" SET (visit_type, visit_site_id, visit_start_date)' ||
		'= (select visit_type, visit_site_id, visit_start_date
			from peds_caregiver.visits
			where peds_caregiver.visits.visit_id=''' || visit || '''
			and pediatric_caregiver."' || table_title || '".participant_id=peds_caregiver.visits.participant_id limit 1)';
		raise notice '%', insert_statement;
		EXECUTE insert_statement;
	END LOOP;

END 
$$ LANGUAGE Plpgsql;

select * from get_visits_tables_caregiver();
select * from insert_participants_visits_caregiver();
select * from insert_data_visits_caregiver();