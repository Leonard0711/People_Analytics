USE RRHH;
CREATE TABLE IF NOT EXISTS rotacion (
    id_rotacion INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL,
    estado_baja DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    motivo_baja VARCHAR(255),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);