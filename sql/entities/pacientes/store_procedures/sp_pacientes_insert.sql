CREATE OR REPLACE PROCEDURE sp_pacientes_insert(_nombres VARCHAR(100),
                                                _apellidos VARCHAR(100),
                                                _genero VARCHAR(3),
                                                _fecha_nacimiento VARCHAR(10),
                                                _dni VARCHAR(15),
                                                _direccion VARCHAR(255),
                                                _departamento_id INT,
                                                _estado VARCHAR(30),
                                                _tipo_sangre VARCHAR(4))
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN
    --validar que existe departamento id
    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _departamento_id) THEN
        RAISE EXCEPTION 'El departamento que ingresó no existe';
    END IF;

    --validar fecha de nacimiento
    IF public.fn_validate_date(_fecha_nacimiento) = FALSE OR _fecha_nacimiento SIMILAR TO '' THEN
        RAISE EXCEPTION 'El formato de la fecha de nacimiento no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';
    END IF;

    --validar DNI
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    --Validar que DNI no existe
    IF EXISTS(SELECT FROM pacientes WHERE dni = _dni) THEN
        RAISE EXCEPTION 'DNI ya existe';
    END IF;

    --Insertar paciente
    INSERT INTO pacientes (nombres,
                           apellidos,
                           genero,
                           fecha_nacimiento,
                           dni,
                           direccion,
                           departamento_id,
                           estado,
                           tipo_sangre)
    VALUES (_nombres,
            _apellidos,
            _genero,
            TO_DATE(_fecha_nacimiento, 'YYYY-MM-DD'),
            _dni,
            _direccion,
            _departamento_id,
            _estado,
            _tipo_sangre)
    RETURNING id INTO _id_new;
    RAISE NOTICE 'Paciente Ingresado con Id: % ',_id_new;
END
$$;
