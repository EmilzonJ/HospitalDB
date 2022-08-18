CREATE OR REPLACE PROCEDURE sp_departamentos_update(_id INT,
                                                    _nombre VARCHAR(100),
                                                    _edificio INT,
                                                    _descripcion VARCHAR(20),
                                                    _hospital_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _nombre_actual      VARCHAR(100);
    _edificio_actual    INT;
    _hospital_id_actual INT;
    not_exists          BOOLEAN; --si este valor es TRUE el departamento se puede editar.
BEGIN

    --Guardan los datos actuales del departamento.
    _nombre_actual = (SELECT nombre FROM departamentos WHERE id = _id);
    _edificio_actual = (SELECT edificio FROM departamentos WHERE id = _id);
    _hospital_id_actual = (SELECT hospital_id FROM departamentos WHERE id = _id);

    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _id) THEN

        RAISE EXCEPTION 'El departamento que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT * FROM hospital WHERE id = _hospital_id) THEN

        RAISE EXCEPTION 'El hospital que está ingresando no existe.';

    END IF;

    IF _nombre IS NULL OR _nombre SIMILAR TO '' THEN

        RAISE EXCEPTION 'El nombre del departamento no puede estar vacío.';

    END IF;

    IF LENGTH(_nombre) > 100 THEN

        RAISE EXCEPTION 'El nombre del departamento no puede tener más de 100 caracteres.';

    END IF;

    IF (SELECT public.fn_string_compare(_nombre, _nombre_actual))
        AND ((_edificio <> _edificio_actual)
            OR (_hospital_id <> _hospital_id_actual)) THEN

        /*Entra en este ELSEIF si el nombre del departamento no ha cambiado y 
        el edificio o el hospital del departamento ha cambiado.*/

        IF EXISTS(SELECT *
                  FROM departamentos
                  WHERE edificio = _edificio
                    AND hospital_id = _hospital_id
                    AND (SELECT public.fn_string_compare(nombre, _nombre))) THEN

            RAISE EXCEPTION 'El edificio del departamento ya existe.';

        ELSE

            not_exists = TRUE;

        END IF;

    END IF;

    IF (SELECT public.fn_string_compare(_nombre, _nombre_actual) = FALSE)
        AND ((_edificio <> _edificio_actual)
            OR (_hospital_id <> _hospital_id_actual)) THEN

        /*Entra en este ELSEIF si el nombre del departamento ha cambiado y 
        el edificio o el hospital del departamento ha cambiado.*/

        IF EXISTS(SELECT *
                  FROM departamentos
                  WHERE edificio = _edificio
                    AND hospital_id = _hospital_id
                    AND (SELECT public.fn_string_compare(nombre, _nombre))) THEN

            RAISE EXCEPTION 'El edificio del departamento ya existe.';

        ELSE

            not_exists = TRUE;

        END IF;

    END IF;

    IF (SELECT public.fn_string_compare(_nombre, _nombre_actual) = FALSE)
        AND ((_edificio = _edificio_actual)
            OR (_hospital_id = _hospital_id_actual)) THEN

        /*Entra en este ELSEIF si el nombre del departamento ha cambiado y 
        el edificio o el hospital del departamento no ha cambiado.*/

        IF EXISTS(SELECT *
                  FROM departamentos
                  WHERE edificio = _edificio
                    AND hospital_id = _hospital_id
                    AND (SELECT public.fn_string_compare(nombre, _nombre))) THEN

            RAISE EXCEPTION 'El edificio del departamento ya existe.';

        ELSE

            not_exists = TRUE;

        END IF;

    END IF;

    IF (SELECT public.fn_string_compare(_nombre, _nombre_actual))
        AND ((_edificio = _edificio_actual)
            OR (_hospital_id = _hospital_id_actual)) THEN

        /*Entra en este ELSEIF si el nombre del departamento no ha cambiado y 
        el edificio o el hospital del departamento no ha cambiado.*/

        not_exists = TRUE;

    END IF;

    IF _descripcion IS NULL OR _descripcion SIMILAR TO '' THEN

        RAISE EXCEPTION 'La descripción del departamento no puede estar vacía.';

    END IF;

    IF LENGTH(_descripcion) > 255 THEN

        RAISE EXCEPTION 'La descripción del departamento no puede tener más de 255 caracteres.';

    END IF;

    IF not_exists THEN

        UPDATE public.departamentos
        SET id          = _id,
            nombre      = _nombre,
            edificio    = _edificio,
            descripcion = _descripcion,
            hospital_id = _hospital_id
        WHERE id = _id;

        RAISE NOTICE 'Se actualizó el departamento "%" en el hospital "%".', (SELECT nombre FROM departamentos WHERE id = _id), (SELECT nombre FROM hospital WHERE id = _hospital_id);

    END IF;

END
$$;
 