CREATE OR REPLACE PROCEDURE sp_usuarios_roles_insert(_usuario_id INT, _rol_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _usuario_id_new INT;
    _rol_id_new     INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM usuarios WHERE id = _usuario_id) THEN
        RAISE EXCEPTION 'El usuario que está ingresando no existe.';
    END IF;

    IF NOT EXISTS(SELECT * FROM roles WHERE id = _rol_id) THEN
        RAISE EXCEPTION 'El rol que está ingresando no existe.';
    END IF;

    IF EXISTS(SELECT *
              FROM usuarios_roles
              WHERE rol_id = _usuario_id
                AND rol_id = _rol_id) THEN
        RAISE EXCEPTION 'El usuario ya se encuentra asociado con este rol.';
    END IF;

    INSERT INTO usuarios_roles(usuario_id, rol_id)
    VALUES (_usuario_id, _rol_id)
    RETURNING rol_id, rol_id INTO _usuario_id_new, _rol_id_new;

    RAISE NOTICE 'Ingresado con éxito el usuario "%" con el rol de "%".',
            (SELECT (nombre) FROM roles WHERE id = _rol_id_new),
            (SELECT (nombres) FROM usuarios WHERE id = _usuario_id_new);
END
$$;
