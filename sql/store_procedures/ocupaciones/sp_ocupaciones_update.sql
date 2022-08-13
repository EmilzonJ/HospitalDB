CREATE OR REPLACE PROCEDURE sp_ocupaciones_update(_id INT,
												 _descripcion VARCHAR(100))
LANGUAGE plpgsql
AS
$$
BEGIN
	UPDATE public.ocupaciones 
	SET descripcion = _descripcion
	WHERE id = _id;
	RAISE NOTICE 'Actualizado con exito ocupacion: %',
	(SELECT descripcion FROM ocupaciones WHERE id = _id);
END
$$