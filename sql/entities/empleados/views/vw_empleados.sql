CREATE OR REPLACE VIEW vw_empleados
AS
SELECT e.id,
       e.nombres,
       e.apellidos,
       e.dni,
       e.correo,
       e.celular,
       oc.id          AS ocupacion_id,
       oc.descripcion AS ocupacion
FROM empleados AS e
         INNER JOIN ocupaciones AS oc ON oc.id = e.ocupacion_id