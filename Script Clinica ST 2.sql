-- Crear la base de datos
CREATE DATABASE Clinica;
USE Clinica;

-- Tabla ESTADO
CREATE TABLE ESTADO (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    tipo_entidad ENUM('Persona', 'Paciente', 'Profesional', 'HorarioDisponible', 'Turno', 'Usuario', 'Especialidad', 'Monto') NOT NULL
);

-- Tabla ROL
CREATE TABLE ROL (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(200),
    CONSTRAINT chk_rol_nombre CHECK (nombre IN ('paciente', 'profesional de la salud', 'administrador'))
);

-- Tabla ESPECIALIDAD
CREATE TABLE ESPECIALIDAD (
    id_especialidad INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(100),
    estado INT NOT NULL,    
    FOREIGN KEY (estado) REFERENCES ESTADO(id_estado)
);

-- Tabla PERSONA
CREATE TABLE PERSONA (
    id_persona INT AUTO_INCREMENT PRIMARY KEY, 
    dni VARCHAR(20) NOT NULL UNIQUE, 
    nombre VARCHAR(50) NOT NULL, 
    apellido VARCHAR(50) NOT NULL, 
    email VARCHAR(100) NOT NULL UNIQUE, 
    telefono VARCHAR(20), 
    direccion VARCHAR(255), 
    id_rol INT,
    id_especialidad INT,    
    estado INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    
    ultima_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,    
    FOREIGN KEY (id_rol) REFERENCES ROL(id_rol),    
    FOREIGN KEY (id_especialidad) REFERENCES ESPECIALIDAD(id_especialidad),
    FOREIGN KEY (estado) REFERENCES ESTADO(id_estado)
);

-- Tabla PACIENTE
CREATE TABLE PACIENTE (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL UNIQUE,
    obra_social VARCHAR(100),
    estado INT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES PERSONA(id_persona),
    FOREIGN KEY (estado) REFERENCES ESTADO(id_estado)
);

-- Tabla PROFESIONAL
CREATE TABLE PROFESIONAL (
    id_profesional INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL UNIQUE,
    matricula_profesional VARCHAR(50),
    estado INT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES PERSONA(id_persona),
    FOREIGN KEY (estado) REFERENCES ESTADO(id_estado)
);

-- Tabla USUARIO
CREATE TABLE USUARIO (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(100) NOT NULL,
    id_persona INT,
    estado INT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES PERSONA(id_persona),
    FOREIGN KEY (estado) REFERENCES ESTADO(id_estado)
);

-- Tabla HORARIO_DISPONIBLE
CREATE TABLE HORARIO_DISPONIBLE (    
    id_horario INT AUTO_INCREMENT PRIMARY KEY,    
    id_profesional INT,    
    dia_semana ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo') NOT NULL,    
    hora_inicio TIME NOT NULL,   
    hora_fin TIME NOT NULL,    
    estado INT NOT NULL,
    FOREIGN KEY (id_profesional) REFERENCES PERSONA(id_persona),
    FOREIGN KEY (estado) REFERENCES ESTADO(id_estado)
);

-- Tabla TURNO
CREATE TABLE TURNO (    
    id_turno INT AUTO_INCREMENT PRIMARY KEY,    
    id_paciente INT,    
    id_profesional INT,    
    fecha_hora DATETIME NOT NULL,    
    duracion INT NOT NULL,    
    estado INT NOT NULL,
    observaciones TEXT,    
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES PERSONA(id_persona),
    FOREIGN KEY (id_profesional) REFERENCES PERSONA(id_persona),
    FOREIGN KEY (estado) REFERENCES ESTADO(id_estado)
);

-- Tabla HISTORIAL_ESTADO_TURNO
CREATE TABLE HISTORIAL_ESTADO_TURNO (    
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_turno INT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_anterior INT NOT NULL,
    estado_nuevo INT NOT NULL,
    observacion TEXT,
    FOREIGN KEY (id_turno) REFERENCES TURNO(id_turno),
    FOREIGN KEY (estado_anterior) REFERENCES ESTADO(id_estado),
    FOREIGN KEY (estado_nuevo) REFERENCES ESTADO(id_estado)
);

-- Tabla MONTO
CREATE TABLE MONTO (
    id_monto INT AUTO_INCREMENT PRIMARY KEY,
    id_turno INT,
    fecha_pago DATE,
    monto DECIMAL(10,2) NOT NULL,
    estado INT NOT NULL,
    FOREIGN KEY (id_turno) REFERENCES TURNO(id_turno),
    FOREIGN KEY (estado) REFERENCES ESTADO(id_estado)
);

DROP DATABASE Clinica;

