CREATE OR REPLACE FUNCTION fn_ocupaciones(_id INT)
    RETURNS TABLE
            (
                OCUPACION_ID          INT,
                OCUPACION_DESCRIPCION VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF NOT EXISTS(SELECT * FROM ocupaciones WHERE ocupacion_id = _id) THEN

        RAISE NOTICE 'La ocupacion no existe "%".', _id;
    END IF;
    RETURN QUERY SELECT o.id,
                        o.descripcion
                 FROM ocupaciones AS o
                 WHERE o.id = _id;
END;
$$;