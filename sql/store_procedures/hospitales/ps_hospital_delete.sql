CREATE OR REPLACE PROCEDURE sp_hospital_delete(_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
DELETE FROM public.hospital
WHERE id = _id;

END $$;