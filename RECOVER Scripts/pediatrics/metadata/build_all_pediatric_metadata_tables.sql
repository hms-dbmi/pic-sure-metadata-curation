-- SCHEMA: meta_pediatric

-- DROP SCHEMA IF EXISTS meta_pediatric ;

CREATE SCHEMA IF NOT EXISTS meta_pediatric
    AUTHORIZATION postgres;

-- Table: meta_pediatric.meta_dataframe

-- DROP TABLE IF EXISTS meta_pediatric.meta_dataframe;

CREATE TABLE IF NOT EXISTS meta_pediatric.datasets
(
    ref character varying COLLATE pg_catalog."default",
    full_name character varying COLLATE pg_catalog."default",
    abbreviation character varying COLLATE pg_catalog."default",
    description character varying COLLATE pg_catalog."default",
    data_type character varying COLLATE pg_catalog."default",
    study_focus character varying COLLATE pg_catalog."default",
    study_design character varying COLLATE pg_catalog."default",
    version character varying COLLATE pg_catalog."default",
    phase character varying COLLATE pg_catalog."default",
    additional_information character varying COLLATE pg_catalog."default",
    additional_info_link character varying COLLATE pg_catalog."default",
    additional_info character varying COLLATE pg_catalog."default",
    study_accession character varying COLLATE pg_catalog."default",
    study_link character varying COLLATE pg_catalog."default"
);
DROP TABLE IF EXISTS meta_pediatric.consents;
CREATE TABLE IF NOT EXISTS meta_pediatric.consents
(
    dataset_ref character varying COLLATE pg_catalog."default",
    consent_code character varying COLLATE pg_catalog."default",
    description character varying COLLATE pg_catalog."default",
    participant_count character varying COLLATE pg_catalog."default",
    variable_count character varying COLLATE pg_catalog."default",
    sample_count character varying COLLATE pg_catalog."default",
    authz character varying COLLATE pg_catalog."default"
);
DROP TABLE IF EXISTS meta_pediatric.concepts;
CREATE TABLE IF NOT EXISTS meta_pediatric.concepts(
    dataset_ref character varying COLLATE pg_catalog."default",
    name character varying COLLATE pg_catalog."default",
    display character varying COLLATE pg_catalog."default",
    concept_type character varying COLLATE pg_catalog."default",
    concept_path character varying COLLATE pg_catalog."default",
    parent_concept_path character varying COLLATE pg_catalog."default",
    values character varying COLLATE pg_catalog."default",
    description character varying COLLATE pg_catalog."default",
    stigmatized character varying COLLATE pg_catalog."default"
);
select 'phs003461' as dataset_ref,
        field_name as name,
        concept_name || ' (' || visit_id || ')' as display,
        CASE WHEN field_type='numeric' then 'numeric' else 'categorical' end as concept_type,
        lower(concept_path) as concept_path,
        lower(concept_path_parent) as parent_concept_path,
        CASE WHEN field_type='numeric' then
           ('[' || min(answer) || ',' || max(answer) || ']')::json
            else json_agg(distinct(answer))
         end as values,
        field_name || ' from form ' || form_name || ' and visit ' || visit_id || ' from pediatric caregiver answerdata.tsv.' as description,
        'false' as stigmatized
 from peds_caregiver.answers_curated
 group by field_name, concept_name, concept_path, concept_path_parent, form_name, field_type, visit_id;

insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        field_name as name,
        concept_name || ' (' || visit_type || ')' as display,
        CASE WHEN field_type='numeric' then 'numeric' else 'categorical' end as concept_type,
        lower(concept_path) as concept_path,
        lower(concept_path_parent) as parent_concept_path,
        CASE WHEN field_type='numeric' then
           ('[' || min(answer) || ',' || max(answer) || ']')::json
            else json_agg(distinct(answer))
         end as values,
        field_name || ' from form ' || form_name || ' and visit ' || visit_type || ' from pediatric cohort answerdata.tsv.' as description,
        'false' as stigmatized
 from peds.answers_curated
 group by field_name, concept_name, concept_path, concept_path_parent, form_name, field_type, visit_type
);
insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        field_name as name,
        concept_name || ' (' || visit_type || ')' as display,
        CASE WHEN field_type='numeric' then 'numeric' else 'categorical' end as concept_type,
        lower(concept_path) as concept_path,
        lower(concept_path_parent) as parent_concept_path,
                CASE WHEN field_type='numeric' then
           ('[' || min(answer) || ',' || max(answer) || ']')::json
            else json_agg(distinct(answer))
         end as values,
        field_name || ' from form ' || form_name || ' and visit ' || visit_type || ' from pediatric congenital cohort answerdata.tsv.' as description,
        'false' as stigmatized
 from peds_congenital.answers_curated
  group by field_name, concept_name, concept_path, concept_path_parent, form_name, field_type, visit_type
);

