--INSERT de pacientes_empleados
CREATE OR REPLACE PROCEDURE sp_pac_emp_insert(_pac_id INT, _emp_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _pac_id_new INT;
    _emp_id_new INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM pacientes WHERE id = _pac_id) THEN

        RAISE EXCEPTION 'El paciente que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT * FROM empleados WHERE id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado que está ingresando no existe.';

    END IF;
    
    IF EXISTS(SELECT *
              FROM pacientes_empleados
              WHERE paciente_id = _pac_id
                AND empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado ya se encuentra con ese paciente.';

    ELSE

        INSERT INTO public.pacientes_empleados(paciente_id, empleado_id)
        VALUES (_pac_id, _emp_id)
        RETURNING paciente_id, empleado_id INTO _pac_id_new, _emp_id_new;

        RAISE NOTICE 'Ingresado con éxito el empleado "%" con el paciente de "%".',
            (SELECT (nombres || ' ' || apellidos) FROM empleados WHERE id = _emp_id_new),
            (SELECT (nombres || ' ' || apellidos) FROM pacientes WHERE id = _pac_id_new);

    END IF;

END
$$;
