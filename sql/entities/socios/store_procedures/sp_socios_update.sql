CREATE OR REPLACE PROCEDURE sp_socios_update(
    _id INT,
    _nombres VARCHAR(100),
    _apellidos VARCHAR(100),
    _celular VARCHAR(20),
    _correo VARCHAR(100),
    _dni VARCHAR(15))
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

    UPDATE socios
    SET nombres   = _nombres,
        apellidos = _apellidos,
        celular   = _celular,
        correo    = _correo,
        dni       = _dni
    WHERE id = _id;

    RAISE NOTICE 'Socio actualizado con éxito';
END;
$$