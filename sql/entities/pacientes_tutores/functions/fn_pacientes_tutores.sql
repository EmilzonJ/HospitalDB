CREATE OR REPLACE FUNCTION fn_pacientes_tutores(_paciente_id INT)
    RETURNS TABLE
            (
                TUTOR_ID  INT,
                NOMBRES   VARCHAR(100),
                APELLIDOS VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM pacientes_tutores WHERE paciente_id = _paciente_id) THEN

        RAISE EXCEPTION 'No hay tutores para el pacientes "%".', _paciente_id;

    END IF;

        RETURN QUERY SELECT t.id,
                            t.nombres,
                            t.apellidos
                     FROM tutores t
                              INNER JOIN
                          pacientes_tutores p_t ON t.id = p_t.tutor_id
                     WHERE p_t.paciente_id = _paciente_id;

    END IF;

END
$$;