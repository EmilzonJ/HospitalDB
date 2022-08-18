CREATE OR REPLACE PROCEDURE sp_roles_insert(
    _nombre VARCHAR(100),
    _descripcion VARCHAR(255)
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN
    INSERT INTO roles(nombre, descripcion)
    VALUES (_nombre, _descripcion)
    RETURNING roles.id INTO _id_new;

    RAISE NOTICE 'Ingresado con éxito rol: %',
            (SELECT nombre FROM roles WHERE id = _id_new);
END
$$