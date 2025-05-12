SELECT id_turno, id_estado FROM clinica.turno LIMIT 1;


UPDATE clinica.turno
SET id_estado = 2
WHERE id_turno = 1;

SELECT * FROM clinica.historial_estado_turno
WHERE id_turno = 1
ORDER BY fecha_cambio DESC;
