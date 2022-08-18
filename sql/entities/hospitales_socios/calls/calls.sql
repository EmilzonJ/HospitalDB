-- Selects
SELECT * FROM public.fn_hospitales_socios(3);
SELECT * FROM public.fn_socios_hospitales(7);

-- CALLS Store Procedures
CALL sp_hospitales_socios_insert(1, 1)