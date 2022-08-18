-------------------------------------- Database Creation --------------------------------------

DO
$do$
    BEGIN
        IF NOT EXISTS(SELECT datname FROM pg_database WHERE datname = 'hospital_db') THEN
            CREATE DATABASE hospital_db;
        END IF;
    END
$do$;

------------------------------------ A N D R E A  ------------------------------------
-------------------------------------- hospital --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'hospitales'
            ) THEN
            DROP TABLE hospitales CASCADE;
        END IF;

        CREATE TABLE hospitales
        (
            id        SERIAL PRIMARY KEY,
            nombre    VARCHAR(100) NOT NULL,
            direccion VARCHAR(100) NOT NULL,
            celular   VARCHAR(20)  NOT NULL
        );
    END
$do$;

-------------------------------------- tipos_socios --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'tipos_socios'
            ) THEN
            DROP TABLE tipos_socios CASCADE;
        END IF;

        CREATE TABLE tipos_socios
        (
            id          SERIAL PRIMARY KEY,
            descripcion VARCHAR(100) NOT NULL
        );
    END
$do$;

-------------------------------------- socios --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'socios'
            ) THEN
            DROP TABLE socios CASCADE;
        END IF;

        CREATE TABLE socios
        (
            id           SERIAL PRIMARY KEY,
            nombres      VARCHAR(100) NOT NULL,
            apellidos    VARCHAR(100) NOT NULL,
            dni          VARCHAR(15) UNIQUE NOT NULL,
            celular      VARCHAR(20)  NOT NULL,
            correo       VARCHAR(100) NOT NULL,
            tiposocio_id INT          NOT NULL,
            FOREIGN KEY (tiposocio_id) REFERENCES tipos_socios (id) ON DELETE RESTRICT
        );
    END
$do$;

-------------------------------------- hospitales_socios --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'hospitales_socios'
            ) THEN
            DROP TABLE hospitales_socios CASCADE;
        END IF;

        CREATE TABLE hospitales_socios
        (
            hospital_id INT NOT NULL,
            socio_id    INT NOT NULL,
            PRIMARY KEY (hospital_id, socio_id),
            FOREIGN KEY (hospital_id) REFERENCES hospitales (id) ON DELETE CASCADE,
            FOREIGN KEY (socio_id) REFERENCES socios (id) ON DELETE CASCADE
        );
    END
$do$;

------------------------------------      S A R Y     -------------------------------------
-------------------------------------- departamentos --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'departamentos'
            ) THEN
            DROP TABLE departamentos CASCADE;
        END IF;

        CREATE TABLE departamentos
        (
            id          SERIAL PRIMARY KEY,
            nombre      VARCHAR(100) NOT NULL,
            edificio    INT          NOT NULL,
            descripcion VARCHAR(255),
            hospital_id INT,
            FOREIGN KEY (hospital_id) REFERENCES hospitales (id) ON DELETE RESTRICT
        );
    END
$do$;

-------------------------------------- ocupaciones --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'ocupaciones'
            ) THEN
            DROP TABLE ocupaciones CASCADE;
        END IF;

        CREATE TABLE ocupaciones
        (
            id          SERIAL PRIMARY KEY,
            descripcion VARCHAR(100) NOT NULL
        );
    END
$do$;

-------------------------------------- empleados --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'empleados'
            ) THEN
            DROP TABLE empleados CASCADE;
        END IF;

        CREATE TABLE empleados
        (
            id           SERIAL PRIMARY KEY,
            nombres      VARCHAR(100)       NOT NULL,
            apellidos    VARCHAR(100)       NOT NULL,
            ocupacion_id INT                NOT NULL,
            FOREIGN KEY (ocupacion_id) REFERENCES ocupaciones (id) ON DELETE RESTRICT,
            dni          VARCHAR(15) UNIQUE NOT NULL,
            correo       VARCHAR(100)       NOT NULL,
            celular      VARCHAR(20)        NOT NULL
        );
    END
$do$;

-------------------------------------- departamentos_empleados --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'departamentos_empleados'
            ) THEN
            DROP TABLE departamentos_empleados CASCADE;
        END IF;

        CREATE TABLE departamentos_empleados
        (
            departamento_id INT NOT NULL,
            empleado_id     INT NOT NULL,
            PRIMARY KEY (departamento_id, empleado_id),
            FOREIGN KEY (departamento_id) REFERENCES departamentos (id) ON DELETE CASCADE,
            FOREIGN KEY (empleado_id) REFERENCES empleados (id) ON DELETE CASCADE
        );
    END
$do$;

---------------------------------     C A R L O S     ---------------------------------
-------------------------------------- pacientes --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'pacientes'
            ) THEN
            DROP TABLE pacientes CASCADE;
        END IF;

        CREATE TABLE pacientes
        (
            id               SERIAL PRIMARY KEY,
            nombres          VARCHAR(100)       NOT NULL,
            apellidos        VARCHAR(100)       NOT NULL,
            genero           VARCHAR(3)         NOT NULL,
            fecha_nacimiento DATE               NOT NULL,
            dni              VARCHAR(15) UNIQUE NOT NULL,
            direccion        VARCHAR(170)       NOT NULL,
            departamento_id  INT                NULL,
            FOREIGN KEY (departamento_id) REFERENCES departamentos (id) ON DELETE SET NULL,
            estado           VARCHAR(30)        NOT NULL,
            tipo_sangre      VARCHAR(4)         NOT NULL
        );
    END
