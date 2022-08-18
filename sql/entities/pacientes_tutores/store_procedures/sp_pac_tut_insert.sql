CREATE OR REPLACE PROCEDURE sp_pac_tut_insert(_paciente_id INT,
                                              _tutor_id INT,
                                              _parentesco VARCHAR(20))
    LANGUAGE plpgsql
AS
$$
DECLARE
    _paciente_id_new INT;
    _tutor_id_new    INT;
BEGIN
    --Validar paciente
    IF NOT EXISTS(SELECT * FROM pacientes WHERE id = _paciente_id) THEN

        RAISE EXCEPTION 'El paciente que está ingresando no existe.';

    END IF;
    --Validar tutor
    IF NOT EXISTS(SELECT * FROM tutores WHERE id = _tutor_id) THEN

        RAISE EXCEPTION 'El tutor que está ingresando no existe.';

    END IF;
    IF _parentesco IS NULL OR _parentesco SIMILAR TO '' THEN

        RAISE EXCEPTION 'El parentesco del paciente y tutor no puede estar vacía.';

    END IF;
    INSERT INTO public.pacientes_tutores(paciente_id, 
                                         tutor_id,
                                         parentesco)
    VALUES (_paciente_id, 
            _tutor_id,
            _parentesco)
    RETURNING paciente_id, tutor_id INTO _paciente_id_new, _tutor_id_new;

    RAISE NOTICE 'Ingresado con éxito el paciente "%" con el tutor "%".',
        (SELECT (nombres || ' ' || apellidos) FROM pacientes WHERE id = _paciente_id_new),
        (SELECT nombres FROM tutores WHERE id = _tutor_id_new);
END;
$$