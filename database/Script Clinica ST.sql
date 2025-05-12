CREATE DATABASE Clinica;
USE Clinica;

-- TABLA ROL
CREATE TABLE ROL (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(200),
    CONSTRAINT chk_rol_nombre CHECK (nombre IN ('paciente', 'profesional de la salud', 'administrador'))
);

-- TABLA ESPECIALIDAD
CREATE TABLE ESPECIALIDAD (
    id_especialidad INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(100),
    activo TINYINT
);

-- TABLA PERSONA
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
    activo INT NOT NULL,    
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    
    ultima_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,    
    FOREIGN KEY (id_rol) REFERENCES ROL(id_rol),    
    FOREIGN KEY (id_especialidad) REFERENCES ESPECIALIDAD(id_especialidad)
);

-- TABLA USUARIO
CREATE TABLE USUARIO (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(100) NOT NULL,
    id_persona INT,
    FOREIGN KEY (id_persona) REFERENCES PERSONA(id_persona)
);

-- TABLA HORARIO_DISPONIBLE
CREATE TABLE HORARIO_DISPONIBLE (    
    id_horario INT AUTO_INCREMENT PRIMARY KEY,    
    id_profesional INT,    
    dia_semana ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo') NOT NULL,    
    hora_inicio TIME NOT NULL,   
    hora_fin TIME NOT NULL,    
    activo INT NOT NULL,    
    FOREIGN KEY (id_profesional) REFERENCES PERSONA(id_persona)
);
 
-- TABLA TURNO
CREATE TABLE TURNO (    
    id_turno INT AUTO_INCREMENT PRIMARY KEY,    
    id_paciente INT,    
    id_profesional INT,    
    fecha_hora DATETIME NOT NULL,    
    duracion INT NOT NULL,    
    estado ENUM('Pendiente', 'Confirmado', 'Cancelado', 'Atendido') NOT NULL,   
    observaciones TEXT,    
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES PERSONA(id_persona),
    FOREIGN KEY (id_profesional) REFERENCES PERSONA(id_persona)
);

-- TABLA HISTORIAL_ESTADO_TURNO
CREATE TABLE HISTORIAL_ESTADO_TURNO (    
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_turno INT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_anterior ENUM('Pendiente', 'Confirmado', 'Cancelado', 'Atendido') NOT NULL,
    estado_nuevo ENUM('Pendiente', 'Confirmado', 'Cancelado', 'Atendido') NOT NULL,
    observacion TEXT,
    FOREIGN KEY (id_turno) REFERENCES TURNO(id_turno)
);

-- TABLA MONTO
CREATE TABLE MONTO (
    id_monto INT AUTO_INCREMENT PRIMARY KEY,
    id_turno INT,
    fecha_turno DATETIME NOT NULL,
    fecha_pago DATE,
    monto DECIMAL(10,2) NOT NULL,
    id_especialidad INT,
    id_doctor INT,
    FOREIGN KEY (id_turno) REFERENCES TURNO(id_turno),
    FOREIGN KEY (id_especialidad) REFERENCES ESPECIALIDAD(id_especialidad),
    FOREIGN KEY (id_doctor) REFERENCES PERSONA(id_persona)
);

-- 1. Insertar roles
INSERT INTO ROL (nombre, descripcion) VALUES
('paciente', 'Paciente de la clínica'),
('profesional de la salud', 'Médico o profesional que atiende pacientes'),
('administrador', 'Personal administrativo o secretaria');

-- 2. Insertar especialidades
INSERT INTO ESPECIALIDAD (nombre, descripcion, activo) VALUES
('Pediatra', 'Especialista en niños', 1),
('Ginecólogo', 'Especialista en salud femenina', 1),
('Clínico General', 'Medicina general', 1),
('Cardiólogo', 'Especialista en corazón', 1);

-- 3. Insertar pacientes
INSERT INTO PERSONA (dni, nombre, apellido, email, telefono, direccion, id_rol, activo)
VALUES
('10000001', 'Ana', 'Gómez', 'ana.gomez@gmail.com', '123456789', 'Calle 1', 1, 1),
('10000002', 'Bruno', 'López', 'bruno.lopez@gmail.com', '123456790', 'Calle 2', 1, 1),
('10000003', 'Carla', 'Martínez', 'carla.martinez@gmail.com', '123456791', 'Calle 3', 1, 1),
('10000004', 'Diego', 'Pérez', 'diego.perez@gmail.com', '123456792', 'Calle 4', 1, 1),
('10000005', 'Elena', 'Ruiz', 'elena.ruiz@gmail.com', '123456793', 'Calle 5', 1, 1),
('10000006', 'Federico', 'Sosa', 'federico.sosa@gmail.com', '123456794', 'Calle 6', 1, 1),
('10000007', 'Gabriela', 'Torres', 'gabriela.torres@gmail.com', '123456795', 'Calle 7', 1, 1),
('10000008', 'Hugo', 'Vega', 'hugo.vega@gmail.com', '123456796', 'Calle 8', 1, 1),
('10000009', 'Isabel', 'Zárate', 'isabel.zarate@gmail.com', '123456797', 'Calle 9', 1, 1),
('10000010', 'Julián', 'Alonso', 'julian.alonso@gmail.com', '123456798', 'Calle 10', 1, 1);

