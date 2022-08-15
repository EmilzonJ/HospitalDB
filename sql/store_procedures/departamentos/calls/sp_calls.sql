--CALL SP Insert Departamentos
CALL sp_insert_departamentos(
        'Cirugía', 
        13, 
        'Sala de cirugías.', 
        20
    );

--CALL SP Update Departamentos
CALL sp_update_departamentos(
        1,
        'Emergencias', 
        2, 
        'Sala de mergencias.', 
        2
    );

--CALL SP Delete Departamentos
CALL sp_delete_departamentos(1);
