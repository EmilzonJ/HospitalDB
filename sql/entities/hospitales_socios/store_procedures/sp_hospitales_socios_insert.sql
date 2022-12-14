CREATE OR REPLACE PROCEDURE sp_hospitales_socios_insert(_hospital_id INT, _socio_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _h_id INT;
    _s_id INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM hospitales WHERE id = _hospital_id) THEN
        RAISE EXCEPTION 'El hospital que ha ingresado no existe.';
    END IF;

    IF NOT EXISTS(SELECT * FROM socios WHERE id = _socio_id) THEN
        RAISE EXCEPTION 'El socio que ha ingresado no existe.';
    END IF;

    IF EXISTS(SELECT *
              FROM hospitales_socios
              WHERE hospital_id = _hospital_id
                AND socio_id = _socio_id) THEN
        RAISE EXCEPTION 'El socio ya se encuentra afiliado a este hospital.';
    END IF;

    INSERT INTO public.hospitales_socios(hospital_id, socio_id)
    VALUES (_hospital_id, _socio_id)
    RETURNING hospital_id, hospital_id INTO _h_id, _s_id;

    RAISE NOTICE 'Ingresado con éxito el socio "%" en el hospital de "%".',
            (SELECT (nombres || ' ' || apellidos) FROM socios WHERE id = _socio_id),
            (SELECT nombre FROM hospitales WHERE id = _h_id);

END
$$;
