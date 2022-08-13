CREATE OR REPLACE PROCEDURE sp_ocupaciones_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE
    FROM public.ocupaciones
    WHERE id = _id;
    RAISE NOTICE 'Ocupacion eliminado con exito';
END
$$