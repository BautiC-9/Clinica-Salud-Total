USE clinica;

DELIMITER //

CREATE TRIGGER after_turno_update
AFTER UPDATE ON turno
FOR EACH ROW
BEGIN
    -- Verificar si el estado del turno ha cambiado
    IF OLD.estado != NEW.estado THEN
        -- Insertar un registro en la tabla historial_estado_turno
        INSERT INTO historial_estado_turno 
            (id_turno, estado_anterior, estado_nuevo, observacion)
        VALUES 
            (NEW.id_turno, OLD.estado, NEW.estado, 'Cambio de estado automático');
    END IF;
END//

DELIMITER ;
