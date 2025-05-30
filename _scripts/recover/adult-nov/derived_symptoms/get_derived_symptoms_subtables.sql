CREATE OR REPLACE FUNCTION get_derived_symptoms_subtables()
	returns void as
	$$
	DECLARE table_names varchar[];
	DECLARE column_list varchar[];
	DECLARE table_statement text;
	DECLARE event_name text;
	DECLARE t_name text;

	BEGIN
	    drop schema if exists output_biostats_derived_symptoms cascade;
	    create schema output_biostats_derived_symptoms;

        select array_agg(table_prop) into table_names from
        (select redcap_event_name as table_prop
            from adult.biostats_derived_symptoms
            where redcap_event_name is not null
            group by redcap_event_name)innie;
        FOR i IN 1 .. array_upper(table_names, 1)
        LOOP
            t_name=table_names[i];
            select array_agg(column_string) into column_list from
                (select ("column_name" || ' as ' || "column_name" || '_' || t_name) as column_string
                from information_schema.columns where
                 "table_schema" = 'adult' and "table_name" = 'biostats_derived_symptoms' and "column_name" != 'record_id')innie;
            raise notice 'Table: %
                          Columns: %', t_name, array_to_string(column_list, ', ');
            table_statement = 'drop table if exists '|| quote_ident('biostats_derived_symptoms_' || t_name) || ';
                              create table output_biostats_derived_symptoms.'|| quote_ident('biostats_derived_symptoms_' || t_name) || ' as
                (select record_id as participant_id, ' || array_to_string(column_list, ', ') ||
                    ' from adult.biostats_derived_symptoms where redcap_event_name = ' || quote_literal(t_name) || ')';
            execute table_statement;
        end loop;
	END
	$$ LANGUAGE Plpgsql;
	select * from get_derived_symptoms_subtables();

