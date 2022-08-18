--FUNCTION para ver los pacientes encargados a un empleado
CREATE OR REPLACE FUNCTION fn_empleado_pacientes(_empleado_id INT)
    RETURNS TABLE
            (
                PACIENTE_ID INT,
                NOMBRE      VARCHAR(100),
                APELLIDO    VARCHAR(100),
                GENERO      VARCHAR(3),
                DNI         VARCHAR(15),
                ESTADO      VARCHAR(30),
                TIPO_SANGRE VARCHAR(4)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM pacientes_empleados WHERE empleado_id = _empleado_id) THEN

        RAISE EXCEPTION 'No hay empleados en el departamento "%".', _empleado_id;

    END IF;

    RETURN QUERY SELECT p.id,
                        p.nombres,
                        p.apellidos,
                        p.genero,
                        p.dni,
                        p.estado,
                        p.tipo_sangre
                 FROM pacientes p
                          INNER JOIN
                      pacientes_empleados p_e ON p.id = p_e.paciente_id
                 WHERE p_e.empleado_id = _empleado_id;

END
$$;