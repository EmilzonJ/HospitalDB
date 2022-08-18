CREATE OR REPLACE PROCEDURE sp_hospitales_insert(
    _nombre VARCHAR(100),
    _direccion VARCHAR(255),
    _celular VARCHAR(20)
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN
    INSERT INTO hospitales(nombre,
                           direccion,
                           celular)
    VALUES (_nombre,
            _direccion,
            _celular)

    RETURNING hospitales.id INTO _id_new;

    RAISE NOTICE 'Ingresado con éxito el hospital: %',
            (SELECT nombre FROM hospitales WHERE id = _id_new);
END
$$;
