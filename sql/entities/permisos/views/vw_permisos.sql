CREATE OR REPLACE VIEW vw_permisos
AS
SELECT p.id,
       p.descripcion,
       p.seccion
FROM permisos AS p;