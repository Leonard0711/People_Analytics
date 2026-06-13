USE RRHH;
CREATE TABLE IF NOT EXISTS asistencia (
    id_asistencia INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL,
    fecha DATE NOT NULL,
    hora_trabajadas DECIMAL(10,2) NOT NULL,
    tardanzas INT NOT NULL,
    ausencias INT NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);