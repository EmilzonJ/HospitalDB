CREATE OR REPLACE FUNCTION fn_empleado_by_id(_id INT)
    RETURNS TABLE
            (
                EMPLEADO_ID  INT,
                NOMBRES      VARCHAR(100),
                APELLIDOS    VARCHAR(100),
                DNI          VARCHAR(15),
                CORREO       VARCHAR(100),
                CELULAR      VARCHAR(20),
                OCUPACION_ID INT,
                OCUPACION    VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM empleados WHERE id = _id) THEN
        RAISE EXCEPTION 'El empleado no existe';
    END IF;

    RETURN QUERY SELECT e.id,
                        e.nombres,
                        e.apellidos,
                        e.dni,
                        e.correo,
                        e.celular,
                        o.id AS ocupacion_id,
                        o.descripcion AS ocupacion
                 FROM empleados AS e
                          INNER JOIN ocupaciones AS o ON e.ocupacion_id = o.id
                 WHERE e.id = _id;
END
$$;