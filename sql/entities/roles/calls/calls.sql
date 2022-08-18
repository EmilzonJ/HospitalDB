-- List
SELECT * FROM vw_roles;

-- Rol By Id
SELECT * FROM fn_rol_by_id(1);

-- Insert rol
CALL sp_roles_insert(
        'Admin',
        'Acceso a todo el sistema'
    );

-- Update rol
CALL sp_roles_update(
        1,
        'Admin',
        'Acceso a todo el sistema'
    );

-- Delete rol
CALL sp_roles_delete(1);