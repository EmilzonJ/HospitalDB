CREATE OR REPLACE PROCEDURE sp_socios_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _nombres   VARCHAR(100);
    _apellidos VARCHAR(100);
BEGIN

    _nombres = (SELECT nombres FROM socios WHERE id = _id);
    _apellidos = (SELECT apellidos FROM socios WHERE id = _id);

    IF NOT EXISTS(SELECT * FROM socios WHERE id = _id) THEN
        RAISE EXCEPTION 'La persona que ingresó no está afiliada al hospital.';
    END IF;

    DELETE
    FROM public.socios
    WHERE id = _id;

    RAISE NOTICE 'Se eliminó exitosamente "% %" con id %.',_nombres, _apellidos, _id;
END
$$;