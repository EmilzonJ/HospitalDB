CREATE OR REPLACE PROCEDURE sp_empleados_update(
    _id INT,
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
BEGIN
    -- Validar DNI
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    -- Validar celular
    IF NOT (SELECT fn_validate_phone(_celular)) THEN
        RAISE EXCEPTION 'Celular no válido, debe tener el formato: +999999999, se permiten hasta 15 caracteres';
    END IF;

    -- Validar FK ocupacion
    IF NOT (SELECT FROM ocupaciones WHERE id = _ocupacion_id) THEN
        RAISE EXCEPTION 'Ocupación no existe';
    END IF;

    -- Actualizar empleado
    UPDATE empleados
    SET nombres      = _nombres,
        apellidos    = _apellidos,
        ocupacion_id = _ocupacion_id,
        dni          = _dni,
        correo       = _correo,
        celular      = _celular
    WHERE id = _id;

    RAISE NOTICE 'Empleado actualizado con éxito';

END;
$$;