--used to build small sample datasets for testing recover pediatric caregiver and pediatric congenital dataset in phs003461

drop schema if exists sample;
create schema sample;
create table sample.answerdata as (select *
                                   from input.answerdata
                                   where participant_id in (select participant_id
                                                            from input.answerdata
                                                            intersect
                                                            select participant_id
                                                            from input.demographics
                                                            intersect
                                                            select participant_id
                                                            from input.biospecimens
                                                            intersect
                                                            select participant_id
                                                            from input.visits
                                                            limit 100));

create table sample.demographics as (select *
                                   from input.demographics
                                   where participant_id in (select participant_id
                                                            from sample.answerdata));

create table sample.biospecimens as (select *
                                   from input.biospecimens
                                   where participant_id in (select participant_id
                                                            from sample.answerdata));
create table sample.visits as (select *
                                   from input.visits
                                   where participant_id in (select participant_id
                                                            from sample.answerdata));
create table sample.concepts as (select * from input.concepts);
