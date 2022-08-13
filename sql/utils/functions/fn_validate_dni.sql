CREATE OR REPLACE FUNCTION fn_validate_dni(dni VARCHAR)
    RETURNS BOOLEAN AS
$$
BEGIN
    RETURN (dni ~ '^\d{4}\-\d{4}\-\d{5}$');
END;
$$
    LANGUAGE plpgsql;