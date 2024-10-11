--run in parallel in different sessions to cut down on ingest time
create or replace function insert_data_peds_answers(inputvisit TEXT) returns void as
$$
DECLARE table_config varchar[][];
DECLARE insert_statement text := '';
DECLARE table_title text := '';
DECLARE visit text := '';
DECLARE form text := '';
DECLARE field text := '';

BEGIN
	select array_agg(arrinner) from (select ARRAY[lower(concat(replace(trim(both ' ' from visit_type), ' ', '_'), '.',
                                                          form_name)), visit_type,
	    form_name, field_name] as arrinner from peds.answers_curated where visit_type = inputvisit
									  group by visit_type, form_name, field_name) ini
	into table_config;
		for i in 1 .. array_upper(table_config, 1)
	LOOP
		table_title := table_config[i][1];
		visit:= table_config[i][2];
		form := table_config[i][3];
		field := table_config[i][4];
		insert_statement:= 'UPDATE pediatric."' || table_config[i][1] ||
		'" SET ' || lower(field) || '= answer from ' ||
		'(select participant_id, answer from peds.answers_curated 
			where peds.answers_curated.visit_type=''' || visit || '''
			and peds.answers_curated.form_name=''' || form || '''
			and peds.answers_curated.field_name=''' || field ||''') innie
			where pediatric."' || table_config[i][1] || '".participant_id=innie.participant_id';
		raise notice '%', insert_statement;
		EXECUTE insert_statement;
	END LOOP;

END 
$$ LANGUAGE Plpgsql
PARALLEL SAFE;


select * from insert_data_peds_answers('24_month_arm_5');
select * from insert_data_peds_answers('Specialized');