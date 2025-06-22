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
-- ADMINISTRADOR
('35876121', 'Carlos', 'Pérez', 'carlos.perez@mail.com', '3624001122', 'Calle Falsa 456', 1, NULL, 1, '1985-08-22'),

-- SECRETARIA
('38455678', 'Valeria', 'López', 'valeria.lopez@mail.com', '3624113344', 'Mitre 789', 2, NULL, 1, '1992-03-30'),

-- PROFESIONALES
('32654321', 'Miguel', 'Fernández', 'miguel.fernandez@mail.com', '3624332211', 'Belgrano 150', 3, 1, 1, '1980-12-05'),
('33887766', 'Paula', 'Martínez', 'paula.martinez@mail.com', '3624556677', 'Urquiza 1020', 3, 2, 1, '1995-07-19'),
('35550123', 'Diego', 'Ramírez', 'diego.ramirez@mail.com', '3624998877', 'España 99', 3, 4, 1, '1998-01-11'),
('39123651', 'Carlos', 'Gómez', 'carlos.gomez@clinica.com', '1234567890', 'Calle 1', 3, 1, 1, '1980-01-01'),
('40736254', 'Laura', 'Martínez', 'laura.martinez@clinica.com', '1234567891', 'Calle 2', 3, 1, 1, '1975-05-10'),
('33783645', 'Luis', 'Pérez', 'luis.perez@clinica.com', '1234567892', 'Calle 3', 3, 2, 1, '1982-02-02'),
('41873523', 'Ana', 'Rivas', 'ana.rivas@clinica.com', '1234567893', 'Calle 4', 3, 2, 1, '1985-03-03'),
('39286543', 'José', 'Fernández', 'jose.fernandez@clinica.com', '1234567894', 'Calle 5', 3, 3, 1, '1970-04-04'),
('33768376', 'Marta', 'López', 'marta.lopez@clinica.com', '1234567895', 'Calle 6', 3, 3, 1, '1988-05-05'),
('35782975', 'Diego', 'Sosa', 'diego.sosa@clinica.com', '1234567896', 'Calle 7', 3, 4, 1, '1981-06-06'),
('38793287', 'Lucía', 'García', 'lucia.garcia@clinica.com', '1234567897', 'Calle 8', 3, 4, 1, '1978-07-07'),

