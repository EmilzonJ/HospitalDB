CREATE OR REPLACE PROCEDURE sp_empleados_insert(
    _nombres VARCHAR(100),
    _apellidos VARCHAR(100),
    _ocupacion_id INT,
    _dni VARCHAR(15),
    _correo VARCHAR(100),
    _celular VARCHAR(20)
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_empleado INT;
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

    -- Validar FK ocupacion
    IF NOT (SELECT FROM ocupaciones WHERE id=_ocupacion_id) THEN
        RAISE EXCEPTION 'Ocupación no existe';
    END IF;

    -- Insertar empleado
    INSERT INTO empleados (nombres,
                           apellidos,
                           ocupacion_id,
                           dni,
                           correo,
                           celular)
    VALUES (_nombres,
            _apellidos,
            _ocupacion_id,
            _dni,
            _correo,
            _celular)

    RETURNING id INTO _id_empleado;

    -- Obtener id del empleado insertado
    RAISE NOTICE 'Empleado insertado con id: %', _id_empleado;
END;
$$;
