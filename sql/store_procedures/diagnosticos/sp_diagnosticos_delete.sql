CREATE OR REPLACE PROCEDURE sp_diagnosticos_delete(p_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    p_nombres VARCHAR(100);
    p_apellidos VARCHAR(100);
    p_paciente_id INT;
BEGIN

    p_paciente_id = (SELECT paciente_id FROM diagnosticos WHERE id = p_id);
    p_nombres = (SELECT nombres FROM pacientes WHERE id = p_paciente_id);
    p_apellidos = (SELECT apellidos FROM pacientes WHERE id = p_paciente_id);

    IF NOT EXISTS (SELECT * FROM diagnosticos WHERE id = p_id) THEN
        
        RAISE NOTICE 'El diagnóstico que está ingresando no existe.';

    ELSEIF p_id IS NULL THEN
        
        RAISE NOTICE 'El edificio del departamento no puede estar vacío y es valor numérico.';

    ELSE

        DELETE FROM
            public.diagnosticos
        WHERE
			id = p_id;

		RAISE NOTICE 'Se eliminó el diagnóstico de "% %" con id %.', p_nombres, p_apellidos, p_id;    
    
    END IF;

END$$;