-- PACIENTES
('41028370', 'Tomás', 'Pérez', 'tomas.perez@mail.com', '1133445566', 'Calle ficticia 54', 4, NULL, 1, '2005-08-20'),
('42938473', 'Pedro', 'Ramírez', 'pedro.ramirez@mail.com', '3410000001', 'Calle 10', 4, NULL, 1, '2000-01-01'),
('44283726', 'Julieta', 'Suárez', 'julieta.suarez@mail.com', '3410000002', 'Calle 11', 4, NULL, 1, '1998-02-02'),
('38928392', 'Martín', 'Bravo', 'martin.bravo@mail.com', '3410000003', 'Calle 12', 4, NULL, 1, '2002-03-03'),
('39283208', 'Soledad', 'Mendoza', 'soledad.mendoza@mail.com', '3410000004', 'Calle 13', 4, NULL, 1, '1995-04-04'),
('36281905', 'Gustavo', 'Ibáñez', 'gustavo.ibanez@mail.com', '3410000005', 'Calle 14', 4, NULL, 1, '2001-05-05'),
('33281086', 'Florencia', 'Bianchi', 'florencia.bianchi@mail.com', '3410000006', 'Calle 15', 4, NULL, 1, '1999-06-06'),
-- PACIENTES NUEVOS
('32009833', 'Valentina', 'López', 'valentina.lopez@mail.com', '3410000007', 'Calle 16', 4, NULL, 1, '1997-07-07'),
('33298654', 'Diego', 'Fernández', 'diego.fernandez@mail.com', '3410000008', 'Calle 17', 4, NULL, 1, '1989-08-08'),
('35278197', 'Camila', 'Gómez', 'camila.gomez@mail.com', '3410000009', 'Calle 18', 4, NULL, 1, '2003-09-09'),
('40927382', 'Lucas', 'Ruiz', 'lucas.ruiz@mail.com', '3410000010', 'Calle 19', 4, NULL, 1, '1995-10-10'),
('34287394', 'Sofía', 'Martínez', 'sofia.martinez@mail.com', '3410000011', 'Calle 20', 4, NULL, 1, '2000-11-11'),
('37892012', 'Agustín', 'Rojas', 'agustin.rojas@mail.com', '3410000012', 'Calle 21', 4, NULL, 1, '1996-12-12'),
('42839172', 'Micaela', 'Vega', 'micaela.vega@mail.com', '3410000013', 'Calle 22', 4, NULL, 1, '1998-01-15'),
('44928312', 'Matías', 'Silva', 'matias.silva@mail.com', '3410000014', 'Calle 23', 4, NULL, 1, '2001-02-20'),
('38901723', 'Lucía', 'Castro', 'lucia.castro@mail.com', '3410000015', 'Calle 24', 4, NULL, 1, '1999-03-25'),
('32873645', 'Facundo', 'Ortiz', 'facundo.ortiz@mail.com', '3410000016', 'Calle 25', 4, NULL, 1, '1994-04-30'),
('40879463', 'Marina', 'Torres', 'marina.torres@mail.com', '3410000017', 'Calle 26', 4, NULL, 1, '1993-05-12'),
('41728362', 'Nicolás', 'Vargas', 'nicolas.vargas@mail.com', '3410000018', 'Calle 27', 4, NULL, 1, '1990-09-21'),
('37298302', 'Carolina', 'Medina', 'carolina.medina@mail.com', '3410000019', 'Calle 28', 4, NULL, 1, '1997-11-11'),
('39287312', 'Ezequiel', 'Figueroa', 'ezequiel.figueroa@mail.com', '3410000020', 'Calle 29', 4, NULL, 1, '2001-03-03'),
('42093190', 'Sabrina', 'Mendoza', 'sabrina.mendoza@mail.com', '3410000021', 'Calle 30', 4, NULL, 1, '2002-12-15'),
('36278102', 'Gonzalo', 'Ruiz', 'gonzalo.ruiz@mail.com', '3410000022', 'Calle 31', 4, NULL, 1, '2003-07-07'),
('41029382', 'Florencia', 'Cabrera', 'florencia.cabrera@mail.com', '3410000023', 'Calle 32', 4, NULL, 1, '2004-01-01'),
('35827382', 'Matías', 'Campos', 'matias.campos@mail.com', '3410000024', 'Calle 33', 4, NULL, 1, '2005-08-19'),
('37829102', 'Romina', 'Soto', 'romina.soto@mail.com', '3410000025', 'Calle 34', 4, NULL, 1, '2006-06-25'),
('39208473', 'Bruno', 'Alonso', 'bruno.alonso@mail.com', '3410000026', 'Calle 35', 4, NULL, 1, '2007-02-10'),

