CREATE PROCEDURE sp_tipos_socios_insert (_descripcion VARCHAR(100))
LANGUAGE plpgsql
AS
$$
DECLARE 
	_id_new INT;
BEGIN
	INSERT INTO public.tipos_socios(descripcion)
	VALUES (_descripcion)
	RETURNING tipos_socios.id INTO _id_new;
	RAISE NOTICE 'Ingresado con exito Tipos Socio: %',
	(SELECT descripcion FROM tipos_socios WHERE id = _id_new);
END
$$