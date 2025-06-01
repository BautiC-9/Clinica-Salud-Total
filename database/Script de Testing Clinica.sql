SELECT id_turno, id_estado FROM clinica.turno LIMIT 1;

UPDATE clinica.turno
SET id_estado = 2
WHERE id_turno = 1;

SELECT * FROM clinica.historial_estado_turno
WHERE id_turno = 1
ORDER BY fecha_cambio DESC;

INSERT INTO persona (
  dni, nombre, apellido, email, telefono, direccion, id_rol, id_especialidad, id_estado, fecha_nacimiento
) VALUES (
  '40222444', 'Pedro', 'García', 'pedro.garcia@mail.com', '3624555123', 'Calle Demo 123', 4, NULL, 1, '1995-05-24'
);

SELECT dni, nombre, apellido, fecha_nacimiento, edad
FROM persona
WHERE dni = '40222444';


SET SQL_SAFE_UPDATES = 0;

UPDATE persona
SET edad = TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE())
WHERE edad IS NULL;

SET SQL_SAFE_UPDATES = 1;  -- lo volvés a activar si querés

USE clinica;
SELECT 
    pt.id_paciente, 
    p.nombre AS nombre_paciente, 
    p.apellido AS apellido_paciente,
    t.id_tutor, 
    tp.nombre AS nombre_tutor, 
    tp.apellido AS apellido_tutor,
    t.parentesco
FROM paciente_tutor pt
JOIN paciente pa ON pt.id_paciente = pa.id_paciente
JOIN persona p ON pa.id_persona = p.id_persona
JOIN tutor t ON pt.id_tutor = t.id_tutor
JOIN persona tp ON t.id_persona = tp.id_persona;
