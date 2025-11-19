
CREATE OR REPLACE FUNCTION get_biospecimens_subtables_peds()
	returns void as
	$$
	DECLARE concept_names varchar[];
	DECLARE table_statement text;
    DECLARE concept_name varchar;
    DECLARE concept_name_norm varchar;
    DECLARE dataset_suffix varchar;
    DECLARE table_count int = 0;
	BEGIN
	    drop schema if exists output_biospecimens cascade;
	    create schema output_biospecimens;
		select array_agg(concept_cd) into concept_names from (SELECT distinct(specimen_concept_cd) as concept_cd from input.biospecimens
            group by specimen_concept_cd order by specimen_concept_cd)innie;
        select value into dataset_suffix from resources.meta_utils where key = 'dataset_suffix';
        raise INFO 'Starting creation of % table(s) of kit ids from biospecimens', array_upper(concept_names, 1);
        FOR i IN 1 .. array_upper(concept_names, 1)
        LOOP
        concept_name=concept_names[i];
        concept_name_norm = lower(regexp_replace(concept_name, ':', '_')) ;
     	table_statement='create table output_biospecimens."'|| concept_name_norm ||'"
            as (select participant_id, kit_id as "'|| concept_name_norm ||'_kit_id' || dataset_suffix|| '" from input.biospecimens
            where specimen_concept_cd = '''|| concept_name ||''')';
        --raise INFO '%', table_statement;
        execute table_statement;
        table_count = table_count + 1;
        end loop;
        raise INFO 'Successfully created % table(s) of kit ids from biospecimens', table_count;
	END
	$$ LANGUAGE Plpgsql;
	select * from get_biospecimens_subtables_peds();

do LANGUAGE Plpgsql $$BEGIN
raise INFO 'starting creation of table for biospecimens metadata';
END$$;
drop table if exists processing_metadata.biospecimens_meta;
create table processing_metadata.biospecimens_meta as (
    select
        meta_utils_id.value as dataset_ref,
    lower(regexp_replace(biospecimens.specimen_concept_cd, ':', '_')) || '_kit_id' || meta_utils_suffix.value as name,
    specimen_type as display,
    'categorical' as concept_type,
    '\' || meta_utils_id.value || '\' || meta_utils_name.value || '\biospecimens\' ||  lower(regexp_replace(biospecimens.specimen_concept_cd, ':', '_')) || '_kit_id' || '\' as concept_path,
    json_build_object(
        --metadata key: description
        'description',
        'Kit Ids corresponding to specimen of type "' || specimen_type || '".' ||
            (case when min_volume is not null and max_volume is not null
                then ' Min volume among samples was ' || min_volume::numeric || ' ' || unit || ' and max volume was ' || max_volume::numeric || ' ' || unit || '. '
                else '' end)
        || ' See biospecimen.tsv file for further specimen information.' ,
        --metadata key: drs_uri
        'drs_uri',
        drs.uri
    )::text as metadata
    from
    (select specimen_concept_cd, specimen_type from input.biospecimens group by specimen_concept_cd, specimen_type)  as biospecimens
    left join
        (select specimen_concept_cd,
        array_agg(distinct(kit_id)) as text_val,
        min(specimen_volume) as min_volume,
        max(specimen_volume) as max_volume,
        min(specimen_volume_units) as unit
        from input.biospecimens
        group by specimen_concept_cd) as ad
    on ad.specimen_concept_cd = biospecimens.specimen_concept_cd
    left join  (select value from resources.meta_utils where key = 'study_id') as meta_utils_id on true
    left join (select value from resources.meta_utils where key = 'dataset_name') as meta_utils_name on true
    left join (select value from resources.meta_utils where key = 'dataset_suffix') as meta_utils_suffix on true
    left join (select array_to_json(array_agg(ga4gh_drs_uri))::text as uri
               from resources.manifest
               where (file_name ~* 'biospecimens')
                 and file_name ~* (select value || '/' from resources.meta_utils where key = 'file_substring')) as drs on true
);
do LANGUAGE Plpgsql $$BEGIN
raise INFO 'successfully established table for biospecimens metadata';
END$$
