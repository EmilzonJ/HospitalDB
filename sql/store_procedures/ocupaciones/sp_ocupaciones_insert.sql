CREATE PROCEDURE sp_ocupaciones_insert (_descripcion VARCHAR(100))
LANGUAGE plpgsql
AS
$$
DECLARE
	_id_new INT;
BEGIN
	INSERT INTO public.ocupaciones(descripcion)
	VALUES (_descripcion)
	RETURNING ocupaciones.id INTO _id_new;
	
	RAISE NOTICE 'Ingresado con exito ocupacion: %',
	(SELECT descripcion FROM ocupaciones WHERE id = _id_new);
END
$$