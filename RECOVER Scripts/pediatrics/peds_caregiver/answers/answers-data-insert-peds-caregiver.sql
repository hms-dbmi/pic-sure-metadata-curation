create or replace function insert_data_answers_caregiver() returns void as
$$
DECLARE table_config varchar[][];
DECLARE insert_statement text := '';
DECLARE table_title text := '';
DECLARE visit text := '';
DECLARE form text := '';
DECLARE field text := '';
BEGIN
	select array_agg(arrinner) from (select ARRAY[concat(replace(trim(both ' ' from visit_id), ' ', '_'), '.', form_name), visit_id,
	    form_name, field_name] as arrinner from peds_caregiver.answers_curated
									  group by visit_id, form_name, field_name) ini
	into table_config;
		for i in 1 .. array_upper(table_config, 1)
	LOOP
		table_title := table_config[i][1];
		visit:= table_config[i][2];
		form := table_config[i][3];
		field := table_config[i][4];
		insert_statement:= 'UPDATE pediatric_caregiver."' || table_config[i][1] ||
		'" SET ' || field || '= answer from ' ||
		'(select participant_id, answer from peds_caregiver.answers_curated 
			where peds_caregiver.answers_curated.visit_id=''' || visit || '''
			and peds_caregiver.answers_curated.form_name=''' || form || '''
			and peds_caregiver.answers_curated.field_name=''' || field ||''') innie
			where pediatric_caregiver."' || table_config[i][1] || '".participant_id=innie.participant_id';
		raise notice '%', insert_statement;
		EXECUTE insert_statement;
	END LOOP;

END 
$$ LANGUAGE Plpgsql;
select * from insert_data_answers_caregiver();