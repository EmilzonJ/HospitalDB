CREATE OR REPLACE PROCEDURE sp_hospitales_update(
    _id INT,
    _nombre VARCHAR(100),
    _direccion VARCHAR(255),
    _celular VARCHAR(20)
)
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE hospitales
    SET nombre    = _nombre,
        direccion = _direccion,
        celular   = _celular
    WHERE id = _id;

END
$$;