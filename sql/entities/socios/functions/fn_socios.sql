CREATE OR REPLACE FUNCTION fn_socios(_tiposocio_id INT)
    RETURNS TABLE
            (
                socio_id INT,
                nombres      VARCHAR(100),
                apellidos   VARCHAR(100),
                tipo_socio   VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM tipos_socios WHERE id = _tiposocio_id) THEN

        RAISE EXCEPTION 'No hay socios de ese tipo "%".', _tiposocio_id;

    ELSE

        RETURN QUERY SELECT s.id,
                            s.nombres,
                            s.apellidos,
                            tp.descripcion
                     FROM socios s
                              INNER JOIN
                          tipos_socios tp ON s.tiposocio_id = tp.id
					 WHERE tp.id = _tiposocio_id;

    END IF;

END
$$;