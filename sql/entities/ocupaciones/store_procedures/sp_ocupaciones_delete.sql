CREATE OR REPLACE PROCEDURE sp_ocupaciones_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF (SELECT COUNT(*) FROM empleados WHERE ocupacion_id = _id) > 0 THEN
        RAISE EXCEPTION 'No se puede eliminar la ocupación porque hay empleados asociados a ella.';
    END IF;

    DELETE
    FROM public.ocupaciones
    WHERE id = _id;
    RAISE NOTICE 'Ocupación eliminada con éxito';
END
$$