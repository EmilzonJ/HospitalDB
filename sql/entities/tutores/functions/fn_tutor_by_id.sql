CREATE OR REPLACE FUNCTION fn_tutor_by_id(_id INT)
    RETURNS TABLE
            (
                TUTOR_ID     INT,
                NOMBRES      VARCHAR(100),
                APELLIDOS    VARCHAR(100),
                DNI          VARCHAR(15),
                CELULAR      VARCHAR(20),
                DIRECCION    VARCHAR(170)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM tutores WHERE id = _id) THEN
        RAISE EXCEPTION 'El tutor no existe';
    END IF;

    RETURN QUERY SELECT t.id,
                        t.nombres,
                        t.apellidos,
                        t.dni,
                        t.celular,
                        t.direccion
                 FROM tutores AS t
                 WHERE t.id = _id;
END
$$;