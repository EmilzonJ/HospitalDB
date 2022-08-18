CREATE OR REPLACE PROCEDURE sp_permisos_insert(
    _nombre VARCHAR(100),
    _descripcion VARCHAR(255),
    _seccion VARCHAR(30)
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN
    INSERT INTO permisos(nombre, descripcion, seccion)
    VALUES (_nombre, _descripcion, _seccion)
    RETURNING permisos.id INTO _id_new;

    RAISE NOTICE 'Ingresado con éxito permiso: %',
            (SELECT nombre FROM permisos WHERE id = _id_new);
END
$$