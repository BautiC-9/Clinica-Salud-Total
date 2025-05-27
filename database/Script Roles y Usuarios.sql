-- ELIMINACIÓN PREVIA DE USUARIOS (si existen)
DROP USER IF EXISTS 'secretaria'@'localhost';
DROP USER IF EXISTS 'especialista'@'localhost';
DROP USER IF EXISTS 'admin'@'localhost';
DROP USER IF EXISTS 'paciente_web'@'localhost';
DROP USER IF EXISTS 'tutor'@'localhost';

-- ELIMINACIÓN PREVIA DE ROLES (si existen)
DROP ROLE IF EXISTS 'rol_secretaria';
DROP ROLE IF EXISTS 'rol_especialista';
DROP ROLE IF EXISTS 'rol_administrador';
DROP ROLE IF EXISTS 'rol_paciente';
DROP ROLE IF EXISTS 'rol_tutor';

USE clinica;
-- CREACIÓN DE ROLES
CREATE ROLE 'rol_secretaria';
CREATE ROLE 'rol_especialista';
CREATE ROLE 'rol_administrador';
CREATE ROLE 'rol_paciente';
CREATE ROLE 'rol_tutor';

-- ASIGNACIÓN DE PRIVILEGIOS A CADA ROL

-- Secretaria: puede ver, insertar, modificar y eliminar datos generales
GRANT SELECT, INSERT, UPDATE, DELETE
ON clinica.* 
TO 'rol_secretaria';

-- Especialista: solo puede consultar turnos y horarios asignados
GRANT SELECT 
ON clinica.turno TO 'rol_especialista';
GRANT SELECT 
ON clinica.horario_disponible TO 'rol_especialista';

-- Administrador: acceso completo
GRANT ALL PRIVILEGES 
ON clinica.* 
TO 'rol_administrador';

-- Paciente: puede ver e insertar consultas web (como desde una web pública) y ver sus turnos
GRANT SELECT, INSERT 
ON clinica.consulta_web TO 'rol_paciente';
GRANT SELECT 
ON clinica.turno TO 'rol_paciente';

-- Tutor: puede ver turnos y consultar datos relacionados a pacientes a su cargo
GRANT SELECT 
ON clinica.turno TO 'rol_tutor';
GRANT SELECT 
ON clinica.paciente TO 'rol_tutor';

-- CREACIÓN DE USUARIOS

CREATE USER 'secretaria'@'localhost' IDENTIFIED BY 'clave_segura_secretaria';
CREATE USER 'especialista'@'localhost' IDENTIFIED BY 'clave_segura_especialista';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'clave_segura_admin';
CREATE USER 'paciente_web'@'localhost' IDENTIFIED BY 'clave_segura_paciente';
CREATE USER 'tutor'@'localhost' IDENTIFIED BY 'clave_segura_tutor';

-- ASIGNACIÓN DE ROLES A USUARIOS

GRANT 'rol_secretaria' TO 'secretaria'@'localhost';
SET DEFAULT ROLE 'rol_secretaria' TO 'secretaria'@'localhost';

GRANT 'rol_especialista' TO 'especialista'@'localhost';
SET DEFAULT ROLE 'rol_especialista' TO 'especialista'@'localhost';

GRANT 'rol_administrador' TO 'admin'@'localhost';
SET DEFAULT ROLE 'rol_administrador' TO 'admin'@'localhost';

GRANT 'rol_paciente' TO 'paciente_web'@'localhost';
SET DEFAULT ROLE 'rol_paciente' TO 'paciente_web'@'localhost';

GRANT 'rol_tutor' TO 'tutor'@'localhost';
SET DEFAULT ROLE 'rol_tutor' TO 'tutor'@'localhost';

-- APLICAR CAMBIOS
FLUSH PRIVILEGES;
