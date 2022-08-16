--funcion para listar los socios de un hospital
CREATE OR REPLACE FUNCTION fn_hospital_socios(_hospital_id INT)
    RETURNS TABLE
            (
                socio_id INT,
                nombres     VARCHAR(100),
                apellidos    VARCHAR(100),
                celular   VARCHAR(100),
				correo   VARCHAR(100),
				dni   VARCHAR(15),
				descripcion VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM hospital_socios WHERE hospital_id = _hospital_id) THEN

        RAISE NOTICE 'No hay socios afiliados a este hospital "%".', _hospital_id;
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
                          hospital_socios h_s ON s.id = h_s.socio_id
                     WHERE h_s.hospital_id = _hospital_id;



END
$$;