CREATE OR REPLACE FUNCTION get_visits_subtables_with_status()
	returns void as
	$$
	DECLARE table_names varchar[][];
	DECLARE table_statement text;
	DECLARE status text;
	DECLARE monthspi text;
	DECLARE table_name text;
    DECLARE column_suffix text;
	BEGIN
	    drop schema if exists output_visits cascade;
	    create schema output_visits;
	    create schema if not exists processing;
        drop table if exists processing.visits;

        create table processing.visits as
            (select participant_id, visit_id, visit_site_id, visit_type, visit_start_date,
                coalesce(infection_status::text, 'unknown') as infection_status,
                coalesce(months_postindex::text, 'unknown') as months_postindex,
                'visits_' || lower(coalesce(infection_status::text, 'unknown') || '-' || coalesce(months_postindex::text, 'unknown')) as table_name
                from adult.visits);

        select array_agg(table_props) into table_names from
        (select ARRAY[infection_status, months_postindex] as table_props
            from processing.visits group by infection_status, months_postindex)innie;

        --create table output_metadata.visits_metadata(varname text, vardesc text, docfile text, values text, comment1 text, max numeric, min numeric, picsure_concept_path text, drs_uri text);

        FOR i IN 1 .. array_upper(table_names, 1)
        LOOP
            status=table_names[i][1];
            monthspi=table_names[i][2];
            table_name='visits_' || lower(table_names[i][1] || '-' || table_names[i][2]);
            column_suffix=lower(table_names[i][1] || '_' || table_names[i][2]);
            table_statement = 'create table output_visits.' || quote_ident(table_name) || ' as
                (select participant_id, visit_id as '|| ('visit_id_' ||column_suffix)||', ' ||
                              'visit_site_id as '|| ('visit_site_id_' ||column_suffix)||', ' ||
                              'visit_type as '|| ('visit_type_' ||column_suffix)||', ' ||
                              'visit_start_date as '|| ('visit_start_date_' ||column_suffix)||', ' ||
                              'infection_status as '|| ('infection_status_' ||column_suffix)||', ' ||
                              'months_postindex as '|| ('months_postindex_' ||column_suffix) ||
                    ' from processing.visits where infection_status = ' || quote_literal(status) || ' and months_postindex = ' || quote_literal(monthspi) ||')';
            raise notice '%', table_statement;
            execute table_statement;
        end loop;
	END
	$$ LANGUAGE Plpgsql;
	select * from get_visits_subtables();

