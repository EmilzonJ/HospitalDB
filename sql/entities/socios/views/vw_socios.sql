CREATE VIEW vw_socios
AS
SELECT socios.id,
       socios.nombres,
	   socios.apellidos,
       socios.celular,
       socios.correo,
	   socios.dni,
	   socios.tiposocio_id
FROM socios;
