CREATE OR REPLACE PROCEDURE sp_dep_emp_insert(_dep_id INT, _emp_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dep_id_new INT;
    _emp_id_new INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _dep_id) THEN

        RAISE NOTICE 'El departamento que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT * FROM empleados WHERE id = _emp_id) THEN

        RAISE NOTICE 'El empleado que está ingresando no existe.';

    END IF;

    IF EXISTS(SELECT *
                  FROM departamentos_empleados
                  WHERE empleado_id = _emp_id) THEN

        RAISE NOTICE 'El empleado ya está asignado a un departamento.';

    END IF;
    
    IF EXISTS(SELECT *
                  FROM departamentos_empleados
                  WHERE departamento_id = _dep_id
                    AND empleado_id = _emp_id) THEN

        RAISE NOTICE 'El empleado ya se encuentra en el departamento.';

    ELSE

        INSERT INTO public.departamentos_empleados(departamento_id, empleado_id)
        VALUES (_dep_id, _emp_id)
        RETURNING departamento_id, empleado_id INTO _dep_id_new, _emp_id_new;

        RAISE NOTICE 'Ingresado con éxito el empleado "%" en el departamento de "%".',
            (SELECT (nombres || ' ' || apellidos) FROM empleados WHERE id = _emp_id_new),
                (SELECT nombre FROM departamentos WHERE id = _dep_id_new);

    END IF;

END
$$;
