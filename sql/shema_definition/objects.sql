-------------------------------------------------- FUNTIONS UTILS --------------------------------------------------
CREATE OR REPLACE FUNCTION fn_string_compare(
    _a VARCHAR,
    _b VARCHAR
)
    RETURNS BOOLEAN
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF TRIM(LOWER(_a)) = TRIM(LOWER(_b)) THEN
        RETURN TRUE;
    END IF;

    RETURN FALSE;
END
$$;

CREATE OR REPLACE FUNCTION fn_validate_date(date VARCHAR)
    RETURNS BOOLEAN AS
$$
BEGIN
    RETURN (date ~ '^\d{4,4}\-\d{2}\-\d{2}$');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_validate_dni(dni VARCHAR)
    RETURNS BOOLEAN AS
$$
BEGIN
    RETURN (dni ~ '^\d{4}\-\d{4}\-\d{5}$');
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_validate_phone(phone VARCHAR)
    RETURNS BOOLEAN AS
$$
BEGIN
    RETURN (phone ~ '^\+1?\d{9,15}$');
END;
$$
    LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE sp_departamentos_insert(_nombre VARCHAR(100),
                                                    _edificio INT,
                                                    _descripcion VARCHAR(20),
                                                    _hospital_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM hospitales WHERE id = _hospital_id) THEN

        RAISE EXCEPTION 'El hospital que está ingresando no existe.';

    END IF;

    IF _nombre IS NULL OR _nombre SIMILAR TO '' THEN

        RAISE EXCEPTION 'El nombre del departamento no puede estar vacío.';

    END IF;

    IF LENGTH(_nombre) > 100 THEN

        RAISE EXCEPTION 'El nombre del departamento no puede tener más de 100 caracteres.';

    END IF;

    IF EXISTS(SELECT *
              FROM departamentos
              WHERE edificio = _edificio
                AND hospital_id = _hospital_id
                AND (SELECT public.fn_string_compare(nombre, _nombre))) THEN

        RAISE EXCEPTION 'El edificio del departamento ya existe.';

    END IF;

    IF _descripcion IS NULL OR _descripcion SIMILAR TO '' THEN

        RAISE EXCEPTION 'La descripción del departamento no puede estar vacía.';

    END IF;

    IF LENGTH(_descripcion) > 255 THEN

        RAISE EXCEPTION 'La descripción del departamento no puede tener más de 255 caracteres.';

    END IF;

    INSERT INTO public.departamentos(nombre, edificio, descripcion, hospital_id)
    VALUES (_nombre, _edificio, _descripcion, _hospital_id)
    RETURNING departamentos.id INTO _id_new;

    RAISE NOTICE 'Ingresado con éxito el departamento "%" en el hospital "%".', (SELECT nombre FROM departamentos WHERE id = _id_new), (SELECT nombre FROM hospitales WHERE id = _hospital_id);

END
$$;


CREATE OR REPLACE PROCEDURE sp_departamentos_update(_id INT,
                                                    _nombre VARCHAR(100),
                                                    _edificio INT,
                                                    _descripcion VARCHAR(20),
                                                    _hospital_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _nombre_actual      VARCHAR(100);
    _edificio_actual    INT;
    _hospital_id_actual INT;
    not_exists          BOOLEAN; --si este valor es TRUE el departamento se puede editar.
BEGIN

    --Guardan los datos actuales del departamento.
    _nombre_actual = (SELECT nombre FROM departamentos WHERE id = _id);
    _edificio_actual = (SELECT edificio FROM departamentos WHERE id = _id);
    _hospital_id_actual = (SELECT hospital_id FROM departamentos WHERE id = _id);

    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _id) THEN

        RAISE EXCEPTION 'El departamento que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT * FROM hospitales WHERE id = _hospital_id) THEN

        RAISE EXCEPTION 'El hospital que está ingresando no existe.';

    END IF;

    IF _nombre IS NULL OR _nombre SIMILAR TO '' THEN

        RAISE EXCEPTION 'El nombre del departamento no puede estar vacío.';

    END IF;

    IF LENGTH(_nombre) > 100 THEN

        RAISE EXCEPTION 'El nombre del departamento no puede tener más de 100 caracteres.';

    END IF;

    IF (SELECT public.fn_string_compare(_nombre, _nombre_actual))
        AND ((_edificio <> _edificio_actual)
            OR (_hospital_id <> _hospital_id_actual)) THEN

        /*Entra en este ELSEIF si el nombre del departamento no ha cambiado y
        el edificio o el hospital del departamento ha cambiado.*/

        IF EXISTS(SELECT *
                  FROM departamentos
                  WHERE edificio = _edificio
                    AND hospital_id = _hospital_id
                    AND (SELECT public.fn_string_compare(nombre, _nombre))) THEN

            RAISE EXCEPTION 'El edificio del departamento ya existe.';

        ELSE

            not_exists = TRUE;

        END IF;

    END IF;

    IF (SELECT public.fn_string_compare(_nombre, _nombre_actual) = FALSE)
        AND ((_edificio <> _edificio_actual)
            OR (_hospital_id <> _hospital_id_actual)) THEN

        /*Entra en este ELSEIF si el nombre del departamento ha cambiado y
        el edificio o el hospital del departamento ha cambiado.*/

        IF EXISTS(SELECT *
                  FROM departamentos
                  WHERE edificio = _edificio
                    AND hospital_id = _hospital_id
                    AND (SELECT public.fn_string_compare(nombre, _nombre))) THEN

            RAISE EXCEPTION 'El edificio del departamento ya existe.';

        ELSE

            not_exists = TRUE;

        END IF;

    END IF;

    IF (SELECT public.fn_string_compare(_nombre, _nombre_actual) = FALSE)
        AND ((_edificio = _edificio_actual)
            OR (_hospital_id = _hospital_id_actual)) THEN

        /*Entra en este ELSEIF si el nombre del departamento ha cambiado y
        el edificio o el hospital del departamento no ha cambiado.*/

        IF EXISTS(SELECT *
                  FROM departamentos
                  WHERE edificio = _edificio
                    AND hospital_id = _hospital_id
                    AND (SELECT public.fn_string_compare(nombre, _nombre))) THEN

            RAISE EXCEPTION 'El edificio del departamento ya existe.';

        ELSE

            not_exists = TRUE;

        END IF;

    END IF;

    IF (SELECT public.fn_string_compare(_nombre, _nombre_actual))
        AND ((_edificio = _edificio_actual)
            OR (_hospital_id = _hospital_id_actual)) THEN

        /*Entra en este ELSEIF si el nombre del departamento no ha cambiado y
        el edificio o el hospital del departamento no ha cambiado.*/

        not_exists = TRUE;

    END IF;

    IF _descripcion IS NULL OR _descripcion SIMILAR TO '' THEN

        RAISE EXCEPTION 'La descripción del departamento no puede estar vacía.';

    END IF;

    IF LENGTH(_descripcion) > 255 THEN

        RAISE EXCEPTION 'La descripción del departamento no puede tener más de 255 caracteres.';

    END IF;

    IF not_exists THEN

        UPDATE public.departamentos
        SET id          = _id,
            nombre      = _nombre,
            edificio    = _edificio,
            descripcion = _descripcion,
            hospital_id = _hospital_id
        WHERE id = _id;

        RAISE NOTICE 'Se actualizó el departamento "%" en el hospital "%".', (SELECT nombre FROM departamentos WHERE id = _id), (SELECT nombre FROM hospitales WHERE id = _hospital_id);

    END IF;

