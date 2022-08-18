-- List
SELECT * FROM vw_permisos;

-- Insert permiso
CALL sp_permisos_insert(
        'Admin',
        'Acceso a todo el sistema'
    );

-- Update permiso
CALL sp_permisos_update(
        1,
        'Admin',
        'Acceso a todo el sistema'
    );

-- Delete permiso
CALL sp_permisos_delete(1);