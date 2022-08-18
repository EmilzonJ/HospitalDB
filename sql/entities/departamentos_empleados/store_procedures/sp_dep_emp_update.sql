/*Este update sirve para cambiar al empleado a otro departamento, 
  se asigna el departamento a cambiar y el empleado que se desea cambiar.*/

CREATE OR REPLACE PROCEDURE sp_dep_emp_update(_dep_id INT, _emp_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _dep_id) THEN

        RAISE EXCEPTION 'El departamento que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT * FROM empleados WHERE id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT *
                  FROM departamentos_empleados
                  WHERE empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado no está asignado a un departamento.';

    END IF;

    IF EXISTS(SELECT *
              FROM departamentos_empleados
              WHERE departamento_id = _dep_id
                AND empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado ya se encuentra en ese departamento.';

    ELSE

        UPDATE
            departamentos_empleados
        SET departamento_id = _dep_id,
            empleado_id     = _emp_id
        WHERE empleado_id = _emp_id;

        RAISE NOTICE 'Se cambió el empleado "%" al departamento de "%".',
                (SELECT (nombres || ' ' || apellidos) FROM empleados WHERE id = _emp_id),
                (SELECT nombre FROM departamentos WHERE id = _dep_id);

    END IF;

END
$$;
