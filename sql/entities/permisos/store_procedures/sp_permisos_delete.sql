CREATE OR REPLACE PROCEDURE sp_permisos_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM permisos WHERE id = _id;
    RAISE NOTICE 'Permiso eliminado con éxito';
END;
$$;