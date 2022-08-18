--CALLS stored prodecures
CALL sp_socios_insert(
        2,
        'Italo Gonzalo',
        'Martinez Carcamo',
        '+50498765438',
        'italogmc@yahoo.com',
        '0801-1969-09044');

CALL sp_socios_update(
        2,
        'Italo Gonzalo',
        'Martinez Carcamo',
        '+50497653090',
        'italogmc@yahoo.com',
        '0801-1969-09044');

CALL sp_socios_delete(1);

--select socios views
SELECT *
FROM public.vw_socios
LIMIT 5