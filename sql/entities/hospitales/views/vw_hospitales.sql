CREATE VIEW vw_hospitales
AS
SELECT h.id,
       h.nombre,
       h.direccion,
       h.celular
FROM hospitales AS h;