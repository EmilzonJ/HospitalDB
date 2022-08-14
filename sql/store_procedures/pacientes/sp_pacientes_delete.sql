CREATE OR REPLACE PROCEDURE sp_pacientes_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM pacientes WHERE id = _id;
    RAISE NOTICE 'Paciente eliminado con exito';
END
$$