END
$$;


CREATE OR REPLACE PROCEDURE sp_departamentos_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _nombre VARCHAR(100);
BEGIN

    _nombre = (SELECT nombre FROM departamentos WHERE id = _id);

    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _id) THEN
        RAISE EXCEPTION 'El departamento que está ingresando no existe.';
    END IF;


    DELETE
    FROM public.departamentos
    WHERE id = _id;

    RAISE NOTICE 'Se eliminó el departamento de "%" con id %.', _nombre, _id;

END
$$;

CREATE OR REPLACE VIEW vw_departamentos AS
SELECT d.id,
       d.nombre,
       d.edificio,
       d.descripcion,
       h.id        AS hospital_id,
       h.nombre    AS hospital_nombre,
       h.direccion AS hospital_direccion
FROM departamentos d
         INNER JOIN
     hospitales h ON d.hospital_id = h.id;

CREATE OR REPLACE FUNCTION fn_departamento_empleados(_departamento_id INT)
    RETURNS TABLE
            (
                EMPLEADO_ID INT,
                NOMBRE      VARCHAR(100),
                APELLIDO    VARCHAR(100),
                OCUPACION   VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM departamentos_empleados WHERE departamento_id = _departamento_id) THEN

        RAISE EXCEPTION 'No hay empleados en el departamento "%".', _departamento_id;

    END IF;

    RETURN QUERY SELECT e.id,
                        e.nombres,
                        e.apellidos,
                        oc.descripcion
                 FROM empleados e
                          INNER JOIN
                      ocupaciones oc ON e.ocupacion_id = oc.id
                          INNER JOIN
                      departamentos_empleados d_e ON e.id = d_e.empleado_id
                 WHERE d_e.departamento_id = _departamento_id;

END
$$;

