CREATE OR REPLACE FUNCTION get_peds_visits_tables()
	returns void as
	$$
	DECLARE table_names varchar[];
	DECLARE create_statement text := '';
	BEGIN
		SELECT array_agg(visit_type) into table_names from
		(select lower(replace(trim(both ' ' from visit_type), ' ', '_')) as visit_type
		 from peds.visits group by visit_type)
		    visits;
		
     	FOR i IN 1 .. array_upper(table_names, 1)
       		LOOP
			create_statement:= 'Create table pediatric."'|| table_names[i] || '.visits_data" ();
			Alter table pediatric."'|| table_names[i] || '.visits_data"
			add column "participant_id" varchar,
			add column "visit_id" varchar,
			add column "visit_site_id" integer,
			add column "visit_start_date" varchar';
			EXECUTE create_statement;
			end loop;
	END
	$$ LANGUAGE Plpgsql;
create or replace function insert_data_peds_visits() returns void as
$$
DECLARE arr varchar[];
DECLARE insert_statement text := '';
DECLARE table_title text := '';
DECLARE visit text := '';
BEGIN
	select array_agg(distinct(visit_type)) from peds.visits into arr;
		for i in 1 .. array_upper(arr, 1)
	LOOP
		visit := arr[i];
		table_title := lower(replace(trim(both ' ' from arr[i]), ' ', '_')) || '.visits_data';
		insert_statement:= 'insert into pediatric."' || table_title ||
		'" (participant_id, visit_id, visit_site_id, visit_start_date)' ||
		'(select participant_id, visit_id, visit_site_id, visit_start_date
			from peds.visits
			where peds.visits.visit_type=''' || visit || ''')';
		raise notice '%', insert_statement;
		EXECUTE insert_statement;
	END LOOP;

END 
$$ LANGUAGE Plpgsql;


select * from get_peds_visits_tables();
select * from insert_data_peds_visits();







