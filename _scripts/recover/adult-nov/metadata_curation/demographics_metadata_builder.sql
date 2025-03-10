create or replace function get_demographics_metadata()
	returns void as
	$$
    DECLARE column_names text[];
    DECLARE insert_text text;
    DECLARE c_name text;

BEGIN
        drop table if exists processing_metadata.demographics_meta;
        create table if not exists processing_metadata.demographics_meta(varname text, vardesc text, docfile text, type text, values text, comment1 text, max numeric, min numeric, picsure_concept_path text, drs_uri text);

        select array_agg(column_name) into column_names from information_schema.columns where 
        table_schema = 'adult' and table_name = 'demographics' and column_name != 'participant_id';
 FOR j IN 1 .. array_upper(column_names, 1)
        LOOP
            c_name = column_names[j];
          
                insert_text='insert into processing_metadata.demographics_meta (' ||
                    'select column_name as varname,
                     column_name || '' (Demographics)'' as vardesc,
                     null as docfile,
                     data_type as type,
                     case when data_type = ''character varying'' ' ||
                            'then (select array_to_string(array_agg(distinct(' || c_name || ')), ''|'') from output_demographics.demographics)
                     end as values,
                     ''Sourced from demographics.tsv'' as comment1,
                    (case when data_type != ''character varying'' then (select max(' || c_name || ') from output_demographics.demographics) end)::numeric as max,
                    (case when data_type != ''character varying'' then (select min(' || c_name || ') from output_demographics.demographics) end)::numeric as min,
                     ''\phs003463\RECOVER_Adult\demographics\'' || lower(column_name)|| ''\'' as picsure_concept_path,
                      ''["drs://dg.4503:dg.4503%2F91aa2abc-8d6d-410e-a491-1b099857a9ca"]'' as drs_uri from
                     information_schema.columns where table_schema = ''output_demographics'' and column_name = ''' || c_name || ''')';
                raise notice '%', insert_text;
                execute insert_text;
        end loop;


END
$$ LANGUAGE Plpgsql;
select * from get_demographics_metadata();
