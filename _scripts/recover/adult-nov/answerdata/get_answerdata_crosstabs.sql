CREATE OR REPLACE FUNCTION get_answerdata_crosstabs()
	returns void as
	$$
	DECLARE table_names varchar[][];
	DECLARE col_names varchar[];
	DECLARE get_cols_statement text := '';
	DECLARE crosstabs_statement text := '';
	BEGIN
	    create schema if not exists output_answerdata;
		SELECT array_agg(distinct(ARRAY[form_name, field_name])) into table_names from processing.concepts;

     	FOR i IN 1 .. array_upper(table_names, 1)
       		LOOP
       		get_cols_statement=
       		'SELECT array_agg(distinct(quote_ident(concept_code)) || '' varchar'') from processing.concepts ' ||
       		'where form_name = ''' || table_names[i][1] || ''' and field_name = ''' || table_names[i][2] || '''  group by db_table_name;';
       		--raise notice '%', get_cols_statement;
       		execute get_cols_statement into col_names;

			crosstabs_statement= 'drop table if exists output_answerdata.' || table_names[i][1] || '_' || table_names[i][2] || ';' ||
			                     'create table output_answerdata.' || table_names[i][1] || '_' || table_names[i][2] ||
			                     ' as (select * from
crosstab(
''select participant_id,
conecpt_cd,
case when (field_type = ''''numeric'''') then
trim_scale(answer_numeric_val)::text
when (field_type = ''''text'''') then
answer_text_val
else
answer_label
end
from adult.answerdata
where form_name = '''''|| table_names[i][1] || ''''' and field_name = '''''|| table_names[i][2] || ''''' order by 1,2'',' ||
			                     '''select distinct(conecpt_cd) from adult.answerdata where form_name = '''''|| table_names[i][1] || ''''' and field_name = '''''|| table_names[i][2] || ''''' order by 1''

)
as ct(participant_id varchar, ' || array_to_string(col_names, ',
			                                                         ') || '))';
			--raise notice '%', crosstabs_statement;
			EXECUTE crosstabs_statement;
			end loop;
	END
	$$ LANGUAGE Plpgsql;

	