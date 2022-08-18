CREATE OR REPLACE VIEW vw_pacientes AS
SELECT p.id AS pacientes_id,
       p.nombres,
       p.apellidos,
       p.genero,
       p.direccion,
       p.fecha_nacimiento,
       p.departamento_id,
       p.estado,
       p.tipo_sangre

FROM pacientes p
         INNER JOIN
     departamentos d ON p.departamento_id = d.id;