
CREATE DATABASE HospitalDB;

USE HospitalDB;

CREATE TABLE hospital(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    celular VARCHAR(20) NOT NULL
);

CREATE TABLE tipos_socios(
    id SERIAL PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL
);

CREATE TABLE socios(
    id SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    celular VARCHAR(20) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    tiposocio_id INT NOT NULL,
    FOREIGN KEY(tiposocio_id) REFERENCES tipos_socios(id)
);

CREATE TABLE hospital_socios(
    hospital_id INT NOT NULL,
    socio_id INT NOT NULL,
    PRIMARY KEY(hospital_id, socio_id),
    FOREIGN KEY(hospital_id) REFERENCES hospital(id),
    FOREIGN KEY(socio_id) REFERENCES socios(id)
);


CREATE TABLE departamentos(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edificio INT NOT NULL,
    descripcion VARCHAR(255),
    hospital_id INT,
    FOREIGN KEY(hospital_id) REFERENCES hospital(id)
);

CREATE TABLE empleados(
    id SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    dni VARCHAR(13) UNIQUE NOT NULL,
    correo VARCHAR(100) NOT NULL,
    celular VARCHAR(20) NOT NULL
);

CREATE TABLE departamentos_empleados(
    departamento_id INT NOT NULL,
    empleado_id INT NOT NULL,
    PRIMARY KEY(departamento_id, empleado_id),
    FOREIGN KEY(departamento_id) REFERENCES departamentos(id),
    FOREIGN KEY(empleado_id) REFERENCES empleados(id)
);

CREATE TABLE pacientes(
    id SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    genero VARCHAR(3) NOT NULL,
    dni VARCHAR(13) UNIQUE NOT NULL,
    direccion VARCHAR(170) NOT NULL,
    departamento_id INT NOT NULL,
    FOREIGN KEY(departamento_id) REFERENCES departamentos(id),
    empleado_id INT NOT NULL,
    FOREIGN KEY(empleado_id) REFERENCES empleados(id),
    estado VARCHAR(30) NOT NULL,
    fecha_ingreso DATE,
    fecha_salida DATE,
    sangre_tipo VARCHAR(4)
);

CREATE TABLE tutores(
    id SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    dni VARCHAR(13) UNIQUE NOT NULL,
    celular VARCHAR(20) NOT NULL,
    parentesco VARCHAR(20) NOT NULL,
    direccion VARCHAR(170) NOT NULL
);

CREATE TABLE pacientes_tutores(
    paciente_id INT NOT NULL,
    tutor_id INT NOT NULL,
    PRIMARY KEY(paciente_id, tutor_id),
    FOREIGN KEY(paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY(tutor_id) REFERENCES tutores(id)
);
