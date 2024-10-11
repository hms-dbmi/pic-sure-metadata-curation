CREATE SCHEMA IF NOT EXISTS pediatric
    AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS pediatric_caregiver
    AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS pediatric_congenital
    AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS peds
    AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS peds_caregiver
    AUTHORIZATION postgres;
CREATE SCHEMA IF NOT EXISTS peds_congenital
    AUTHORIZATION postgres;

create table peds.answerdata
(
    participant_id     varchar,
    visit_id           varchar,
    visit_type         varchar,
    data_entry_date    varchar,
    form_name          varchar,
    instance_num       integer,
    field_name         varchar,
    data_field_name    varchar,
    field_type         varchar,
    answer_label       varchar,
    answer_numeric_val numeric,
    answer_text_val    varchar,
    conecpt_cd         varchar,
    concept_name       varchar
);

alter table peds.answerdata
    owner to postgres;

create table peds.biospecimens
(
    participant_id                  varchar,
    kit_id                          varchar,
    collection_date                 varchar,
    specimen_type                   varchar,
    specimen_concept_cd             varchar,
    specimen_volume                 integer,
    specimen_volume_units           varchar,
    specimen_thaw_count             integer,
    collection_to_freeze_time_hours integer,
    pbmc_cell_count                 integer,
    pbmc_cell_viability             numeric
);

alter table peds.biospecimens
    owner to postgres;

create table peds.concepts
(
    concept_code    varchar,
    field_name      varchar,
    data_field_name varchar,
    form_name       varchar,
    concept_name    varchar,
    concept_path    varchar
);

alter table peds.concepts
    owner to postgres;

create table peds.demographics
(
    participant_id     varchar,
    enroll_protocol    varchar,
    enroll_site_id     integer,
    enroll_hub_site_id integer,
    enroll_site_path   varchar,
    enroll_date        varchar,
    enroll_category    varchar,
    enroll_index_date  varchar,
    sex_at_birth       varchar,
    dob                integer,
    age_at_enrollment  integer,
    enroll_zip_code    integer,
    withdrawn          varchar,
    withdraw_date      varchar,
    deceased           varchar,
    deceased_date      varchar
);

alter table peds.demographics
    owner to postgres;

create table peds.fitbit
(
    participant_id    varchar,
    encounter_num     varchar,
    summary_date      varchar,
    fitbit_concept_cd varchar,
    concept_name      varchar,
    summary_value     varchar,
    device_type       varchar
);

alter table peds.fitbit
    owner to postgres;

create table peds.visits
(
    visit_id         varchar,
    participant_id   varchar,
    visit_site_id    integer,
    visit_type       varchar,
    visit_start_date varchar
);

alter table peds.visits
    owner to postgres;

create table peds_caregiver.answerdata
(
    participant_id     varchar,
    visit_id           varchar,
    visit_type         varchar,
    data_entry_date    varchar,
    form_name          varchar,
    instance_num       integer,
    field_name         varchar,
    data_field_name    varchar,
    field_type         varchar,
    answer_label       varchar,
    answer_numeric_val numeric,
    answer_text_val    varchar,
    conecpt_cd         varchar,
    concept_name       varchar
);

alter table peds_caregiver.answerdata
    owner to postgres;

create table peds_caregiver.biospecimens
(
    participant_id                  varchar,
    kit_id                          varchar,
    collection_date                 varchar,
    specimen_type                   varchar,
    specimen_concept_cd             varchar,
    specimen_volume                 integer,
    specimen_volume_units           varchar,
    specimen_thaw_count             integer,
    collection_to_freeze_time_hours integer
);

alter table peds_caregiver.biospecimens
    owner to postgres;

create table peds_caregiver.concepts
(
    concept_code    varchar,
    field_name      varchar,
    data_field_name varchar,
    form_name       varchar,
    concept_name    varchar,
    concept_path    varchar
);

alter table peds_caregiver.concepts
    owner to postgres;

