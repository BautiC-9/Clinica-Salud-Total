DROP DATABASE IF EXISTS clinica;

CREATE DATABASE clinica;
USE clinica;

-- Tabla entidad
CREATE TABLE entidad (
    id_entidad BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);
INSERT INTO entidad (nombre, descripcion) VALUES
('Persona', 'Estados aplicables a registros de la tabla Persona'),
('Paciente', 'Estados aplicables a registros de la tabla Paciente'),
('Profesional', 'Estados aplicables a registros de la tabla Profesional'),
('Horario_Disponible', 'Estados aplicables a los horarios disponibles'),
('Turno', 'Estados aplicables a la tabla Turno'),
('Usuario', 'Estados aplicables a los usuarios del sistema'),
('Especialidad', 'Estados aplicables a las especialidades médicas'),
('Monto', 'Estados aplicables a pagos y facturaciones'),
('Consulta_Web', 'Estados aplicables a consultas web'),
('Asistencia_Turno', 'Estados aplicables al registro de asistencia'),
('Estado', 'Entidad que representa los distintos estados del sistema'),
('Historial_Estado_Turno', 'Historial de cambios de estado en los turnos'),
('Rol', 'Estados aplicables a los distintos roles del sistema'),
('Paciente_Tutor', 'Relación entre pacientes y tutores'),
('Tutor', 'Estados aplicables a la entidad Tutor');

-- Tabla estado
CREATE TABLE estado (
    id_estado BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    id_entidad BIGINT NOT NULL,
    FOREIGN KEY (id_entidad) REFERENCES entidad(id_entidad)
);
INSERT INTO estado (nombre, descripcion, id_entidad) VALUES
('Activo', 'Estado activo de la entidad', 1), -- Persona
('Inactivo', 'Entidad actualmente deshabilitada', 1),
('Activo', 'Paciente habilitado para sacar turnos', 2),
('Inactivo', 'Paciente con su acceso deshabilitado', 2),
('Disponible', 'Profesional activo con agenda abierta', 3),
('No Disponible', 'Profesional sin agenda activa', 3),
('Disponible', 'Horario disponible para asignar turnos', 4),
('No Disponible', 'Horario bloqueado o fuera de servicio', 4),
('Confirmado', 'Turno confirmado por el paciente', 5),
('Programado', 'Turno asignado y pendiente de atención', 5),
('Cancelado', 'Turno que fue cancelado por el paciente o profesional', 5),
('Reprogramado', 'Turno que fue re-agendado para otra fecha', 5),
('Atendido', 'Turno atendido por profesional', 5),
('Pendiente', 'Usuario pendiente de validación', 6),
('Activo', 'Usuario con acceso completo al sistema', 6),
('Inactivo', 'Usuario sin acceso al sistema', 6),
('Disponible', 'Especialidad que se encuentra habilitada', 7),
('Suspendida', 'Especialidad que no se ofrece temporalmente', 7),
('Registrado', 'Monto registrado correctamente en el sistema', 8),
('Anulado', 'Monto cancelado o revertido por error', 8),
('Abierto', 'Consulta web pendiente de ser respondida', 9),
('Cerrado', 'Consulta web ya fue respondida y cerrada', 9),
('Asistió', 'Paciente se presentó al turno', 10),
('No Asistió', 'Paciente no se presentó al turno', 10);

-- Tabla rol
CREATE TABLE rol (
    id_rol BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(200),
    CONSTRAINT chk_rol_nombre CHECK (nombre IN ('administrador', 'secretaria', 'profesional', 'paciente', 'tutor'))
);
INSERT INTO rol (nombre, descripcion) VALUES
('administrador', 'Acceso completo al sistema'),
('secretaria', 'Gestión de turnos y pacientes'),
('profesional', 'Consulta y atención de turnos'),
('paciente', 'Acceso a turnos desde la web'),
('tutor', 'Acceso limitado para tutor de pacientes menores');