--Biospecimens

insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        specimen_concept_cd as name,
        specimen_type as display,
        'categorical' as concept_type,
        '\phs003461\recover_pediatric_congenital\biospecimens\' || specimen_concept_cd as concept_path,
        '\phs003461\recover_pediatric_congenital\biospecimens\'as parent_concept_path,
         ('[' || 'true' || ',' || 'false' || ']')::json as values,
        case when
            trim(both '"' from mode() within group (order by specimen_volume_units)) != ''
            then
            'Did participant submit sample of type "' ||
            specimen_type ||
            '"? Submitted samples for this specimen type range from ' ||
            min(specimen_volume) ||
            ' to ' ||
            max(specimen_volume) ||
            ' ' ||
            trim(both '"' from mode() within group (order by specimen_volume_units))||
            '. Derived from pediatric congenital cohort biospecimens.tsv.'

            else
                 'Did participant submit sample of type "' ||
            specimen_type ||
            '"? Derived from pediatric congenital cohort biospecimens.tsv.'
	    end as description,

        'false' as stigmatized
 from peds_congenital.biospecimens
  group by specimen_concept_cd, specimen_type
);
insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        specimen_concept_cd as name,
        specimen_type as display,
        'categorical' as concept_type,
        '\phs003461\recover_pediatric_caregiver\biospecimens\' || specimen_concept_cd as concept_path,
        '\phs003461\recover_pediatric_caregiver\biospecimens\'as parent_concept_path,
        ('[' || 'true' || ',' || 'false' || ']')::json as values,
        case when
            trim(both '"' from mode() within group (order by specimen_volume_units)) != ''
            then
            'Did participant submit sample of type "' ||
            specimen_type ||
            '"? Submitted samples for this specimen type range from ' ||
            min(specimen_volume) ||
            ' to ' ||
            max(specimen_volume) ||
            ' ' ||
            trim(both '"' from mode() within group (order by specimen_volume_units))||
            '. Derived from pediatric caregiver cohort biospecimens.tsv.'

            else
                 'Did participant submit sample of type "' ||
            specimen_type ||
            '"? Derived from pediatric caregiver cohort biospecimens.tsv.'
	    end as description,

        'false' as stigmatized
 from peds_caregiver.biospecimens
  group by specimen_concept_cd, specimen_type
);
insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        specimen_concept_cd as name,
        specimen_type as display,
        'categorical' as concept_type,
        '\phs003461\recover_pediatric\biospecimens\' || specimen_concept_cd as concept_path,
        '\phs003461\recover_pediatric\biospecimens\'as parent_concept_path,
        ('[' || 'true' || ',' || 'false' || ']')::json as values,
        case when
            trim(both '"' from mode() within group (order by specimen_volume_units)) != ''
            then
            'Did participant submit sample of type "' ||
            specimen_type ||
            '"? Submitted samples for this specimen type range from ' ||
            min(specimen_volume) ||
            ' to ' ||
            max(specimen_volume) ||
            ' ' ||
            trim(both '"' from mode() within group (order by specimen_volume_units)) ||
            '. Derived from pediatric cohort biospecimens.tsv.'

            else
                 'Did participant submit sample of type "' ||
            specimen_type ||
            '"? Derived from pediatric cohort biospecimens.tsv.'
	    end as description,
        'false' as stigmatized
 from peds.biospecimens
  group by specimen_concept_cd, specimen_type
);

--Demographics

insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        column_name as name,
        column_name as display,
        CASE WHEN data_type='integer' then 'numeric' else 'categorical' end as concept_type,
        '\phs003461\recover_' || table_schema ||'\demographics\' || column_name as concept_path,
        '\phs003461\recover_' || table_schema ||'\demographics\' as parent_concept_path,
        '' as values,
        column_name || ' in ' || regexp_replace(table_schema, '_', ' ') || ' cohort demographics.tsv.' as description,
        'false' as stigmatized
 from information_schema.columns where table_name='demographics' and table_schema~'pediatric.*'
);

--Fitbit
insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        fitbit_concept_cd as name,
        CASE WHEN concept_name = 'NA'
            then fitbit_concept_cd
            else concept_name end as display,
        CASE WHEN fitbit_concept_cd='mhp:device' then 'categorical' else 'numeric' end as concept_type,
        '\phs003461\recover_pediatric\fitbit\' || fitbit_concept_cd as concept_path,
        '\phs003461\recover_pediatric\fitbit\'as parent_concept_path,
        '' as values,
        CASE WHEN fitbit_concept_cd ~ '.*weekly.*'
            then 'Count of recorded weekly Fitbit values for participant for ' || concept_name
            when fitbit_concept_cd ~ '.*alltime.*' then 'Fitbit all time summary - '|| concept_name
            else concept_name
        end as description,
        'false' as stigmatized
 from peds.fitbit group by fitbit_concept_cd, concept_name
);

--Visits
insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        column_name as name,
        column_name || ' (' || regexp_replace(table_name, '\..*', '') || ')' as display,
        CASE WHEN data_type='integer' then 'numeric' else 'categorical' end as concept_type,
        '\phs003461\recover_pediatric_caregiver\' || regexp_replace(table_name, '\..*', '') || '\' || column_name as concept_path,
        '\phs003461\recover_pediatric_caregiver\' || regexp_replace(table_name, '\..*', '') || '\'as parent_concept_path,
        '' as values,
        column_name || ' for visit type ' || regexp_replace(table_name, '\..*', '') || ' in ' || regexp_replace(table_schema, '_', ' ') || ' cohort visits.tsv.' as description,
        'false' as stigmatized
 from information_schema.columns where table_name~'.*visits_data' and table_schema~'pediatric.*'
);

--intermediate nodes
--answerdata forms
insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        form_name as name,
        form_name || ' (' || trim(both ' ' from visit_type) || ')' as display,
        'categorical' as concept_type,
        lower(concept_path_parent) as concept_path,
        CONCAT('\phs003461\recover_pediatric\', replace(trim(both ' ' from visit_type), ' ', '_'), '\') as parent_concept_path,
        '' as values,
        'This dataset contains data from form ' || form_name || ' and visit ' || visit_type || ' in the pediatric cohort  answerdata.tsv.' as description,
        'false' as stigmatized
 from peds.answers_curated
 group by concept_path_parent, form_name, visit_type
);
insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        form_name as name,
        form_name || ' (' || trim(both ' ' from visit_type) || ')' as display,
        'categorical' as concept_type,
        lower(concept_path_parent) as concept_path,
        CONCAT('\phs003461\recover_pediatric_congenital\', replace(trim(both ' ' from visit_type), ' ', '_'), '\') as parent_concept_path,
        '' as values,
        'This dataset contains data from form ' || form_name || ' and visit ' || visit_type || ' in the pediatric congenital cohort  answerdata.tsv.' as description,
        'false' as stigmatized
 from peds_congenital.answers_curated
 group by concept_path_parent, form_name, visit_type
);
insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        form_name as name,
        form_name || ' (' || trim(both ' ' from visit_id) || ')' as display,
        'categorical' as concept_type,
        lower(concept_path_parent) as concept_path,
        CONCAT('\phs003461\recover_pediatric_caregiver\', replace(trim(both ' ' from visit_id), ' ', '_'), '\') as parent_concept_path,
        '' as values,
        'This dataset contains data from form ' || form_name || ' and visit ' || visit_id || ' in the pediatric caregiver cohort answerdata.tsv.' as description,
        'false' as stigmatized
 from peds_caregiver.answers_curated
 group by concept_path_parent, form_name, visit_id
);

