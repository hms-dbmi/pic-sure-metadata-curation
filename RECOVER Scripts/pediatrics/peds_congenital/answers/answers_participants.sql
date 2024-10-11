create or replace function insert_participants_answers_peds_congenital() returns void as
$$
DECLARE arr varchar[][];
DECLARE insert_statement text := '';
DECLARE columnlist text := '';
DECLARE valuelist text := '';
DECLARE val boolean;
BEGIN
	select array_agg(arrinner) from (select ARRAY[concat(replace(trim(both ' ' from visit_type), ' ', '_'), '_', form_name), visit_type, form_name] as arrinner from peds_congenital.answers_curated group by visit_type, form_name) ini
	into arr;
		for i in 1 .. array_upper(arr, 1)
	LOOP
		insert_statement:= 'INSERT INTO pediatric_congenital."' || arr[i][1] ||
		'" select distinct(participant_id) from peds_congenital.answers_curated where visit_type=''' || arr[i][2] ||
		''' and form_name=''' || arr[i][3] || '''';
		raise notice '%', insert_statement;
		EXECUTE insert_statement;
	END LOOP;

END 
$$ LANGUAGE Plpgsql;
select * from insert_participants_answers_peds_congenital();