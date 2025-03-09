-- 1. Actualizar inventario de especies cuando se inserta una nueva especie en un área
DELIMITER //
CREATE TRIGGER actualizar_inventario_insert
AFTER INSERT ON Especie_Area
FOR EACH ROW
BEGIN
    UPDATE Especie
    SET inventario_individuos = inventario_individuos + NEW.num_inventario
    WHERE id_especie = NEW.id_especie;
END;
//
DELIMITER ;

-- 2. Actualizar inventario de especies cuando se elimina una especie de un área
DELIMITER //
CREATE TRIGGER actualizar_inventario_delete
AFTER DELETE ON Especie_Area
FOR EACH ROW
BEGIN
    UPDATE Especie
    SET inventario_individuos = inventario_individuos - OLD.num_inventario
    WHERE id_especie = OLD.id_especie;
END;
//
DELIMITER ;

-- 3. Evitar que el inventario de especies sea negativo al eliminar un registro
DELIMITER //
CREATE TRIGGER evitar_inventario_negativo
BEFORE DELETE ON Especie_Area
FOR EACH ROW
BEGIN
    IF (SELECT inventario_individuos FROM Especie WHERE id_especie = OLD.id_especie) < OLD.num_inventario THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar, el inventario quedaría en negativo';
    END IF;
END;
//
DELIMITER ;

-- 4. Asegurar que no se inserten especies con inventario negativo
DELIMITER //
CREATE TRIGGER evitar_insertar_inventario_negativo
BEFORE INSERT ON Especie_Area
FOR EACH ROW
BEGIN
    IF NEW.num_inventario < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede registrar una cantidad negativa de especies';
    END IF;
END;
//
DELIMITER ;

-- 5. Log de cambios en inventario de especies
DELIMITER //
CREATE TRIGGER log_cambios_inventario
AFTER UPDATE ON Especie
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operaciones (descripcion, fecha)
    VALUES (CONCAT('Cambio en inventario de la especie ID ', NEW.id_especie, ': ', OLD.inventario_individuos, ' -> ', NEW.inventario_individuos), NOW());
END;
//
DELIMITER ;

-- 6. Registro de cambios salariales del personal
DELIMITER //
CREATE TRIGGER registrar_cambio_sueldo
BEFORE UPDATE ON Personal
FOR EACH ROW
BEGIN
    IF OLD.sueldo <> NEW.sueldo THEN
        INSERT INTO Log_Salarios (id_personal, sueldo_anterior, sueldo_nuevo, fecha_cambio)
        VALUES (OLD.id_personal, OLD.sueldo, NEW.sueldo, NOW());
    END IF;
END;
//
DELIMITER ;

-- 7. Evitar que el sueldo sea menor al mínimo permitido (ejemplo: 1,000)
DELIMITER //
CREATE TRIGGER evitar_sueldo_minimo
BEFORE UPDATE ON Personal
FOR EACH ROW
BEGIN
    IF NEW.sueldo < 1000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El sueldo no puede ser menor a 1000';
    END IF;
END;
//
DELIMITER ;

-- 8. Registrar la fecha de ingreso de nuevos empleados
DELIMITER //
CREATE TRIGGER registrar_fecha_ingreso
BEFORE INSERT ON Personal
FOR EACH ROW
BEGIN
    SET NEW.fecha_ingreso = NOW();
END;
//
DELIMITER ;

-- 9. Evitar que un empleado tenga el mismo número de documento que otro
DELIMITER //
CREATE TRIGGER evitar_documento_duplicado
BEFORE INSERT ON Personal
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM Personal WHERE documento = NEW.documento) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El número de documento ya existe';
    END IF;
END;
//
DELIMITER ;

-- 10. Log de eliminación de personal
DELIMITER //
CREATE TRIGGER log_eliminacion_personal
AFTER DELETE ON Personal
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operaciones (descripcion, fecha)
    VALUES (CONCAT('Se eliminó al empleado ID ', OLD.id_personal), NOW());
END;
//
DELIMITER ;

