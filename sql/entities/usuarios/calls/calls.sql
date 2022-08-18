-- List
SELECT * FROM vw_usuarios;

-- Usuario By Id
SELECT * FROM fn_usuario_by_id(1);

-- Insert usuario
CALL sp_usuarios_insert(
        'Juan Armando',
        'Caceres Iriarte',
        '0331-1990-00576',
        '+50483748576',
        'Santa Rosa Copan'
    );

-- Update usuario
CALL sp_usuarios_update(
        1,
        'Juan Ramiro',
        'Caceres Iriarte',
        '0331-1990-00576',
        '+50483748576',
        'Santa Rosa Copan'
    );

-- Delete usuario
CALL sp_usuarios_delete(1);
