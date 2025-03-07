-- Tabla Departamento
CREATE TABLE Departamento (
    id_departamento INT PRIMARY KEY,
    nombre VARCHAR(100),
    FOREIGN KEY (id_entidad) REFERENCES Entidad(id_entidad)
);
-- Entidad
CREATE TABLE Entidad(
    id_entidad INT PRIMARY KEY,
    nombre VARCHAR(150)
)

-- Relacion Departamento - Entidad
CREATE TABLE Departamento_Entidad (
    id_departamento INT,
    id_entidad INT,
    PRIMARY KEY (id_departamento, id_entidad),
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento),
    FOREIGN KEY (id_entidad) REFERENCES Entidad(id_entidad)
);

-- Tabla Parque
CREATE TABLE Parque (
    id_parque INT PRIMARY KEY,
    nombre VARCHAR(150),
    fecha_declaracion DATE
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
    id_area INT PRIMARY KEY,
    id_parque INT,
    nombre VARCHAR(150),
    extension DECIMAL(10,2),
    FOREIGN KEY (id_parque) REFERENCES Parque(id_parque)
);

-- Tabla Especie
CREATE TABLE Especie (
    id_especie INT PRIMARY KEY,
    nombre_cientifico VARCHAR(200),
    nombre_vulgar VARCHAR(150),
    tipo ENUM('Vegetal', 'Animal', 'Mineral'),
    inventario_individuos INT,
    FOREIGN KEY (id_area) REFERENCES Area(id_area)
);

-- Relación entre Especie y Área (Muchos a Muchos)
CREATE TABLE Especie_Area (
    id_especie INT,
    id_area INT,
    num_inventario INT,
    PRIMARY KEY (id_especie, id_area),
    FOREIGN KEY (id_especie) REFERENCES Especie(id_especie),
    FOREIGN KEY (id_area) REFERENCES Area(id_area)
);

-- Tabla Personal
CREATE TABLE Personal (
    id_personal INT PRIMARY KEY,
    tipo_documento VARCHAR(100),
    documento INT UNIQUE
    nombre VARCHAR(150),
    direccion VARCHAR(100),
    telefono VARCHAR(20),
    sueldo DECIMAL(10,2)
    rol ENUM('Gestion', 'Vigilancia', 'Conservacion', 'Investigacion')
);


-- Tabla Proyecto de Investigación
CREATE TABLE Proyecto_Investigacion (
    id_proyecto INT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    presupuesto DECIMAL(10,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

-- Relación entre Investigador y Proyecto 
CREATE TABLE Proyecto_Investigador (
    id_proyecto INT,
    id_investigador INT,
    PRIMARY KEY (id_proyecto, id_investigador),
    FOREIGN KEY (id_proyecto) REFERENCES Proyecto_Investigacion(id_proyecto),
    FOREIGN KEY (id_personal) REFERENCES Personal(id_personal)
);

-- Relación entre Proyecto, Especie e Investigador 
CREATE TABLE Proyecto_Especie (
    id_proyecto INT,
    id_especie INT,
    PRIMARY KEY (id_proyecto, id_especie),
    FOREIGN KEY (id_proyecto) REFERENCES Proyecto_Investigacion(id_proyecto),
    FOREIGN KEY (id_especie) REFERENCES Especie(id_especie),
);

-- Tabla Visitante
CREATE TABLE Visitante (
    id_visitante INT PRIMARY KEY,
    cedula VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(100),
    profesion VARCHAR(100)
);

-- Tabla Alojamiento
CREATE TABLE Alojamiento (
    id_alojamiento INT PRIMARY KEY,
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
    id_vehiculo INT PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
);

