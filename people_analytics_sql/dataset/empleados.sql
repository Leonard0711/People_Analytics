USE RRHH;
CREATE TABLE IF NOT EXISTS empleados(
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    genero VARCHAR(10) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    area VARCHAR(20) NOT NULL,
    cargo VARCHAR(20),
    fecha_ingreso DATE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    id_jefe INT,
    FOREIGN KEY (id_jefe) REFERENCES empleados(id_empleado)
);