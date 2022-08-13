CREATE OR REPLACE VIEW vw_diagnosticos AS
    SELECT
        d.id AS diagnostico_id,
        d.paciente_id,
        p.nombres AS paciente_nombres,
        p.apellidos AS paciente_apellidos,
        d.fecha_ingreso,
        d.fecha_salida,
        d.resumen,
        d.razon_ingreso,
        d.fecha
    FROM
        diagnosticos d,
        pacientes p
    WHERE
        d.paciente_id = p.id
    ORDER BY d.id ASC;
    