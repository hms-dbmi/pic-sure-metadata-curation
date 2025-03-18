CREATE OR REPLACE FUNCTION get_visits_subtables_with_visit_id()
	returns void as
	$$
	DECLARE table_names varchar[];
	DECLARE table_statement text;
    DECLARE t_name text;
    DECLARE column_names varchar[];
    DECLARE dataset_suffix varchar;
    DECLARE table_count int = 0;
	BEGIN
	    drop schema if exists output_visits cascade;
	    create schema output_visits;
        select array_agg(distinct(replace(lower(trim(visit_id)), ' ', '_'))) into table_names from input.visits;
        select value into dataset_suffix from resources.meta_utils where key = 'dataset_suffix';
        raise notice 'Starting creation of % table(s) from visits table', array_upper(table_names, 1);
        FOR i IN 1 .. array_upper(table_names, 1)
        LOOP
            t_name=table_names[i];
            select array_agg(column_string) into column_names from
                (select (column_name || ' as ' || column_name || '_' || t_name || dataset_suffix ) as column_string
                from information_schema.columns where
                 table_schema = 'input' and table_name = 'visits' and column_name != 'participant_id')innie;

            table_statement = 'create table output_visits.' || quote_ident(t_name) || ' as
                (select participant_id, '||
                    array_to_string(column_names, ', ')
                 ||
                    ' from input.visits where replace(lower(visit_id), '' '', ''_'') = ' || quote_literal(t_name) || ')';
            raise notice '%', table_statement;
            execute table_statement;
            table_count = table_count + 1;
        end loop;
        raise notice 'Successfully created % table(s) from visits table', table_count;
	END
	$$ LANGUAGE Plpgsql;
	select * from get_visits_subtables_with_visit_id();

