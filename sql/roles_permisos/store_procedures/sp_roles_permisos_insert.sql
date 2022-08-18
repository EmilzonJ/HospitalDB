CREATE OR REPLACE PROCEDURE sp_roles_permisos_insert(_rol_id INT, _permiso_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _rol_id_new     INT;
    _permiso_id_new INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM roles WHERE id = _rol_id) THEN
        RAISE EXCEPTION 'El rol que está ingresando no existe.';
    END IF;

    IF NOT EXISTS(SELECT * FROM empleados WHERE id = _permiso_id) THEN
        RAISE EXCEPTION 'El permiso que está ingresando no existe.';
    END IF;

    IF EXISTS(SELECT *
              FROM roles_permisos
              WHERE rol_id = _rol_id
                AND permiso_id = _permiso_id) THEN
        RAISE EXCEPTION 'El rol ya se encuentra asociado con este permiso.';
    END IF;

    INSERT INTO roles_permisos(rol_id, permiso_id)
    VALUES (_rol_id, _permiso_id)
    RETURNING rol_id, permiso_id INTO _rol_id_new, _permiso_id_new;

    RAISE NOTICE 'Ingresado con éxito el rol "%" con el permiso de "%".',
            (SELECT (nombre) FROM permisos WHERE id = _permiso_id_new),
            (SELECT (nombre) FROM roles WHERE id = _rol_id_new);

END
$$;
