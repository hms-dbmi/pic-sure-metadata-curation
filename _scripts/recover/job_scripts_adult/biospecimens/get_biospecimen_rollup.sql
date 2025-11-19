alter table input.biospecimens
   drop column if exists mpi_cd,
   drop column if exists mpi_type,
    add column mpi_cd text,
    add column mpi_type text;
update input.biospecimens set (mpi_cd, mpi_type) =(
coalesce(regexp_substr(specimen_concept_cd,'(.*(?=(_[0-9]+M.*)|(_BL_)))'), specimen_concept_cd)|| '_' || coalesce(months_since_index_date, 'unknown'),
coalesce(regexp_substr(specimen_type, '(?<=[0-9]\. ).*(?=( at.*)|( .+? Month))'), specimen_type )|| ' (' || coalesce(months_since_index_date, 'unknown') || ' months post-index)');


