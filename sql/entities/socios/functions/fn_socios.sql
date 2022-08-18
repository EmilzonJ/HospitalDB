CREATE OR REPLACE FUNCTION fn_socios(_tiposocio_id INT)
    RETURNS TABLE
            (
                SOCIO_ID   INT,
                NOMBRES    VARCHAR(100),
                APELLIDOS  VARCHAR(100),
                TIPO_SOCIO VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM tipos_socios WHERE id = _tiposocio_id) THEN
        RAISE EXCEPTION 'No hay socios de ese tipo "%".', _tiposocio_id;
    END IF;

    RETURN QUERY SELECT s.id,
                        s.nombres,
                        s.apellidos,
                        tp.descripcion
                 FROM socios s
                          INNER JOIN
                      tipos_socios tp ON s.tiposocio_id = tp.id
                 WHERE tp.id = _tiposocio_id;
END
$$;