--funcion para listar los socios de un hospital
CREATE OR REPLACE FUNCTION fn_hospitales_socios(_hospital_id INT)
    RETURNS TABLE
            (
                SOCIO_ID    INT,
                NOMBRES     VARCHAR(100),
                APELLIDOS   VARCHAR(100),
                CELULAR     VARCHAR(100),
                CORREO      VARCHAR(100),
                DNI         VARCHAR(15),
                DESCRIPCION VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM hospitales_socios WHERE hospital_id = _hospital_id) THEN
        RAISE EXCEPTION 'No hay socios afiliados a este hospital "%".', _hospital_id;
    END IF;

    RETURN QUERY SELECT s.id,
                        s.nombres,
                        s.apellidos,
                        s.celular,
                        s.correo,
                        s.dni,
                        ts.descripcion
                 FROM socios s
                          INNER JOIN
                      tipos_socios ts ON s.tiposocio_id = ts.id
                          INNER JOIN
                      hospitales_socios h_s ON s.id = h_s.socio_id
                 WHERE h_s.hospital_id = _hospital_id;
END
$$;