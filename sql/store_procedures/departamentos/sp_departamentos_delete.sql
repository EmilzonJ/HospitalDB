CREATE OR REPLACE PROCEDURE sp_departamentos_delete(p_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    p_nombre VARCHAR(100);
BEGIN

    p_nombre = (SELECT nombre FROM departamentos WHERE id = p_id);

    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = p_id) THEN

        RAISE NOTICE 'El departamento que está ingresando no existe.';

    ELSEIF p_id IS NULL THEN

        RAISE NOTICE 'El edificio del departamento no puede estar vacío y es valor numérico.';

    ELSE

        DELETE
        FROM public.departamentos
        WHERE id = p_id;

        RAISE NOTICE 'Se eliminó el departamento de "%" con id %.', p_nombre, p_id;

    END IF;

END
$$;