CREATE OR REPLACE PROCEDURE sp_dep_emp_insert(_dep_id INT, _emp_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dep_id_new INT;
    _emp_id_new INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _dep_id) THEN

        RAISE EXCEPTION 'El departamento que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT * FROM empleados WHERE id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado que está ingresando no existe.';

    END IF;

    IF EXISTS(SELECT *
              FROM departamentos_empleados
              WHERE empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado ya está asignado a un departamento.';

    END IF;

    IF EXISTS(SELECT *
              FROM departamentos_empleados
              WHERE departamento_id = _dep_id
                AND empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado ya se encuentra en el departamento.';

    ELSE

        INSERT INTO public.departamentos_empleados(departamento_id, empleado_id)
        VALUES (_dep_id, _emp_id)
        RETURNING departamento_id, empleado_id INTO _dep_id_new, _emp_id_new;

        RAISE NOTICE 'Ingresado con éxito el empleado "%" en el departamento de "%".',
            (SELECT (nombres || ' ' || apellidos) FROM empleados WHERE id = _emp_id_new),
                (SELECT nombre FROM departamentos WHERE id = _dep_id_new);

    END IF;

END
$$;


/*Este update sirve para cambiar al empleado a otro departamento,
  se asigna el departamento a cambiar y el empleado que se desea cambiar.*/

CREATE OR REPLACE PROCEDURE sp_dep_emp_update(_dep_id INT, _emp_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _dep_id) THEN

        RAISE EXCEPTION 'El departamento que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT * FROM empleados WHERE id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT *
                  FROM departamentos_empleados
                  WHERE empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado no está asignado a un departamento.';

    END IF;

    IF EXISTS(SELECT *
              FROM departamentos_empleados
              WHERE departamento_id = _dep_id
                AND empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado ya se encuentra en ese departamento.';

    ELSE

        UPDATE
            departamentos_empleados
        SET departamento_id = _dep_id,
            empleado_id     = _emp_id
        WHERE empleado_id = _emp_id;

        RAISE NOTICE 'Se cambió el empleado "%" al departamento de "%".',
                (SELECT (nombres || ' ' || apellidos) FROM empleados WHERE id = _emp_id),
                (SELECT nombre FROM departamentos WHERE id = _dep_id);

    END IF;

END
$$;

CREATE OR REPLACE PROCEDURE sp_dep_emp_delete(_dep_id INT, _emp_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dep_nombre VARCHAR(100);
    _emp_nombre VARCHAR(100);
BEGIN

    _dep_nombre = (SELECT nombre FROM departamentos WHERE id = _dep_id);
    _emp_nombre = (SELECT (nombres || ' ' || apellidos) FROM empleados WHERE id = _emp_id);

    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _dep_id) THEN

        RAISE EXCEPTION 'El departamento que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT * FROM empleados WHERE id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT *
                  FROM departamentos_empleados
                  WHERE empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado no está asignado a un departamento.';

    END IF;

    IF NOT EXISTS(SELECT *
                  FROM departamentos_empleados
                  WHERE departamento_id = _dep_id
                    AND empleado_id = _emp_id) THEN

        RAISE EXCEPTION 'El empleado no se encuentra en el departamento.';

    ELSE

        DELETE
        FROM public.departamentos_empleados
        WHERE departamento_id = _dep_id
          AND empleado_id = _emp_id;

        RAISE NOTICE 'Se elminó el empleado "%" del departamento de "%".', _emp_nombre, _dep_nombre;

    END IF;

END
$$;

CREATE OR REPLACE VIEW vw_departamentos_empleados AS
SELECT d.id        AS departamento_id,
       d.nombre    AS departamento_nombre,
       e.id        AS empleado_id,
       e.nombres   AS empleado_nombres,
       e.apellidos AS empleado_apellidos
FROM departamentos_empleados d_e
         INNER JOIN
     departamentos d ON d_e.departamento_id = d.id
         INNER JOIN
     empleados e ON d_e.empleado_id = e.id;


CREATE OR REPLACE FUNCTION fn_paciente_diagnosticos(_paciente_id INT)
    RETURNS TABLE
            (
                DIAGNOSTICO_ID INT,
                NOMBRE         VARCHAR(100),
                APELLIDO       VARCHAR(100),
                FECHA_INGRESO  DATE,
                RAZON_INGRESO  TEXT,
                FECHA          DATE
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM diagnosticos WHERE paciente_id = _paciente_id) THEN

        RAISE EXCEPTION 'No hay diagnósticos del paciente "%".', _paciente_id;

    END IF;

    RETURN QUERY SELECT d.id,
                        p.nombres,
                        p.apellidos,
                        d.fecha_ingreso,
                        d.razon_ingreso,
                        d.fecha
                 FROM diagnosticos d
                          INNER JOIN
                      pacientes p ON p.id = d.paciente_id
                 WHERE d.paciente_id = _paciente_id;

END
$$;

CREATE OR REPLACE PROCEDURE sp_diagnosticos_insert(_paciente_id INT, --NOT NULL
                                                   _fecha_ingreso VARCHAR(10), --DATE NOT NULL VARCHAR para validar formato
                                                   _fecha_salida VARCHAR(10), --DATE NULL VARCHAR para validar formato
                                                   _resumen TEXT, --NULL
                                                   _razon_ingreso TEXT, --NOT NULL
                                                   _fecha VARCHAR(10)) --DATE NOT NULL VARCHAR para validar formato
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM pacientes WHERE id = _paciente_id) THEN

        RAISE EXCEPTION 'El paciente que está ingresando no existe.';

    END IF;

    IF public.fn_validate_date(_fecha_ingreso) = FALSE OR _fecha_ingreso SIMILAR TO '' THEN

        RAISE EXCEPTION 'El formato de la fecha de ingreso no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';

    END IF;

    IF _fecha_salida NOT SIMILAR TO '' AND public.fn_validate_date(_fecha_salida) = FALSE THEN

        RAISE EXCEPTION 'El formato de la fecha de salida no es válido, el formato debe ser el siguiente "YYYY-MM-DD".';

    END IF;

    IF _razon_ingreso IS NULL OR _razon_ingreso SIMILAR TO '' THEN

        RAISE EXCEPTION 'La razón de ingreso no puede estar vacía.';

    END IF;

    IF public.fn_validate_date(_fecha) = FALSE THEN

        RAISE EXCEPTION 'El formato de la fecha actual no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';

    ELSE

        IF _resumen SIMILAR TO '' THEN

            _resumen := NULL;

        END IF;

        IF _fecha_salida SIMILAR TO '' THEN

            _fecha_salida := NULL;

        END IF;

        INSERT INTO public.diagnosticos (paciente_id, fecha_ingreso, fecha_salida, resumen, razon_ingreso, fecha)
        VALUES (_paciente_id, TO_DATE(_fecha_ingreso, 'YYYY-MM-DD'), TO_DATE(_fecha_salida, 'YYYY-MM-DD'), _resumen,
                _razon_ingreso, TO_DATE(_fecha, 'YYYY-MM-DD'))
        RETURNING diagnosticos.id INTO _id_new;

        RAISE NOTICE 'Se ha ingresado el diagnóstico de "% %" con éxito.', (SELECT nombres FROM pacientes WHERE id = _paciente_id), (SELECT apellidos FROM pacientes WHERE id = _paciente_id);

    END IF;

END
$$;

CREATE OR REPLACE PROCEDURE sp_diagnosticos_update(_id INT,
                                                   _paciente_id INT, --NOT NULL
                                                   _fecha_ingreso VARCHAR(10), --DATE NOT NULL VARCHAR para validar formato
                                                   _fecha_salida VARCHAR(10), --DATE NULL VARCHAR para validar formato
                                                   _resumen TEXT, --NULL
                                                   _razon_ingreso TEXT, --NOT NULL
                                                   _fecha VARCHAR(10)) --DATE NOT NULL VARCHAR para validar formato
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM diagnosticos WHERE id = _id) THEN

        RAISE EXCEPTION 'El diagnóstico que está ingresando no existe.';

    END IF;

    IF NOT EXISTS(SELECT * FROM pacientes WHERE id = _paciente_id) THEN

        RAISE EXCEPTION 'El paciente que está ingresando no existe.';

    END IF;

    IF public.fn_validate_date(_fecha_ingreso) = FALSE OR _fecha_ingreso SIMILAR TO '' THEN

        RAISE EXCEPTION 'El formato de la fecha de ingreso no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';

    END IF;

    IF _fecha_salida NOT SIMILAR TO '' AND public.fn_validate_date(_fecha_salida) = FALSE THEN

        RAISE EXCEPTION 'El formato de la fecha de salida no es válido, el formato debe ser el siguiente "YYYY-MM-DD".';

    END IF;

    IF _razon_ingreso IS NULL OR _razon_ingreso SIMILAR TO '' THEN

        RAISE EXCEPTION 'La razón de ingreso no puede estar vacía.';

    END IF;

    IF public.fn_validate_date(_fecha) = FALSE THEN

        RAISE EXCEPTION 'El formato de la fecha actual no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';

    ELSE

        IF _resumen SIMILAR TO '' THEN

            _resumen := NULL;

        END IF;

        IF _fecha_salida SIMILAR TO '' THEN

            _fecha_salida := NULL;

        END IF;

        UPDATE public.diagnosticos
        SET id            = _id,
            paciente_id   = _paciente_id,
            fecha_ingreso = TO_DATE(_fecha_ingreso, 'YYYY-MM-DD'),
            fecha_salida  = TO_DATE(_fecha_salida, 'YYYY-MM-DD'),
            resumen       = _resumen,
            razon_ingreso = _razon_ingreso,
            fecha         = TO_DATE(_fecha, 'YYYY-MM-DD')
        WHERE id = _id;

        RAISE NOTICE 'El diagnóstico de "% %" se actualizó correctamente.', (SELECT nombres FROM pacientes WHERE id = _paciente_id), (SELECT apellidos FROM pacientes WHERE id = _paciente_id);

    END IF;

END
$$;

CREATE OR REPLACE PROCEDURE sp_diagnosticos_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _nombres     VARCHAR(100);
    _apellidos   VARCHAR(100);
    _paciente_id INT;
BEGIN

    _paciente_id = (SELECT paciente_id FROM diagnosticos WHERE id = _id);
    _nombres = (SELECT nombres FROM pacientes WHERE id = _paciente_id);
    _apellidos = (SELECT apellidos FROM pacientes WHERE id = _paciente_id);

    IF NOT EXISTS(SELECT * FROM diagnosticos WHERE id = _id) THEN

        RAISE EXCEPTION 'El diagnóstico que está ingresando no existe.';

    ELSE

        DELETE
        FROM public.diagnosticos
        WHERE id = _id;

        RAISE NOTICE 'Se eliminó el diagnóstico de "% %" con id %.', _nombres, _apellidos, _id;

    END IF;

END
$$;


CREATE OR REPLACE VIEW vw_diagnosticos AS
SELECT d.id,
       d.paciente_id,
       p.nombres   AS paciente_nombres,
       p.apellidos AS paciente_apellidos,
       d.fecha_ingreso,
       d.fecha_salida,
       d.resumen,
       d.razon_ingreso,
       d.fecha
FROM diagnosticos d
         INNER JOIN
     pacientes p ON d.paciente_id = p.id;


CREATE OR REPLACE FUNCTION fn_empleado_by_id(_id INT)
    RETURNS TABLE
            (
                EMPLEADO_ID  INT,
                NOMBRES      VARCHAR(100),
                APELLIDOS    VARCHAR(100),
                DNI          VARCHAR(15),
                CORREO       VARCHAR(100),
                CELULAR      VARCHAR(20),
                OCUPACION_ID INT,
                OCUPACION    VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM empleados WHERE id = _id) THEN
        RAISE EXCEPTION 'El empleado no existe';
    END IF;

    RETURN QUERY SELECT e.id,
                        e.nombres,
                        e.apellidos,
                        e.dni,
                        e.correo,
                        e.celular,
                        o.id          AS ocupacion_id,
                        o.descripcion AS ocupacion
                 FROM empleados AS e
                          INNER JOIN ocupaciones AS o ON e.ocupacion_id = o.id
                 WHERE e.id = _id;
END
$$;


CREATE OR REPLACE PROCEDURE sp_empleados_insert(
    _nombres VARCHAR(100),
    _apellidos VARCHAR(100),
    _ocupacion_id INT,
    _dni VARCHAR(15),
    _correo VARCHAR(100),
    _celular VARCHAR(20)
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_empleado INT;
BEGIN

    -- Validar DNI
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    -- Validar DNI repetido
    IF EXISTS(SELECT FROM tutores WHERE dni = _dni) THEN
        RAISE EXCEPTION 'DNI ya existe';
    END IF;

    -- Validar celular
    IF NOT (SELECT fn_validate_phone(_celular)) THEN
        RAISE EXCEPTION 'Celular no válido, debe tener el formato: +999999999, se permiten hasta 15 caracteres';
    END IF;

    -- Validar FK ocupacion
    IF NOT (SELECT FROM ocupaciones WHERE id = _ocupacion_id) THEN
        RAISE EXCEPTION 'Ocupación no existe';
    END IF;

    -- Insertar empleado
    INSERT INTO empleados (nombres,
                           apellidos,
                           ocupacion_id,
                           dni,
                           correo,
                           celular)
    VALUES (_nombres,
            _apellidos,
            _ocupacion_id,
            _dni,
            _correo,
            _celular)

    RETURNING id INTO _id_empleado;

    -- Obtener id del empleado insertado
    RAISE NOTICE 'Empleado insertado con id: %', _id_empleado;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_empleados_update(
    _id INT,
    _nombres VARCHAR(100),
    _apellidos VARCHAR(100),
    _ocupacion_id INT,
    _dni VARCHAR(15),
    _correo VARCHAR(100),
    _celular VARCHAR(20)
)
    LANGUAGE plpgsql
AS
$$
BEGIN
    -- Validar DNI
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    -- Validar celular
    IF NOT (SELECT fn_validate_phone(_celular)) THEN
        RAISE EXCEPTION 'Celular no válido, debe tener el formato: +999999999, se permiten hasta 15 caracteres';
    END IF;

    -- Validar FK ocupacion
    IF NOT (SELECT FROM ocupaciones WHERE id = _ocupacion_id) THEN
        RAISE EXCEPTION 'Ocupación no existe';
    END IF;

    -- Actualizar empleado
    UPDATE empleados
    SET nombres      = _nombres,
        apellidos    = _apellidos,
        ocupacion_id = _ocupacion_id,
        dni          = _dni,
        correo       = _correo,
        celular      = _celular
    WHERE id = _id;

    RAISE NOTICE 'Empleado actualizado con éxito';

END;
$$;


CREATE OR REPLACE PROCEDURE sp_empleados_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM empleados WHERE id = _id;
    RAISE NOTICE 'Empleado eliminado con éxito';
END;
$$;

CREATE OR REPLACE VIEW vw_empleados
AS
SELECT e.id,
       e.nombres,
       e.apellidos,
       e.dni,
       e.correo,
       e.celular,
       oc.id          AS ocupacion_id,
       oc.descripcion AS ocupacion
FROM empleados AS e
         INNER JOIN ocupaciones AS oc ON oc.id = e.ocupacion_id;


CREATE OR REPLACE FUNCTION fn_hospitaleses(_id INT)
    RETURNS TABLE
            (
                HOSPITALES_ID INT,
                NOMBRE        VARCHAR(100),
                DIRECCION     VARCHAR(255),
                CELULAR       VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM hospitales WHERE hospitales_id = _id) THEN
        RAISE EXCEPTION 'El hospital no existe "%".', _id;
    END IF;

    RETURN QUERY SELECT h.id,
                        h.nombre,
                        h.direccion,
                        h.celular
                 FROM hospitales AS h
                 WHERE h.id = _id;

END
$$;

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

CREATE OR REPLACE PROCEDURE sp_hospitales_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF (SELECT COUNT(*) FROM departamentos WHERE hospital_id = _id) > 0 THEN
        RAISE EXCEPTION 'No se puede eliminar el hospital porque tiene departamentos asociados';
    END IF;

    DELETE
    FROM public.hospitales
    WHERE id = _id;

    RAISE NOTICE 'Hospital eliminado con éxito';
END
$$;


CREATE OR REPLACE VIEW vw_hospitales
AS
SELECT h.id,
       h.nombre,
       h.direccion,
       h.celular
FROM hospitales AS h;


--funcion para listar los socios de un hospital
CREATE OR REPLACE FUNCTION fn_hospitales_socios(_hospital_id INT)
    RETURNS TABLE
            (
                SOCIO_ID    INT,
                NOMBRES     VARCHAR(100),
                APELLIDOS   VARCHAR(100),
                CELULAR     VARCHAR(100),
                CORREO      VARCHAR(100),
                DNI         VARCHAR(15),
                DESCRIPCION VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM hospitales_socios WHERE hospital_id = _hospital_id) THEN
        RAISE EXCEPTION 'No hay socios afiliados a este hospital "%".', _hospital_id;
    END IF;

    RETURN QUERY SELECT s.id,
                        s.nombres,
                        s.apellidos,
                        s.celular,
                        s.correo,
                        s.dni,
                        ts.descripcion
                 FROM socios s
                          INNER JOIN
                      tipos_socios ts ON s.tiposocio_id = ts.id
                          INNER JOIN
                      hospitales_socios h_s ON s.id = h_s.socio_id
                 WHERE h_s.hospital_id = _hospital_id;
END
$$;

--Listar en que hospitales estan afiliados los socios
CREATE OR REPLACE FUNCTION fn_socios_hospitales(_socio_id INT)
    RETURNS TABLE
            (
                HOSPITAL_ID INT,
                NOMBRES     VARCHAR(100),
                DIRECCION   VARCHAR(255)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM hospitales_socios WHERE socio_id = _socio_id) THEN
        RAISE EXCEPTION 'Esta persona no está afiliada a ningun hospital "%".', _socio_id;
    END IF;

    RETURN QUERY SELECT h.id,
                        h.nombre,
                        h.direccion
                 FROM hospitales AS h
                          INNER JOIN
                      hospitales_socios h_s ON h.id = h_s.hospital_id
                 WHERE h_s.socio_id = _socio_id;
END
$$;

CREATE OR REPLACE PROCEDURE sp_hospitales_socios_insert(_hospital_id INT, _socio_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _h_id INT;
    _s_id INT;
BEGIN

    IF NOT EXISTS(SELECT * FROM hospitales WHERE id = _hospital_id) THEN
        RAISE EXCEPTION 'El hospital que ha ingresado no existe.';
    END IF;

    IF NOT EXISTS(SELECT * FROM socios WHERE id = _socio_id) THEN
        RAISE EXCEPTION 'El socio que ha ingresado no existe.';
    END IF;

    IF EXISTS(SELECT *
              FROM hospitales_socios
              WHERE hospital_id = _hospital_id
                AND socio_id = _socio_id) THEN
        RAISE EXCEPTION 'El socio ya se encuentra afiliado a este hospital.';
    END IF;

    INSERT INTO public.hospitales_socios(hospital_id, socio_id)
    VALUES (_hospital_id, _socio_id)
    RETURNING hospital_id, hospital_id INTO _h_id, _s_id;

    RAISE NOTICE 'Ingresado con éxito el socio "%" en el hospital de "%".',
            (SELECT (nombres || ' ' || apellidos) FROM socios WHERE id = _socio_id),
            (SELECT nombre FROM hospitales WHERE id = _h_id);

END
$$;


CREATE OR REPLACE FUNCTION fn_ocupaciones(_id INT)
    RETURNS TABLE
            (
                OCUPACION_ID          INT,
                OCUPACION_DESCRIPCION VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF NOT EXISTS(SELECT * FROM ocupaciones WHERE ocupacion_id = _id) THEN

        RAISE NOTICE 'La ocupacion no existe "%".', _id;
    END IF;
    RETURN QUERY SELECT o.id,
                        o.descripcion
                 FROM ocupaciones AS o
                 WHERE o.id = _id;
END;
$$;


CREATE OR REPLACE PROCEDURE sp_ocupaciones_insert(_descripcion VARCHAR(100))
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN
    INSERT INTO public.ocupaciones(descripcion)
    VALUES (_descripcion)
    RETURNING ocupaciones.id INTO _id_new;

    RAISE NOTICE 'Ingresado con exito ocupacion: %',
            (SELECT descripcion FROM ocupaciones WHERE id = _id_new);
END
$$;


CREATE OR REPLACE PROCEDURE sp_ocupaciones_update(_id INT,
                                                  _descripcion VARCHAR(100))
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE public.ocupaciones
    SET descripcion = _descripcion
    WHERE id = _id;
    RAISE NOTICE 'Actualizado con exito ocupacion: %',
            (SELECT descripcion FROM ocupaciones WHERE id = _id);
END
$$;


CREATE OR REPLACE PROCEDURE sp_ocupaciones_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF (SELECT COUNT(*) FROM empleados WHERE ocupacion_id = _id) > 0 THEN
        RAISE EXCEPTION 'No se puede eliminar la ocupación porque hay empleados asociados a ella.';
    END IF;

    DELETE
    FROM public.ocupaciones
    WHERE id = _id;
    RAISE NOTICE 'Ocupación eliminada con éxito';
END
$$;


CREATE VIEW vw_ocupaciones
AS
SELECT ocupaciones.id,
       ocupaciones.descripcion
FROM ocupaciones;


CREATE OR REPLACE FUNCTION fn_pacientes(_id INT)
    RETURNS TABLE
            (
                PACIENTE_ID      INT,
                NOMBRES          VARCHAR(100),
                APELLIDOS        VARCHAR(100),
                GENERO           VARCHAR(3),
                FECHA_NACIMIENTO DATE,
                DNI              VARCHAR(15),
                DIRECCION        VARCHAR(255),
                DEPARTAMENTI_ID  INT,
                EMPLEADO_ID      INT,
                ESTADO           VARCHAR(30),
                TIPO_SANGRE      VARCHAR(4)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM pacientes WHERE paciente_id = _id) THEN
        RAISE NOTICE 'El paciente no existe "%".', _id;
    END IF;

    RETURN QUERY SELECT p.id,
                        p.nombres,
                        p.apellidos,
                        p.genero,
                        p.fecha_nacimiento,
                        p.dni,
                        p.direccion,
                        p.departamento_id,
                        p.empleado_id,
                        p.estado,
                        p.tipo_sangre
                 FROM pacientes AS p
                 WHERE p.id = _id;
END
$$;


CREATE OR REPLACE PROCEDURE sp_pacientes_insert(_nombres VARCHAR(100),
                                                _apellidos VARCHAR(100),
                                                _genero VARCHAR(3),
                                                _fecha_nacimiento VARCHAR(10),
                                                _dni VARCHAR(15),
                                                _direccion VARCHAR(255),
                                                _departamento_id INT,
                                                _empleado_id INT,
                                                _estado VARCHAR(30),
                                                _tipo_sangre VARCHAR(4))
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN
    --validar que existe departamento id
    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _departamento_id) THEN
        RAISE EXCEPTION 'El departamento que ingresó no existe';
    END IF;

    --Validar que existe empleado_id
    IF NOT EXISTS(SELECT *FROM empleados WHERE id = _empleado_id) THEN
        RAISE EXCEPTION 'El empleado que ingresó no existe';
    END IF;

    --validar fecha de nacimiento
    IF _fecha_nacimiento NOT SIMILAR TO '\d{4,4}\-\d{2}\-\d{2}' OR _fecha_nacimiento SIMILAR TO '' THEN
        RAISE EXCEPTION 'El formato de la fecha de nacimiento no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';
    END IF;

    --validar DNI
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    --Validar que DNI no existe
    IF EXISTS(SELECT FROM pacientes WHERE dni = _dni) THEN
        RAISE EXCEPTION 'DNI ya existe';
    END IF;

    --Insertar paciente
    INSERT INTO pacientes (nombres,
                           apellidos,
                           genero,
                           fecha_nacimiento,
                           dni,
                           direccion,
                           departamento_id,
                           empleado_id,
                           estado,
                           tipo_sangre)
    VALUES (_nombres,
            _apellidos,
            _genero,
            TO_DATE(_fecha_nacimiento, 'YYYY-MM-DD'),
            _dni,
            _direccion,
            _departamento_id,
            _empleado_id,
            _estado,
            _tipo_sangre)
    RETURNING id INTO _id_new;
    RAISE NOTICE 'Paciente Ingresado con Id: % ',_id_new;
END
$$;


CREATE OR REPLACE PROCEDURE sp_pacientes_update(_id INT,
                                                _nombres VARCHAR(100),
                                                _apellidos VARCHAR(100),
                                                _genero VARCHAR(3),
                                                _fecha_nacimiento VARCHAR(10),
                                                _dni VARCHAR(15),
                                                _direccion VARCHAR(255),
                                                _departamento_id INT,
                                                _empleado_id INT,
                                                _estado VARCHAR(30),
                                                _tipo_sangre VARCHAR(4))
    LANGUAGE plpgsql
AS
$$
BEGIN
    --Verificar Id del paciente
    IF NOT EXISTS(SELECT * FROM pacientes WHERE id = _id) THEN
        RAISE EXCEPTION 'El paciente que está ingresando no existe.';
    END IF;

    --Verificar Id de departamento
    IF NOT EXISTS(SELECT * FROM departamentos WHERE id = _departamento_id) THEN
        RAISE EXCEPTION 'El departamento que está ingresando no existe.';
    END IF;

    --Verificar Id de empleado
    IF NOT EXISTS(SELECT * FROM empleados WHERE id = _empleado_id) THEN
        RAISE EXCEPTION 'El empleado que está ingresando no existe.';
    END IF;

    --Verificar fecha de nacimiento
    IF public.fn_validate_date(_fecha_nacimiento) = FALSE OR _fecha_nacimiento SIMILAR TO '' THEN
        RAISE EXCEPTION 'El formato de la fecha de ingreso no es válido o está vacío, el formato debe ser el siguiente "YYYY-MM-DD".';
    END IF;

    --Verificar dni de paciente
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    --Verificar nombres de paciente
    IF _nombres IS NULL OR _nombres SIMILAR TO '' THEN
        RAISE EXCEPTION 'El nombre del paciente no puede estar vacío.';
    END IF;

    --Verificar apellidos de paciente
    IF _apellidos IS NULL OR _apellidos SIMILAR TO '' THEN
        RAISE EXCEPTION 'Los apellidos del paciente no puede estar vacío.';
    END IF;

    --Verificar genero de paciente
    IF _genero IS NULL OR _genero SIMILAR TO '' THEN
        RAISE EXCEPTION 'El genero del paciente no puede estar vacío.';
    END IF;

    --Verificar direccion de paciente
    IF _direccion IS NULL OR _direccion SIMILAR TO '' THEN
        RAISE EXCEPTION 'La direccion del paciente no puede estar vacía.';
    END IF;

    --Verificar estado de paciente
    IF _estado IS NULL OR _estado SIMILAR TO '' THEN
        RAISE EXCEPTION 'El estado del paciente no puede estar vacío.';
    END IF;

    UPDATE public.pacientes
    SET id               = _id,
        nombres          = _nombres,
        apellidos        = _apellidos,
        genero           = _genero,
        fecha_nacimiento = TO_DATE(_fecha_nacimiento, 'YYYY-MM-DD'),
        dni              = _dni,
        direccion        = _direccion,
        departamento_id  = _departamento_id,
        empleado_id      = _empleado_id,
        estado           = _estado,
        tipo_sangre      = _tipo_sangre
    WHERE id = _id;

    RAISE NOTICE 'Los datos del paciente % con código %se editaron correctamente',
            (SELECT nombres FROM pacientes WHERE id = _id),
            (SELECT id FROM pacientes WHERE id = _id);
END;
$$;


CREATE OR REPLACE PROCEDURE sp_pacientes_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM pacientes WHERE id = _id;
    RAISE NOTICE 'Paciente eliminado con éxito';
END
$$;


CREATE OR REPLACE VIEW vw_pacientes AS
SELECT p.id AS pacientes_id,
       p.nombres,
       p.apellidos,
       p.genero,
       p.direccion,
       p.fecha_nacimiento,
       p.departamento_id,
       p.empleado_id,
       p.estado,
       p.tipo_sangre

FROM pacientes p
         INNER JOIN
     departamentos d ON p.departamento_id = d.id
         INNER JOIN
     empleados e ON p.empleado_id = e.id;


CREATE OR REPLACE FUNCTION fn_pacientes_tutores(_paciente_id INT)
    RETURNS TABLE
            (
                TUTOR_ID  INT,
                NOMBRES   VARCHAR(100),
                APELLIDOS VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM pacientes_tutores WHERE paciente_id = _paciente_id) THEN
        RAISE EXCEPTION 'No hay tutores para el pacientes "%".', _paciente_id;
    END IF;

    RETURN QUERY SELECT t.id,
                        t.nombres,
                        t.apellidos
                 FROM tutores t
                          INNER JOIN
                      pacientes_tutores p_t ON t.id = p_t.tutor_id
                 WHERE p_t.paciente_id = _paciente_id;

END
$$;

CREATE OR REPLACE PROCEDURE sp_pac_tut_insert(_paciente_id INT,
                                              _tutor_id INT,
                                              _parentesco VARCHAR(20))
    LANGUAGE plpgsql
AS
$$
DECLARE
    _paciente_id_new INT;
    _tutor_id_new    INT;
BEGIN
    --Validar paciente
    IF NOT EXISTS(SELECT * FROM pacientes WHERE id = _paciente_id) THEN
        RAISE EXCEPTION 'El paciente que está ingresando no existe.';
    END IF;

    --Validar tutor
    IF NOT EXISTS(SELECT * FROM tutores WHERE id = _tutor_id) THEN
        RAISE EXCEPTION 'El tutor que está ingresando no existe.';
    END IF;

    IF _parentesco IS NULL OR _parentesco SIMILAR TO '' THEN
        RAISE EXCEPTION 'El parentesco del paciente y tutor no puede estar vacía.';
    END IF;

    INSERT INTO public.pacientes_tutores(paciente_id,
                                         tutor_id,
                                         parentesco)
    VALUES (_paciente_id,
            _tutor_id,
            _parentesco)
    RETURNING paciente_id, tutor_id INTO _paciente_id_new, _tutor_id_new;

    RAISE NOTICE 'Ingresado con éxito el paciente "%" con el tutor "%".',
        (SELECT (nombres || ' ' || apellidos) FROM pacientes WHERE id = _paciente_id_new),
            (SELECT nombres FROM tutores WHERE id = _tutor_id_new);
END;
$$;


CREATE OR REPLACE VIEW vw_pacientes_tutores AS
SELECT t.id        AS tutor_id,
       t.nombres   AS tutor_nombres,
       t.apellidos AS tutor_apellidos,
       p.id        AS pacientes_id,
       p.nombres   AS pacientes_nombres,
       p.apellidos AS pacientes_apellidos
FROM pacientes_tutores p_t
         INNER JOIN
     pacientes p ON p_t.paciente_id = p.id
         INNER JOIN
     tutores t ON p_t.tutor_id = t.id;


CREATE OR REPLACE FUNCTION fn_socios(_tiposocio_id INT)
    RETURNS TABLE
            (
                SOCIO_ID   INT,
                NOMBRES    VARCHAR(100),
                APELLIDOS  VARCHAR(100),
                TIPO_SOCIO VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN

    IF NOT EXISTS(SELECT * FROM tipos_socios WHERE id = _tiposocio_id) THEN
        RAISE EXCEPTION 'No hay socios de ese tipo "%".', _tiposocio_id;
    END IF;

    RETURN QUERY SELECT s.id,
                        s.nombres,
                        s.apellidos,
                        tp.descripcion
                 FROM socios s
                          INNER JOIN
                      tipos_socios tp ON s.tiposocio_id = tp.id
                 WHERE tp.id = _tiposocio_id;
END
$$;

CREATE OR REPLACE PROCEDURE sp_socios_insert(
    _tiposocio_id INT,
    _nombres VARCHAR(100),
    _apellidos VARCHAR(100),
    _celular VARCHAR(20),
    _correo VARCHAR(100),
    _dni VARCHAR(15))

    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN
    -- Validar DNI
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    -- Validar DNI repetido
    IF EXISTS(SELECT FROM tutores WHERE dni = _dni) THEN
        RAISE EXCEPTION 'DNI ya existe';
    END IF;

    -- Validar celular
    IF NOT (SELECT fn_validate_phone(_celular)) THEN
        RAISE EXCEPTION 'Celular no válido, debe tener el formato: +999999999, se permiten hasta 15 caracteres';
    END IF;

    IF NOT EXISTS(SELECT * FROM tipos_socios WHERE id = _tiposocio_id) THEN
        RAISE EXCEPTION 'No existe este tipo de socio.';
    END IF;
    IF _nombres IS NULL OR _nombres SIMILAR TO '' THEN
        RAISE EXCEPTION 'Los nombres de socio no pueden estar vacíos.';
    END IF;
    IF _apellidos IS NULL OR _apellidos SIMILAR TO '' THEN
        RAISE EXCEPTION 'Los apellidos de socio no pueden estar vacíos.';
    END IF;
    IF _celular IS NULL OR _celular SIMILAR TO '' THEN
        RAISE EXCEPTION 'Debe de ingresar un numero de celular.';
    END IF;
    IF _correo IS NULL OR _correo SIMILAR TO '' THEN
        RAISE EXCEPTION 'Debe de ingresar un correo electronico.';
    END IF;
    INSERT INTO public.socios (tiposocio_id, nombres, apellidos, celular, correo, dni)
    VALUES (_tiposocio_id, _nombres, _apellidos, _celular, _correo, _dni)
    RETURNING socios.id INTO _id_new;

    RAISE NOTICE 'Se ha ingresado el socios de "%" con éxito.',
            (SELECT descripcion FROM tipos_socios WHERE id = _tiposocio_id);
END
$$;


CREATE OR REPLACE PROCEDURE sp_socios_update(
    _id INT,
    _nombres VARCHAR(100),
    _apellidos VARCHAR(100),
    _celular VARCHAR(20),
    _correo VARCHAR(100),
    _dni VARCHAR(15))
    LANGUAGE plpgsql
AS
$$
BEGIN
    -- Validar DNI
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    -- Validar celular
    IF NOT (SELECT fn_validate_phone(_celular)) THEN
        RAISE EXCEPTION 'Celular no válido, debe tener el formato: +999999999, se permiten hasta 15 caracteres';
    END IF;

    UPDATE socios
    SET nombres   = _nombres,
        apellidos = _apellidos,
        celular   = _celular,
        correo    = _correo,
        dni       = _dni
    WHERE id = _id;

    RAISE NOTICE 'Socio actualizado con éxito';
END;
$$;


CREATE OR REPLACE PROCEDURE sp_socios_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _nombres   VARCHAR(100);
    _apellidos VARCHAR(100);
BEGIN

    _nombres = (SELECT nombres FROM socios WHERE id = _id);
    _apellidos = (SELECT apellidos FROM socios WHERE id = _id);

    IF NOT EXISTS(SELECT * FROM socios WHERE id = _id) THEN
        RAISE EXCEPTION 'La persona que ingreso no está afiliada al hospital.';
    END IF;

    DELETE
    FROM public.socios
    WHERE id = _id;

    RAISE NOTICE 'Se elimino exitosamente "% %" con id %.',_nombres, _apellidos, _id;
END
$$;



CREATE VIEW vw_socios
AS
SELECT socios.id,
       socios.nombres,
       socios.apellidos,
       socios.celular,
       socios.correo,
       socios.dni,
       socios.tiposocio_id
FROM socios;


CREATE OR REPLACE FUNCTION fn_tipos_socios(_id INT)
    RETURNS TABLE
            (
                TIPOS_SOCIOS_ID          INT,
                TIPOS_SOCIOS_DESCRIPCION VARCHAR(100)
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF NOT EXISTS(SELECT * FROM tipos_socios WHERE tipos_socios_id = _id) THEN

        RAISE NOTICE 'El tipo de socio no existe "%".', _id;
    END IF;
    RETURN QUERY SELECT tipos_socios.id,
                        tipos_socios.descripcion
                 FROM tipos_socios
                 WHERE tipos_socios.id = _id;
END;
$$;


CREATE PROCEDURE sp_tipos_socios_insert(_descripcion VARCHAR(100))
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_new INT;
BEGIN
    INSERT INTO public.tipos_socios(descripcion)
    VALUES (_descripcion);

    RAISE NOTICE 'Ingresado con éxito Tipos Socio: %',
            (SELECT descripcion FROM tipos_socios WHERE id = _id_new);
END
$$;


CREATE OR REPLACE PROCEDURE sp_tipos_socios_update(_id INT,
                                                   _descripcion VARCHAR(100))
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE public.tipos_socios
    SET descripcion = _descripcion
    WHERE id = _id;
    RAISE NOTICE 'Actualizado con éxito tipos socios: %',
            (SELECT descripcion FROM tipos_socios WHERE id = _id);
END
$$;


CREATE OR REPLACE PROCEDURE sp_tipos_socios_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE
    FROM public.tipos_socios
    WHERE id = _id;
    RAISE NOTICE 'Tipos socios eliminado con éxito';
END
$$;


CREATE OR REPLACE VIEW vw_tipos_socios
AS
SELECT tipos_socios.id,
       tipos_socios.descripcion
FROM tipos_socios;


CREATE OR REPLACE PROCEDURE sp_tutores_insert(
    _nombres VARCHAR,
    _apellidos VARCHAR,
    _dni VARCHAR,
    _celular VARCHAR,
    _direccion VARCHAR
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id_tutor INT;
BEGIN
    -- Validar DNI
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    -- Validar DNI repetido
    IF EXISTS(SELECT FROM tutores WHERE dni = _dni) THEN
        RAISE EXCEPTION 'DNI ya existe';
    END IF;

    -- Validar celular
    IF NOT (SELECT fn_validate_phone(_celular)) THEN
        RAISE EXCEPTION 'Celular no válido, debe tener el formato: +999999999, se permiten hasta 15 caracteres';
    END IF;

    -- Insertar tutor
    INSERT INTO tutores (nombres,
                         apellidos,
                         dni,
                         celular,
                         direccion)
    VALUES (_nombres,
            _apellidos,
            _dni,
            _celular,
            _direccion)

    RETURNING id INTO _id_tutor;

    -- Obtener id del tutor insertado
    RAISE NOTICE 'Tutor insertado con id: %', _id_tutor;
END;
$$;


CREATE OR REPLACE PROCEDURE sp_tutores_update(
    _id INT,
    _nombres VARCHAR,
    _apellidos VARCHAR,
    _dni VARCHAR,
    _celular VARCHAR,
    _direccion VARCHAR
)
    LANGUAGE plpgsql
AS
$$
BEGIN
    -- Validar DNI
    IF NOT (SELECT fn_validate_dni(_dni)) THEN
        RAISE EXCEPTION 'DNI no válido, debe tener el formato: 0000-0000-00000';
    END IF;

    -- Validar celular
    IF NOT (SELECT fn_validate_phone(_celular)) THEN
        RAISE EXCEPTION 'Celular no válido, debe tener el formato: +999999999, se permiten hasta 15 caracteres';
    END IF;

    -- Actualizar tutor
    UPDATE tutores
    SET nombres   = _nombres,
        apellidos = _apellidos,
        dni       = _dni,
        celular   = _celular,
        direccion = _direccion
    WHERE id = _id;

    RAISE NOTICE 'Tutor actualizado con éxito';
END;
$$;


CREATE OR REPLACE PROCEDURE sp_tutores_delete(_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM tutores WHERE id = _id;
    RAISE NOTICE 'Tutor eliminado con éxito';
END;
$$;


CREATE OR REPLACE VIEW vw_tutores
AS
SELECT t.id,
       t.nombres,
       t.apellidos,
       t.dni,
       t.celular,
       t.direccion
FROM tutores AS t;











