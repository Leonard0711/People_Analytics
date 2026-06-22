USE RECRUITMENT;

CREATE TABLE IF NOT EXISTS requerimientos (
    id_requerimiento INT PRIMARY KEY AUTO_INCREMENT,
    id_reclutador INT NOT NULL,
    id_puesto INT NOT NULL,
    fecha_requerimiento DATE NOT NULL,
    estado ENUM('Abierto', 'En Proceso', 'Cerrado') NOT NULL,
    vacantes INT NOT NULL,
    FOREIGN KEY (id_reclutador) REFERENCES reclutadores(id_reclutador),
    FOREIGN KEY (id_puesto) REFERENCES puestos(id_puesto)
);