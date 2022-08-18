CREATE OR REPLACE PROCEDURE sp_usuarios_update(
    _id INT,
    _nombres VARCHAR,
    _apellidos VARCHAR,
    _dni VARCHAR,
    _celular VARCHAR,
    _direccion VARCHAR
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

    -- Actualizar usuario
    UPDATE usuarios
    SET nombres   = _nombres,
        apellidos = _apellidos,
        dni       = _dni,
        celular   = _celular,
        direccion = _direccion
    WHERE id = _id;

    RAISE NOTICE 'usuario actualizado con éxito';
END;
$$