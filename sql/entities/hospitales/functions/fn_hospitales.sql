CREATE OR REPLACE FUNCTION fn_hospitales(_id INT)
    RETURNS TABLE
            (
                HOSPITALES_ID INT,
                NOMBRE        VARCHAR(100),
                DIRECCION     VARCHAR(255),
                CELULAR       VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM hospitales WHERE id = _id) THEN
        RAISE EXCEPTION 'El hospital no existe "%".', _id;
    END IF;

    RETURN QUERY SELECT h.id,
                        h.nombre,
                        h.direccion,
                        h.celular
                 FROM hospitales AS h
                 WHERE h.id = _id;

END
$$;