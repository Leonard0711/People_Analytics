USE RECRUITMENT;
CREATE TABLE IF NOT EXISTS candidatos (
    id_candidato INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    edad INT NOT NULL,
    sexo VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS puestos (
    id_puesto INT PRIMARY KEY AUTO_INCREMENT,
    nombre_puesto VARCHAR(50) NOT NULL,
    area VARCHAR(50) NOT NULL 
);
CREATE TABLE IF NOT EXISTS postulaciones (
    id_postulacion INT PRIMARY KEY AUTO_INCREMENT,
    id_candidato INT,
    id_puesto INT,
    fecha_postulacion DATETIME NOT NULL,
    resultado VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_candidato) REFERENCES candidatos(id_candidato),
    FOREIGN KEY (id_puesto) REFERENCES puestos(id_puesto)
);

CREATE TABLE IF NOT EXISTS entrevistas (
    id_entrevista INT PRIMARY KEY AUTO_INCREMENT,
    id_postulacion INT NOT NULL,
    fecha_entrevista DATETIME NOT NULL,
    puntaje DECIMAL(5,2) NOT NULL,
    comentarios VARCHAR(255),
    FOREIGN KEY (id_postulacion) REFERENCES postulaciones(id_postulacion)
);

CREATE TABLE IF NOT EXISTS fuentes (
    id_fuente INT PRIMARY KEY AUTO_INCREMENT,
    nombre_fuente VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS canales (
    id_postulacion INT,
    id_fuente INT,
    PRIMARY KEY (id_postulacion, id_fuente),
    FOREIGN KEY (id_postulacion) REFERENCES postulaciones(id_postulacion),
    FOREIGN KEY (id_fuente) REFERENCES fuentes(id_fuente)
);

CREATE TABLE IF NOT EXISTS reclutadores (
    id_reclutador INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS asignaciones (
    id_postulacion INT,
    id_reclutador INT,
    PRIMARY KEY (id_postulacion, id_reclutador),
    FOREIGN KEY (id_postulacion) REFERENCES postulaciones(id_postulacion),
    FOREIGN KEY (id_reclutador) REFERENCES reclutadores(id_reclutador)
);


