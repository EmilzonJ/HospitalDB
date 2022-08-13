CREATE OR REPLACE VIEW vw_departamentos_empleados AS
    SELECT
        h.id AS hospital_id,
        h.nombre AS hospital_nombre,
        d.id AS departamento_id,
        d.nombre AS departamento_nombre,
        e.id AS empleado_id,
        e.nombres AS empleado_nombres,
        e.apellidos AS empleado_apellidos
    FROM
        departamentos d,
        empleados e,
        departamentos_empleados d_e,
        hospital h
    WHERE
        d_e.departamento_id = d.id AND d_e.empleado_id = e.id AND d.hospital_id = h.id 
    ORDER BY h.id ASC;
