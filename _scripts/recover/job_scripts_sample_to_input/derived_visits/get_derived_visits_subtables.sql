CREATE OR REPLACE FUNCTION get_derived_visits_subtables()
	returns void as
	$$
	DECLARE table_names varchar[];
	DECLARE column_list varchar[];
	DECLARE table_statement text;
	DECLARE t_name text;

	BEGIN

	--decode data


	    drop schema if exists output_derived_visits cascade;
	    create schema output_derived_visits;

        select array_agg(table_prop) into table_names from
        (select lower(infect_yn_curr || '_' || replace(visit_month_curr::text, '-','minus')) as table_prop
            from input.derived_visits group by infect_yn_curr || '_' || replace(visit_month_curr::text, '-','minus'))innie;

        FOR i IN 1 .. array_upper(table_names, 1)
        LOOP

            t_name=table_names[i];

            select array_agg(column_string) into column_list from
                (select (column_name || ' as ' || column_name || '_' || t_name || meta_utils_suffix.value) as column_string
                from information_schema.columns
                    left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix on true
                where
                 table_schema = 'input' and table_name = 'derived_visits' and column_name != 'record_id')innie;

            table_statement = 'drop table if exists '|| quote_ident('derived_visits_' || t_name) || ';
                              create table output_derived_visits.'|| quote_ident('derived_visits_' || t_name) || ' as
                (select record_id as participant_id, ' || array_to_string(column_list, ', ') ||
                    ' from input.derived_visits where lower(infect_yn_curr || ''_'' || replace(visit_month_curr::text, ''-'',''minus'')) = ' || quote_literal(t_name) || ')';
            raise notice '%', table_statement;
            execute table_statement;
        end loop;

	END
	$$ LANGUAGE Plpgsql;
	select * from get_derived_visits_subtables();

