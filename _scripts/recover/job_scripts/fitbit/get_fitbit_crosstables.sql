
do LANGUAGE Plpgsql $$BEGIN
raise INFO 'starting curation of fitbit data';
END$$;
CREATE OR REPLACE FUNCTION get_fitbit_crosstabs()
	returns void as
	$$
	DECLARE weekly_col_names varchar[];
	DECLARE alltime_col_names varchar[];
	DECLARE weekly_crosstabs_statement text := '';
	DECLARE alltime_crosstabs_statement text := '';
    BEGIN
        set SEARCH_PATH = input;
        drop schema if exists output_fitbit cascade;
        create schema if not exists output_fitbit;
        select array_agg(quote_ident(concept_cd) || ' varchar')
        into weekly_col_names
        from (
            select distinct(fitbit_concept_cd) as concept_cd from input.fitbit
                where fitbit_concept_cd ~ '.*weekly.*'
        )innie;

        weekly_crosstabs_statement='create table output_fitbit.weekly as (select * from crosstab(
            ''select participant_id, fitbit_concept_cd, count(*) as value
                from input.fitbit
                where fitbit_concept_cd ~ ''''.*weekly.*''''
                group by participant_id, fitbit_concept_cd order by 1,2'',' ||
                                   '''select distinct(fitbit_concept_cd) as concept_cd from input.fitbit
                where fitbit_concept_cd ~ ''''.*weekly.*''''order by 1''
        ) as ct(participant_id varchar, '|| array_to_string(weekly_col_names, ', ')||'));';
        execute weekly_crosstabs_statement;

        select array_agg(quote_ident(concept_cd) || ' varchar') into alltime_col_names from (
            select distinct(fitbit_concept_cd) as concept_cd from input.fitbit
                where fitbit_concept_cd ~ '.*alltime.*'
        )innie;
        alltime_crosstabs_statement='create table output_fitbit.alltime as (select * from crosstab(
            ''select participant_id, fitbit_concept_cd, summary_value as value
                from input.fitbit
                where fitbit_concept_cd ~ ''''.*alltime.*''''
                order by 1,2'',' ||
                                   '''select distinct(fitbit_concept_cd) as concept_cd from input.fitbit
                where fitbit_concept_cd ~ ''''.*alltime.*'''' order by 1''
       ) as ct(participant_id varchar, '|| array_to_string(weekly_col_names, ', ')||'));';
        execute alltime_crosstabs_statement;
    END
    $$ LANGUAGE Plpgsql;

select * from get_fitbit_crosstabs();
do LANGUAGE Plpgsql $$BEGIN
raise INFO 'successfully completed curation of fitbit data';
END$$;