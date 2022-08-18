SELECT * FROM vw_ocupaciones;

--Select fn de ocupaciones;
SELECT * FROM fn_ocupaciones(1);

--Call sp insert de ocupaciones
CALL sp_ocupaciones_insert(
        'Enfermera'
    );

--CAll sp update de ocupaciones
CALL sp_tipos_socios_update(
        1,
        'Pediatra'
    );

--CAll sp delete de ocupaciones
CALL sp_tipos_socios_delete(1);