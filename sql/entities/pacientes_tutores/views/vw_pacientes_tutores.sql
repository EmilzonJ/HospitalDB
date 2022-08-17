CREATE OR REPLACE VIEW vw_pacientes_tutores AS
SELECT t.id        AS tutor_id,
       t.nombres    AS tutor_nombres,
       t.apellidos AS tutor_apellidos,
       p.id        AS pacientes_id,
       p.nombres   AS pacientes_nombres,
       p.apellidos AS pacientes_apellidos
FROM pacientes_tutores p_t
         INNER JOIN
     pacientes p ON p_t.paciente_id = p.id
         INNER JOIN
     tutores t ON p_t.tutor_id = t.id;
