-- List
SELECT * FROM vw_tutores;

-- Tutor By Id
SELECT * FROM fn_tutor_by_id(1);

-- Insert Tutor
CALL sp_tutores_insert(
        'Juan Armando',
        'Caceres Iriarte',
        '0331-1990-00576',
        '+50483748576',
        'Santa Rosa Copan'
    );

-- Update Tutor
CALL sp_tutores_update(
        1,
        'Juan Ramiro',
        'Caceres Iriarte',
        '0331-1990-00576',
        '+50483748576',
        'Santa Rosa Copan'
    );

-- Delete Tutor
CALL sp_tutores_delete(1);
