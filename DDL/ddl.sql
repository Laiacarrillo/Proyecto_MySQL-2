-- Crear la base de datos y usarla
CREATE DATABASE Ambiental;
USE Ambiental;

-- Tabla Entidad
CREATE TABLE Entidad(
    id_entidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL
);

-- Tabla Departamento
CREATE TABLE Departamento(
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_entidad INT, 
    FOREIGN KEY (id_entidad) REFERENCES Entidad(id_entidad)
);

-- Tabla Parque
CREATE TABLE Parque (
    id_parque INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    fecha_declaracion DATE NOT NULL
);

-- Relación Parque - Departamento 
CREATE TABLE Parque_Departamento (
    id_parque INT,
    id_departamento INT,
    PRIMARY KEY (id_parque, id_departamento),
    FOREIGN KEY (id_parque) REFERENCES Parque(id_parque),
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
);

-- Tabla Área dentro de un parque
CREATE TABLE Area (
    id_area INT AUTO_INCREMENT PRIMARY KEY,
    id_parque INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    extension DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_parque) REFERENCES Parque(id_parque)
);

-- Tabla Especie
CREATE TABLE Especie (
    id_especie INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cientifico VARCHAR(200) NOT NULL,
    nombre_vulgar VARCHAR(150),
    tipo ENUM('Vegetal', 'Animal', 'Mineral') NOT NULL,
    inventario_individuos INT NOT NULL
);

-- Relación entre Especie y Área (Muchos a Muchos)
CREATE TABLE Especie_Area (
    id_especie INT,
    id_area INT,
    num_inventario INT NOT NULL,
    PRIMARY KEY (id_especie, id_area),
    FOREIGN KEY (id_especie) REFERENCES Especie(id_especie),
    FOREIGN KEY (id_area) REFERENCES Area(id_area)
);

-- Tabla Personal 
CREATE TABLE Personal (
    id_personal INT AUTO_INCREMENT PRIMARY KEY,
    tipo_documento VARCHAR(100) NOT NULL,
    documento INT UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    sueldo DECIMAL(10,2) NOT NULL,
    rol ENUM('Gestion', 'Vigilancia', 'Conservacion', 'Investigacion') NOT NULL
);

-- Tabla Proyecto de Investigación
CREATE TABLE Proyecto_Investigacion (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    presupuesto DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

-- Relación entre Personal (Investigador) y Proyecto 
CREATE TABLE Proyecto_Investigador (
    id_proyecto INT,
    id_personal INT,
    PRIMARY KEY (id_proyecto, id_personal),
    FOREIGN KEY (id_proyecto) REFERENCES Proyecto_Investigacion(id_proyecto),
    FOREIGN KEY (id_personal) REFERENCES Personal(id_personal)
);

-- Relación entre Proyecto y Especie
CREATE TABLE Proyecto_Especie (
    id_proyecto INT,
    id_especie INT,
    PRIMARY KEY (id_proyecto, id_especie),
    FOREIGN KEY (id_proyecto) REFERENCES Proyecto_Investigacion(id_proyecto),
    FOREIGN KEY (id_especie) REFERENCES Especie(id_especie)
);

-- Tabla Visitante
CREATE TABLE Visitante (
    id_visitante INT AUTO_INCREMENT PRIMARY KEY,
    cedula VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(100),
    profesion VARCHAR(100)
);

-- Tabla Alojamiento
CREATE TABLE Alojamiento (
    id_alojamiento INT AUTO_INCREMENT PRIMARY KEY,
    id_parque INT NOT NULL,
    capacidad INT NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    FOREIGN KEY (id_parque) REFERENCES Parque(id_parque)
);

-- Relación entre Visitante y Alojamiento (Muchos a Muchos)
CREATE TABLE Visitante_Alojamiento (
    id_visitante INT,
    id_alojamiento INT,
    PRIMARY KEY (id_visitante, id_alojamiento),
    FOREIGN KEY (id_visitante) REFERENCES Visitante(id_visitante),
    FOREIGN KEY (id_alojamiento) REFERENCES Alojamiento(id_alojamiento)
);

-- Tabla Vehiculo
CREATE TABLE Vehiculo (
    id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL
);

-- Tablas DQL

-- Crear la tabla Reportes
CREATE TABLE Reportes (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear la tabla Pagos
CREATE TABLE Pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_alojamiento INT NOT NULL,
    pago_total DECIMAL(10,2) NOT NULL,
    fecha_pago DATE NOT NULL,
    FOREIGN KEY (id_alojamiento) REFERENCES Alojamiento(id_alojamiento)
);

-- Crear la tabla Log_Operaciones
CREATE TABLE Log_Operaciones (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    descripcion TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear la tabla Log_Salarios
CREATE TABLE Log_Salarios (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_personal INT NOT NULL,
    sueldo_anterior DECIMAL(10,2) NOT NULL,
    sueldo_nuevo DECIMAL(10,2) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_personal) REFERENCES Personal(id_personal)
);
-- Crear el usuario Administrador con acceso total
CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'password_administrador';
GRANT ALL PRIVILEGES ON ambientalistas.* TO 'administrador'@'localhost';

-- Crear el usuario Gestor de parques con permisos específicos
CREATE USER 'gestor_parques'@'localhost' IDENTIFIED BY 'password_gestor_parques';
GRANT SELECT, INSERT, UPDATE, DELETE ON ambientalistas.Parque TO 'gestor_parques'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON ambientalistas.Area TO 'gestor_parques'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON ambientalistas.Especie TO 'gestor_parques'@'localhost';

-- Crear el usuario Investigador con permisos específicos
CREATE USER 'investigador'@'localhost' IDENTIFIED BY 'password_investigador';
GRANT SELECT ON ambientalistas.Proyecto_Investigacion TO 'investigador'@'localhost';
GRANT SELECT ON ambientalistas.Especie TO 'investigador'@'localhost';

-- Crear el usuario Auditor con permisos específicos
CREATE USER 'auditor'@'localhost' IDENTIFIED BY 'password_auditor';
GRANT SELECT ON ambientalistas.Auditoria_Visitante TO 'auditor'@'localhost';
GRANT SELECT ON ambientalistas.Auditoria_Personal TO 'auditor'@'localhost';
GRANT SELECT ON ambientalistas.Auditoria_Vehiculo TO 'auditor'@'localhost';
GRANT SELECT ON ambientalistas.Auditoria_Especie TO 'auditor'@'localhost';
GRANT SELECT ON ambientalistas.Auditoria_Proyecto TO 'auditor'@'localhost';
GRANT SELECT ON ambientalistas.Auditoria_Departamento TO 'auditor'@'localhost';

-- Crear el usuario Encargado de visitantes con permisos específicos
CREATE USER 'encargado_visitantes'@'localhost' IDENTIFIED BY 'password_encargado_visitantes';
GRANT SELECT, INSERT, UPDATE, DELETE ON ambientalistas.Visitante TO 'encargado_visitantes'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON ambientalistas.Alojamiento TO 'encargado_visitantes'@'localhost';

-- Aplicar los cambios
FLUSH PRIVILEGES;