--answerdata visits
insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        trim(both ' ' from visit_id) as name,
        trim(both ' ' from visit_id) as display,
        'categorical' as concept_type,
        CONCAT('\phs003461\recover_pediatric_caregiver\', replace(trim(both ' ' from visit_id), ' ', '_'), '\')  as concept_path,
        '\phs003461\recover_pediatric_caregiver\' as parent_concept_path,
        '' as values,
        'This dataset contains forms from visit ' || visit_id || ' in the pediatric caregiver cohort answerdata.tsv and visits.tsv.' as description,
        'false' as stigmatized
 from peds_caregiver.answers_curated
 group by visit_id
);
insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        trim(both ' ' from visit_type) as name,
        trim(both ' ' from visit_type) as display,
        'categorical' as concept_type,
        CONCAT('\phs003461\recover_pediatric\', replace(trim(both ' ' from visit_type), ' ', '_'), '\')  as concept_path,
        '\phs003461\recover_pediatric\' as parent_concept_path,
        '' as values,
        'This dataset contains forms from visit ' || visit_type || ' in the pediatric cohort answerdata.tsv and visits.tsv.' as description,
        'false' as stigmatized
 from peds.answers_curated
 group by visit_type
);
insert into meta_pediatric.concepts
(select 'phs003461' as dataset_ref,
        trim(both ' ' from visit_type) as name,
        trim(both ' ' from visit_type) as display,
        'categorical' as concept_type,
        CONCAT('\phs003461\recover_pediatric_congenital\', replace(trim(both ' ' from visit_type), ' ', '_'), '\')  as concept_path,
        '\phs003461\recover_pediatric_congenital\' as parent_concept_path,
        '' as values,
        'This dataset contains forms from visit ' || visit_type || ' in the pediatric congenital cohort answerdata.tsv and visits.tsv.' as description,
        'false' as stigmatized
 from peds_congenital.answers_curated
 group by visit_type
);

--cohorts and study concepts
insert into meta_pediatric.concepts values
('phs003461', 'recover_pediatric_caregiver', 'RECOVER Pediatric Caregiver Cohort', 'categorical','\phs003461\recover_pediatric_caregiver\',
        '\phs003461\',
        '',
        'The pediatric caregiver cohort for RECOVER Pediatric.',
        'false'),
        ('phs003461', 'recover_pediatric_congenital', 'RECOVER Pediatric Congenital Cohort', 'categorical','\phs003461\recover_pediatric_congenital\',
        '\phs003461\',
        '',
        'The pediatric congenital cohort for RECOVER Pediatric.',
        'false'),
        ('phs003461', 'recover_pediatric', 'RECOVER Pediatric Cohort', 'categorical','\phs003461\recover_pediatric\',
        '\phs003461\',
        '',
        'The pediatric cohort for RECOVER Pediatric.',
        'false'),
        ('phs003461', 'phs003461', 'phs003461', 'categorical','\phs003461\',
        '',
        '',
        '',
        'false');

--dataset and consents
insert into meta_pediatric.consents values
                                        (
                                         'phs003461',
                                         'c1',
                                         'General Research Use (GRU)',
                                         null,
                                         null,
                                         null,
                                         '/programs/RECOVER/projects/RC_Pediatrics_GRU'
                                        );
insert into meta_pediatric.datasets values
                                        (
                                         'phs003461',
                                         'Researching COVID to Enhance Recovery (RECOVER): Post Acute Sequelae of SARS-CoV-2 (PASC) Pediatric Cohort Study',
                                         'RECOVER_Pediatric',
                                         '',
                                         'P',
                                         'COVID-19',
                                         'Retrospective/Prospective',
                                         'v1',
                                         'p1',
                                         '',
                                         '',
                                         '',
                                         'phs003461.v1.p1',
                                         'https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=phs003461.v1.p1'
                                        );

update meta_pediatric.concepts set (concept_path, parent_concept_path) = (replace(concept_path, '\', '\\'), replace(parent_concept_path, '\', '\\'));


--biospecimens/fitbit/demographics nodes
insert into meta_pediatric.concepts values
('phs003461', 'Pediatric Caregiver Demographics', 'RECOVER Pediatric Caregiver Cohort Demographics',
 'categorical','\\phs003461\\recover_pediatric_caregiver\\demographics\\',
        '\\phs003461\\recover_pediatric_caregiver\\',
        '',
        'Data from the demographics.tsv for RECOVER Pediatric Caregiver.',
        'false'),
('phs003461', 'Pediatric Caregiver Biospecimens', 'RECOVER Pediatric Caregiver Cohort Biospecimens',
 'categorical','\\phs003461\\recover_pediatric_caregiver\\biospecimens\\',
        '\\phs003461\\recover_pediatric_caregiver\\',
        '',
        'Data from the biospecimens.tsv for RECOVER Pediatric Caregiver.',
        'false'),

    ('phs003461', 'Pediatric Congenital Demographics', 'RECOVER Pediatric Congenital Cohort Demographics',
 'categorical','\\phs003461\\recover_pediatric_congenital\\demographics\\',
        '\\phs003461\\recover_pediatric_congenital\\',
        '',
        'Data from the demographics.tsv for RECOVER Pediatric Congenital.',
        'false'),
('phs003461', 'Pediatric Congenital Biospecimens', 'RECOVER Pediatric Congenital Cohort Biospecimens',
 'categorical','\\phs003461\\recover_pediatric_congenital\\biospecimens\\',
        '\\phs003461\\recover_pediatric_congenital\\',
        '',
        'Data from the biospecimens.tsv for RECOVER Pediatric Congenital.',
        'false'),
        ('phs003461', 'Pediatric Fitbit', 'RECOVER Pediatric Cohort Fitbit',
 'categorical','\\phs003461\\recover_pediatric\\fitbit\\',
        '\\phs003461\\recover_pediatric\\',
        '',
        'Data from the fitbit.tsv for RECOVER Pediatric.',
        'false'),


        ('phs003461', 'Pediatric Demographics', 'RECOVER Pediatric Cohort Demographics',
 'categorical','\\phs003461\\recover_pediatric\\demographics\\',
        '\\phs003461\\recover_pediatric\\',
        '',
        'Data from the demographics.tsv for RECOVER Pediatric.',
        'false'),
('phs003461', 'Pediatric Biospecimens', 'RECOVER Pediatric Cohort Biospecimens',
 'categorical','\\phs003461\\recover_pediatric\\biospecimens\\',
        '\\phs003461\\recover_pediatric\\',
        '',
        'Data from the biospecimens.tsv for RECOVER Pediatric.',
        'false');

--values for demographics/fitbit
create or replace function get_vals_fitbit() returns void as
    $$
    DECLARE cols text[];
    DECLARE vals_statement text;
        BEGIN
        select array_agg(fitbit_concept_cd) into cols from
		(select fitbit_concept_cd from peds.fitbit group by fitbit_concept_cd) fitbit;
    FOR i IN 1 .. array_upper(cols, 1)
       		LOOP
              if (cols[i] != 'mhp:device')
              then
                vals_statement:= 'update meta_pediatric.concepts set values = vals from ' ||
                                 '(select (''['' || min("'|| cols[i] ||'") || '','' || max("'|| cols[i] ||'") || '']'')::json as vals from pediatric.fitbit)innie ' ||
                                 'where concept_path ~ ''.*' || cols[i] || '.*''';
              else
                vals_statement:= 'update meta_pediatric.concepts set values = vals from ' ||
                    '(select json_agg(distinct("'|| cols[i] || '")) as vals from pediatric.fitbit)innie '||
                                 'where concept_path ~ ''.*' || cols[i] || '.*''';
                end if;
			EXECUTE vals_statement;
	end loop;
    end
    $$ LANGUAGE Plpgsql;
select * from get_vals_fitbit();


create or replace function get_vals_demo() returns void as
    $$
    DECLARE cols1 text[];
        DECLARE cols2 text[];
        DECLARE cols3 text[];
            DECLARE cols4 text[];
        DECLARE cols5 text[];
        DECLARE cols6 text[];
    DECLARE vals_statement text;
        BEGIN
        select array_agg(column_name) into cols1 from
		(select column_name from information_schema.columns where table_name = 'demographics' and table_schema = 'pediatric' and data_type = 'integer') demo1;
        select array_agg(column_name) into cols2 from
		(select column_name from information_schema.columns where table_name = 'demographics' and table_schema = 'pediatric_congenital' and data_type = 'integer') demo2;
        select array_agg(column_name) into cols3 from
		(select column_name from information_schema.columns where table_name = 'demographics' and table_schema = 'pediatric_caregiver' and data_type = 'integer') demo3;
        select array_agg(column_name) into cols4 from
		(select column_name from information_schema.columns where table_name = 'demographics' and table_schema = 'pediatric' and data_type != 'integer') demo1;
        select array_agg(column_name) into cols5 from
		(select column_name from information_schema.columns where table_name = 'demographics' and table_schema = 'pediatric_congenital' and data_type != 'integer') demo2;
        select array_agg(column_name) into cols6 from
		(select column_name from information_schema.columns where table_name = 'demographics' and table_schema = 'pediatric_caregiver' and data_type != 'integer') demo3;
    FOR i IN 1 .. array_upper(cols1, 1)
       		LOOP
                vals_statement:= 'update meta_pediatric.concepts set values = vals from ' ||
                                 '(select (''['' || min("'|| cols1[i] ||'") || '','' || max("'|| cols1[i] ||'") || '']'')::json as vals from pediatric.demographics)innie ' ||
                                 'where concept_path ~ ''.*' || cols1[i] || '.*''';
			EXECUTE vals_statement;
	end loop;
    FOR i IN 1 .. array_upper(cols2, 1)
       		LOOP
                vals_statement:= 'update meta_pediatric.concepts set values = vals from ' ||
                                 '(select (''['' || min("'|| cols2[i] ||'") || '','' || max("'|| cols2[i] ||'") || '']'')::json as vals from pediatric_congenital.demographics)innie ' ||
                                 'where concept_path ~ ''.*' || cols2[i] || '.*''';
			EXECUTE vals_statement;
	end loop;
    FOR i IN 1 .. array_upper(cols3, 1)
       		LOOP
                vals_statement:= 'update meta_pediatric.concepts set values = vals from ' ||
                                 '(select (''['' || min("'|| cols3[i] ||'") || '','' || max("'|| cols3[i] ||'") || '']'')::json as vals from pediatric_caregiver.demographics)innie ' ||
                                 'where concept_path ~ ''.*' || cols3[i] || '.*''';
			EXECUTE vals_statement;
	end loop;
    FOR i IN 1 .. array_upper(cols4, 1)
       		LOOP
                vals_statement:= 'update meta_pediatric.concepts set values = vals from ' ||
                                 '(select json_agg(distinct("'|| cols4[i] || '")) as vals from pediatric.demographics)innie ' ||
                                 'where concept_path ~ ''.*' || cols4[i] || '.*''';
			EXECUTE vals_statement;
	end loop;
    FOR i IN 1 .. array_upper(cols5, 1)
       		LOOP
                vals_statement:= 'update meta_pediatric.concepts set values = vals from ' ||
                                 '(select json_agg(distinct("'|| cols5[i] || '")) as vals from pediatric_congenital.demographics)innie ' ||
                                 'where concept_path ~ ''.*' || cols5[i] || '.*''';
			EXECUTE vals_statement;
	end loop;
        FOR i IN 1 .. array_upper(cols6, 1)
       		LOOP
                vals_statement:= 'update meta_pediatric.concepts set values = vals from ' ||
                                 '(select json_agg(distinct("'|| cols6[i] || '")) as vals from pediatric_caregiver.demographics)innie ' ||
                                 'where concept_path ~ ''.*' || cols6[i] || '.*''';
			EXECUTE vals_statement;
	end loop;
    end
    $$ LANGUAGE Plpgsql;
select * from get_vals_demo();

update meta_pediatric.concepts
set description = description || ' Dates have been shifted to protect anonymity.'
where
((name ~* '.*dt.*' or name ~* '.*date.*' or name ~* '.*preg.*' or name ~* '.*month.*')
and (display ~* '.*date.*' or display ~* '.*when.*')) or name = 'dob';
select * from meta_pediatric.concepts where description ~ '.* Dates have been shifted .*';