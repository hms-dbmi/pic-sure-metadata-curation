CREATE OR REPLACE FUNCTION get_visits_subtables_with_visit_id()
	returns void as
	$$
	DECLARE table_names varchar[];
	DECLARE table_statement text;
    DECLARE t_name text;
    DECLARE column_names varchar[];
	BEGIN
	    drop schema if exists output_visits cascade;
	    create schema output_visits;
        select array_agg(distinct(replace(lower(visit_id), ' ', '_'))) into table_names from input.visits;
        FOR i IN 1 .. array_upper(table_names, 1)
        LOOP
            t_name=table_names[i];
            select array_agg(column_string) into column_names from
                (select (column_name || ' as ' || column_name || '_' || t_name) as column_string
                from information_schema.columns where
                 table_schema = 'input' and table_name = 'visits' and column_name != 'participant_id')innie;

            table_statement = 'create table output_visits.' || quote_ident(t_name) || ' as
                (select participant_id, '||
                    array_to_string(column_names, ', ')
                 ||
                    ' from input.visits where replace(lower(visit_id), '' '', ''_'') = ' || quote_literal(t_name) || ')';
            raise notice '%', table_statement;
            execute table_statement;
        end loop;
	END
	$$ LANGUAGE Plpgsql;
	select * from get_visits_subtables_with_visit_id();

