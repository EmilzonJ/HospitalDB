CREATE OR REPLACE PROCEDURE sp_diagnosticos_update(_id INT,
                                                   _paciente_id INT, --NOT NULL
                                                   _fecha_ingreso VARCHAR(10), --DATE NOT NULL VARCHAR para validar formato
                                                   _fecha_salida VARCHAR(10), --DATE NULL VARCHAR para validar formato
                                                   _resumen TEXT, --NULL
                                                   _razon_ingreso TEXT, --NOT NULL
                                                   _fecha VARCHAR(10)) --DATE NOT NULL VARCHAR para validar formato
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM diagnosticos WHERE id = _id) THEN

        RAISE NOTICE 'El diagnóstico que está ingresando no existe.';

    END IF;
    
    IF NOT EXISTS(SELECT * FROM pacientes WHERE id = _paciente_id) THEN

        RAISE NOTICE 'El paciente que está ingresando no existe.';

    END IF;
    
    IF public.fn_validate_date(_fecha_ingreso) = FALSE OR _fecha_ingreso SIMILAR TO '' THEN
    
        RAISE NOTICE 'El formato de la fecha de ingreso no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';

    END IF;

    IF _fecha_salida NOT SIMILAR TO '' AND public.fn_validate_date(_fecha_salida) = FALSE THEN

        RAISE NOTICE 'El formato de la fecha de salida no es válido, el formato debe ser el siguiente "YYYY-MM-DD".';

    END IF;

    IF _razon_ingreso IS NULL OR _razon_ingreso SIMILAR TO '' THEN

        RAISE NOTICE 'La razón de ingreso no puede estar vacía.';

    END IF;

    IF public.fn_validate_date(_fecha) = FALSE THEN

        RAISE NOTICE 'El formato de la fecha actual no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';

    ELSE

        IF _resumen SIMILAR TO '' THEN

            _resumen := NULL;

        END IF;

        IF _fecha_salida SIMILAR TO '' THEN

            _fecha_salida := NULL;

        END IF;

        UPDATE public.diagnosticos
        SET id            = _id,
            paciente_id   = _paciente_id,
            fecha_ingreso = TO_DATE(_fecha_ingreso, 'YYYY-MM-DD'),
            fecha_salida  = TO_DATE(_fecha_salida, 'YYYY-MM-DD'),
            resumen       = _resumen,
            razon_ingreso = _razon_ingreso,
            fecha         = TO_DATE(_fecha, 'YYYY-MM-DD')
        WHERE id = _id;

        RAISE NOTICE 'El diagnóstico de "% %" se actualizó correctamente.', (SELECT nombres FROM pacientes WHERE id = _paciente_id), (SELECT apellidos FROM pacientes WHERE id = _paciente_id);

    END IF;

END
$$;
