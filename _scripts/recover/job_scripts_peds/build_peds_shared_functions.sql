create or replace function get_clean_visit_type(visit_type TEXT)
    returns TEXT
as
$$
BEGIN
--cleans up the visit type so it plays nice with the concept code and psql column headers

    --set the visit type to lower case and remove leading/trailing spaces
    visit_type := lower(TRIM(visit_type));
    --replace spaces with underscores
    visit_type := replace(visit_type, ' ', '_');
    --replace dashes with underscores
    visit_type := replace(visit_type, '-', '_');

    return visit_type;
END
$$
LANGUAGE Plpgsql;
