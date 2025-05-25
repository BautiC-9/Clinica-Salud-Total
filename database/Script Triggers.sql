DROP TRIGGER IF EXISTS after_turno_update;
DROP TRIGGER IF EXISTS before_persona_insert;
DROP TRIGGER IF EXISTS before_persona_update;

-- Trigger Turno
USE clinica;

DELIMITER //

CREATE TRIGGER after_turno_update
AFTER UPDATE ON turno
FOR EACH ROW
BEGIN
    -- Verificar si el estado del turno ha cambiado
    IF OLD.clinica.estado != NEW.clinica.estado THEN
        -- Insertar un registro en la tabla historial_estado_turno
        INSERT INTO historial_estado_turno 
            (id_turno, estado_anterior, estado_nuevo, observacion)
        VALUES 
            (NEW.id_turno, OLD.clinica.estado, NEW.clinica.estado, 'Cambio de estado automático');
    END IF;
END//

DELIMITER ;


USE clinica;
DELIMITER //

CREATE TRIGGER before_persona_insert
BEFORE INSERT ON persona
FOR EACH ROW
BEGIN
  IF NEW.fecha_nacimiento IS NOT NULL THEN
    SET NEW.edad = TIMESTAMPDIFF(YEAR, NEW.fecha_nacimiento, CURDATE());
  ELSE
    SET NEW.edad = NULL;
  END IF;
END//

DELIMITER ;

USE clinica;
DELIMITER //

CREATE TRIGGER before_persona_update
BEFORE UPDATE ON persona
FOR EACH ROW
BEGIN
  IF NEW.fecha_nacimiento IS NOT NULL THEN
    SET NEW.edad = TIMESTAMPDIFF(YEAR, NEW.fecha_nacimiento, CURDATE());
  ELSE
    SET NEW.edad = NULL;
  END IF;
END//

DELIMITER ;