CREATE OR REPLACE PROCEDURE sp_hospitales_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF (SELECT COUNT(*) FROM departamentos WHERE hospital_id = _id) > 0 THEN
        RAISE EXCEPTION 'No se puede eliminar el hospital porque tiene departamentos asociados';
    END IF;

    DELETE
    FROM public.hospitales
    WHERE id = _id;

    RAISE NOTICE 'Hospital eliminado con éxito';
END
$$;