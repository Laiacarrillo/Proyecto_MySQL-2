-- 1. Registrar un nuevo parque
DELIMITER //
CREATE PROCEDURE RegistrarParque(IN nombre_parque VARCHAR(150), IN fecha_declaracion DATE)
BEGIN
    INSERT INTO Parque (nombre, fecha_declaracion) VALUES (nombre_parque, fecha_declaracion);
END //
DELIMITER ;

-- 2. Actualizar el nombre de un parque
DELIMITER //
CREATE PROCEDURE ActualizarParque(IN id_parque INT, IN nuevo_nombre VARCHAR(150))
BEGIN
    UPDATE Parque SET nombre = nuevo_nombre WHERE id_parque = id_parque;
END //
DELIMITER ;

-- 3. Registrar un área en un parque
DELIMITER //
CREATE PROCEDURE RegistrarArea(IN id_parque INT, IN nombre_area VARCHAR(150), IN extension DECIMAL(10,2))
BEGIN
    INSERT INTO Area (id_parque, nombre, extension) VALUES (id_parque, nombre_area, extension);
END //
DELIMITER ;

-- 4. Registrar una especie en el sistema
DELIMITER //
CREATE PROCEDURE RegistrarEspecie(IN nombre_cientifico VARCHAR(200), IN nombre_vulgar VARCHAR(150), IN tipo ENUM('Vegetal', 'Animal', 'Mineral'), IN inventario INT)
BEGIN
    INSERT INTO Especie (nombre_cientifico, nombre_vulgar, tipo, inventario_individuos)
    VALUES (nombre_cientifico, nombre_vulgar, tipo, inventario);
END //
DELIMITER ;

-- 5. Asignar especie a un área
DELIMITER //
CREATE PROCEDURE AsignarEspecieArea(IN id_especie INT, IN id_area INT, IN num_inventario INT)
BEGIN
    INSERT INTO Especie_Area (id_especie, id_area, num_inventario)
    VALUES (id_especie, id_area, num_inventario);
END //
DELIMITER ;
📌 Procesamiento de Datos de Visitantes y Asignación de Alojamientos
sql
Copiar
Editar
-- 6. Registrar un visitante
DELIMITER //
CREATE PROCEDURE RegistrarVisitante(IN cedula VARCHAR(20), IN nombre VARCHAR(150), IN direccion VARCHAR(100), IN profesion VARCHAR(100))
BEGIN
    INSERT INTO Visitante (cedula, nombre, direccion, profesion)
    VALUES (cedula, nombre, direccion, profesion);
END //
DELIMITER ;

-- 7. Registrar un alojamiento
DELIMITER //
CREATE PROCEDURE RegistrarAlojamiento(IN id_parque INT, IN capacidad INT, IN categoria VARCHAR(50), IN fecha_ingreso DATE, IN fecha_salida DATE)
BEGIN
    INSERT INTO Alojamiento (id_parque, capacidad, categoria, fecha_ingreso, fecha_salida)
    VALUES (id_parque, capacidad, categoria, fecha_ingreso, fecha_salida);
END //
DELIMITER ;

-- 8. Asignar un visitante a un alojamiento
DELIMITER //
CREATE PROCEDURE AsignarVisitanteAlojamiento(IN id_visitante INT, IN id_alojamiento INT)
BEGIN
    INSERT INTO Visitante_Alojamiento (id_visitante, id_alojamiento)
    VALUES (id_visitante, id_alojamiento);
END //
DELIMITER ;

-- 9. Consultar visitantes en un alojamiento
DELIMITER //
CREATE PROCEDURE ObtenerVisitantesPorAlojamiento(IN id_alojamiento INT)
BEGIN
    SELECT v.nombre, v.cedula FROM Visitante v
    JOIN Visitante_Alojamiento va ON v.id_visitante = va.id_visitante
    WHERE va.id_alojamiento = id_alojamiento;
END //
DELIMITER ;

-- 10. Liberar un alojamiento (remueve visitantes asignados)
DELIMITER //
CREATE PROCEDURE LiberarAlojamiento(IN id_alojamiento INT)
BEGIN
    DELETE FROM Visitante_Alojamiento WHERE id_alojamiento = id_alojamiento;
