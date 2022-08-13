CREATE OR REPLACE PROCEDURE sp_tipos_socios_delete(_id INT)
LANGUAGE plpgsql
AS
$$
BEGIN
	DELETE FROM public.tipos_socios
	WHERE id = _id;
	RAISE NOTICE 'Tipos socios eliminado con exito';
END
$$