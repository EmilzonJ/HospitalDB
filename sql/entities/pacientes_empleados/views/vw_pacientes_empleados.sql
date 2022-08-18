CREATE OR REPLACE VIEW vw_pacientes_empleados AS
SELECT p.id,
       p.nombres,
       p.apellidos,
       e.id        AS empleado_id,
       e.nombres   AS empleado_nombres,
       e.apellidos AS empleado_apellidos
FROM pacientes_empleados p_e
         INNER JOIN
     pacientes p ON p_e.paciente_id = p.id
         INNER JOIN
     empleados e ON p_e.empleado_id = e.id;
