-- Call SP Insert Tutor
CALL sp_tutores_insert(
        'Juan Armando',
        'Caceres Iriarte',
        '0331-1990-00576',
        '+50483748576',
        'Santa Rosa Copan'
    );

-- Call SP Update Tutor
CALL sp_tutores_update(
        1,
        'Juan Ramiro',
        'Caceres Iriarte',
        '0331-1990-00576',
        '+50483748576',
        'Santa Rosa Copan'
    );

-- Call SP Delete Tutor
CALL sp_tutores_delete(1);
