CREATE OR REPLACE FUNCTION fn_validate_phone(phone VARCHAR)
    RETURNS BOOLEAN AS
$$
BEGIN
    RETURN (phone ~ '^\+1?\d{9,15}$');
END;
$$
    LANGUAGE plpgsql;