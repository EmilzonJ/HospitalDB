CREATE OR REPLACE PROCEDURE sp_roles_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM roles WHERE id = _id;
    RAISE NOTICE 'Rol eliminado con éxito';
END;
$$;