-- Tabla especialidad
CREATE TABLE especialidad (
    id_especialidad BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    id_estado BIGINT,
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO especialidad (nombre, descripcion, id_estado) VALUES
('Clínica General', 'Atención médica general para adultos.', 1),
('Pediatría', 'Atención médica para niños y adolescentes.', 1),
('Cardiología', 'Diagnóstico y tratamiento de enfermedades del corazón.', 1),
('Ginecología', 'Atención de salud femenina y control ginecológico.', 1);

-- Tabla persona
CREATE TABLE persona (
    id_persona BIGINT AUTO_INCREMENT PRIMARY KEY, 
    dni VARCHAR(20) NOT NULL UNIQUE, 
    nombre VARCHAR(50) NOT NULL, 
    apellido VARCHAR(50) NOT NULL, 
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20), 
    direccion VARCHAR(255), 
    id_rol BIGINT,
    id_especialidad BIGINT,    
    id_estado BIGINT NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    edad INT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    
    ultima_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,    

    FOREIGN KEY (id_rol) REFERENCES rol(id_rol),    
    FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);

INSERT INTO persona (
    dni, nombre, apellido, email, telefono, direccion, 
    id_rol, id_especialidad, id_estado, fecha_nacimiento
)
VALUES
-- 1. ADMINISTRADOR
('28999111', 'Carlos', 'Pérez', 'carlos.perez@mail.com', '3624001122', 'Calle Falsa 456', 1, NULL, 1, '1985-08-22'),
-- 2. SECRETARIA
('31455678', 'Valeria', 'López', 'valeria.lopez@mail.com', '3624113344', 'Mitre 789', 2, NULL, 1, '1992-03-30'),
-- 3. ESPECIALISTAS
('27654321', 'Miguel', 'Fernández', 'miguel.fernandez@mail.com', '3624332211', 'Belgrano 150', 3, 1, 1, '1980-12-05'),
('30887766', 'Paula', 'Martínez', 'paula.martinez@mail.com', '3624556677', 'Urquiza 1020', 3, 2, 1, '1995-07-19'),
('29550123', 'Diego', 'Ramírez', 'diego.ramirez@mail.com', '3624998877', 'España 99', 3, 4, 1, '1998-01-11'),
('11111111', 'Carlos', 'Gómez', 'carlos.gomez@clinica.com', '1234567890', 'Calle 1', 3, 1, 1, '1980-01-01'),
('22222222', 'Laura', 'Martínez', 'laura.martinez@clinica.com', '1234567891', 'Calle 2', 3, 1, 1, '1975-05-10'),
('33333333', 'Luis', 'Pérez', 'luis.perez@clinica.com', '1234567892', 'Calle 3', 3, 2, 1, '1982-02-02'),
('44444444', 'Ana', 'Rivas', 'ana.rivas@clinica.com', '1234567893', 'Calle 4', 3, 2, 1, '1985-03-03'),
('55555555', 'José', 'Fernández', 'jose.fernandez@clinica.com', '1234567894', 'Calle 5', 3, 3, 1, '1970-04-04'),
('66666666', 'Marta', 'López', 'marta.lopez@clinica.com', '1234567895', 'Calle 6', 3, 3, 1, '1988-05-05'),
('77777777', 'Diego', 'Sosa', 'diego.sosa@clinica.com', '1234567896', 'Calle 7', 3, 4, 1, '1981-06-06'),
('88888888', 'Lucía', 'García', 'lucia.garcia@clinica.com', '1234567897', 'Calle 8', 3, 4, 1, '1978-07-07'),
-- 4. PACIENTES
('49111222', 'Tomás', 'Pérez', 'tomas.perez@example.com', '1133445566', 'Av. Siempre Viva 742', 4, NULL, 1, '2012-08-20'),
('99900001', 'Pedro', 'Ramírez', 'pedro.ramirez@mail.com', '3410000001', 'Calle 10', 4, NULL, 1, '2000-01-01'),
('99900002', 'Julieta', 'Suárez', 'julieta.suarez@mail.com', '3410000002', 'Calle 11', 4, NULL, 1, '1998-02-02'),
('99900003', 'Martín', 'Bravo', 'martin.bravo@mail.com', '3410000003', 'Calle 12', 4, NULL, 1, '2002-03-03'),
('99900004', 'Soledad', 'Mendoza', 'soledad.mendoza@mail.com', '3410000004', 'Calle 13', 4, NULL, 1, '1995-04-04'),
('99900005', 'Gustavo', 'Ibáñez', 'gustavo.ibanez@mail.com', '3410000005', 'Calle 14', 4, NULL, 1, '2001-05-05'),
('99900006', 'Florencia', 'Bianchi', 'florencia.bianchi@mail.com', '3410000006', 'Calle 15', 4, NULL, 1, '1999-06-06');

