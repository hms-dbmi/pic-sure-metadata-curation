create or replace function get_biostats_derived_core_proc_metadata()
	returns void as
	$$
    DECLARE column_names text[];
    DECLARE insert_text text;
    DECLARE c_name text;

BEGIN
        drop table if exists processing_metadata.derived_core_proc_meta;
        create table if not exists processing_metadata.biostats_derived_core_proc_meta(varname text, vardesc text, docfile text, type text, values text, comment1 text, max numeric, min numeric, picsure_concept_path text, drs_uri text);

        select array_agg(column_name) into column_names from information_schema.columns where 
        table_schema = 'adult' and table_name = 'biostats_derived_core_proc' and column_name != 'participant_id';
 FOR j IN 1 .. array_upper(column_names, 1)
        LOOP
            c_name = lower(column_names[j]);
          
                insert_text='insert into processing_metadata.biostats_derived_core_proc_meta (' ||
                    'select column_name as varname,
                     (select description from dictionaries.biostats_derived_combined where variable = ''' || c_name || ''' limit 1) as vardesc,
                     null as docfile,
                     data_type as type,
                     case when data_type != ''numeric'' ' ||
                            'then (select array_to_string(array_agg(distinct(' || c_name || ')), ''|'') from output_biostats_derived_core_proc.biostats_derived_core_proc)
                     end as values,
                     ''Sourced from biostats_derived_core_proc.tsv'' as comment1,
                    (case when data_type = ''numeric'' then (select min(' || c_name || ') from output_biostats_derived_core_proc.biostats_derived_core_proc) end)::numeric as max,
                    (case when data_type = ''numeric'' then (select max(' || c_name || ') from output_biostats_derived_core_proc.biostats_derived_core_proc) end)::numeric as min,
                     ''\phs003463\RECOVER_Adult\biostats_derived_core_proc\'' || lower(column_name)|| ''\'' as picsure_concept_path,
                      ''["drs://dg.4503:dg.4503%2F24148f27-155e-486a-a3e5-b0064b00cad2"]'' as drs_uri from
                     information_schema.columns where table_schema = ''output_biostats_derived_core_proc'' and column_name = ''' || c_name || ''')';
                raise notice '%', insert_text;
                execute insert_text;
        end loop;


END
$$ LANGUAGE Plpgsql;
select * from get_biostats_derived_core_proc_metadata();
