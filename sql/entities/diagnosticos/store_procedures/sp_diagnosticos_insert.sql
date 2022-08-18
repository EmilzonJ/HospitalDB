CREATE OR REPLACE PROCEDURE sp_diagnosticos_insert(_paciente_id INT, --NOT NULL
                                                   _fecha_ingreso VARCHAR(10), --DATE NOT NULL VARCHAR para validar formato
                                                   _fecha_salida VARCHAR(10), --DATE NULL VARCHAR para validar formato
                                                   _resumen TEXT, --NULL
                                                   _razon_ingreso TEXT, --NOT NULL
                                                   _fecha VARCHAR(10)) --DATE NOT NULL VARCHAR para validar formato
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM pacientes WHERE id = _paciente_id) THEN

        RAISE EXCEPTION 'El paciente que está ingresando no existe.';

    END IF;

    IF public.fn_validate_date(_fecha_ingreso) = FALSE OR _fecha_ingreso SIMILAR TO '' THEN

        RAISE EXCEPTION 'El formato de la fecha de ingreso no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';

    END IF;

    IF _fecha_salida NOT SIMILAR TO '' AND public.fn_validate_date(_fecha_salida) = FALSE THEN

        RAISE EXCEPTION 'El formato de la fecha de salida no es válido, el formato debe ser el siguiente "YYYY-MM-DD".';

    END IF;

    IF _razon_ingreso IS NULL OR _razon_ingreso SIMILAR TO '' THEN

        RAISE EXCEPTION 'La razón de ingreso no puede estar vacía.';

    END IF;

    IF public.fn_validate_date(_fecha) = FALSE THEN

        RAISE EXCEPTION 'El formato de la fecha actual no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';

    ELSE

        IF _resumen SIMILAR TO '' THEN

            _resumen := NULL;

        END IF;

        IF _fecha_salida SIMILAR TO '' THEN

            _fecha_salida := NULL;

        END IF;

        INSERT INTO public.diagnosticos (paciente_id, fecha_ingreso, fecha_salida, resumen, razon_ingreso, fecha)
        VALUES (_paciente_id, TO_DATE(_fecha_ingreso, 'YYYY-MM-DD'), TO_DATE(_fecha_salida, 'YYYY-MM-DD'), _resumen,
                _razon_ingreso, TO_DATE(_fecha, 'YYYY-MM-DD'))
        RETURNING diagnosticos.id INTO _id_new;

        RAISE NOTICE 'Se ha ingresado el diagnóstico de "% %" con éxito.', (SELECT nombres FROM pacientes WHERE id = _paciente_id), (SELECT apellidos FROM pacientes WHERE id = _paciente_id);

    END IF;

END
$$;
