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
