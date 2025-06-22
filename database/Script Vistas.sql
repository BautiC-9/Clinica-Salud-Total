DROP VIEW IF EXISTS vista_paciente;
DROP VIEW IF EXISTS vista_profesional;
DROP VIEW IF EXISTS vista_secretaria;
DROP VIEW IF EXISTS vista_profesionales_paciente;
DROP VIEW IF EXISTS vista_paciente_tutor;

-- Vista de pacientes
USE clinica;
CREATE VIEW vista_paciente AS
SELECT 
    p.id_paciente,
    p.id_persona,
    per.dni,
    per.nombre,
    per.apellido,
    per.email,
    per.telefono,
    per.direccion,
    per.fecha_nacimiento,
    per.edad,
    p.obra_social,
    p.id_estado
FROM paciente p
JOIN persona per ON p.id_persona = per.id_persona;

-- Vista de profesionales
USE clinica;
CREATE VIEW vista_profesional AS
SELECT 
    pr.id_profesional,
    pr.id_persona,
    per.dni,
    per.nombre,
    per.apellido,
    per.email,
    per.telefono,
    per.direccion,
    per.fecha_nacimiento,
    per.edad,
    pr.matricula_profesional,
    pr.id_estado
FROM profesional pr
JOIN persona per ON pr.id_persona = per.id_persona;

-- Vista de Secretaria
USE clinica;
CREATE VIEW vista_secretaria AS
SELECT 
    p.id_persona,
    p.dni,
    p.nombre,
    p.apellido,
    p.email,
    p.telefono,
    p.direccion,
    p.fecha_nacimiento,
    p.edad,
    p.id_estado
FROM persona p
WHERE p.id_rol = (SELECT id_rol FROM rol WHERE nombre = 'Secretaria');

-- Vista de profesionales (consulta desde rol paciente)
CREATE VIEW vista_profesionales_paciente AS
SELECT 
    p.id_profesional,
    p.id_especialidad,
    e.nombre AS nombre_especialidad,
    per.nombre,
    per.apellido,
    per.email,
    per.telefono,
    per.fecha_nacimiento,
    per.edad
FROM profesional p
JOIN persona per ON p.id_persona = per.id_persona
JOIN especialidad e ON p.id_especialidad = e.id_especialidad
WHERE p.id_estado = 1;  -- Mostrar solo profesionales activos

-- Vista de tutores
USE clinica;
CREATE VIEW vista_paciente_tutor AS
SELECT 
    pt.id_paciente, 
    p.nombre AS nombre_paciente, 
    p.apellido AS apellido_paciente,
    t.id_tutor, 
    per_t.nombre AS nombre_tutor, 
    per_t.apellido AS apellido_tutor,
    t.parentesco
FROM paciente_tutor pt
JOIN paciente pa ON pt.id_paciente = pa.id_paciente
JOIN persona p ON pa.id_persona = p.id_persona
JOIN tutor t ON pt.id_tutor = t.id_tutor
JOIN persona per_t ON t.id_persona = per_t.id_persona
WHERE p.id_estado = 1;  -- Mostrar solo profesionales activos
