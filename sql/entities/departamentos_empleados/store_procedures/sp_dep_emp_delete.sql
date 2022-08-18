CREATE OR REPLACE PROCEDURE sp_dep_emp_delete(_dep_id INT, _emp_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dep_nombre VARCHAR(100);
    _emp_nombre VARCHAR(100);
BEGIN

    _dep_nombre = (SELECT nombre FROM departamentos WHERE id = _dep_id);
    _emp_nombre = (SELECT (nombres || ' ' || apellidos) FROM empleados WHERE id = _emp_id);

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

    IF NOT EXISTS(SELECT *
                  FROM departamentos_empleados
                  WHERE departamento_id = _dep_id
                    AND empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado no se encuentra en el departamento.';

    ELSE

        DELETE
        FROM public.departamentos_empleados
        WHERE departamento_id = _dep_id
          AND empleado_id = _emp_id;

        RAISE NOTICE 'Se elminó el empleado "%" del departamento de "%".', _emp_nombre, _dep_nombre;

    END IF;

END
$$;
