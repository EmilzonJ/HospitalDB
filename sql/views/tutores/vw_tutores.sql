CREATE OR REPLACE VIEW vw_tutores
AS
SELECT t.id,
       t.nombres,
       t.apellidos,
       t.dni,
       t.celular,
       t.direccion
FROM tutores AS t;