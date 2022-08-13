CREATE OR REPLACE PROCEDURE sp_tipos_socios_update(_id INT,
                                                   _descripcion VARCHAR(100))
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE public.tipos_socios
    SET descripcion = _descripcion
    WHERE id = _id;
    RAISE NOTICE 'Actualizado con exito tipos socios: %',
            (SELECT descripcion FROM tipos_socios WHERE id = _id);
END
$$