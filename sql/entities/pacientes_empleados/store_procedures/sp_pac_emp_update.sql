/*Este update sirve para cambiar al empleado a otro paciente, 
  se asigna el paciente a cambiar y el empleado que se desea cambiar.*/

CREATE OR REPLACE PROCEDURE sp_pac_emp_update(_pac_id INT, _emp_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM pacientes WHERE id = _pac_id) THEN

        RAISE EXCEPTION 'El paciente que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT * FROM empleados WHERE id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT *
                  FROM pacientes_empleados
                  WHERE paciente_id = _pac_id) THEN

        RAISE EXCEPTION 'El paciente no está asignado a ningún empleado.';

    END IF;

    IF NOT EXISTS(SELECT *
                  FROM pacientes_empleados
                  WHERE empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado no está asignado a un paciente.';

    END IF;

    IF EXISTS(SELECT *
              FROM pacientes_empleados
              WHERE paciente_id = _pac_id
                AND empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado ya se encuentra con ese paciente.';

    ELSE

        UPDATE
            pacientes_empleados
        SET paciente_id = _pac_id,
            empleado_id     = _emp_id
        WHERE empleado_id = _emp_id;

        RAISE NOTICE 'Se cambió el empleado "%" al paciente "%".',
                (SELECT (nombres || ' ' || apellidos) FROM empleados WHERE id = _emp_id),
                (SELECT (nombres || ' ' || apellidos) FROM pacientes WHERE id = _pac_id);

    END IF;

END
$$;
