CREATE OR REPLACE PROCEDURE sp_pacientes_update(_id INT,
                                                _nombres VARCHAR(100),
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
BEGIN
    --Verificar Id del paciente
    IF NOT EXISTS(SELECT * FROM pacientes WHERE id = _id) THEN
        RAISE EXCEPTION 'El paciente que está ingresando no existe.';
    END IF;

    --Verificar Id de departamento
    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _departamento_id) THEN
        RAISE EXCEPTION 'El departamento que está ingresando no existe.';
    END IF;

    --Verificar fecha de nacimiento
    IF public.fn_validate_date(_fecha_nacimiento) = FALSE OR _fecha_nacimiento SIMILAR TO '' THEN
        RAISE EXCEPTION 'El formato de la fecha de ingreso no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';
    END IF;

    --Verificar dni de paciente
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    --Verificar nombres de paciente
    IF _nombres IS NULL OR _nombres SIMILAR TO '' THEN
        RAISE EXCEPTION 'El nombre del paciente no puede estar vacío.';
    END IF;

    --Verificar apellidos de paciente
    IF _apellidos IS NULL OR _apellidos SIMILAR TO '' THEN
        RAISE EXCEPTION 'Los apellidos del paciente no puede estar vacío.';
    END IF;

    --Verificar genero de paciente
    IF _genero IS NULL OR _genero SIMILAR TO '' THEN
        RAISE EXCEPTION 'El genero del paciente no puede estar vacío.';
    END IF;

    --Verificar direccion de paciente
    IF _direccion IS NULL OR _direccion SIMILAR TO '' THEN
        RAISE EXCEPTION 'La direccion del paciente no puede estar vacía.';
    END IF;

    --Verificar estado de paciente
    IF _estado IS NULL OR _estado SIMILAR TO '' THEN
        RAISE EXCEPTION 'El estado del paciente no puede estar vacío.';
    END IF;

    UPDATE public.pacientes
    SET id               = _id,
        nombres          = _nombres,
        apellidos        = _apellidos,
        genero           = _genero,
        fecha_nacimiento = TO_DATE(_fecha_nacimiento, 'YYYY-MM-DD'),
        dni              = _dni,
        direccion        = _direccion,
        departamento_id  = _departamento_id,
        estado           = _estado,
        tipo_sangre      = _tipo_sangre
    WHERE id = _id;

    RAISE NOTICE 'Los datos del paciente % con código %se editaron correctamente',
            (SELECT nombres FROM pacientes WHERE id = _id),
            (SELECT id FROM pacientes WHERE id = _id);
END;
$$;