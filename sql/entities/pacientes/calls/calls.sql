SELECT * FROM vw_pacientes;
--Select fn de Pacientes
SELECT * FROM fn_pacientes(1);
--CALL insert de pacientes
CALL sp_pacientes_insert('Karla',
                         'Ramirez',
                         'F',
                         '2000-10-10',
                         '0401-2000-00678',
                         'Santa Rosa de Copan',
                         3,
                         1,
                         'Critico',
                         'O+');

--CALL update de pacientes
CALL sp_pacientes_update(2,
                         'Karla',
                         'Ramirez',
                         'F',
                         '2001-10-10',
                         '0401-2001-00678',
                         'Santa Rosa de Copan Barrio Mercedez',
                         1,
                         1,
                         'Critico',
                         'O-');
--CALL delete de pacientes
CALL sp_pacientes_delete(1);