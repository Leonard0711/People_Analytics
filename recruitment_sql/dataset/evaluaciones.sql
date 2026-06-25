USE RECRUITMENT;

CREATE TABLE IF NOT EXISTS evaluaciones (
    id_evaluacion INT PRIMARY KEY AUTO_INCREMENT,
    id_postulacion INT NOT NULL,
    id_etapa INT NOT NULL,
    fecha_evaluacion DATE NOT NULL,
    puntaje INT NOT NULL,
    resultado_etapa VARCHAR(30) NOT NULL,
    comentarios VARCHAR(255),
    FOREIGN KEY (id_postulacion) REFERENCES postulaciones(id_postulacion),
    FOREIGN KEY (id_etapa) REFERENCES etapas(id_etapa)
);

ALTER TABLE evaluaciones MODIFY COLUMN resultado_etapa ENUM('Aprobado', 'Desaprobado', 'Retirado');

SHOW COLUMNS FROM evaluaciones;