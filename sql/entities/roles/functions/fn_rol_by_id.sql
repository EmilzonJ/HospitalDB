CREATE OR REPLACE FUNCTION fn_rol_by_id(_id INT)
    RETURNS TABLE
            (
                ROL_ID          INT,
                ROL_NOMBRE      VARCHAR(100),
                ROL_DESCRIPCION VARCHAR(255)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF NOT EXISTS(SELECT * FROM roles WHERE rol_id = _id) THEN

        RAISE NOTICE 'La rol no existe "%".', _id;
    END IF;
    RETURN QUERY SELECT r.id,
                        r.nombre,
                        r.descripcion
                 FROM roles AS r
                 WHERE r.id = _id;
END;
$$;