CREATE OR REPLACE PROCEDURE sp_diagnosticos_update(p_id INT,
                                                   p_paciente_id INT, --NOT NULL
                                                   p_fecha_ingreso VARCHAR(10), --DATE NOT NULL VARCHAR para validar formato
                                                   p_fecha_salida VARCHAR(10), --DATE NULL VARCHAR para validar formato
                                                   p_resumen TEXT, --NULL
                                                   p_razon_ingreso TEXT, --NOT NULL
                                                   p_fecha VARCHAR(10)) --DATE NOT NULL VARCHAR para validar formato
LANGUAGE plpgsql
AS $$
BEGIN

    IF NOT EXISTS (SELECT * FROM diagnosticos WHERE id = p_id) THEN

        RAISE NOTICE 'El diagnóstico que está ingresando no existe.';

    ELSEIF NOT EXISTS (SELECT * FROM pacientes WHERE id = p_paciente_id) THEN

        RAISE NOTICE 'El paciente que está ingresando no existe.';
		
    ELSEIF p_fecha_ingreso NOT SIMILAR TO '\d{4,4}\-\d{2}\-\d{2}' OR p_fecha_ingreso SIMILAR TO '' THEN

        RAISE NOTICE 'El formato de la fecha de ingreso no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';

    ELSEIF p_fecha_salida NOT SIMILAR TO '' AND p_fecha_salida NOT SIMILAR TO '\d{4,4}\-\d{2}\-\d{2}' THEN

        RAISE NOTICE 'El formato de la fecha de salida no es válido, el formato debe ser el siguiente "YYYY-MM-DD".';
                
    ELSEIF p_razon_ingreso IS NULL OR p_razon_ingreso SIMILAR TO '' THEN
        
        RAISE NOTICE 'La razón de ingreso no puede estar vacía.';
    
    ELSEIF p_fecha NOT SIMILAR TO '\d{4,4}\-\d{2}\-\d{2}' THEN
        
        RAISE NOTICE 'El formato de la fecha actual no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';
    
    ELSE
	
        IF p_resumen SIMILAR TO '' THEN
        		
		    p_resumen := NULL;
	
	    END IF;

        IF p_fecha_salida SIMILAR TO '' THEN

		    p_fecha_salida := NULL;
			
        END IF;

        UPDATE public.diagnosticos
            SET
                id = p_id,
                paciente_id = p_paciente_id,
                fecha_ingreso = TO_DATE(p_fecha_ingreso, 'YYYY-MM-DD'),
                fecha_salida = TO_DATE(p_fecha_salida, 'YYYY-MM-DD'),
                resumen = p_resumen,
                razon_ingreso = p_razon_ingreso,
                fecha = TO_DATE(p_fecha, 'YYYY-MM-DD')
            WHERE 
                id = p_id;
        
        RAISE NOTICE 'El diagnóstico de "% %" se actualizó correctamente.', (SELECT nombres FROM pacientes WHERE id = p_paciente_id), (SELECT apellidos FROM pacientes WHERE id = p_paciente_id);

    END IF;

END$$;
