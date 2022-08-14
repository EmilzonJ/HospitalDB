CREATE OR REPLACE PROCEDURE sp_departamentos_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _nombre VARCHAR(100);
BEGIN

    _nombre = (SELECT nombre FROM departamentos WHERE id = _id);

    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _id) THEN

        RAISE NOTICE 'El departamento que está ingresando no existe.';

    ELSE

        DELETE
        FROM public.departamentos
        WHERE id = _id;
    
        RAISE NOTICE 'Se eliminó el departamento de "%" con id %.', _nombre, _id;
  
    END IF;
        
END
$$;
