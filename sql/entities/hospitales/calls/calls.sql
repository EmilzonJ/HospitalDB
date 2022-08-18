--calls stored procedures
CALL sp_hospital_insert(
        'Hospital Juan Luis',
        'San Juan de Opoa',
        '25516798');

CALL sp_hospital_update(
        1,
        'Hospital Luis Celeste',
        'San Juan de Opoa',
        '25516798');

CALL sp_hospital_delete(1);

--view hospital select
SELECT *
FROM public.vw_hospitales
LIMIT 5