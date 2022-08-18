SELECT * FROM vw_tipos_socios;

--Select fn de tipos de socios
SELECT * FROM fn_tipos_socios(1);

--Call sp insert de tipos de socios
CALL sp_tipos_socios_insert(
        'Naturales'
    );
--CAll sp update de Tipos de socios
CALL sp_tipos_socios_update(
        1,
        'Juridicos'
    );
--CAll sp delete de Tipos de socios
CALL sp_tipos_socios_delete(1);