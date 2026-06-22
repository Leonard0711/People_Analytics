USE RECRUITMENT;

CREATE TABLE IF NOT EXISTS postulaciones (
    id_postulacion INT PRIMARY KEY AUTO_INCREMENT,
    id_candidato INT NOT NULL,
    id_requerimiento INT NOT NULL,
    id_fuente INT NOT NULL,
    fecha_postulacion DATE NOT NULL,
    estado_postulacion ENUM('En Proceso', 'Contratado', 'No Contratado', 'Retirado') NOT NULL,
    FOREIGN KEY (id_candidato) REFERENCES candidatos(id_candidato),
    FOREIGN KEY (id_requerimiento) REFERENCES requerimientos(id_requerimiento),
    FOREIGN KEY (id_fuente) REFERENCES fuentes(id_fuente)
);