create table peds_caregiver.demographics
(
    participant_id     varchar,
    enroll_protocol    varchar,
    enroll_site_id     integer,
    enroll_hub_site_id integer,
    enroll_site_path   varchar,
    enroll_date        varchar,
    enroll_category    varchar,
    enroll_index_date  varchar,
    sex_at_birth       varchar,
    dob                integer,
    age_at_enrollment  integer,
    enroll_zip_code    integer,
    withdrawn          varchar,
    withdraw_date      varchar,
    deceased           varchar,
    deceased_date      varchar
);

alter table peds_caregiver.demographics
    owner to postgres;

create table peds_caregiver.visits
(
    visit_id         varchar,
    participant_id   varchar,
    visit_site_id    integer,
    visit_type       varchar,
    visit_start_date varchar
);

alter table peds_caregiver.visits
    owner to postgres;

create table peds_congenital.answerdata
(
    participant_id     varchar,
    visit_id           varchar,
    visit_type         varchar,
    data_entry_date    varchar,
    form_name          varchar,
    instance_num       integer,
    field_name         varchar,
    data_field_name    varchar,
    field_type         varchar,
    answer_label       varchar,
    answer_numeric_val numeric,
    answer_text_val    varchar,
    conecpt_cd         varchar,
    concept_name       varchar
);

alter table peds_congenital.answerdata
    owner to postgres;

create table peds_congenital.biospecimens
(
    participant_id                  varchar,
    kit_id                          varchar,
    collection_date                 varchar,
    specimen_type                   varchar,
    specimen_concept_cd             varchar,
    specimen_volume                 integer,
    specimen_volume_units           varchar,
    specimen_thaw_count             integer,
    collection_to_freeze_time_hours integer
);

alter table peds_congenital.biospecimens
    owner to postgres;

create table peds_congenital.visits
(
    visit_id         varchar,
    participant_id   varchar,
    visit_site_id    integer,
    visit_type       varchar,
    visit_start_date varchar
);

alter table peds_congenital.visits
    owner to postgres;

create table peds_congenital.demographics
(
    participant_id     varchar,
    enroll_protocol    varchar,
    enroll_site_id     integer,
    enroll_hub_site_id integer,
    enroll_site_path   varchar,
    enroll_date        varchar,
    enroll_category    varchar,
    enroll_index_date  varchar,
    sex_at_birth       varchar,
    dob                integer,
    age_at_enrollment  integer,
    enroll_zip_code    integer,
    withdrawn          varchar,
    withdraw_date      varchar,
    deceased           varchar,
    deceased_date      varchar
);

alter table peds_congenital.demographics
    owner to postgres;

create table peds_congenital.concepts
(
    concept_code    varchar,
    field_name      varchar,
    data_field_name varchar,
    form_name       varchar,
    concept_name    varchar,
    concept_path    varchar
);

alter table peds_congenital.concepts
    owner to postgres;

create table peds_caregiver.answers_curated
(
    participant_id      varchar,
    visit_id            varchar,
    form_name           varchar,
    field_name          varchar,
    field_type          varchar,
    answer              varchar,
    conecpt_cd          varchar,
    concept_name        text,
    concept_path        text,
    concept_path_parent text
);

alter table peds_caregiver.answers_curated
    owner to postgres;

create table peds.answers_curated
(
    participant_id      varchar,
    visit_type          varchar,
    form_name           varchar,
    field_name          varchar,
    field_type          varchar,
    answer              varchar,
    conecpt_cd          varchar,
    concept_name        text,
    concept_path        text,
    concept_path_parent text
);

alter table peds.answers_curated
    owner to postgres;

create table peds_congenital.answers_curated
(
    participant_id      varchar,
    visit_type          varchar,
    form_name           varchar,
    field_name          varchar,
    field_type          varchar,
    answer              varchar,
    conecpt_cd          varchar,
    concept_name        text,
    concept_path        text,
    concept_path_parent text
);

alter table peds_congenital.answers_curated
    owner to postgres;

