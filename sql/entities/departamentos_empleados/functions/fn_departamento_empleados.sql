CREATE OR REPLACE FUNCTION fn_departamento_empleados(_departamento_id INT)
    RETURNS TABLE
            (
                EMPLEADO_ID INT,
                NOMBRE      VARCHAR(100),
                APELLIDO    VARCHAR(100),
                OCUPACION   VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM departamentos_empleados WHERE departamento_id = _departamento_id) THEN

        RAISE EXCEPTION 'No hay empleados en el departamento "%".', _departamento_id;

    END IF;

    RETURN QUERY SELECT e.id,
                        e.nombres,
                        e.apellidos,
                        oc.descripcion
                    FROM empleados e
                        INNER JOIN
                            ocupaciones oc ON e.ocupacion_id = oc.id
                        INNER JOIN
                            departamentos_empleados d_e ON e.id = d_e.empleado_id
                    WHERE 
                        d_e.departamento_id = _departamento_id;

END
$$;
