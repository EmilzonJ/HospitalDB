CREATE PROCEDURE sp_hospital_insert(_nombre VARCHAR(100), _direccion VARCHAR(255), _celular VARCHAR(20))
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN
    INSERT INTO public.hospital(nombre, direccion, celular)
    VALUES (_nombre, _direccion, _celular)
    RETURNING hospital.id INTO _id_new;

    RAISE NOTICE 'Ingresado con exito el hospital: %',
            (SELECT nombre FROM hospital WHERE id = _id_new);
END
$$;
