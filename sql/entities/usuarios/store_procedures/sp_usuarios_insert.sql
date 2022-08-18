CREATE OR REPLACE PROCEDURE sp_usuarios_insert(
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
    _id_usuario INT;
BEGIN
    -- Validar DNI
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    -- Validar DNI repetido
    IF EXISTS(SELECT FROM usuarios WHERE dni = _dni) THEN
        RAISE EXCEPTION 'DNI ya existe';
    END IF;

    -- Validar celular
    IF NOT (SELECT fn_validate_phone(_celular)) THEN
        RAISE EXCEPTION 'Celular no válido, debe tener el formato: +999999999, se permiten hasta 15 caracteres';
    END IF;

    -- Insertar usuario
    INSERT INTO usuarios (nombres,
                         apellidos,
                         dni,
                         celular,
                         direccion)
    VALUES (_nombres,
            _apellidos,
            _dni,
            _celular,
            _direccion)

    RETURNING id INTO _id_usuario;

    -- Obtener id del usuario insertado
    RAISE NOTICE 'Usuario insertado con id: %', _id_usuario;
END;
$$;