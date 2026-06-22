USE RECRUITMENT;

CREATE TABLE IF NOT EXISTS candidatos (
    id_candidato INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono INT,
    email VARCHAR(50) NOT NULL,
    sexo ENUM('M', 'F') NOT NULL
);