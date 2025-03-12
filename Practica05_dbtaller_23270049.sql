DROP DATABASE IF EXISTS Practica05_dbtaller_23270049;
CREATE DATABASE Practica05_dbtaller_23270049;
USE Practica05_dbtaller_23270049;

-- Tablas Padre

CREATE TABLE Linea_Investigacion (
    clave_inv VARCHAR(10) PRIMARY KEY,
    nombre_linea VARCHAR(45)
);

CREATE TABLE Tipo_Proyecto (
    tipo VARCHAR(2) PRIMARY KEY,
    nombre_tipo VARCHAR(45)
);

CREATE TABLE Profesor (
    clave_profesor VARCHAR(10) PRIMARY KEY,
    nombre_profesor VARCHAR(45),
    rubrica_id INT,                      -- Relaciona a Rubrica
    rubrica_area_conocimiento_id INT,    -- Campo opcional para información adicional
    CONSTRAINT Califica_Segun FOREIGN KEY (rubrica_id) REFERENCES Rubrica(id_rubrica)
);

-- Insertar ejemplos en Linea_Investigacion (áreas de conocimiento)
INSERT INTO Linea_Investigacion (clave_inv, nombre_linea) VALUES
('L01', 'Redes de Computadoras'),
('L02', 'Base de Datos'),
('L03', 'Ingeniería de Software'),
('L04', 'Arquitectura de Computadoras'),
('L05', 'Tesis');

-- Tablas Hijas

CREATE TABLE Proyectos (
    clave_proyecto VARCHAR(10) PRIMARY KEY,
    nombre_proyecto VARCHAR(45),
    clave_inv VARCHAR(10),
    tipo VARCHAR(2),
    clave_profesor VARCHAR(10), 
    CONSTRAINT Pertenece FOREIGN KEY (clave_inv) REFERENCES Linea_Investigacion(clave_inv),
    CONSTRAINT Aplica FOREIGN KEY (tipo) REFERENCES Tipo_Proyecto(tipo),
    CONSTRAINT Asesora FOREIGN KEY (clave_profesor) REFERENCES Profesor(clave_profesor)
);

CREATE TABLE Alumno (
    numero_control VARCHAR(10) PRIMARY KEY,
    nombre_alumno VARCHAR(40),
    clave_proyecto VARCHAR(10),
    clave_inv VARCHAR(10), 
    tipo VARCHAR(2),
    clave_profesor VARCHAR(10), 
    CONSTRAINT Requiere FOREIGN KEY (clave_proyecto) REFERENCES Proyectos(clave_proyecto),
    CONSTRAINT Proviene_del_Proyecto FOREIGN KEY (clave_inv) REFERENCES Linea_Investigacion(clave_inv),
    CONSTRAINT Aplica_del_proyecto FOREIGN KEY (tipo) REFERENCES Tipo_Proyecto(tipo),
    CONSTRAINT Asesora_del_proyecto FOREIGN KEY (clave_profesor) REFERENCES Profesor(clave_profesor)
);

CREATE TABLE Revisor (
    Clave_R INT PRIMARY KEY,
    Nombre_Revisor VARCHAR(45),
    Calificacion INT,
    clave_proyecto VARCHAR(10),
    clave_inv VARCHAR(10), 
    tipo VARCHAR(2), 
    clave_profesor VARCHAR(10), 
    CONSTRAINT Requiere_2 FOREIGN KEY (clave_proyecto) REFERENCES Proyectos(clave_proyecto),
    CONSTRAINT Proviene_2 FOREIGN KEY (clave_inv) REFERENCES Linea_Investigacion(clave_inv),
    CONSTRAINT Aplica_2 FOREIGN KEY (tipo) REFERENCES Tipo_Proyecto(tipo),
    CONSTRAINT Asesora_2 FOREIGN KEY (clave_profesor) REFERENCES Profesor(clave_profesor)
);

-- Nueva Tabla: Rubrica
-- Se relaciona con Linea_Investigacion a través de clave_inv para definir el área de conocimiento.
CREATE TABLE Rubrica (
    id_rubrica INT AUTO_INCREMENT PRIMARY KEY,
    numero CHAR(7),
    indicador VARCHAR(120) NOT NULL,
    descripcion VARCHAR(250) NOT NULL,
    ponderacion DECIMAL(5,2) NOT NULL,
    evaluacion DECIMAL(5,2) NOT NULL,
    clave_inv VARCHAR(10) NOT NULL,
    CONSTRAINT fk_rubrica_linea FOREIGN KEY (clave_inv) REFERENCES Linea_Investigacion(clave_inv)
);

