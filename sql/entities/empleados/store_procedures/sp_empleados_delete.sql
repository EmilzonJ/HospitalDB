CREATE OR REPLACE PROCEDURE sp_empleados_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM empleados WHERE id = _id;
    RAISE NOTICE 'Empleado eliminado con éxito';
END;
$$;