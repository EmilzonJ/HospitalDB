SELECT *
FROM vw_pacientes_tutores;

--Select fn de pacientes tutores
SELECT *
FROM fn_pacientes_tutores(1);

--Call sp insert de pacientes tutores
CALL sp_pac_tut_insert(1,
                       1,
                       'Padre');