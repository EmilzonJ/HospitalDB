CREATE VIEW vw_hospitales
 AS
 SELECT hospital.id,
    hospital.nombre,
    hospital.direccion,
    hospital.celular
   FROM hospital;