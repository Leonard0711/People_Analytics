USE RECRUITMENT;

CREATE TABLE IF NOT EXISTS puestos (
    id_puesto INT PRIMARY KEY AUTO_INCREMENT,
    nombre_puesto VARCHAR(50) NOT NULL,
    id_area INT NOT NULL,
    descripcion_puesto VARCHAR(255) NOT NULL
)