--CAll sp insert de Tipos de socios
CALL sp_tipos_socios_insert(
        'Naturales'
    );
--CAll sp update de Tipos de socios
CALL sp_tipos_socios_update(
        '2',
        'Juridicos'
    );
--CAll sp delete de Tipos de socios
CALL sp_tipos_socios_delete('2');
