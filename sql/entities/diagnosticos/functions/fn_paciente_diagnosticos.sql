CREATE OR REPLACE FUNCTION fn_paciente_diagnosticos(_paciente_id INT)
    RETURNS TABLE
            (
                diagnostico_id INT,
                nombre         VARCHAR(100),
                apellido       VARCHAR(100),
                fecha_ingreso  DATE,    
                razon_ingreso  TEXT,
                fecha DATE
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM diagnosticos WHERE paciente_id = _paciente_id) THEN

        RAISE NOTICE 'No hay diagnósticos del paciente "%".', _paciente_id;

    ELSE

        RETURN QUERY SELECT d.id,
                            p.nombres,
                            p.apellidos,
                            d.fecha_ingreso,
                            d.razon_ingreso,
                            d.fecha
                     FROM 
                            diagnosticos d
                        INNER JOIN
                            pacientes p ON p.id = d.paciente_id
                     WHERE 
                        d.paciente_id = _paciente_id;

    END IF;

END
$$;
