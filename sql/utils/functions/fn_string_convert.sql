CREATE OR REPLACE FUNCTION fn_string_convert(p_string_name_1 VARCHAR(100), p_string_name_2 VARCHAR(100)) 
    RETURNS BOOLEAN
    LANGUAGE plpgsql
AS 
$$
BEGIN
	
	--CREATE EXTENSION unaccent; --Solo se usa la primera vez, recomendado hacerlo en un query vacío.
	
	IF REPLACE(UNACCENT(LOWER(p_string_name_1)), ' ', '') = REPLACE(UNACCENT(LOWER(p_string_name_2)), ' ', '') THEN

		RETURN TRUE;
		
	ELSE

		RETURN FALSE;

	END IF;
	
END
$$;
