CREATE OR REPLACE PROCEDURE sp_tutores_insert(
    _nombres VARCHAR,
    _apellidos VARCHAR,
    _dni VARCHAR,
    _celular VARCHAR,
    _direccion VARCHAR
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_tutor INT;
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

    -- Insertar tutor
    INSERT INTO tutores (nombres,
                         apellidos,
                         dni,
                         celular,
                         direccion)
    VALUES (_nombres,
            _apellidos,
            _dni,
            _celular,
            _direccion)

    RETURNING id INTO _id_tutor;

    -- Obtener id del tutor insertado
    RAISE NOTICE 'Tutor insertado con id: %', _id_tutor;
END;
$$;