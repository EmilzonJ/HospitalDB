CREATE OR REPLACE PROCEDURE sp_departamentos_update(p_id INT,
                                                    p_nombre VARCHAR(100),
                                                    p_edificio INT,
                                                    p_descripcion VARCHAR(20),
                                                    p_hospital_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    p_nombre_actual      VARCHAR(100);
    p_edificio_actual    INT;
    p_hospital_id_actual INT;
    not_exists           BOOLEAN; --si este valor es TRUE el departamento se puede editar.
BEGIN

    --Guardan los datos actuales del departamento.
    p_nombre_actual = (SELECT nombre FROM departamentos WHERE id = p_id);
    p_edificio_actual = (SELECT edificio FROM departamentos WHERE id = p_id);
    p_hospital_id_actual = (SELECT hospital_id FROM departamentos WHERE id = p_id);

    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = p_id) THEN

        RAISE NOTICE 'El departamento que está ingresando no existe.';

    ELSEIF NOT EXISTS(SELECT * FROM hospital WHERE id = p_hospital_id) THEN

        RAISE NOTICE 'El hospital que está ingresando no existe.';

    ELSEIF p_nombre IS NULL OR p_nombre SIMILAR TO '' THEN

        RAISE NOTICE 'El nombre del departamento no puede estar vacío.';

    ELSEIF LENGTH(p_nombre) > 100 THEN

        RAISE NOTICE 'El nombre del departamento no puede tener más de 100 caracteres.';

    ELSEIF p_edificio IS NULL THEN

        RAISE NOTICE 'El edificio del departamento no puede estar vacío y es valor numérico.';

    ELSEIF (SELECT public.fn_string_convert(p_nombre, p_nombre_actual))
        AND ((p_edificio <> p_edificio_actual)
            OR (p_hospital_id <> p_hospital_id_actual)) THEN


        /*Entra en este ELSEIF si el nombre del departamento no ha cambiado y 
        el edificio o el hospital del departamento ha cambiado.*/

        IF EXISTS(SELECT *
                  FROM departamentos
                  WHERE edificio = p_edificio
                    AND hospital_id = p_hospital_id
                    AND (SELECT public.fn_string_convert(nombre, p_nombre))) THEN

            RAISE NOTICE 'El edificio del departamento ya existe.';

        ELSE

            not_exists = TRUE;

        END IF;

    ELSEIF (SELECT public.fn_string_convert(p_nombre, p_nombre_actual) = FALSE)
        AND ((p_edificio <> p_edificio_actual)
            OR (p_hospital_id <> p_hospital_id_actual)) THEN

        /*Entra en este ELSEIF si el nombre del departamento ha cambiado y 
        el edificio o el hospital del departamento ha cambiado.*/

        IF EXISTS(SELECT *
                  FROM departamentos
                  WHERE edificio = p_edificio
                    AND hospital_id = p_hospital_id
                    AND (SELECT public.fn_string_convert(nombre, p_nombre))) THEN

            RAISE NOTICE 'El edificio del departamento ya existe.';

        ELSE

            not_exists = TRUE;

        END IF;

    ELSEIF (SELECT public.fn_string_convert(p_nombre, p_nombre_actual) = FALSE)
        AND ((p_edificio = p_edificio_actual)
            OR (p_hospital_id = p_hospital_id_actual)) THEN

        /*Entra en este ELSEIF si el nombre del departamento ha cambiado y 
        el edificio o el hospital del departamento no ha cambiado.*/

        IF EXISTS(SELECT *
                  FROM departamentos
                  WHERE edificio = p_edificio
                    AND hospital_id = p_hospital_id
                    AND (SELECT public.fn_string_convert(nombre, p_nombre))) THEN

            RAISE NOTICE 'El edificio del departamento ya existe.';

        ELSE

            not_exists = TRUE;

        END IF;

    ELSEIF (SELECT public.fn_string_convert(p_nombre, p_nombre_actual))
        AND ((p_edificio = p_edificio_actual)
            OR (p_hospital_id = p_hospital_id_actual)) THEN

        /*Entra en este ELSEIF si el nombre del departamento no ha cambiado y 
        el edificio o el hospital del departamento no ha cambiado.*/

        not_exists = TRUE;

    END IF;

    IF p_descripcion IS NULL OR p_descripcion SIMILAR TO '' THEN

        RAISE NOTICE 'La descripción del departamento no puede estar vacía.';

    ELSEIF LENGTH(p_descripcion) > 255 THEN

        RAISE NOTICE 'La descripción del departamento no puede tener más de 255 caracteres.';

    ELSEIF not_exists THEN

        UPDATE public.departamentos
        SET id          = p_id,
            nombre      = p_nombre,
            edificio    = p_edificio,
            descripcion = p_descripcion,
            hospital_id = p_hospital_id
        WHERE id = p_id;

        RAISE NOTICE 'Se actualizó el departamento "%" en el hospital "%".', (SELECT nombre FROM departamentos WHERE id = p_id), (SELECT nombre FROM hospital WHERE id = p_hospital_id);

    END IF;

END
$$;
 