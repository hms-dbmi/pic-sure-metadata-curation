alter table input.concepts
    drop column if exists concept_path_rollup,
    drop column if exists concept_code_rollup,
    drop column if exists concept_name_rollup,
    add concept_path_rollup text,
    add concept_code_rollup text,
    add concept_name_rollup text;
alter table input.answerdata
    drop column if exists concept_code_rollup,
    add concept_code_rollup text;

delete
from input.concepts
where field_name = 'ps_sinus_burden'
  and concept_path ~ 'sprblms';

create or replace function get_val(data_field_name TEXT)
    returns TEXT
as
$$
BEGIN
    return coalesce(
            case when data_field_name ~ '_{4}'
                        then '-' || regexp_substr(
                                            data_field_name, '(?<=_{4}).*')
                        else
                        regexp_substr(
                                data_field_name,
                                '(?<=_{3}).*'
                        ) end,
            ''
           );
END
$$
    LANGUAGE Plpgsql;

update input.concepts
set (concept_path_rollup, concept_code_rollup, concept_name_rollup) =
        ((regexp_replace(concept_path,
                  '\\' || get_val(data_field_name) || '\\',
                  '\\'
          )),
         (replace(concept_code, data_field_name, field_name)),
         case when data_field_name != field_name
         then
         (regexp_replace(concept_name, ('\(' || get_val(data_field_name) || '\,.*\)'), ''))
         else
         concept_name
         end
            );
update input.answerdata
set concept_code_rollup = coalesce(replace(concept_cd, data_field_name, field_name), concept_cd);

