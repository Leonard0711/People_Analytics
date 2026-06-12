USE RRHH;
CREATE TABLE IF NOT EXISTS desempeno (
    id_desempeno INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT NOT NULL,
    periodo VARCHAR(20),
    score_rendimiento DECIMAL(5, 2),
    fecha_evaluacion DATE NOT NULL,
    objetivo_cumplido INT NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

