--DELETE de pacientes_empleados
CREATE OR REPLACE PROCEDURE sp_pac_emp_delete(_pac_id INT, _emp_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _pac_nombre VARCHAR(100);
    _emp_nombre VARCHAR(100);
BEGIN

    _pac_nombre = (SELECT (nombres || ' ' || apellidos) FROM pacientes WHERE id = _pac_id);
    _emp_nombre = (SELECT (nombres || ' ' || apellidos) FROM empleados WHERE id = _emp_id);

    IF NOT EXISTS(SELECT * FROM pacientes WHERE id = _pac_id) THEN

        RAISE EXCEPTION 'El paciente que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT * FROM empleados WHERE id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT *
                  FROM pacientes_empleados
                  WHERE empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado no está asignado a un paciente.';

    END IF;

    IF NOT EXISTS(SELECT *
                  FROM pacientes_empleados
                  WHERE paciente_id = _pac_id
                    AND empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado no se encuentra con ese paciente.';

    ELSE

        DELETE
        FROM public.pacientes_empleados
        WHERE paciente_id = _pac_id
          AND empleado_id = _emp_id;

        RAISE NOTICE 'Se elminó el empleado "%" del paciente "%".', _emp_nombre, _pac_nombre;

    END IF;

END
$$;
