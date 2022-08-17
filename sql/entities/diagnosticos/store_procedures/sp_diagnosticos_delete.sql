CREATE OR REPLACE PROCEDURE sp_diagnosticos_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _nombres     VARCHAR(100);
    _apellidos   VARCHAR(100);
    _paciente_id INT;
BEGIN

    _paciente_id = (SELECT paciente_id FROM diagnosticos WHERE id = _id);
    _nombres = (SELECT nombres FROM pacientes WHERE id = _paciente_id);
    _apellidos = (SELECT apellidos FROM pacientes WHERE id = _paciente_id);

    IF NOT EXISTS(SELECT * FROM diagnosticos WHERE id = _id) THEN

        RAISE EXCEPTION 'El diagnóstico que está ingresando no existe.';

    ELSE

        DELETE
        FROM public.diagnosticos
        WHERE id = _id;

        RAISE NOTICE 'Se eliminó el diagnóstico de "% %" con id %.', _nombres, _apellidos, _id;

    END IF;

END
$$;
