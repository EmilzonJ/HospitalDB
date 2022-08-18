CREATE OR REPLACE PROCEDURE sp_socios_insert(
    _tiposocio_id INT,
    _nombres VARCHAR(100),
    _apellidos VARCHAR(100),
    _celular VARCHAR(20),
    _correo VARCHAR(100),
    _dni VARCHAR(15))

    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN
    -- Validar DNI
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    -- Validar DNI repetido
    IF EXISTS(SELECT FROM tutores WHERE dni = _dni) THEN
        RAISE EXCEPTION 'DNI ya existe';
    END IF;

    -- Validar celular
    IF NOT (SELECT fn_validate_phone(_celular)) THEN
        RAISE EXCEPTION 'Celular no válido, debe tener el formato: +999999999, se permiten hasta 15 caracteres';
    END IF;

    IF NOT EXISTS(SELECT * FROM tipos_socios WHERE id = _tiposocio_id) THEN
        RAISE EXCEPTION 'No existe este tipo de socio.';
    END IF;

    IF _nombres IS NULL OR _nombres SIMILAR TO '' THEN
        RAISE EXCEPTION 'Los nombres de socio no pueden estar vacíos.';
    END IF;

    IF _apellidos IS NULL OR _apellidos SIMILAR TO '' THEN
        RAISE EXCEPTION 'Los apellidos de socio no pueden estar vacíos.';
    END IF;

    IF _celular IS NULL OR _celular SIMILAR TO '' THEN
        RAISE EXCEPTION 'Debe de ingresar un numero de celular.';
    END IF;

    IF _correo IS NULL OR _correo SIMILAR TO '' THEN
        RAISE EXCEPTION 'Debe de ingresar un correo electronico.';
    END IF;

    INSERT INTO public.socios (tiposocio_id, nombres, apellidos, celular, correo, dni)
    VALUES (_tiposocio_id, _nombres, _apellidos, _celular, _correo, _dni)
    RETURNING socios.id INTO _id_new;

    RAISE NOTICE 'Se ha ingresado el socios de "%" con éxito.',
            (SELECT descripcion FROM tipos_socios WHERE id = _tiposocio_id);
END
$$;