-- 100 Consultas SQL para la base de datos Ambiental

-- 1. Cantidad de parques por departamento
SELECT d.nombre AS departamento, COUNT(pd.id_parque) AS cantidad_parques
FROM Departamento d
LEFT JOIN Parque_Departamento pd ON d.id_departamento = pd.id_departamento
GROUP BY d.nombre;

-- 2. Superficie total de parques por departamento
SELECT d.nombre AS departamento, SUM(a.extension) AS superficie_total
FROM Departamento d
JOIN Parque_Departamento pd ON d.id_departamento = pd.id_departamento
JOIN Parque p ON pd.id_parque = p.id_parque
JOIN Area a ON p.id_parque = a.id_parque
GROUP BY d.nombre;

-- 3. Inventario total de especies por tipo en todas las áreas
SELECT e.tipo, SUM(e.inventario_individuos) AS total_individuos
FROM Especie e
GROUP BY e.tipo;

-- 4. Especies por área
SELECT a.nombre AS area, e.nombre_vulgar AS especie, ea.num_inventario
FROM Area a
JOIN Especie_Area ea ON a.id_area = ea.id_area
JOIN Especie e ON ea.id_especie = e.id_especie
ORDER BY a.nombre;

-- 5. Promedio de sueldo por tipo de personal
SELECT rol, AVG(sueldo) AS sueldo_promedio
FROM Personal
GROUP BY rol;

-- 6. Proyectos de investigación y su costo total
SELECT nombre, presupuesto FROM Proyecto_Investigacion
ORDER BY presupuesto DESC;

-- 7. Cantidad de especies investigadas por proyecto
SELECT pi.nombre AS proyecto, COUNT(pe.id_especie) AS especies_investigadas
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
GROUP BY pi.nombre;

-- 8. Visitantes por parque y su ocupación en alojamientos
SELECT p.nombre AS parque, COUNT(va.id_visitante) AS visitantes
FROM Parque p
JOIN Alojamiento a ON p.id_parque = a.id_parque
JOIN Visitante_Alojamiento va ON a.id_alojamiento = va.id_alojamiento
GROUP BY p.nombre;

-- 9. Vehículos asignados al personal de vigilancia
SELECT p.nombre AS personal, v.marca, v.modelo
FROM Personal p
JOIN Vehiculo v ON p.id_personal = v.id_vehiculo
WHERE p.rol = 'Vigilancia';

-- 10. Proyectos con más de 5 especies investigadas
SELECT pi.nombre AS proyecto, COUNT(pe.id_especie) AS especies_investigadas
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
GROUP BY pi.nombre
HAVING COUNT(pe.id_especie) > 5;
-- 11. Listar los parques con más de 3 áreas registradas
SELECT p.nombre AS parque, COUNT(a.id_area) AS total_areas
FROM Parque p
JOIN Area a ON p.id_parque = a.id_parque
GROUP BY p.nombre
HAVING COUNT(a.id_area) > 3;

-- 12. Obtener la cantidad de especies registradas en cada parque
SELECT p.nombre AS parque, COUNT(DISTINCT ea.id_especie) AS total_especies
FROM Parque p
JOIN Area a ON p.id_parque = a.id_parque
JOIN Especie_Area ea ON a.id_area = ea.id_area
GROUP BY p.nombre;

-- 13. Cantidad total de visitantes por año
SELECT YEAR(a.fecha_ingreso) AS anio, COUNT(va.id_visitante) AS total_visitantes
FROM Alojamiento a
JOIN Visitante_Alojamiento va ON a.id_alojamiento = va.id_alojamiento
GROUP BY YEAR(a.fecha_ingreso)
ORDER BY anio DESC;

-- 14. Promedio de presupuesto de los proyectos de investigación
SELECT AVG(p.presupuesto) AS promedio_presupuesto
FROM Proyecto_Investigacion p;

-- 15. Obtener los alojamientos con más de 5 visitantes alojados
SELECT a.id_alojamiento, p.nombre AS parque, COUNT(va.id_visitante) AS total_visitantes
FROM Alojamiento a
JOIN Parque p ON a.id_parque = p.id_parque
JOIN Visitante_Alojamiento va ON a.id_alojamiento = va.id_alojamiento
GROUP BY a.id_alojamiento, p.nombre
HAVING COUNT(va.id_visitante) > 5;

-- 16. Listar los investigadores y la cantidad de proyectos en los que trabajan
SELECT per.nombre AS investigador, COUNT(pi.id_proyecto) AS total_proyectos
FROM Personal per
JOIN Proyecto_Investigador pi ON per.id_personal = pi.id_personal
WHERE per.rol = 'Investigacion'
GROUP BY per.nombre;

-- 17. Obtener el total de sueldos pagados por cada tipo de personal
SELECT rol, SUM(sueldo) AS total_sueldos
FROM Personal
GROUP BY rol;

-- 18. Listar los vehículos asignados a personal de vigilancia con modelos del año 2020 en adelante
SELECT v.marca, v.modelo
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.modelo >= '2020';

-- 19. Identificar el parque con la mayor cantidad de visitantes registrados
SELECT p.nombre AS parque, COUNT(va.id_visitante) AS total_visitantes
FROM Parque p
JOIN Alojamiento a ON p.id_parque = a.id_parque
JOIN Visitante_Alojamiento va ON a.id_alojamiento = va.id_alojamiento
GROUP BY p.nombre
ORDER BY total_visitantes DESC
LIMIT 1;

-- 20. Listar los proyectos de investigación que han finalizado
SELECT nombre, fecha_fin
FROM Proyecto_Investigacion
WHERE fecha_fin < CURDATE();

-- 21. Obtener el promedio de sueldos de los investigadores
SELECT AVG(sueldo) AS sueldo_promedio
FROM Personal
WHERE rol = 'Investigacion';

-- 22. Listar los vehículos asignados a personal de vigilancia con más de 5 años de antigüedad
SELECT v.marca, v.modelo, YEAR(CURDATE()) - YEAR(v.modelo) AS antiguedad
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND YEAR(CURDATE()) - YEAR(v.modelo) > 5;

-- 23. Cantidad de especies investigadas por proyecto y tipo
SELECT pi.nombre AS proyecto, e.tipo, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie e ON pe.id_especie = e.id_especie
GROUP BY pi.nombre, e.tipo;

-- 24. Listar los proyectos de investigación con un presupuesto mayor a 10000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto > 10000;

-- 25. Obtener el total de sueldos pagados a personal de vigilancia
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Vigilancia';

-- 26. Listar los vehículos asignados a personal de vigilancia con más de 100000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 100000;

-- 27. Cantidad de especies investigadas por proyecto y área
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
GROUP BY pi.nombre, a.nombre;

-- 28. Listar los proyectos de investigación con un presupuesto menor a 5000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto < 5000;

-- 29. Obtener el total de sueldos pagados a personal de investigación
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Investigacion';

-- 30. Listar los vehículos asignados a personal de vigilancia con más de 5000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 5000;

-- 31. Cantidad de especies investigadas por proyecto y área en el último año
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 32. Listar los proyectos de investigación con un presupuesto entre 5000 y 10000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto BETWEEN 5000 AND 10000;

-- 33. Obtener el total de sueldos pagados a personal de conservación
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Conservacion';

-- 34. Listar los vehículos asignados a personal de vigilancia con más de 10000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 10000;





