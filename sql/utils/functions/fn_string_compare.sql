CREATE OR REPLACE FUNCTION fn_string_compare(
    _a VARCHAR,
    _b VARCHAR
)
    RETURNS BOOLEAN
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF TRIM(LOWER(_a)) = TRIM(LOWER(_b)) THEN
        RETURN TRUE;
    END IF;

    RETURN FALSE;
END
$$;
