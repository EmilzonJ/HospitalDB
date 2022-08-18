CREATE OR REPLACE PROCEDURE sp_permisos_update(
    _id INT,
    _nombre VARCHAR(100),
    _descripcion VARCHAR(255),
    _seccion VARCHAR(30)
)
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE permisos
    SET nombre      = _nombre,
        descripcion = _descripcion,
        seccion     = _seccion
    WHERE id = _id;
    RAISE NOTICE 'Actualizado con éxito permiso: %',
            (SELECT nombre FROM permisos WHERE id = _id);
END

$$