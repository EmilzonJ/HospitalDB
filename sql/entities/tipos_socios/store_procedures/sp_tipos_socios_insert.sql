CREATE PROCEDURE sp_tipos_socios_insert(_descripcion VARCHAR(100))
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN
    INSERT INTO public.tipos_socios(descripcion)
    VALUES (_descripcion);

    RAISE NOTICE 'Ingresado con éxito Tipos Socio: %',
            (SELECT descripcion FROM tipos_socios WHERE id = _id_new);
END
$$