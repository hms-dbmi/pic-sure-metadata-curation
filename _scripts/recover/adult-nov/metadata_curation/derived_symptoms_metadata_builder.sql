create or replace function get_biostats_derived_symptoms_metadata()
	returns void as
	$$
	DECLARE table_names varchar[];
	DECLARE event_name text;
	DECLARE output_table_name text;
    DECLARE column_suffix text;
    DECLARE column_names text[];
    DECLARE insert_text text;
    DECLARE data_type text;
    DECLARE data_text text;
BEGIN
        drop table if exists processing_metadata.biostats_derived_symptoms_meta;
        create table if not exists processing_metadata.biostats_derived_symptoms_meta(varname text, vardesc text, docfile text, type text, values text, comment1 text, max numeric, min numeric, picsure_concept_path text, drs_uri text);

        select array_agg(distinct(redcap_event_name)) into table_names
            from adult.biostats_derived_symptoms where redcap_event_name is not null;
        select array_agg(column_name) into column_names from information_schema.columns where table_schema = 'adult' and table_name = 'biostats_derived_symptoms' and column_name != 'record_id' and column_name != 'redcap_event_name';
 FOR i IN 1 .. array_upper(table_names, 1)
        LOOP
            event_name=table_names[i];
            output_table_name='biostats_derived_symptoms_' || lower(table_names[i]);
            column_suffix=lower('_' || table_names[i]);
            for j in 1 .. array_upper(column_names, 1)
            LOOP
                data_text = 'select data_type from information_schema.columns where column_name = ''' || column_names[j] || column_suffix || ''' limit 1;';
                raise notice '% % %', column_names[j], column_suffix, data_text;
                execute data_text into data_type;
                insert_text='insert into processing_metadata.biostats_derived_symptoms_meta (' ||
                            'select ''' || column_names[j] || column_suffix ||''' as varname,
                 (select description from dictionaries.biostats_derived_combined where variable = ''' || column_names[j] || ''' limit 1) || '' ('|| event_name||')'' as vardesc,
                 '''' as docfile,
                '''|| data_type || ''' as type,
                ' || case when data_type != 'character varying' and data_type != 'text' then 'null' else 'array_to_string(array_agg(distinct('||column_names[j]||')), ''|'')'  end || ' as values,
                ''Derived from biostats_derived_symptoms.tsv.'' as comment1,
                ' || case when data_type = 'character varying' or data_type = 'text' then 'null' else 'max('||column_names[j]||'::numeric)' end || ' as max,
                ' || case when data_type = 'character varying' or data_type = 'text' then 'null' else 'min('||column_names[j]||'::numeric)' end || ' as min,
                ''\phs003463\RECOVER_Adult\biostats_derived_symptoms\'' || lower('''||column_names[j] || column_suffix ||''') || ''\'' as picsure_concept_path,
                ''["drs://dg.4503:dg.4503%2Ffe973c70-8180-46bc-8428-de4e8fa16319"]'' as drs_uri ' ||
                            'from adult.biostats_derived_symptoms where biostats_derived_symptoms.redcap_event_name = '''|| event_name || ''' group by redcap_event_name)';
                raise notice '%', insert_text;
                execute insert_text;


                end loop;


        end loop;
        update processing_metadata.biostats_derived_symptoms_meta set vardesc = (varname || vardesc) where vardesc ~ '^( \()';

END
$$ LANGUAGE Plpgsql;
select * from get_biostats_derived_symptoms_metadata();