$do$;

-------------------------------- pacientes_empleados --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'pacientes_empleados'
            ) THEN
            DROP TABLE pacientes_empleados CASCADE;
        END IF;

        CREATE TABLE pacientes_empleados
        (
            paciente_id INT NOT NULL,
            empleado_id     INT NOT NULL,
            PRIMARY KEY (paciente_id, empleado_id),
            FOREIGN KEY (paciente_id) REFERENCES pacientes (id) ON DELETE CASCADE,
            FOREIGN KEY (empleado_id) REFERENCES empleados (id) ON DELETE CASCADE
        );
    END
$do$;


-------------------------------------- diagnosticos --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'diagnosticos'
            ) THEN
            DROP TABLE diagnosticos CASCADE;
        END IF;

        CREATE TABLE diagnosticos
        (
            id            SERIAL PRIMARY KEY,
            paciente_id   INT  NOT NULL,
            FOREIGN KEY (paciente_id) REFERENCES pacientes (id) ON DELETE CASCADE,
            fecha_ingreso DATE NOT NULL,
            fecha_salida  DATE NULL,
            resumen       TEXT,
            razon_ingreso TEXT NOT NULL,
            fecha         DATE NOT NULL
        );
    END
$do$;

-------------------------------------- tutores --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'tutores'
            ) THEN
            DROP TABLE tutores CASCADE;
        END IF;

        CREATE TABLE tutores
        (
            id        SERIAL PRIMARY KEY,
            nombres   VARCHAR(100)       NOT NULL,
            apellidos VARCHAR(100)       NOT NULL,
            dni       VARCHAR(15) UNIQUE NOT NULL,
            celular   VARCHAR(20)        NOT NULL,
            direccion VARCHAR(170)       NOT NULL
        );
    END
$do$;

-------------------------------------- pacientes_tutores ----------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'pacientes_tutores'
            ) THEN
            DROP TABLE pacientes_tutores CASCADE;
        END IF;

        CREATE TABLE pacientes_tutores
        (
            paciente_id INT         NOT NULL,
            tutor_id    INT         NOT NULL,
            parentesco  VARCHAR(20) NOT NULL,
            PRIMARY KEY (paciente_id, tutor_id),
            FOREIGN KEY (paciente_id) REFERENCES pacientes (id) ON DELETE CASCADE,
            FOREIGN KEY (tutor_id) REFERENCES tutores (id) ON DELETE CASCADE
        );
    END
$do$;


---------------------------------    E M I L Z O N     -------------------------------
-------------------------------------- usuarios --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'usuarios'
            ) THEN
            DROP TABLE usuarios CASCADE;
        END IF;

        CREATE TABLE usuarios
        (
            id        SERIAL PRIMARY KEY,
            nombres   VARCHAR(100)       NOT NULL,
            apellidos VARCHAR(100)       NOT NULL,
            dni       VARCHAR(15) UNIQUE NOT NULL,
            celular   VARCHAR(20)        NOT NULL,
            direccion VARCHAR(170)       NOT NULL
        );
    END
$do$;


-------------------------------------- roles --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'roles'
            ) THEN
            DROP TABLE roles CASCADE;
        END IF;

        CREATE TABLE roles
        (
            id          SERIAL PRIMARY KEY,
            nombre      VARCHAR(100) NOT NULL,
            descripcion VARCHAR(255) NOT NULL
        );
    END
$do$;

-------------------------------------- permisos --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'permisos'
            ) THEN
            DROP TABLE permisos CASCADE;
        END IF;

        CREATE TABLE permisos
        (
            id          SERIAL PRIMARY KEY,
            nombre      VARCHAR(100) NOT NULL,
            descripcion VARCHAR(255) NOT NULL,
            seccion     VARCHAR(30)  NOT NULL
        );
    END
$do$;

-------------------------------------- usuarios_roles --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'usuarios_roles'
            ) THEN
            DROP TABLE usuarios_roles CASCADE;
        END IF;

        CREATE TABLE usuarios_roles
        (
            usuario_id INT NOT NULL,
            rol_id     INT NOT NULL,
            PRIMARY KEY (usuario_id, rol_id),
            FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE,
            FOREIGN KEY (rol_id) REFERENCES roles (id) ON DELETE CASCADE
        );
    END
$do$;


-------------------------------------- roles_permisos  --------------------------------------
DO
$do$
    BEGIN
        IF EXISTS(
                SELECT
                FROM pg_tables
                WHERE schemaname = 'public'
                  AND tablename = 'roles_permisos'
            ) THEN
            DROP TABLE roles_permisos CASCADE;
        END IF;

        CREATE TABLE roles_permisos
        (
            rol_id     INT NOT NULL,
            permiso_id INT NOT NULL,
            PRIMARY KEY (rol_id, permiso_id),
            FOREIGN KEY (rol_id) REFERENCES roles (id) ON DELETE CASCADE,
            FOREIGN KEY (permiso_id) REFERENCES permisos (id) ON DELETE CASCADE
        );
    END
$do$;

