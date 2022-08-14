CREATE OR REPLACE FUNCTION fn_validate_date(date VARCHAR)
    RETURNS BOOLEAN AS
$$
BEGIN
    RETURN (date ~ '^\d{4,4}\-\d{2}\-\d{2}$');
END;
$$
    LANGUAGE plpgsql;
    