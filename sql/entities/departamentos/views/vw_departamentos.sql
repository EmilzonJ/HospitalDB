CREATE OR REPLACE VIEW vw_departamentos AS
SELECT d.id,
       d.nombre,
       d.edificio,
       d.descripcion,
       h.id        AS hospital_id,
       h.nombre    AS hospital_nombre,
       h.direccion AS hospital_direccion
FROM departamentos d
         INNER JOIN
     hospitales h ON d.hospital_id = h.id;