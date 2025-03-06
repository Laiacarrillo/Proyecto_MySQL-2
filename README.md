# Proyecto: Los Ambientales

## Descripción del Proyecto
El objetivo del proyecto es diseñar y desarrollar una base de datos eficiente para gestionar los parques naturales bajo la supervisión del Ministerio del Medio Ambiente. El sistema permite administrar departamentos, parques, áreas, especies, personal, proyectos de investigación, visitantes y alojamientos. Se busca optimizar la gestión de estos elementos y facilitar consultas críticas para la toma de decisiones.

## Requisitos del Sistema
Para ejecutar los scripts y utilizar la base de datos, es necesario contar con:
- **Sistema de Base de Datos:** MySQL v8.0 o superior.
- **Herramientas recomendadas:** MySQL Workbench, DBeaver o phpMyAdmin.
- **Lenguaje SQL:** Se emplea para la creación y manipulación de la base de datos.

## Instalación y Configuración
Para implementar la base de datos, sigue estos pasos:
1. Clona el repositorio desde GitHub:
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   ```
2. Abre MySQL Workbench o tu herramienta preferida.
3. Ejecuta el script `ddl.sql` para crear la estructura de la base de datos:
   ```sql
   SOURCE ddl.sql;
   ```
4. Carga los datos iniciales ejecutando `dml.sql`:
   ```sql
   SOURCE dml.sql;
   ```
5. Ejecuta los diferentes scripts SQL según sea necesario:
   - Consultas: `dql_select.sql`
   - Procedimientos almacenados: `dql_procedimientos.sql`
   - Funciones: `dql_funciones.sql`
   - Triggers: `dql_triggers.sql`
   - Eventos: `dql_eventos.sql`

## Estructura de la Base de Datos
La base de datos está diseñada con las siguientes entidades:
- **Departamentos:** Administran los parques.
- **Parques:** Espacios naturales protegidos.
- **Áreas:** Divisiones dentro de los parques.
- **Especies:** Organismos vegetales, animales y minerales registrados.
- **Personal:** Trabajadores con distintas funciones.
- **Proyectos de Investigación:** Estudios sobre especies y conservación.
- **Visitantes:** Personas que ingresan a los parques.
- **Alojamientos:** Espacios para estadías temporales.

## Ejemplos de Consultas
Algunas consultas que se pueden ejecutar en la base de datos incluyen:
- **Cantidad de parques por departamento:**
   ```sql
   SELECT departamento_id, COUNT(*) AS cantidad_parques
   FROM parques
   GROUP BY departamento_id;
   ```
- **Superficie total de parques por departamento:**
   ```sql
   SELECT departamento_id, SUM(superficie) AS superficie_total
   FROM parques
   GROUP BY departamento_id;
   ```
- **Inventario de especies por tipo:**
   ```sql
   SELECT tipo_especie, COUNT(*) AS cantidad_especies
   FROM especies
   GROUP BY tipo_especie;
   ```

## Procedimientos, Funciones, Triggers y Eventos
- **Procedimientos almacenados:** Automatizan la gestión de parques, áreas, especies y visitantes.
- **Funciones SQL:** Calculan valores clave como la superficie total por departamento y costos operativos.
- **Triggers:** Controlan cambios en los datos, como actualización de inventarios al registrar nuevas especies.
- **Eventos:** Generan reportes automáticos y actualizan datos periódicamente.

## Roles de Usuario y Permisos
Se han definido cinco tipos de usuarios con permisos específicos:
1. **Administrador:** Acceso total al sistema.
2. **Gestor de parques:** Administración de parques, áreas y especies.
3. **Investigador:** Acceso a datos de proyectos y especies.
4. **Auditor:** Acceso a reportes financieros.
5. **Encargado de visitantes:** Gestión de visitantes y alojamientos.

Para asignar roles, ejecuta:
```sql
CREATE USER 'gestor'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE ON base_datos.parques TO 'gestor'@'localhost';
```

## Estructura del Repositorio
El repositorio sigue una organización clara y estructurada:
```
Los_Ambientales/
│-- ddl.sql              # Creación de la base de datos y tablas
│-- dml.sql              # Inserción de datos de ejemplo
│-- dql_select.sql       # Consultas SQL
│-- dql_procedimientos.sql # Procedimientos almacenados
│-- dql_funciones.sql    # Funciones definidas en SQL
│-- dql_triggers.sql     # Triggers
│-- dql_eventos.sql      # Eventos programados
│-- README.md            # Documentación del proyecto
│-- Diagrama.jpg         # Modelo de datos
```

## Contribuciones
Si el proyecto fue desarrollado en grupo, cada integrante debe indicar su contribución aquí:
- **Integrante 1:** Diseño del modelo de base de datos.
- **Integrante 2:** Implementación de consultas y procedimientos almacenados.
- **Integrante 3:** Creación de triggers y eventos.
- **Integrante 4:** Documentación y pruebas.

## Licencia y Contacto
Para consultas, contacta a: **laiacarrilloes@gmail.com**.

---


