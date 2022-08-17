CREATE OR REPLACE FUNCTION fn_tipos_socios(_id INT)
    RETURNS TABLE
            (
                TIPOS_SOCIOS_ID          INT,
                TIPOS_SOCIOS_DESCRIPCION VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF NOT EXISTS(SELECT * FROM tipos_socios WHERE tipos_socios_id = _id) THEN

        RAISE NOTICE 'El tipo de socio no existe "%".', _id;
    END IF;
    RETURN QUERY SELECT tipos_socios.id,
                        tipos_socios.descripcion
                 FROM tipos_socios
                 WHERE tipos_socios.id = _id;
END;
$$;