-- Insertar datos de ejemplo en Rubrica (valores genéricos)
INSERT INTO Rubrica (numero, indicador, descripcion, ponderacion, evaluacion, clave_inv)
VALUES 
('RDC001', 'Conectividad', 'Evalúa la eficiencia de la red', 30.00, 90.00, 'L01'),
('BD002', 'Integridad', 'Evalúa la robustez de la base de datos', 25.00, 85.00, 'L02'),
('IS003', 'Calidad', 'Evalúa el desarrollo de software', 20.00, 88.00, 'L03'),
('AC004', 'Eficiencia', 'Evalúa la arquitectura de computadoras', 15.00, 80.00, 'L04'),
('TES005', 'Originalidad', 'Evalúa el trabajo de tesis', 10.00, 95.00, 'L05');

-- Nueva Tabla: Matriz de Derechos de Acceso
CREATE TABLE Matriz_Derechos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_usuario VARCHAR(30) NOT NULL,  
    objeto VARCHAR(50) NOT NULL,           
    privilegios VARCHAR(100) NOT NULL     
);

-- Matriz de Derechos
INSERT INTO Matriz_Derechos (tipo_usuario, objeto, privilegios)
VALUES 
('Administrador', 'Linea_Investigacion', 'SELECT, INSERT, UPDATE, DELETE'),
('Administrador', 'Tipo_Proyecto', 'SELECT, INSERT, UPDATE, DELETE'),
('Administrador', 'Profesor', 'SELECT, INSERT, UPDATE, DELETE'),
('Administrador', 'Proyectos', 'SELECT, INSERT, UPDATE, DELETE'),
('Administrador', 'Alumno', 'SELECT, INSERT, UPDATE, DELETE'),
('Administrador', 'Revisor', 'SELECT, INSERT, UPDATE, DELETE'),
('Administrador', 'Rubrica', 'SELECT, INSERT, UPDATE, DELETE'),
('Profesor', 'Proyectos', 'SELECT, INSERT, UPDATE'),
('Profesor', 'Alumno', 'SELECT, INSERT'),
('Profesor', 'Revisor', 'SELECT'),
('Profesor', 'Rubrica', 'SELECT'),
('Alumno', 'Proyectos', 'SELECT'),
('Alumno', 'Alumno', 'SELECT'),
('Alumno', 'Rubrica', 'SELECT'),
('Revisor', 'Proyectos', 'SELECT, UPDATE'),
('Revisor', 'Revisor', 'SELECT, UPDATE'),
('Revisor', 'Rubrica', 'SELECT');

-- Creación de Usuarios y asignación de privilegios
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'adminpass';
CREATE USER 'profesor'@'localhost' IDENTIFIED BY 'profpass';
CREATE USER 'alumno'@'localhost' IDENTIFIED BY 'alumnopass';
CREATE USER 'revisor'@'localhost' IDENTIFIED BY 'revisorpass';

GRANT SELECT, INSERT, UPDATE, DELETE ON Practica05_dbtaller_23270049.* TO 'admin'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Practica05_dbtaller_23270049.Proyectos TO 'profesor'@'localhost';
GRANT SELECT, INSERT ON Practica05_dbtaller_23270049.Alumno TO 'profesor'@'localhost';
GRANT SELECT ON Practica05_dbtaller_23270049.Revisor TO 'profesor'@'localhost';
GRANT SELECT ON Practica05_dbtaller_23270049.Rubrica TO 'profesor'@'localhost';

GRANT SELECT ON Practica05_dbtaller_23270049.Proyectos TO 'alumno'@'localhost';
GRANT SELECT ON Practica05_dbtaller_23270049.Alumno TO 'alumno'@'localhost';
GRANT SELECT ON Practica05_dbtaller_23270049.Rubrica TO 'alumno'@'localhost';

GRANT SELECT, UPDATE ON Practica05_dbtaller_23270049.Revisor TO 'revisor'@'localhost';
GRANT SELECT ON Practica05_dbtaller_23270049.Proyectos TO 'revisor'@'localhost';
GRANT SELECT ON Practica05_dbtaller_23270049.Rubrica TO 'revisor'@'localhost';

FLUSH PRIVILEGES;


# Fin del script
