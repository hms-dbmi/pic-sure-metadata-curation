CREATE OR REPLACE FUNCTION get_derived_symptoms_subtables()
	returns void as
	$$
	DECLARE table_names varchar[];
	DECLARE column_list varchar[];
	DECLARE table_statement text;
	DECLARE event_name text;
	DECLARE t_name text;

	BEGIN
	    drop schema if exists output_derived_symptoms cascade;
	    create schema output_derived_symptoms;

        select array_agg(table_prop) into table_names from
        (select infect_yn_curr || '_' || visit_month_curr as table_prop
            from sample.derived_symptoms
            where infect_yn_curr || '_' || visit_month_curr is not null
            group by infect_yn_curr || '_' || visit_month_curr)innie;
        FOR i IN 1 .. array_upper(table_names, 1)
        LOOP
            t_name=table_names[i];
            select array_agg(column_string) into column_list from
                (select ("column_name" || ' as ' || "column_name" || '_' || t_name|| meta_utils_suffix.value) as column_string
                from information_schema.columns
                    left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix on true
                where
                 "table_schema" = 'sample' and "table_name" = 'derived_symptoms' and "column_name" != 'record_id')innie;
            raise notice 'Table: %
                          Columns: %', t_name, array_to_string(column_list, ', ');
            table_statement = 'drop table if exists '|| quote_ident('derived_symptoms_' || t_name) || ';
                              create table output_derived_symptoms.'|| quote_ident('derived_symptoms_' || t_name) || ' as
                (select record_id as participant_id, ' || array_to_string(column_list, ', ') ||
                    ' from sample.derived_symptoms where infect_yn_curr || ''_'' || visit_month_curr = ' || quote_literal(t_name) || ')';
            execute table_statement;
        end loop;
	END
	$$ LANGUAGE Plpgsql;
	select * from get_derived_symptoms_subtables();

