CREATE OR REPLACE PROCEDURE sp_tutores_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM tutores WHERE id = _id;
    RAISE NOTICE 'Tutor eliminado con éxito';
END;
$$;