-- 4. Insertar doctores (2 por especialidad)
-- Pediatras
INSERT INTO PERSONA (dni, nombre, apellido, email, telefono, direccion, id_rol, id_especialidad, activo)
VALUES
('20000001', 'Laura', 'Méndez', 'laura.mendez@clinic.com', '987654321', 'Av. Pediatras 1', 2, 1, 1),
('20000002', 'Carlos', 'Ibarra', 'carlos.ibarra@clinic.com', '987654322', 'Av. Pediatras 2', 2, 1, 1);

-- Ginecólogos
INSERT INTO PERSONA (dni, nombre, apellido, email, telefono, direccion, id_rol, id_especialidad, activo)
VALUES
('20000003', 'Silvia', 'Nuñez', 'silvia.nunez@clinic.com', '987654323', 'Av. Ginecólogos 1', 2, 2, 1),
('20000004', 'Raúl', 'Ferrer', 'raul.ferrer@clinic.com', '987654324', 'Av. Ginecólogos 2', 2, 2, 1);

-- Clínicos Generales
INSERT INTO PERSONA (dni, nombre, apellido, email, telefono, direccion, id_rol, id_especialidad, activo)
VALUES
('20000005', 'María', 'Suárez', 'maria.suarez@clinic.com', '987654325', 'Av. Clínicos 1', 2, 3, 1),
('20000006', 'José', 'Ortiz', 'jose.ortiz@clinic.com', '987654326', 'Av. Clínicos 2', 2, 3, 1);

-- Cardiólogos
INSERT INTO PERSONA (dni, nombre, apellido, email, telefono, direccion, id_rol, id_especialidad, activo)
VALUES
('20000007', 'Patricia', 'Campos', 'patricia.campos@clinic.com', '987654327', 'Av. Cardiólogos 1', 2, 4, 1),
('20000008', 'Luis', 'Morales', 'luis.morales@clinic.com', '987654328', 'Av. Cardiólogos 2', 2, 4, 1);

-- 5. Insertar secretarias
INSERT INTO PERSONA (dni, nombre, apellido, email, telefono, direccion, id_rol, activo)
VALUES
('30000001', 'Marta', 'Sánchez', 'marta.sanchez@clinic.com', '555111111', 'Recepción 1', 3, 1),
('30000002', 'Rosa', 'Bianchi', 'rosa.bianchi@clinic.com', '555111112', 'Recepción 2', 3, 1),
('30000003', 'Esteban', 'Carrizo', 'esteban.carrizo@clinic.com', '555111113', 'Recepción 3', 3, 1);


INSERT INTO USUARIO (nombre_usuario, contrasena, id_persona) VALUES
('marta_sec', 'clave123', 19),
('rosa_sec', 'clave123', 20),
('esteban_sec', 'clave123', 21);


-- Doctores (pueden solo visualizar)
INSERT INTO USUARIO (nombre_usuario, contrasena, id_persona) VALUES
('laura_doc', 'clave123', 11),  -- Laura Méndez (Pediatra)
('carlos_doc', 'clave123', 12); -- Carlos Ibarra (Pediatra)

-- HORARIO_DISPONIBLE
INSERT INTO HORARIO_DISPONIBLE (id_profesional, dia_semana, hora_inicio, hora_fin, activo) VALUES
(11, 'Lunes', '08:00:00', '12:00:00', TRUE),
(12, 'Martes', '09:00:00', '13:00:00', TRUE),
(13, 'Miércoles', '10:00:00', '14:00:00', TRUE),
(14, 'Jueves', '08:30:00', '12:30:00', TRUE),
(15, 'Viernes', '07:00:00', '11:00:00', TRUE);

-- TURNO
INSERT INTO TURNO (id_paciente, id_profesional, fecha_hora, duracion, estado, observaciones) VALUES
(1, 11, '2025-05-10 10:00:00', 30, 'Confirmado', 'Consulta pediátrica'),
(2, 12, '2025-05-11 09:30:00', 30, 'Pendiente', ''),
(3, 13, '2025-05-12 11:00:00', 30, 'Pendiente', 'Chequeo general');

-- MONTO
INSERT INTO MONTO (id_turno, fecha_turno, fecha_pago, monto, id_especialidad, id_doctor) VALUES
(1, '2025-05-10 10:00:00', '2025-05-10', 2500.00, 1, 11),
(2, '2025-05-11 09:30:00', NULL, 2500.00, 1, 12),
(3, '2025-05-12 11:00:00', NULL, 3000.00, 3, 13);

-- HISTORIAL_ESTADO_TURNO
INSERT INTO HISTORIAL_ESTADO_TURNO (id_turno, estado_anterior, estado_nuevo, observacion)
VALUES 
(1, 'Pendiente', 'Confirmado', 'Turno confirmado por secretaria.'),
(1, 'Confirmado', 'Atendido', 'Paciente atendido sin novedades.'),
(2, 'Pendiente', 'Cancelado', 'Paciente no pudo asistir.'),
(3, 'Pendiente', 'Confirmado', 'Confirmación automática por sistema.'),
(2, 'Pendiente', 'Confirmado', 'Confirmado telefónicamente.'),
(2, 'Confirmado', 'Cancelado', 'Doctor ausente por urgencia.'),
(3, 'Confirmado', 'Atendido', 'Consulta completada.'),
(2, 'Cancelado', 'Pendiente', 'Turno reprogramado.'),
(2, 'Pendiente', 'Confirmado', 'Reconfirmado por paciente.'),
(2, 'Confirmado', 'Atendido', 'Paciente fue atendido finalmente.');

DROP DATABASE Clinica;