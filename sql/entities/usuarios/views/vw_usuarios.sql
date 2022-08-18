CREATE OR REPLACE VIEW vw_usuarios
AS
SELECT t.id,
       t.nombres,
       t.apellidos,
       t.dni,
       t.celular,
       t.direccion
FROM usuarios AS t;