-- 11. Evitar que un visitante se aloje si la capacidad está llena
DELIMITER //
CREATE TRIGGER verificar_capacidad_alojamiento
BEFORE INSERT ON Visitante_Alojamiento
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM Visitante_Alojamiento WHERE id_alojamiento = NEW.id_alojamiento) >= 
       (SELECT capacidad FROM Alojamiento WHERE id_alojamiento = NEW.id_alojamiento) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El alojamiento ya está lleno';
    END IF;
END;
//
DELIMITER ;

-- 12. Registrar fecha de check-in de visitante
DELIMITER //
CREATE TRIGGER registrar_checkin_visitante
BEFORE INSERT ON Visitante_Alojamiento
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operaciones (descripcion, fecha)
    VALUES (CONCAT('Visitante ID ', NEW.id_visitante, ' ingresó al alojamiento ID ', NEW.id_alojamiento), NOW());
END;
//
DELIMITER ;

-- 13. Registrar fecha de check-out cuando se elimina un visitante de un alojamiento
DELIMITER //
CREATE TRIGGER registrar_checkout_visitante
AFTER DELETE ON Visitante_Alojamiento
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operaciones (descripcion, fecha)
    VALUES (CONCAT('Visitante ID ', OLD.id_visitante, ' salió del alojamiento ID ', OLD.id_alojamiento), NOW());
END;
//
DELIMITER ;

-- 14. Evitar que un visitante se registre en más de un alojamiento al mismo tiempo
DELIMITER //
CREATE TRIGGER evitar_duplicado_alojamiento
BEFORE INSERT ON Visitante_Alojamiento
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM Visitante_Alojamiento WHERE id_visitante = NEW.id_visitante) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El visitante ya tiene un alojamiento registrado';
    END IF;
END;
//
DELIMITER ;

-- 15. Log de cancelaciones de alojamiento
DELIMITER //
CREATE TRIGGER log_cancelacion_alojamiento
AFTER DELETE ON Alojamiento
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operaciones (descripcion, fecha)
    VALUES (CONCAT('Alojamiento ID ', OLD.id_alojamiento, ' ha sido cancelado'), NOW());
END;
//
DELIMITER ;

-- 16. Evitar que un vehículo sea asignado a más de un personal
DELIMITER //
CREATE TRIGGER evitar_vehiculo_duplicado
BEFORE INSERT ON Vehiculo
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM Personal WHERE id_personal = NEW.id_vehiculo) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El vehículo ya está asignado';
    END IF;
END;
//
DELIMITER ;

-- 17. Registro de asignación de vehículo a personal
DELIMITER //
CREATE TRIGGER log_asignacion_vehiculo
AFTER INSERT ON Vehiculo
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operaciones (descripcion, fecha)
    VALUES (CONCAT('Vehículo ID ', NEW.id_vehiculo, ' asignado'), NOW());
END;
//
DELIMITER ;

-- 18. Log de eliminación de vehículo
DELIMITER //
CREATE TRIGGER log_eliminacion_vehiculo
AFTER DELETE ON Vehiculo
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operaciones (descripcion, fecha)
    VALUES (CONCAT('Vehículo ID ', OLD.id_vehiculo, ' eliminado'), NOW());
END;
//
DELIMITER ;

-- 19. Evitar que se elimine un vehículo asignado a un personal
DELIMITER //
CREATE TRIGGER evitar_eliminar_vehiculo_asignado
BEFORE DELETE ON Vehiculo
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM Personal WHERE id_personal = OLD.id_vehiculo) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar un vehículo asignado a un personal';
    END IF;
END;
//
DELIMITER ;

-- 20. Registrar cambios en los datos personales de un empleado
DELIMITER //
CREATE TRIGGER log_cambios_personal
AFTER UPDATE ON Personal
FOR EACH ROW
BEGIN
    INSERT INTO Log_Operaciones (descripcion, fecha)
    VALUES (CONCAT('Empleado ID ', OLD.id_personal, ' actualizado: Nombre: ', OLD.nombre, ' -> ', NEW.nombre, ', Dirección: ', OLD.direccion, ' -> ', NEW.direccion), NOW());
END;
//
DELIMITER ;