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
-- 3. PROFESIONALES
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
('49111222', 'Tomás', 'Pérez', 'tomas.perez@example.com', '1133445566', 'Av. Siempre Viva 742', 4, NULL, 1, '2005-08-20'),
('99900001', 'Pedro', 'Ramírez', 'pedro.ramirez@mail.com', '3410000001', 'Calle 10', 4, NULL, 1, '2000-01-01'),
('99900002', 'Julieta', 'Suárez', 'julieta.suarez@mail.com', '3410000002', 'Calle 11', 4, NULL, 1, '1998-02-02'),
('99900003', 'Martín', 'Bravo', 'martin.bravo@mail.com', '3410000003', 'Calle 12', 4, NULL, 1, '2002-03-03'),
('99900004', 'Soledad', 'Mendoza', 'soledad.mendoza@mail.com', '3410000004', 'Calle 13', 4, NULL, 1, '1995-04-04'),
('99900005', 'Gustavo', 'Ibáñez', 'gustavo.ibanez@mail.com', '3410000005', 'Calle 14', 4, NULL, 1, '2001-05-05'),
('99900006', 'Florencia', 'Bianchi', 'florencia.bianchi@mail.com', '3410000006', 'Calle 15', 4, NULL, 1, '1999-06-06'),
-- PACIENTES NUEVOS
('99900007', 'Valentina', 'López', 'valentina.lopez@mail.com', '3410000007', 'Calle 16', 4, NULL, 1, '1997-07-07'),
('99900008', 'Diego', 'Fernández', 'diego.fernandez@mail.com', '3410000008', 'Calle 17', 4, NULL, 1, '1989-08-08'),
('99900009', 'Camila', 'Gómez', 'camila.gomez@mail.com', '3410000009', 'Calle 18', 4, NULL, 1, '2003-09-09'),
('99900010', 'Lucas', 'Ruiz', 'lucas.ruiz@mail.com', '3410000010', 'Calle 19', 4, NULL, 1, '1995-10-10'),
('99900011', 'Sofía', 'Martínez', 'sofia.martinez@mail.com', '3410000011', 'Calle 20', 4, NULL, 1, '2000-11-11'),
('99900012', 'Agustín', 'Rojas', 'agustin.rojas@mail.com', '3410000012', 'Calle 21', 4, NULL, 1, '1996-12-12'),
('99900013', 'Micaela', 'Vega', 'micaela.vega@mail.com', '3410000013', 'Calle 22', 4, NULL, 1, '1998-01-15'),
('99900014', 'Matías', 'Silva', 'matias.silva@mail.com', '3410000014', 'Calle 23', 4, NULL, 1, '2001-02-20'),
('99900015', 'Lucía', 'Castro', 'lucia.castro@mail.com', '3410000015', 'Calle 24', 4, NULL, 1, '1999-03-25'),
('99900016', 'Facundo', 'Ortiz', 'facundo.ortiz@mail.com', '3410000016', 'Calle 25', 4, NULL, 1, '1994-04-30'),
('99900017', 'Marina', 'Torres', 'marina.torres@mail.com', '3410000017', 'Calle 26', 4, NULL, 1, '1993-05-12'),
('99900018', 'Nicolás', 'Vargas', 'nicolas.vargas@mail.com', '3410000018', 'Calle 27', 4, NULL, 1, '1990-09-21'),
('99900019', 'Carolina', 'Medina', 'carolina.medina@mail.com', '3410000019', 'Calle 28', 4, NULL, 1, '1997-11-11'),
('99900020', 'Ezequiel', 'Figueroa', 'ezequiel.figueroa@mail.com', '3410000020', 'Calle 29', 4, NULL, 1, '1988-03-03'),
('99900021', 'Sabrina', 'Mendoza', 'sabrina.mendoza@mail.com', '3410000021', 'Calle 30', 4, NULL, 1, '1995-12-15'),
('99900022', 'Gonzalo', 'Ruiz', 'gonzalo.ruiz@mail.com', '3410000022', 'Calle 31', 4, NULL, 1, '1992-07-07'),
('99900023', 'Florencia', 'Cabrera', 'florencia.cabrera@mail.com', '3410000023', 'Calle 32', 4, NULL, 1, '1999-01-01'),
('99900024', 'Matías', 'Campos', 'matias.campos@mail.com', '3410000024', 'Calle 33', 4, NULL, 1, '1994-08-19'),
('99900025', 'Romina', 'Soto', 'romina.soto@mail.com', '3410000025', 'Calle 34', 4, NULL, 1, '1987-06-25'),
('99900026', 'Bruno', 'Alonso', 'bruno.alonso@mail.com', '3410000026', 'Calle 35', 4, NULL, 1, '1996-10-10'),

