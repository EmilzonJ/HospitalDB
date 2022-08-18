CREATE OR REPLACE PROCEDURE sp_hospital_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF (SELECT COUNT(*) FROM departamentos WHERE hospital_id = _id) > 0 THEN
        RAISE EXCEPTION 'No se puede eliminar el hospital porque tiene departamentos asociados';
    END IF;

    DELETE
    FROM public.hospital
    WHERE id = _id;

    RAISE NOTICE 'Hospital eliminado con éxito';
END
$$;