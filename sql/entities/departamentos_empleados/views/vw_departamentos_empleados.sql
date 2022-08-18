CREATE OR REPLACE VIEW vw_departamentos_empleados AS
SELECT d.id,
       d.nombre,
       e.id        AS empleado_id,
       e.nombres   AS empleado_nombres,
       e.apellidos AS empleado_apellidos
FROM departamentos_empleados d_e
         INNER JOIN
     departamentos d ON d_e.departamento_id = d.id
         INNER JOIN
     empleados e ON d_e.empleado_id = e.id;