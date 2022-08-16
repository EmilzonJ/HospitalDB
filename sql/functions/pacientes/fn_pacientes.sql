CREATE OR REPLACE FUNCTION fn_pacientes(_id INT)
    RETURNS TABLE
            (
                PACIENTE_ID      INT,
                NOMBRES          VARCHAR(100),
                APELLIDOS        VARCHAR(100),
                GENERO           VARCHAR(3),
                FECHA_NACIMIENTO DATE,
                DNI              VARCHAR(15),
                DIRECCION        VARCHAR(255),
                DEPARTAMENTI_ID  INT,
                EMPLEADO_ID      INT,
                ESTADO           VARCHAR(30),
                TIPO_SANGRE      VARCHAR(4)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM pacientes WHERE paciente_id = _id) THEN

        RAISE NOTICE 'El paciente no existe "%".', _id;
    END IF;
    RETURN QUERY SELECT pacientes.id,
                        pacientes.nombres,
                        pacientes.apellidos,
                        pacientes.genero,
                        pacientes.fecha_nacimiento,
                        pacientes.dni,
                        pacientes.direccion,
                        pacientes.departamento_id,
                        pacientes.empleado_id,
                        pacientes.estado,
                        pacientes.tipo_sangre
                 FROM pacientes
                 WHERE pacientes.id = _id;

END
$$;