CREATE OR REPLACE PROCEDURE sp_usuarios_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM usuarios WHERE id = _id;
    RAISE NOTICE 'usuario eliminado con éxito';
END;
$$;