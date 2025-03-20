drop schema if exists output_answerdata cascade;
create schema output_answerdata;

set search_path = input;
create extension if not exists tablefunc;
CREATE OR REPLACE FUNCTION get_answerdata_crosstabs(
)
    returns void
as
$$
DECLARE
    table_names varchar[][];
    DECLARE col_names varchar[];
    DECLARE get_cols_statement text := '';
    DECLARE crosstabs_arg_1 text := '';
    DECLARE crosstabs_arg_2 text := '';
    DECLARE create_table_statement text := '';
    DECLARE dataset_name text := '';
    DECLARE table_count int = 0;
BEGIN
    --table naming structure is (form_name)_(field_name) - one field can have many concepts
    --limiting tables to just form can result in too many columns for one table
    select array_agg(formfield)
        from
            (
                SELECT ARRAY [form_name, field_name] as formfield into table_names from answerdata group by form_name, field_name
            ) ini;
    select value into dataset_name from resources.meta_utils where key = 'dataset_name';
    raise INFO 'Starting creation of % table(s) from form/field pairs in answerdata', array_upper(table_names, 1);
    FOR i IN 1 .. array_upper(table_names, 1)
        LOOP
        --raise INFO 'Building table for form % and field %', table_names[i][1], table_names[i][2];


        --get participant/value pairs for each concept in the given form/field pair
            crosstabs_arg_1 =
            'select
                participant_id,
                concept_cd,
                case
                    when (field_type = ''numeric'') then
                        trim_scale(answer_numeric_val::numeric)::text
                    when (field_type = ''text'') then
                        answer_text_val
                    else
                        answer_label
                end
                from answerdata
                where form_name = ' || quote_literal(table_names[i][1]) || ' and ' ||
            'field_name = ' || quote_literal(table_names[i][2]) || ' order by 1,2';
            --raise INFO 'arg1: %', crosstabs_arg_1;

            --sets order of concepts by getting distinct concept list and ordering on it
            crosstabs_arg_2 =
            'select distinct(concept_cd) from answerdata ' ||
            'where form_name = ' || quote_literal(table_names[i][1])
                || ' and field_name = ' || quote_literal(table_names[i][2]) || ' order by 1';
            --raise INFO 'arg2: %', crosstabs_arg_2;

            --gets the array of columns for the given form and field, and concats it with "varchar"
            --to complete the explicit table declaration
            get_cols_statement =
            'SELECT array_agg(distinct(quote_ident(lower(concept_cd))) || '' varchar'') from answerdata ' ||
            'where form_name = ''' || table_names[i][1] || ''' and field_name = ''' || table_names[i][2]
                || '''  group by form_name, field_name;';
            --raise INFO 'col array: %', get_cols_statement;

            execute get_cols_statement into col_names;
            --piece all the elements together into one statement that performs the crosstab
--and selects it into the new table
            create_table_statement =
            'create table ' ||
            'output_answerdata.' || quote_ident(table_names[i][2]) ||
            ' as (select * from ' ||
            'crosstab(' ||
            quote_literal(crosstabs_arg_1) || ', ' || quote_literal(crosstabs_arg_2) ||
            ') as ct(participant_id varchar, ' || array_to_string(col_names, ', ') || ')' ||
            ')';


            --raise INFO '%', create_table_statement;
            EXECUTE create_table_statement;
            table_count = table_count + 1;
        end loop;
    raise INFO 'Successfully created % table(s) from form/field pairs in answerdata file', table_count;
END
$$
    LANGUAGE Plpgsql;
select * from get_answerdata_crosstabs();

