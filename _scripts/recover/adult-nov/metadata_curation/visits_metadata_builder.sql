create or replace function get_visits_metadata()
	returns void as
	$$
	DECLARE table_names varchar[][];
	DECLARE status text;
	DECLARE monthspi text;
	DECLARE output_table_name text;
    DECLARE column_suffix text;
    DECLARE column_names text[];
    DECLARE insert_text text;
    DECLARE data_type text;
    DECLARE data_text text;
BEGIN
        drop table if exists processing_metadata.visits_meta;
        create table if not exists processing_metadata.visits_meta(varname text, vardesc text, docfile text, type text, values text, comment1 text, max numeric, min numeric, picsure_concept_path text, drs_uri text);

        select array_agg(table_props) into table_names from
        (select ARRAY[infection_status, months_postindex] as table_props
            from processing.visits group by infection_status, months_postindex)innie;
        select array_agg(column_name) into column_names from information_schema.columns where table_schema = 'adult' and table_name = 'visits' and column_name != 'participant_id';
 FOR i IN 1 .. array_upper(table_names, 1)
        LOOP
            status=table_names[i][1];
            monthspi=table_names[i][2];
            output_table_name='visits_' || lower(table_names[i][1] || '-' || table_names[i][2]);
            column_suffix=lower('_' || table_names[i][1] || '_' || table_names[i][2]);
            for j in 1 .. array_upper(column_names, 1)
            LOOP
                data_text = 'select data_type from information_schema.columns where column_name = ''' || column_names[j] || column_suffix || ''' limit 1;';
                raise notice '%', data_text;
                execute data_text into data_type;
                insert_text='insert into processing_metadata.visits_meta (' ||
                            'select ''' || column_names[j] || column_suffix ||''' as varname,
                 ''' || column_names[j] || ' (Infection status: '|| status || ', Months post-index: ' || monthspi || ')'' as vardesc,
                 '''' as docfile,
                '''|| data_type || ''' as type,
                ' || case when data_type != 'character varying' and data_type != 'text' then 'null' else 'array_to_string(array_agg(distinct('||column_names[j]||')), ''|'')'  end || ' as values,
                ''Derived from visits.tsv.'' as comment1,
                ' || case when data_type = 'character varying' or data_type = 'text' then 'null' else 'max('||column_names[j]||'::numeric)' end || ' as max,
                ' || case when data_type = 'character varying' or data_type = 'text' then 'null' else 'min('||column_names[j]||'::numeric)' end || ' as min,
                ''\phs003463\RECOVER_Adult\visits\'' || lower('''||column_names[j] || column_suffix ||''') || ''\'' as picsure_concept_path,
                ''["drs://dg.4503:dg.4503%2Ffe973c70-8180-46bc-8428-de4e8fa16319"]'' as drs_uri ' ||
                            'from processing.visits where visits.table_name = '''|| output_table_name || ''' group by table_name)';
                raise notice '%', insert_text;
                execute insert_text;


                end loop;


        end loop;


END
$$ LANGUAGE Plpgsql;
select * from get_visits_metadata();
