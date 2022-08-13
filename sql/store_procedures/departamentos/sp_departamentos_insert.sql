CREATE OR REPLACE PROCEDURE sp_departamentos_insert(p_nombre VARCHAR(100),
                                                    p_edificio INT,
                                                    p_descripcion VARCHAR(20),
                                                    p_hospital_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    p_id_new INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM hospital WHERE id = p_hospital_id) THEN

        RAISE NOTICE 'El hospital que está ingresando no existe.';

    ELSEIF p_nombre IS NULL OR p_nombre SIMILAR TO '' THEN

        RAISE NOTICE 'El nombre del departamento no puede estar vacío.';

    ELSEIF LENGTH(p_nombre) > 100 THEN

        RAISE NOTICE 'El nombre del departamento no puede tener más de 100 caracteres.';

    ELSEIF p_edificio IS NULL THEN

        RAISE NOTICE 'El edificio del departamento no puede estar vacío y es valor numérico.';

    ELSEIF EXISTS(SELECT *
                  FROM departamentos
                  WHERE edificio = p_edificio
                    AND hospital_id = p_hospital_id
                    AND (SELECT public.fn_string_convert(nombre, p_nombre))) THEN

        RAISE NOTICE 'El edificio del departamento ya existe.';

    ELSEIF p_descripcion IS NULL OR p_descripcion SIMILAR TO '' THEN

        RAISE NOTICE 'La descripción del departamento no puede estar vacía.';

    ELSEIF LENGTH(p_descripcion) > 255 THEN

        RAISE NOTICE 'La descripción del departamento no puede tener más de 255 caracteres.';

    ELSE

        INSERT INTO public.departamentos(nombre, edificio, descripcion, hospital_id)
        VALUES (p_nombre, p_edificio, p_descripcion, p_hospital_id)
        RETURNING departamentos.id INTO p_id_new;

        RAISE NOTICE 'Ingresado con éxito el departamento "%" en el hospital "%".', (SELECT nombre FROM departamentos WHERE id = p_id_new), (SELECT nombre FROM hospital WHERE id = p_hospital_id);

    END IF;

END
$$;
