CREATE OR REPLACE VIEW vw_roles
AS
SELECT r.id,
       r.descripcion
FROM roles AS r;