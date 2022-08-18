--calls stored procedures
CALL sp_hospitales_insert(
        'hospitales Juan Luis',
        'San Juan de Opoa',
        '25516798');

CALL sp_hospitales_update(
        1,
        'hospitales Luis Celeste',
        'San Juan de Opoa',
        '25516798');

CALL sp_hospitales_delete(1);

--view hospitales select
SELECT *
FROM vw_hospitales
LIMIT 5;

-- function select
SELECT * FROM fn_hospitales(1);