END //
DELIMITER ;
📌 Asignación de Personal a Áreas y Registro de Actividades
sql
Copiar
Editar
-- 11. Registrar personal en el sistema
DELIMITER //
CREATE PROCEDURE RegistrarPersonal(IN tipo_documento VARCHAR(100), IN documento INT, IN nombre VARCHAR(150), IN direccion VARCHAR(100), IN telefono VARCHAR(20), IN sueldo DECIMAL(10,2), IN rol ENUM('Gestion', 'Vigilancia', 'Conservacion', 'Investigacion'))
BEGIN
    INSERT INTO Personal (tipo_documento, documento, nombre, direccion, telefono, sueldo, rol)
    VALUES (tipo_documento, documento, nombre, direccion, telefono, sueldo, rol);
END //
DELIMITER ;

-- 12. Asignar personal a un área
DELIMITER //
CREATE PROCEDURE AsignarPersonalArea(IN id_personal INT, IN id_area INT)
BEGIN
    UPDATE Personal SET id_area = id_area WHERE id_personal = id_personal;
END //
DELIMITER ;

-- 13. Registrar actividad de vigilancia
DELIMITER //
CREATE PROCEDURE RegistrarActividadVigilancia(IN id_personal INT, IN descripcion TEXT)
BEGIN
    INSERT INTO Actividad (id_personal, descripcion, fecha)
    VALUES (id_personal, descripcion, NOW());
END //
DELIMITER ;

-- 14. Actualizar sueldo de un empleado
DELIMITER //
CREATE PROCEDURE ActualizarSueldo(IN id_personal INT, IN nuevo_sueldo DECIMAL(10,2))
BEGIN
    UPDATE Personal SET sueldo = nuevo_sueldo WHERE id_personal = id_personal;
END //
DELIMITER ;

-- 15. Consultar personal asignado a un área
DELIMITER //
CREATE PROCEDURE ObtenerPersonalPorArea(IN id_area INT)
BEGIN
    SELECT nombre, rol FROM Personal WHERE id_area = id_area;
END //
DELIMITER ;
📌 Gestión Automatizada de Presupuestos y Proyectos de Investigación
sql
Copiar
Editar
-- 16. Registrar un proyecto de investigación
DELIMITER //
CREATE PROCEDURE RegistrarProyecto(IN nombre VARCHAR(200), IN presupuesto DECIMAL(10,2), IN fecha_inicio DATE, IN fecha_fin DATE)
BEGIN
    INSERT INTO Proyecto_Investigacion (nombre, presupuesto, fecha_inicio, fecha_fin)
    VALUES (nombre, presupuesto, fecha_inicio, fecha_fin);
END //
DELIMITER ;

-- 17. Asignar un investigador a un proyecto
DELIMITER //
CREATE PROCEDURE AsignarInvestigadorProyecto(IN id_proyecto INT, IN id_personal INT)
BEGIN
    INSERT INTO Proyecto_Investigador (id_proyecto, id_personal)
    VALUES (id_proyecto, id_personal);
END //
DELIMITER ;

-- 18. Asignar una especie a un proyecto
DELIMITER //
CREATE PROCEDURE AsignarEspecieProyecto(IN id_proyecto INT, IN id_especie INT)
BEGIN
    INSERT INTO Proyecto_Especie (id_proyecto, id_especie)
    VALUES (id_proyecto, id_especie);
END //
DELIMITER ;

-- 19. Consultar especies en un proyecto
DELIMITER //
CREATE PROCEDURE ObtenerEspeciesPorProyecto(IN id_proyecto INT)
BEGIN
    SELECT e.nombre_vulgar FROM Especie e
    JOIN Proyecto_Especie pe ON e.id_especie = pe.id_especie
    WHERE pe.id_proyecto = id_proyecto;
END //
DELIMITER ;

-- 20. Calcular presupuesto total de los proyectos en curso
DELIMITER //
CREATE PROCEDURE CalcularPresupuestoProyectos()
BEGIN
    SELECT SUM(presupuesto) AS presupuesto_total FROM Proyecto_Investigacion;
END //
DELIMITER ;