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

-- 35. Cantidad de especies investigadas por proyecto y área en el último mes
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE MONTH(pi.fecha_fin) = MONTH(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 36. Listar los proyectos de investigación con un presupuesto entre 10000 y 20000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto BETWEEN 10000 AND 20000;

-- 37. Obtener el total de sueldos pagados a personal de gestión
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Gestion';

-- 38. Listar los vehículos asignados a personal de vigilancia con más de 20000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 20000;

-- 39. Cantidad de especies investigadas por proyecto y área en el último trimestre
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE QUARTER(pi.fecha_fin) = QUARTER(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 40. Listar los proyectos de investigación con un presupuesto entre 20000 y 30000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto BETWEEN 20000 AND 30000;

-- 41. Obtener el total de sueldos pagados a personal de investigación en el último año
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Investigacion' AND YEAR(CURDATE()) - YEAR(fecha_ingreso) = 1;

-- 42. Listar los vehículos asignados a personal de vigilancia con más de 30000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 30000;

-- 43. Cantidad de especies investigadas por proyecto y área en el último semestre
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE QUARTER(pi.fecha_fin) = QUARTER(CURDATE()) AND YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 44. Listar los proyectos de investigación con un presupuesto entre 30000 y 40000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto BETWEEN 30000 AND 40000;

-- 45. Obtener el total de sueldos pagados a personal de conservación en el último año
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Conservacion' AND YEAR(CURDATE()) - YEAR(fecha_ingreso) = 1;

-- 46. Listar los vehículos asignados a personal de vigilancia con más de 40000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 40000;

-- 47. Cantidad de especies investigadas por proyecto y área en el último año
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 48. Listar los proyectos de investigación con un presupuesto entre 40000 y 50000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto BETWEEN 40000 AND 50000;

-- 49. Obtener el total de sueldos pagados a personal de gestión en el último año
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Gestion' AND YEAR(CURDATE()) - YEAR(fecha_ingreso) = 1;

-- 50. Listar los vehículos asignados a personal de vigilancia con más de 50000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 50000;

-- 51. Cantidad de especies investigadas por proyecto y área en el último mes
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE MONTH(pi.fecha_fin) = MONTH(CURDATE())

-- 52. Listar los proyectos de investigación con un presupuesto entre 50000 y 60000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto BETWEEN 50000 AND 60000;

-- 53. Obtener el total de sueldos pagados a personal de investigación en el último mes
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Investigacion' AND MONTH(CURDATE()) - MONTH(fecha_ingreso) = 1;

-- 54. Listar los vehículos asignados a personal de vigilancia con más de 60000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 60000;

-- 55. Cantidad de especies investigadas por proyecto y área en el último trimestre
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE QUARTER(pi.fecha_fin) = QUARTER(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 56. Listar los proyectos de investigación con un presupuesto entre 60000 y 70000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto BETWEEN 60000 AND 70000;

-- 57. Obtener el total de sueldos pagados a personal de conservación en el último mes
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Conservacion' AND MONTH(CURDATE()) - MONTH(fecha_ingreso) = 1;

-- 58. Listar los vehículos asignados a personal de vigilancia con más de 70000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 70000;

-- 59. Cantidad de especies investigadas por proyecto y área en el último semestre
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE QUARTER(pi.fecha_fin) = QUARTER(CURDATE()) AND YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 60. Listar los proyectos de investigación con un presupuesto entre 70000 y 80000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto BETWEEN 70000 AND 80000;

-- 61. Obtener el total de sueldos pagados a personal de gestión en el último mes
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Gestion' AND MONTH(CURDATE()) - MONTH(fecha_ingreso) = 1;

-- 62. Listar los vehículos asignados a personal de vigilancia con más de 80000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 80000;

-- 63. Cantidad de especies investigadas por proyecto y área en el último año
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 64. Listar los proyectos de investigación con un presupuesto entre 80000 y 90000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto BETWEEN 80000 AND 90000;

-- 65. Obtener el total de sueldos pagados a personal de investigación en el último trimestre
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Investigacion' AND QUARTER(CURDATE()) - QUARTER(fecha_ingreso) = 1;

-- 66. Listar los vehículos asignados a personal de vigilancia con más de 90000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 90000;

-- 67. Cantidad de especies investigadas por proyecto y área en el último año
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 68. Listar los proyectos de investigación con un presupuesto entre 90000 y 100000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto BETWEEN 90000 AND 100000;

-- 69. Obtener el total de sueldos pagados a personal de conservación en el último trimestre
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Conservacion' AND QUARTER(CURDATE()) - QUARTER(fecha_ingreso) = 1;

-- 70. Listar los vehículos asignados a personal de vigilancia con más de 100000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 100000;

-- 71. Cantidad de especies investigadas por proyecto y área en el último año
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 72. Listar los proyectos de investigación con un presupuesto mayor a 100000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto > 100000;

-- 73. Obtener el total de sueldos pagados a personal de gestión en el último trimestre
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Gestion' AND QUARTER(CURDATE()) - QUARTER(fecha_ingreso) = 1;

-- 74. Listar los vehículos asignados a personal de vigilancia con más de 110000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 110000;

-- 75. Cantidad de especies investigadas por proyecto y área en el último año
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 76. Listar los proyectos de investigación con un presupuesto mayor a 200000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto > 200000;

-- 77. Obtener el total de sueldos pagados a personal de investigación en el último año
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Investigacion' AND YEAR(CURDATE()) - YEAR(fecha_ingreso) = 1;

-- 78. Listar los vehículos asignados a personal de vigilancia con más de 120000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 120000;

-- 79. Cantidad de especies investigadas por proyecto y área en el último año
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 80. Listar los proyectos de investigación con un presupuesto mayor a 300000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto > 300000;

-- 81. Obtener el total de sueldos pagados a personal de conservación en el último año
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Conservacion' AND YEAR(CURDATE()) - YEAR(fecha_ingreso) = 1;	

-- 82. Listar los vehículos asignados a personal de vigilancia con más de 130000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 130000;

-- 83. Cantidad de especies investigadas por proyecto y área en el último año
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 84. Listar los proyectos de investigación con un presupuesto mayor a 400000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto > 400000;

-- 85. Obtener el total de sueldos pagados a personal de gestión en el último año
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Gestion' AND YEAR(CURDATE()) - YEAR(fecha_ingreso) = 1;

-- 86. Listar los vehículos asignados a personal de vigilancia con más de 140000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 140000;

-- 87. Cantidad de especies investigadas por proyecto y área en el último año
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 88. Listar los proyectos de investigación con un presupuesto mayor a 500000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto > 500000;

-- 89. Obtener el total de sueldos pagados a personal de investigación en el último año
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Investigacion' AND YEAR(CURDATE()) - YEAR(fecha_ingreso) = 1;

-- 90. Listar los vehículos asignados a personal de vigilancia con más de 150000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 150000;

-- 91. Cantidad de especies investigadas por proyecto y área en el último año
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 92. Listar los proyectos de investigación con un presupuesto mayor a 600000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto > 600000;

-- 93. Obtener el total de sueldos pagados a personal de conservación en el último año
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Conservacion' AND YEAR(CURDATE()) - YEAR(fecha_ingreso) = 1;

-- 94. Listar los vehículos asignados a personal de vigilancia con más de 160000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 160000;

-- 95. Cantidad de especies investigadas por proyecto y área en el último año
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 96. Listar los proyectos de investigación con un presupuesto mayor a 700000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto > 700000;

-- 97. Obtener el total de sueldos pagados a personal de gestión en el último año
SELECT SUM(sueldo) AS total_sueldos
FROM Personal
WHERE rol = 'Gestion' AND YEAR(CURDATE()) - YEAR(fecha_ingreso) = 1;

-- 98. Listar los vehículos asignados a personal de vigilancia con más de 170000 km recorridos
SELECT v.marca, v.modelo, v.kilometraje
FROM Vehiculo v
JOIN Personal p ON v.id_vehiculo = p.id_personal
WHERE p.rol = 'Vigilancia' AND v.kilometraje > 170000;

-- 99. Cantidad de especies investigadas por proyecto y área en el último año
SELECT pi.nombre AS proyecto, a.nombre AS area, COUNT(pe.id_especie) AS total_especies
FROM Proyecto_Investigacion pi
JOIN Proyecto_Especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN Especie_Area ea ON pe.id_especie = ea.id_especie
JOIN Area a ON ea.id_area = a.id_area
WHERE YEAR(pi.fecha_fin) = YEAR(CURDATE())
GROUP BY pi.nombre, a.nombre;

-- 100. Listar los proyectos de investigación con un presupuesto mayor a 800000
SELECT nombre, presupuesto
FROM Proyecto_Investigacion
WHERE presupuesto > 800000;





