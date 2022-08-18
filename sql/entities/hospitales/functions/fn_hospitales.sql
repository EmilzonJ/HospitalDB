CREATE OR REPLACE FUNCTION fn_hospitales(_id INT)
    RETURNS TABLE
            (
                hospital_id INT,
                nombre      VARCHAR(100),
                direccion   VARCHAR(255),
                celular   VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM hospital WHERE hospital_id =_id) THEN

        RISE EXCEPTION 'El hospital no existe "%".', _id;
  END IF;
        RETURN QUERY SELECT hospital.id,
                            hospital.nombre,
                            hospital.direccion,
                            hospital.celular
							FROM hospital
					WHERE hospital.id = _id;

END
$$;