DO LANGUAGE Plpgsql $$
    BEGIN
        RAISE NOTICE 'starting merge for all metadata tables in processing_metadata schema';
    END
$$;

CREATE OR REPLACE FUNCTION merge_metadata_tables() RETURNS void AS $$
DECLARE table_statements text[]; DECLARE merge_statement text; DECLARE dataset_name text;
BEGIN

    CREATE SCHEMA IF NOT EXISTS metadata_output;

    DROP TABLE IF EXISTS metadata_output.metadata;

    SELECT ARRAY_AGG(DISTINCT ('select * from processing_metadata.' || TABLE_NAME))
        INTO table_statements
        FROM information_schema.tables
        WHERE table_schema = 'processing_metadata';

    merge_statement = 'create table metadata_output.metadata as (' || ARRAY_TO_STRING(table_statements, 'UNION ALL');
    RAISE NOTICE '%', merge_statement;

    EXECUTE merge_statement;

END
$$ LANGUAGE Plpgsql;

SELECT * FROM merge_metadata_tables();

DO LANGUAGE Plpgsql $$
    BEGIN
        RAISE NOTICE 'completed merge for all metadata tables in processing_metadata schema';
    END
$$;