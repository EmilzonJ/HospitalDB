--Listar en que hospitales estan afiliados los socios
CREATE OR REPLACE FUNCTION fn_socios_hospital(_socio_id INT)
    RETURNS TABLE
            (
                hospital_id INT,
                nombres     VARCHAR(100),
				direccion VARCHAR(255)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM hospital_socios WHERE socio_id = _socio_id) THEN

        RAISE EXCEPTION 'Esta persona no está afiliada a ningun hospital "%".', _socio_id;
    END IF;

        RETURN QUERY SELECT h.id,
                            h.nombre,
                            h.direccion
                     FROM hospital h
                              INNER JOIN
                          hospital_socios h_s ON h.id = h_s.hospital_id
                     WHERE h_s.socio_id = _socio_id;



END
$$;