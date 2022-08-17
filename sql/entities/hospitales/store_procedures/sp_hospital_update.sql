CREATE OR REPLACE PROCEDURE sp_hospital_update(_id INT, _nombre VARCHAR(100), 
_direccion VARCHAR(255), _celular VARCHAR(20))
LANGUAGE plpgsql
AS $$
BEGIN
UPDATE public.hospital
	SET nombre = _nombre, 
		direccion = _direccion,
		celular= _celular
WHERE id = _id;

END $$;