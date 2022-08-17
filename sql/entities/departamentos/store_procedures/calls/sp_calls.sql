--CALL SP Insert Departamentos
CALL sp_departamentos_insert(
        'Cirugía', 
        13, 
        'Sala de cirugías.', 
        20
    );

--CALL SP Update Departamentos
CALL sp_departamentos_update(
        1,
        'Emergencias', 
        2, 
        'Sala de mergencias.', 
        2
    );

--CALL SP Delete Departamentos
CALL sp_departamentos_delete(1);
