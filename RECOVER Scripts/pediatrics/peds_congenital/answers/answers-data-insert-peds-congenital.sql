create or replace function insert_data_peds_congenital_answers() returns void as
$$
DECLARE table_config varchar[][];
DECLARE insert_statement text := '';
DECLARE table_title text := '';
DECLARE visit text := '';
DECLARE form text := '';
DECLARE field text := '';
BEGIN
	select array_agg(arrinner) from (select ARRAY[concat(replace(trim(both ' ' from lower(visit_type)), ' ', '_'),
                                                         '_',
                                                         form_name), visit_type,
	    form_name, field_name] as arrinner from peds_congenital.answers_curated
									  group by visit_type, form_name, field_name) ini
	into table_config;
		for i in 1 .. array_upper(table_config, 1)
	LOOP
		table_title := table_config[i][1];
		visit:= table_config[i][2];
		form := table_config[i][3];
		field := table_config[i][4];
		insert_statement:= 'UPDATE pediatric_congenital."' || table_config[i][1] ||
		'" SET ' || field || '= answer from ' ||
		'(select participant_id, answer from peds_congenital.answers_curated 
			where peds_congenital.answers_curated.visit_type=''' || visit || '''
			and peds_congenital.answers_curated.form_name=''' || form || '''
			and peds_congenital.answers_curated.field_name=''' || field ||''') innie
			where pediatric_congenital."' || table_config[i][1] || '".participant_id=innie.participant_id';
		raise notice '%', insert_statement;
		EXECUTE insert_statement;
	END LOOP;

END 
$$ LANGUAGE Plpgsql;
select * from insert_data_peds_congenital_answers();