CREATE OR REPLACE PROCEDURE sp_dep_emp_insert(p_dep_id INT, p_emp_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    p_dep_id_new INT;
    p_emp_id_new INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = p_dep_id) THEN

        RAISE NOTICE 'El departamento que está ingresando no existe.';

    ELSEIF NOT EXISTS(SELECT * FROM empleados WHERE id = p_emp_id) THEN

        RAISE NOTICE 'El empleado que está ingresando no existe.';

    ELSEIF EXISTS(SELECT *
                  FROM departamentos_empleados
                  WHERE empleado_id = p_emp_id) THEN

        RAISE NOTICE 'El empleado ya está asignado a un departamento.';

    ELSEIF EXISTS(SELECT *
                  FROM departamentos_empleados
                  WHERE departamento_id = p_dep_id
                    AND empleado_id = p_emp_id) THEN

        RAISE NOTICE 'El empleado ya se encuentra en el departamento.';

    ELSE

        INSERT INTO public.departamentos_empleados(departamento_id, empleado_id)
        VALUES (p_dep_id, p_emp_id)
        RETURNING departamento_id, empleado_id INTO p_dep_id_new, p_emp_id_new;

        RAISE NOTICE 'Ingresado con éxito el empleado "%" en el departamento de "%".',
            (SELECT (nombres || ' ' || apellidos) FROM empleados WHERE id = p_emp_id_new),
                (SELECT nombre FROM departamentos WHERE id = p_dep_id_new);

    END IF;

END
$$;