-- PROFESIONALES NUEVOS
('32456789', 'Carla', 'Martínez', 'carla.martinez@salud.com', '3411000001', 'Av. Belgrano 123', 3, 1, 1, '1985-03-15'),
('33541236', 'Federico', 'González', 'federico.gonzalez@salud.com', '3411000002', 'Calle Mitre 456', 3, 2, 1, '1978-07-22'),
('34678945', 'Laura', 'Paz', 'laura.paz@salud.com', '3411000003', 'Bv. Oroño 789', 3, 3, 1, '1982-11-09'),
('35890124', 'Andrés', 'Sosa', 'andres.sosa@salud.com', '3411000004', 'Calle Córdoba 321', 3, 4, 1, '1990-05-30'),
('36987654', 'Verónica', 'Herrera', 'veronica.herrera@salud.com', '3411000005', 'Calle San Juan 654', 3, 1, 1, '1987-09-12'),
('37895412', 'Julián', 'Morales', 'julian.morales@salud.com', '3411000006', 'Calle Mendoza 111', 3, 2, 1, '1980-10-05'),
('38123456', 'Daniela', 'Ríos', 'daniela.rios@salud.com', '3411000007', 'Calle Buenos Aires 222', 3, 3, 1, '1992-01-18'),
('39234567', 'Gabriel', 'Castillo', 'gabriel.castillo@salud.com', '3411000008', 'Calle Salta 333', 3, 4, 1, '1986-06-27'),
('40321654', 'Natalia', 'Luna', 'natalia.luna@salud.com', '3411000009', 'Calle Tucumán 444', 3, 1, 1, '1991-08-08'),
('41234568', 'Santiago', 'Leiva', 'santiago.leiva@salud.com', '3411000010', 'Calle Entre Ríos 555', 3, 2, 1, '1983-12-02'),
('42348901', 'Marina', 'Sánchez', 'marina.sanchez@salud.com', '3411000011', 'Calle Rivadavia 123', 3, 1, 1, '1984-09-10'),
('43456789', 'Javier', 'Domínguez', 'javier.dominguez@salud.com', '3411000012', 'Calle San Martín 456', 3, 2, 1, '1979-11-20'),
('44123456', 'Mónica', 'Gutiérrez', 'monica.gutierrez@salud.com', '3411000013', 'Av. Corrientes 789', 3, 3, 1, '1987-02-15'),
('32449876', 'Ricardo', 'Vargas', 'ricardo.vargas@salud.com', '3411000014', 'Calle Salta 101', 3, 4, 1, '1990-07-25'),
('33765432', 'Carolina', 'Fernández', 'carolina.fernandez@salud.com', '3411000015', 'Calle Mendoza 202', 3, 1, 1, '1985-12-05'),
('34871239', 'Fernando', 'Alvarez', 'fernando.alvarez@salud.com', '3411000016', 'Calle Belgrano 303', 3, 2, 1, '1982-03-18'),
('35439876', 'Sofía', 'Morales', 'sofia.morales@salud.com', '3411000017', 'Calle Entre Ríos 404', 3, 3, 1, '1991-06-07'),
('36234987', 'Esteban', 'Cruz', 'esteban.cruz@salud.com', '3411000018', 'Av. Santa Fe 505', 3, 4, 1, '1988-01-22'),
('37321234', 'Verónica', 'Ledesma', 'veronica.ledesma@salud.com', '3411000019', 'Calle Pueyrredón 606', 3, 1, 1, '1986-08-13'),
('38456123', 'Gustavo', 'Ramírez', 'gustavo.ramirez@salud.com', '3411000020', 'Calle Paraná 707', 3, 2, 1, '1977-10-30');


-- Tabla tutor
CREATE TABLE tutor (
    id_tutor BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_persona BIGINT NOT NULL UNIQUE,
    parentesco VARCHAR(100),
    id_estado BIGINT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);

