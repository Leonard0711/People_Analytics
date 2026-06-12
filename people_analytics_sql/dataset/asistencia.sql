USE RRHH;
CREATE TABLE IF NOT EXISTS asistencia (
    id_asistencia INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL,
    fecha DATE NOT NULL,
    hora_trabajadas TIME NOT NULL,
    tardanzas INT NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);