-- Tabla tutor
CREATE TABLE tutor (
    id_tutor BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_persona BIGINT NOT NULL UNIQUE,
    parentesco VARCHAR(100),
    id_estado BIGINT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO tutor (id_persona, parentesco, id_estado)
VALUES (8, 'Madre', 1);

-- Tabla paciente
CREATE TABLE paciente (
    id_paciente BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_persona BIGINT NOT NULL UNIQUE,
    obra_social VARCHAR(100),
    id_estado BIGINT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO paciente (id_persona, obra_social, id_estado)
VALUES
(14, 'Osde', 1),
(15, 'Osde', 1),
(16, 'Osde', 1),
(17, 'Swiss Medical', 1), 
(18, 'Swiss Medical', 1), 
(19, 'Osde', 1), 
(20, 'Swiss Medical', 1);

-- Tabla paciente_tutor
CREATE TABLE paciente_tutor (
    id_paciente BIGINT NOT NULL,
    id_tutor BIGINT NOT NULL,
    PRIMARY KEY (id_paciente, id_tutor),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_tutor) REFERENCES tutor(id_tutor)
);
INSERT INTO paciente_tutor (id_paciente, id_tutor)
VALUES (3, 1);

-- Tabla profesional
CREATE TABLE profesional (
    id_profesional BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_persona BIGINT NOT NULL UNIQUE,
	id_especialidad BIGINT NOT NULL,
    matricula_profesional VARCHAR(50),
    id_estado BIGINT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona),
    FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO profesional (id_persona, id_especialidad, matricula_profesional, id_estado)
VALUES
(3, 2, 'M12345', 1),
(4, 3, 'M67890', 1),
(5, 4, 'M8394', 1),
(6, 1, 'M11111', 1),  
(7, 1, 'M22222', 1),  
(8, 2, 'M33333', 1),  
(9, 2, 'M44444', 1), 
(10, 3, 'M55555', 1), 
(11, 3, 'M66666', 1), 
(12, 4, 'M77777', 1),
(13, 4, 'M88888', 1); 

-- Tabla usuario
CREATE TABLE usuario (
    id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(100) NOT NULL,
    id_persona BIGINT,
    id_estado BIGINT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO usuario (nombre_usuario, contrasena, id_persona, id_estado)
VALUES
('admin', 'admin123', 1, 1), 
('secretaria1', 'secretaria123', 2, 1),
('especialista1', 'especialista123', 3, 1),
('paciente1', 'paciente123', 14, 1),
-- especialistas
('cardio1', '1234', 3, 1),
('cardio2', '1234', 4, 1),
('pedia1', '1234', 5, 1),
('pedia2', '1234', 6, 1),
('clinico1', '1234', 7, 1),
('clinico2', '1234', 8, 1),
('gine1', '1234', 9, 1),
('gine2', '1234', 10, 1),
-- pacientes
('tomasperez', '123', 14, 1),
('pedroramirez', '123', 15, 1),
('julietasuarez', '123', 16, 1),
('martinbravo', '123', 17, 1),
('soledadmendoza', '123', 18, 1),
('gustavoibanez', '123', 19, 1),
('florenciabianchi', '123', 20, 1);

-- Tabla horario_disponible
CREATE TABLE horario_disponible (    
    id_horario BIGINT AUTO_INCREMENT PRIMARY KEY,    
    id_profesional BIGINT,    
    dia_semana ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo') NOT NULL,    
    hora_inicio TIME NOT NULL,   
    hora_fin TIME NOT NULL,    
    id_estado BIGINT NOT NULL,
    FOREIGN KEY (id_profesional) REFERENCES persona(id_persona),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO horario_disponible (id_profesional, dia_semana, hora_inicio, hora_fin, id_estado)
VALUES
-- Cardiólogos
(3, 'Lunes', '09:00:00', '12:00:00', 1), 
(3, 'Martes', '09:00:00', '12:00:00', 1),
(3, 'Miércoles', '09:00:00', '12:00:00', 1),
(3, 'Jueves', '14:00:00', '18:00:00', 1),
(3, 'Viernes', '09:00:00', '12:00:00', 1),
(4, 'Lunes', '09:00:00', '12:00:00', 1),
-- Pediatras
(3, 'Lunes', '09:00:00', '12:00:00', 1),
(3, 'Jueves', '09:00:00', '12:00:00', 1),
(4, 'Martes', '09:00:00', '12:00:00', 1),
(4, 'Viernes', '09:00:00', '12:00:00', 1),
-- Clínicos
(5, 'Miércoles', '09:00:00', '12:00:00', 1),
(5, 'Viernes', '09:00:00', '12:00:00', 1),
(6, 'Lunes', '09:00:00', '12:00:00', 1),
(6, 'Martes', '09:00:00', '12:00:00', 1),
-- Ginecólogos
(7, 'Miércoles', '09:00:00', '12:00:00', 1),
(7, 'Jueves', '09:00:00', '12:00:00', 1),
(8, 'Lunes', '09:00:00', '12:00:00', 1),
(8, 'Viernes', '09:00:00', '12:00:00', 1),
-- Carlos Gómez 
(7, 'Lunes', '14:00:00', '18:00:00', 1),
(7, 'Miércoles', '14:00:00', '18:00:00', 1),
-- Laura Martínez
(8, 'Martes', '14:00:00', '18:00:00', 1),
(8, 'Jueves', '14:00:00', '18:00:00', 1),
-- Luis Pérez 
(9, 'Lunes', '14:00:00', '18:00:00', 1),
(9, 'Jueves', '14:00:00', '18:00:00', 1),
-- Ana Rivas 
(10, 'Martes', '14:00:00', '18:00:00', 1),
(10, 'Viernes', '14:00:00', '18:00:00', 1),
-- José Fernández 
(11, 'Miércoles', '14:00:00', '18:00:00', 1),
(11, 'Viernes', '14:00:00', '18:00:00', 1),
-- Marta López 
(12, 'Lunes', '14:00:00', '18:00:00', 1),
(12, 'Martes', '14:00:00', '18:00:00', 1),
-- Diego Sosa 
(13, 'Miércoles', '14:00:00', '18:00:00', 1),
(13, 'Jueves', '14:00:00', '18:00:00', 1);

-- Tabla turno
CREATE TABLE turno (    
    id_turno BIGINT AUTO_INCREMENT PRIMARY KEY,
    comprobante VARCHAR(50) NOT NULL,
    id_paciente BIGINT,
    id_profesional BIGINT,
    fecha_hora DATETIME NOT NULL,
    duracion INT NOT NULL,
    id_estado BIGINT NOT NULL,
    observaciones TEXT DEFAULT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES persona(id_persona),
    FOREIGN KEY (id_profesional) REFERENCES persona(id_persona),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO turno (comprobante, id_paciente, id_profesional, fecha_hora, duracion, id_estado, observaciones)
VALUES
('ST-20250506-000001', 14, 3, '2025-05-10 09:00:00', 30, 1, 'Consulta general de salud'), 
('ST-20250506-000002', 15, 4, '2025-05-11 10:00:00', 30, 1, 'Chequeo pediátrico'), 
('ST-20250506-000003', 16, 5, '2025-05-12 14:00:00', 45, 2, 'Consulta cardiológica'), 
('ST-20250506-000004', 17, 6, '2025-05-13 11:00:00', 30, 1, 'Consulta general'), 
('ST-20250506-000005', 18, 7, '2025-05-14 16:00:00', 45, 3, 'Consulta ginecológica'), 
('ST-20250506-000006', 19, 8, '2025-05-15 10:00:00', 30, 2, 'Chequeo general');

-- Tabla historial_estado_turno
CREATE TABLE historial_estado_turno (    
    id_historial BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_turno BIGINT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_anterior BIGINT NOT NULL,
    estado_nuevo BIGINT NOT NULL,
    observacion TEXT DEFAULT NULL,
    FOREIGN KEY (id_turno) REFERENCES turno(id_turno),
    FOREIGN KEY (estado_anterior) REFERENCES estado(id_estado),
    FOREIGN KEY (estado_nuevo) REFERENCES estado(id_estado)
);

-- Tabla monto
CREATE TABLE monto (
    id_monto BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_turno BIGINT,
    fecha_pago DATE,
    monto DECIMAL(10,2) NOT NULL,
    id_estado BIGINT NOT NULL,
    FOREIGN KEY (id_turno) REFERENCES turno(id_turno),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO monto (id_turno, fecha_pago, monto, id_estado)
VALUES
(1, '2025-05-10', 500.00, 1), 
(2, '2025-05-11', 400.00, 1), 
(3, '2025-05-12', 700.00, 1), 
(4, '2025-05-13', 500.00, 1), 
(5, '2025-05-14', 600.00, 1), 
(6, '2025-05-15', 500.00, 1);

-- Tabla consulta_web
CREATE TABLE consulta_web (
    id_consulta BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    mensaje TEXT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_estado BIGINT NOT NULL,
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO consulta_web (nombre, correo, mensaje, id_estado)
VALUES
('Juan Pérez', 'juan.perez@gmail.com', 'Quisiera saber los horarios de atención del médico general.', 1), 
('Ana García', 'ana.garcia@gmail.com', '¿Cómo puedo agendar un turno para pediatría?', 1), 
('Luis Martínez', 'luis.martinez@gmail.com', 'Tengo dudas sobre los servicios de cardiología.', 1), 
('Marta López', 'marta.lopez@gmail.com', '¿Cuáles son los requisitos para un turno con ginecología?', 1), 
('Carlos Rodríguez', 'carlos.rodriguez@gmail.com', 'Necesito cancelar un turno con el doctor.', 1), 
('Elena Sánchez', 'elena.sanchez@gmail.com', '¿Hay disponibilidad para turno en la próxima semana?', 1);

-- Tabla asistencia_turno
CREATE TABLE asistencia_turno (
    id_asistencia BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_turno BIGINT NOT NULL,
    asistio BIGINT NOT NULL, -- 1: asistió, 0: no asistió
    observaciones TEXT,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_estado BIGINT NOT NULL,
    FOREIGN KEY (id_turno) REFERENCES turno(id_turno),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO asistencia_turno (id_turno, asistio, observaciones, id_estado)
VALUES
(1, 1, 'El paciente asistió a su turno a la hora acordada.', 1), 
(2, 0, 'El paciente no se presentó al turno programado.', 1), 
(3, 1, 'El paciente llegó 10 minutos antes de la hora programada y fue atendido sin inconvenientes.', 1), 
(4, 0, 'El paciente canceló el turno con 24 horas de anticipación.', 1), 
(5, 1, 'El paciente asistió puntualmente y completó la consulta médica.', 1), 
(6, 0, 'El paciente no se presentó sin previo aviso y no contactó a la clínica.', 1);
