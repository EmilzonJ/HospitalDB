--FUNCTION para ver los empleados encargados de un paciente
CREATE OR REPLACE FUNCTION fn_paciente_empleados(_paciente_id INT)
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

    IF NOT EXISTS(SELECT * FROM pacientes_empleados WHERE paciente_id = _paciente_id) THEN

        RAISE EXCEPTION 'No hay registros del paciente "%".', _paciente_id;

    END IF;

    RETURN QUERY SELECT e.id,
                        e.nombres,
                        e.apellidos,
                        oc.descripcion
                 FROM empleados e
                          INNER JOIN
                      ocupaciones oc ON e.ocupacion_id = oc.id
                          INNER JOIN
                      pacientes_empleados p_e ON e.id = p_e.empleado_id
                 WHERE p_e.paciente_id = _paciente_id;

END
$$;
