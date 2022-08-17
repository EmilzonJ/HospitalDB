CREATE OR REPLACE VIEW vw_departamentos AS
SELECT d.id          AS departamento_id,
       d.nombre      AS departamento_nombre,
       d.edificio    AS departamento_edificio,
       d.descripcion AS departamento_descripcion,
       h.id          AS hospital_id,
       h.nombre      AS hospital_nombre,
       h.direccion   AS hospital_direccion
FROM departamentos d
         INNER JOIN
     hospital h ON d.hospital_id = h.id;