-- PROFESIONALES NUEVOS
('88810001', 'Carla', 'Martínez', 'carla.martinez@salud.com', '3411000001', 'Av. Belgrano 123', 3, 1, 1, '1985-03-15'),
('88810002', 'Federico', 'González', 'federico.gonzalez@salud.com', '3411000002', 'Calle Mitre 456', 3, 2, 1, '1978-07-22'),
('88810003', 'Laura', 'Paz', 'laura.paz@salud.com', '3411000003', 'Bv. Oroño 789', 3, 3, 1, '1982-11-09'),
('88810004', 'Andrés', 'Sosa', 'andres.sosa@salud.com', '3411000004', 'Calle Córdoba 321', 3, 4, 1, '1990-05-30'),
('88810005', 'Verónica', 'Herrera', 'veronica.herrera@salud.com', '3411000005', 'Calle San Juan 654', 3, 1, 1, '1987-09-12'),
('88810006', 'Julián', 'Morales', 'julian.morales@salud.com', '3411000006', 'Calle Mendoza 111', 3, 2, 1, '1980-10-05'),
('88810007', 'Daniela', 'Ríos', 'daniela.rios@salud.com', '3411000007', 'Calle Buenos Aires 222', 3, 3, 1, '1992-01-18'),
('88810008', 'Gabriel', 'Castillo', 'gabriel.castillo@salud.com', '3411000008', 'Calle Salta 333', 3, 4, 1, '1986-06-27'),
('88810009', 'Natalia', 'Luna', 'natalia.luna@salud.com', '3411000009', 'Calle Tucumán 444', 3, 1, 1, '1991-08-08'),
('88810010', 'Santiago', 'Leiva', 'santiago.leiva@salud.com', '3411000010', 'Calle Entre Ríos 555', 3, 2, 1, '1983-12-02'),
('88810011', 'Marina', 'Sánchez', 'marina.sanchez@salud.com', '3411000011', 'Calle Rivadavia 123', 3, 1, 1, '1984-09-10'),
('88810012', 'Javier', 'Domínguez', 'javier.dominguez@salud.com', '3411000012', 'Calle San Martín 456', 3, 2, 1, '1979-11-20'),
('88810013', 'Mónica', 'Gutiérrez', 'monica.gutierrez@salud.com', '3411000013', 'Av. Corrientes 789', 3, 3, 1, '1987-02-15'),
('88810014', 'Ricardo', 'Vargas', 'ricardo.vargas@salud.com', '3411000014', 'Calle Salta 101', 3, 4, 1, '1990-07-25'),
('88810015', 'Carolina', 'Fernández', 'carolina.fernandez@salud.com', '3411000015', 'Calle Mendoza 202', 3, 1, 1, '1985-12-05'),
('88810016', 'Fernando', 'Alvarez', 'fernando.alvarez@salud.com', '3411000016', 'Calle Belgrano 303', 3, 2, 1, '1982-03-18'),
('88810017', 'Sofía', 'Morales', 'sofia.morales@salud.com', '3411000017', 'Calle Entre Ríos 404', 3, 3, 1, '1991-06-07'),
('88810018', 'Esteban', 'Cruz', 'esteban.cruz@salud.com', '3411000018', 'Av. Santa Fe 505', 3, 4, 1, '1988-01-22'),
('88810019', 'Verónica', 'Ledesma', 'veronica.ledesma@salud.com', '3411000019', 'Calle Pueyrredón 606', 3, 1, 1, '1986-08-13'),
('88810020', 'Gustavo', 'Ramírez', 'gustavo.ramirez@salud.com', '3411000020', 'Calle Paraná 707', 3, 2, 1, '1977-10-30');


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
(20, 'Swiss Medical', 1),
(21, 'Medifé', 1),
(22, 'IOMA', 1),
(23, 'Osde', 1),
(24, 'Swiss Medical', 1),
(25, 'Pami', 1),
(26, 'Osde', 1),
(27, 'Medifé', 1),
(28, 'IOMA', 1),
(29, 'Swiss Medical', 1),
(30, 'Osde', 1),
(31, 'Osde', 1),
(32, 'Swiss Medical', 1),
(33, 'Medifé', 1),
(34, 'IOMA', 1),
(35, 'Pami', 1),
(36, 'Osde', 1),
(37, 'Swiss Medical', 1),
(38, 'Medifé', 1),
(39, 'IOMA', 1),
(40, 'Pami', 1);

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
(13, 4, 'M88888', 1),
(14, 1, 'M90001', 1),
(15, 2, 'M90002', 1),
(16, 3, 'M90003', 1),
(17, 4, 'M90004', 1),
(18, 1, 'M90005', 1),
(19, 2, 'M90006', 1),
(20, 3, 'M90007', 1),
(21, 4, 'M90008', 1),
(22, 1, 'M90009', 1),
(23, 2, 'M90010', 1),
(24, 1, 'M90011', 1),
(25, 2, 'M90012', 1),
(26, 3, 'M90013', 1),
(27, 4, 'M90014', 1),
(28, 1, 'M90015', 1),
(29, 2, 'M90016', 1),
(30, 3, 'M90017', 1),
(31, 4, 'M90018', 1),
(32, 1, 'M90019', 1),
(33, 2, 'M90020', 1);

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
-- EXISTENTES
INSERT INTO turno (comprobante, id_paciente, id_profesional, fecha_hora, duracion, id_estado, observaciones)
VALUES
('ST-20250506-000001', 14, 3, '2025-06-10 09:00:00', 30, 9, 'Consulta general de salud'), 
('ST-20250506-000002', 15, 4, '2025-06-11 10:00:00', 30, 9, 'Chequeo pediátrico'), 
('ST-20250506-000003', 16, 5, '2025-06-12 14:00:00', 45, 9, 'Consulta cardiológica'), 
('ST-20250506-000004', 17, 6, '2025-06-13 11:00:00', 30, 9, 'Consulta general'), 
('ST-20250506-000005', 18, 7, '2025-06-14 16:00:00', 45, 9, 'Consulta ginecológica'), 
('ST-20250506-000006', 19, 8, '2025-06-15 10:00:00', 30, 9, 'Chequeo general'),
('ST-20250701-000007', 20, 9, '2025-07-01 09:00:00', 30, 9, 'Control clínico rutinario'),
('ST-20250702-000008', 21, 10, '2025-07-02 10:30:00', 45, 9, 'Consulta por síntomas respiratorios'),
('ST-20250703-000009', 22, 11, '2025-07-03 11:00:00', 30, 9, 'Revisión pediátrica'),
('ST-20250704-000010', 23, 12, '2025-07-04 12:00:00', 45, 9, 'Control ginecológico anual'),
('ST-20250705-000011', 24, 13, '2025-07-05 13:30:00', 30, 9, 'Chequeo general'),
('ST-20250706-000012', 25, 14, '2025-07-06 14:00:00', 45, 9, 'Control post-operatorio'),
('ST-20250707-000013', 26, 15, '2025-07-07 15:00:00', 30, 9, 'Evaluación prequirúrgica'),
('ST-20250708-000014', 27, 16, '2025-07-08 09:30:00', 30, 9, 'Control clínico'),
('ST-20250709-000015', 28, 17, '2025-07-09 10:00:00', 45, 9, 'Consulta por dolores articulares'),
('ST-20250710-000016', 29, 18, '2025-07-10 11:30:00', 30, 9, 'Control general anual'),
('ST-20250711-000017', 30, 19, '2025-07-11 09:00:00', 30, 9, 'Consulta clínica'),
('ST-20250712-000018', 21, 20, '2025-07-12 10:00:00', 45, 9, 'Revisión post tratamiento'),
('ST-20250713-000019', 22, 21, '2025-07-13 11:00:00', 30, 9, 'Chequeo cardiológico'),
('ST-20250714-000020', 23, 22, '2025-07-14 12:00:00', 45, 9, 'Consulta pediátrica de seguimiento'),
('ST-20250715-000021', 24, 23, '2025-07-15 13:00:00', 30, 9, 'Control ginecológico semestral'),
('ST-20250716-000022', 31, 24, '2025-07-16 09:00:00', 30, 9, 'Consulta general de salud'),
('ST-20250717-000023', 32, 25, '2025-07-17 10:00:00', 30, 9, 'Chequeo pediátrico'),
('ST-20250718-000024', 33, 26, '2025-07-18 11:00:00', 45, 9, 'Consulta cardiológica'),
('ST-20250719-000025', 34, 27, '2025-07-19 09:30:00', 30, 9, 'Consulta general'),
('ST-20250720-000026', 35, 28, '2025-07-20 10:30:00', 45, 9, 'Consulta ginecológica'),
('ST-20250721-000027', 36, 29, '2025-07-21 11:30:00', 30, 9, 'Chequeo general'),
('ST-20250722-000028', 37, 30, '2025-07-22 09:00:00', 30, 9, 'Control clínico rutinario'),
('ST-20250723-000029', 38, 31, '2025-07-23 10:00:00', 45, 9, 'Consulta por síntomas respiratorios'),
('ST-20250724-000030', 39, 32, '2025-07-24 11:00:00', 30, 9, 'Revisión pediátrica'),
('ST-20250725-000031', 40, 33, '2025-07-25 12:00:00', 45, 9, 'Control ginecológico anual');

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
