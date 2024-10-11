CREATE OR REPLACE FUNCTION get_tables_caregiver()
	returns void as
	$$
	DECLARE table_names varchar[];
	DECLARE column_names varchar[];
	DECLARE insert_statement text := '';
	BEGIN
		SELECT array_agg(distinct(form)) into table_names from
		(select concat(replace(trim(both ' ' from visit_id), ' ', '_'), '.', form_name) as form from peds_caregiver.answerdata) forms;
		
     	FOR i IN 1 .. array_upper(table_names, 1)
       		LOOP

			insert_statement:= 'CREATE TABLE pediatric_caregiver."' || table_names[i] || '"();
					ALTER table pediatric_caregiver."'|| table_names[i] || '" add column "participant_id" varchar';
			    raise notice '%', insert_statement;
				EXECUTE insert_statement;
				insert_statement:= '';
			SELECT array_agg(distinct(field_name)) into column_names from
				(select concat(replace(trim(both ' ' from visit_id), ' ', '_'), '_', form_name) as form, field_name from peds_caregiver.answerdata group by visit_id, form_name, field_name) forms
				where forms.form=table_names[i];
			FOR j IN 1 .. array_upper(column_names, 1)
       		LOOP
				insert_statement:= 'ALTER table pediatric_caregiver."'|| table_names[i] || '"
					add column "' || column_names[j] || '" varchar';
				EXECUTE insert_statement;
				insert_statement:= '';
			end loop;
			column_names := null;

			end loop;
	END
	$$ LANGUAGE Plpgsql;
	select * from get_tables_caregiver();
    select * from information_schema.tables where table_schema = 'pediatric_caregiver';
