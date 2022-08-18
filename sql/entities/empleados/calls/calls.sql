-- List
SELECT *
FROM vw_empleados;

-- GetByID
SELECT * FROM fn_empleado_by_id(3);

-- Insert empleado
CALL sp_empleados_insert(
        'Juan',
        'Perez',
        1,
        '0000-0000-00000',
        'perez@mail.com',
        '+99999999'
    );

-- Update empleado
CALL sp_empleados_update(
        1,
        'Juan',
        'Perez',
        1,
        '0000-0000-00000',
        'perez@mail.com',
        '+99999999'
    );

-- Delete empleado
CALL sp_empleados_delete(1);