CREATE OR REPLACE FUNCTION fn_paciente_diagnosticos(_paciente_id INT)
    RETURNS TABLE
            (
                DIAGNOSTICO_ID INT,
                NOMBRE         VARCHAR(100),
                APELLIDO       VARCHAR(100),
                FECHA_INGRESO  DATE,
                RAZON_INGRESO  TEXT,
                FECHA          DATE
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM diagnosticos WHERE paciente_id = _paciente_id) THEN

        RAISE EXCEPTION 'No hay diagnósticos del paciente "%".', _paciente_id;

    END IF;

    RETURN QUERY SELECT d.id,
                        p.nombres,
                        p.apellidos,
                        d.fecha_ingreso,
                        d.razon_ingreso,
                        d.fecha
                 FROM diagnosticos d
                          INNER JOIN
                      pacientes p ON p.id = d.paciente_id
                 WHERE d.paciente_id = _paciente_id;

END
$$;
