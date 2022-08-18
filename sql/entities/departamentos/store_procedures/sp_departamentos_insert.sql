CREATE OR REPLACE PROCEDURE sp_departamentos_insert(_nombre VARCHAR(100),
                                                    _edificio INT,
                                                    _descripcion VARCHAR(20),
                                                    _hospital_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM hospitales WHERE id = _hospital_id) THEN

        RAISE EXCEPTION 'El hospital que está ingresando no existe.';

    END IF;

    IF _nombre IS NULL OR _nombre SIMILAR TO '' THEN

        RAISE EXCEPTION 'El nombre del departamento no puede estar vacío.';

    END IF;

    IF LENGTH(_nombre) > 100 THEN

        RAISE EXCEPTION 'El nombre del departamento no puede tener más de 100 caracteres.';

    END IF;

    IF EXISTS(SELECT *
              FROM departamentos
              WHERE edificio = _edificio
                AND hospital_id = _hospital_id
                AND (SELECT public.fn_string_compare(nombre, _nombre))) THEN

        RAISE EXCEPTION 'El edificio del departamento ya existe.';

    END IF;

    IF _descripcion IS NULL OR _descripcion SIMILAR TO '' THEN

        RAISE EXCEPTION 'La descripción del departamento no puede estar vacía.';

    END IF;

    IF LENGTH(_descripcion) > 255 THEN

        RAISE EXCEPTION 'La descripción del departamento no puede tener más de 255 caracteres.';

    END IF;

    INSERT INTO public.departamentos(nombre, edificio, descripcion, hospital_id)
    VALUES (_nombre, _edificio, _descripcion, _hospital_id)
    RETURNING departamentos.id INTO _id_new;

    RAISE NOTICE 'Ingresado con éxito el departamento "%" en el hospital "%".', (SELECT nombre FROM departamentos WHERE id = _id_new), (SELECT nombre FROM hospital WHERE id = _hospital_id);

END
$$;