-- Tabla paciente
CREATE TABLE paciente (
    id_paciente BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_persona BIGINT NOT NULL UNIQUE,
    obra_social VARCHAR(100) DEFAULT 'sin obra social',
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
(3, 2, 'M12345', 1),     -- uno(8), dos(9), tres(7), cuatro(7)
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
(41, 1, 'M90001', 1),
(42, 2, 'M90002', 1),
(43, 3, 'M90003', 1),
(44, 4, 'M90004', 1),
(45, 1, 'M90005', 1),
(46, 2, 'M90006', 1),
(47, 3, 'M90007', 1),
(48, 4, 'M90008', 1),
(49, 1, 'M90009', 1),
(50, 2, 'M90010', 1),
(51, 1, 'M90011', 1),
(52, 2, 'M90012', 1),
(53, 3, 'M90013', 1),
(54, 4, 'M90014', 1),
(55, 1, 'M90015', 1),
(56, 2, 'M90016', 1),
(57, 3, 'M90017', 1),
(58, 4, 'M90018', 1),
(59, 1, 'M90019', 1),
(60, 2, 'M90020', 1);

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
-- especialistas
('miguel_fernandez', 'profesional123', 3, 1),
('paula_martinez', 'profesional123', 4, 1),
('diego_ramirez', 'profesional123', 5, 1),
('carlos_gomez', 'profesional123', 6, 1),
('laura_martinez', 'profesional123', 7, 1),
('luis_perez', 'profesional123', 8, 1),
('ana_rivas', 'profesional123', 9, 1),
('jose_fernandez', 'profesional123', 10, 1),
('marta_lopez', 'profesional123', 11, 1),
('diego_sosa', 'profesional123', 12, 1),
('lucia_garcia', 'profesional123', 13, 1),
-- pacientes
('tomas_perez', 'paciente123', 14, 1),
('pedro_ramirez', 'paciente123', 15, 1),
('julieta_suarez', 'paciente123', 16, 1),
('martin_bravo', 'paciente123', 17, 1),
('soledad_mendoza', 'paciente123', 18, 1),
('gustavo_ibanez', 'paciente123', 19, 1),
('florencia_bianchi', 'paciente123', 20, 1),
('valentina_lopez', 'paciente123', 21, 1),
('diego_fernandez', 'paciente123', 22, 1),
('camila_gomez', 'paciente123', 23, 1),
('lucas_ruiz', 'paciente123', 24, 1),
('sofia_martinez', 'paciente123', 25, 1),
('agustin_rojas', 'paciente123', 26, 1),
('micaela_vega', 'paciente123', 27, 1),
('matias_silva', 'paciente123', 28, 1),
('lucia_castro', 'paciente123', 29, 1),
('facundo_ortiz', 'paciente123', 30, 1),
('marina_torres', 'paciente123', 31, 1),
('nicolas_vargas', 'paciente123', 32, 1),
('carolina_medina', 'paciente123', 33, 1),
('ezequiel_figueroa', 'paciente123', 34, 1),
('sabrina_mendoza', 'paciente123', 35, 1),
('gonzalo_ruiz', 'paciente123', 36, 1),
('florencia_cabrera', 'paciente123', 37, 1),
('matias_campos', 'paciente123', 38, 1),
('romina_soto', 'paciente123', 39, 1),
('bruno_alonso', 'paciente123', 40, 1);

-- Tabla horario_disponible
CREATE TABLE horario_disponible (    
    id_horario BIGINT AUTO_INCREMENT PRIMARY KEY,    
    id_profesional BIGINT,    
    dia_semana ENUM('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo') NOT NULL,    
    hora_inicio TIME NOT NULL,   
    hora_fin TIME NOT NULL,    
    id_estado BIGINT NOT NULL,
    FOREIGN KEY (id_profesional) REFERENCES persona(id_persona),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO horario_disponible (id_profesional, dia_semana, hora_inicio, hora_fin, id_estado)
VALUES
-- Profesional 3 (Lunes y Martes)
(3, 'Lunes', '09:00:00', '12:00:00', 1),
(3, 'Martes', '09:00:00', '12:00:00', 1),
-- Profesional 4 (Miércoles y Jueves)
(4, 'Miercoles', '09:00:00', '12:00:00', 1),
(4, 'Jueves', '09:00:00', '12:00:00', 1),
-- Profesional 5 (Viernes y Sábado)
(5, 'Viernes', '09:00:00', '12:00:00', 1),
(5, 'Sabado', '09:00:00', '12:00:00', 1),
-- Profesional 6 (Lunes y Martes)
(6, 'Lunes', '09:00:00', '12:00:00', 1),
(6, 'Martes', '09:00:00', '12:00:00', 1),
-- Profesional 7 (Miércoles y Jueves)
(7, 'Miercoles', '09:00:00', '12:00:00', 1),
(7, 'Jueves', '09:00:00', '12:00:00', 1),
-- Profesional 8 (Viernes y Sábado)
(8, 'Viernes', '09:00:00', '12:00:00', 1),
(8, 'Sabado', '09:00:00', '12:00:00', 1),
-- Profesional 9 (Lunes y Martes)
(9, 'Lunes', '09:00:00', '12:00:00', 1),
(9, 'Martes', '09:00:00', '12:00:00', 1),
-- Profesional 10 (Miércoles y Jueves)
(10, 'Miercoles', '09:00:00', '12:00:00', 1),
(10, 'Jueves', '09:00:00', '12:00:00', 1),
-- Profesional 11 (Viernes y Sábado)
(11, 'Viernes', '09:00:00', '12:00:00', 1),
(11, 'Sabado', '09:00:00', '12:00:00', 1),
-- Profesional 12 (Lunes y Martes)
(12, 'Lunes', '09:00:00', '12:00:00', 1),
(12, 'Martes', '09:00:00', '12:00:00', 1),
-- Profesional 13 (Miércoles y Jueves)
(13, 'Miercoles', '09:00:00', '12:00:00', 1),
(13, 'Jueves', '09:00:00', '12:00:00', 1),
-- Profesional 41 (Lunes y Martes)
(41, 'Lunes', '09:00:00', '12:00:00', 1),
(41, 'Martes', '09:00:00', '12:00:00', 1),
-- Profesional 42 (Miercoles y Jueves)
(42, 'Miercoles', '09:00:00', '12:00:00', 1),
(42, 'Jueves', '09:00:00', '12:00:00', 1),
-- Profesional 43 (Viernes y Sabado)
(43, 'Viernes', '09:00:00', '12:00:00', 1),
(43, 'Sabado', '09:00:00', '12:00:00', 1),
-- Profesional 44 (Lunes y Martes)
(44, 'Lunes', '09:00:00', '12:00:00', 1),
(44, 'Martes', '09:00:00', '12:00:00', 1),
-- Profesional 45 (Miercoles y Jueves)
(45, 'Miercoles', '09:00:00', '12:00:00', 1),
(45, 'Jueves', '09:00:00', '12:00:00', 1),
-- Profesional 46 (Viernes y Sabado)
(46, 'Viernes', '09:00:00', '12:00:00', 1),
(46, 'Sabado', '09:00:00', '12:00:00', 1),
-- Profesional 47 (Lunes y Martes)
(47, 'Lunes', '09:00:00', '12:00:00', 1),
(47, 'Martes', '09:00:00', '12:00:00', 1),
-- Profesional 48 (Miercoles y Jueves)
(48, 'Miercoles', '09:00:00', '12:00:00', 1),
(48, 'Jueves', '09:00:00', '12:00:00', 1),
-- Profesional 49 (Viernes y Sabado)
(49, 'Viernes', '09:00:00', '12:00:00', 1),
(49, 'Sabado', '09:00:00', '12:00:00', 1),
-- Profesional 50 (Lunes y Martes)
(50, 'Lunes', '09:00:00', '12:00:00', 1),
(50, 'Martes', '09:00:00', '12:00:00', 1),
-- Profesional 51 (Miercoles y Jueves)
(51, 'Miercoles', '09:00:00', '12:00:00', 1),
(51, 'Jueves', '09:00:00', '12:00:00', 1),
-- Profesional 52 (Viernes y Sabado)
(52, 'Viernes', '09:00:00', '12:00:00', 1),
(52, 'Sabado', '09:00:00', '12:00:00', 1),
-- Profesional 53 (Lunes y Martes)
(53, 'Lunes', '09:00:00', '12:00:00', 1),
(53, 'Martes', '09:00:00', '12:00:00', 1),
-- Profesional 54 (Miercoles y Jueves)
(54, 'Miercoles', '09:00:00', '12:00:00', 1),
(54, 'Jueves', '09:00:00', '12:00:00', 1),
-- Profesional 55 (Viernes y Sabado)
(55, 'Viernes', '09:00:00', '12:00:00', 1),
(55, 'Sabado', '09:00:00', '12:00:00', 1),
-- Profesional 56 (Lunes y Martes)
(56, 'Lunes', '09:00:00', '12:00:00', 1),
(56, 'Martes', '09:00:00', '12:00:00', 1),
-- Profesional 57 (Miercoles y Jueves)
(57, 'Miercoles', '09:00:00', '12:00:00', 1),
(57, 'Jueves', '09:00:00', '12:00:00', 1),
-- Profesional 58 (Viernes y Sabado)
(58, 'Viernes', '09:00:00', '12:00:00', 1),
(58, 'Sabado', '09:00:00', '12:00:00', 1),
-- Profesional 59 (Lunes y Martes)
(59, 'Lunes', '09:00:00', '12:00:00', 1),
(59, 'Martes', '09:00:00', '12:00:00', 1),
-- Profesional 60 (Miercoles y Jueves)
(60, 'Miercoles', '09:00:00', '12:00:00', 1),
(60, 'Jueves', '09:00:00', '12:00:00', 1);

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
('ST-20250615-000001', 14, 3, '2025-06-25 09:00:00', 30, 10, 'Chequeo pediátrico'), 
('ST-20250615-000002', 15, 4, '2025-06-25 09:30:00', 30, 10, 'Consulta pediátrica'), 
('ST-20250615-000003', 16, 5, '2025-06-25 10:00:00', 30, 10, 'Consulta ginecológica'), 
('ST-20250615-000004', 17, 6, '2025-06-26 10:30:00', 30, 10, 'Consulta general'), 
('ST-20250615-000005', 18, 7, '2025-06-26 11:00:00', 30, 10, 'Consulta general'), 
('ST-20250615-000006', 19, 8, '2025-06-27 11:30:00', 30, 10, 'Consulta pediátrica'),
('ST-20250615-000007', 20, 9, '2025-07-01 09:00:00', 30, 10, 'Consulta pediátrica'),
('ST-20250615-000008', 21, 10, '2025-07-02 09:30:00', 30, 10, 'Consulta cardiológica'),
('ST-20250615-000009', 22, 11, '2025-07-03 10:00:00', 30, 10, 'Consulta cardiológica'),
('ST-20250615-000010', 23, 12, '2025-07-04 10:30:00', 30, 10, 'Control ginecológico anual'),
('ST-20250616-000001', 24, 13, '2025-07-05 11:00:00', 30, 10, 'Consulta ginecológica'),
('ST-20250616-000002', 25, 41, '2025-07-06 11:30:00', 30, 10, 'Chequeo clinico'),
('ST-20250616-000003', 26, 42, '2025-07-07 09:00:00', 30, 10, 'Consulta pediátrica'),
('ST-20250616-000004', 27, 43, '2025-07-08 09:30:00', 30, 10, 'Consulta cardiológica'),
('ST-20250616-000005', 28, 44, '2025-07-09 10:00:00', 30, 10, 'Consulta ginecológica'),
('ST-20250616-000006', 29, 45, '2025-07-10 11:30:00', 30, 10, 'Chequeo clinico'),
('ST-20250616-000007', 30, 46, '2025-07-11 09:00:00', 30, 10, 'Consulta pediátrica'),
('ST-20250616-000008', 21, 47, '2025-07-12 09:30:00', 30, 10, 'Consulta cardiológica'),
('ST-20250616-000009', 22, 48, '2025-07-13 10:00:00', 30, 10, 'Consulta ginecológica'),
('ST-20250616-000010', 23, 49, '2025-07-14 10:30:00', 30, 10, 'Consulta clinica'),
('ST-20250617-000001', 24, 50, '2025-07-15 11:00:00', 30, 10, 'Control pediátrica'),
('ST-20250617-000002', 31, 51, '2025-07-16 11:30:00', 30, 9, 'Consulta general de salud'),
('ST-20250617-000003', 32, 52, '2025-07-17 09:00:00', 30, 9, 'Chequeo pediátrico'),
('ST-20250617-000004', 33, 53, '2025-07-18 09:30:00', 30, 9, 'Consulta cardiológica'),
('ST-20250617-000005', 34, 54, '2025-07-19 10:00:00', 30, 9, 'Consulta ginecológica'),
('ST-20250617-000006', 35, 55, '2025-07-20 10:30:00', 30, 9, 'Consulta general'),
('ST-20250617-000007', 36, 56, '2025-07-21 11:00:00', 30, 9, 'Consulta pediátrica'),
('ST-20250617-000008', 37, 57, '2025-07-22 11:30:00', 30, 9, 'Consulta cardiológica'),
('ST-20250617-000009', 38, 58, '2025-07-23 09:00:00', 30, 9, 'Consulta ginecológica'),
('ST-20250617-000010', 39, 59, '2025-07-24 09:30:00', 30, 9, 'Chequeo clinico general'),
('ST-20250617-000011', 40, 60, '2025-07-25 10:00:00', 30, 9, 'Chequeo pediátrico');

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
