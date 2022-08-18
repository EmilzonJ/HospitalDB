CREATE OR REPLACE PROCEDURE sp_roles_update(
    _id INT,
    _nombre VARCHAR(100),
    _descripcion VARCHAR(255))
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE roles
    SET nombre      = _nombre,
        descripcion = _descripcion
    WHERE id = _id;
    RAISE NOTICE 'Actualizado con éxito rol: %',
            (SELECT nombre FROM roles WHERE id = _id);
END
$$