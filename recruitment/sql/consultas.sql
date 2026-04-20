USE recruitment;

-- Consulta donde devuelva las 5 fuentes (fuentes) que tienen mayor número de 
-- registros cuyo resultado es 'aceptado', junto con cuántos ingresos tuvo cada una.
SELECT f.nombre_fuente, COUNT(*) AS cantidad_ingresos   
FROM fuentes f
JOIN canales c ON f.id_fuente = c.id_fuente
JOIN postulaciones p ON c.id_postulacion = p.id_postulacion
WHERE p.resultado = 'aceptado'
GROUP BY f.nombre_fuente
ORDER BY cantidad_ingresos DESC
LIMIT 5;

WITH aceptados_por_fuente AS (
    SELECT f.nombre_fuente, COUNT(*) AS cantidad_aceptados
    FROM fuentes f
    JOIN canales c ON f.id_fuente = c.id_fuente
    JOIN postulaciones p ON c.id_postulacion = p.id_postulacion
    WHERE p.resultado = 'aceptado'
    GROUP BY f.nombre_fuente
)
SELECT nombre_fuente, cantidad_aceptados
FROM aceptados_por_fuente
ORDER BY cantidad_aceptados DESC
LIMIT 5;

-- Mostrar el total de postulaciones por área del puesto.
SELECT
    pu.area,
    COUNT(*) AS cantidad_postulaciones
FROM puestos AS pu
WHERE po.id_puesto = pu.id_puesto
GROUP BY pu.area;

-- Listar los candidatos que han postulado a más de un puesto.
SELECT
    ca.id_candidato,
    ca.nombre
FROM candidados AS ca
JOIN postulaciones AS po
ON po.id_candidato = ca.id_candidato
GROUP BY ca.id_candidato, ca.nombre
HAVING COUNT(DISTINCT po.id_puesto) > 1;

-- Obtener la cantidad de candidatos aceptados por fuente de reclutamiento.
SELECT
    fu.id_fuente,
    fu.nombre_fuente,
    COUNT(DISTINCT po.id_candidato) AS cnt_candidatos
FROM canales AS can
JOIN postulaciones AS po
ON po.id_postulacion = can.id_postulacion
JOIN fuentes AS fu
ON fu.id_fuente = can.id_fuente
WHERE po.resultado = 'aceptado'
GROUP BY fu.id_fuente, fu.nombre_fuente;

-- Mostrar cada puesto con el número total de entrevistas realizadas.
SELECT
    pu.id_puesto,
    pu.nombre_puesto,
    COUNT(DISTINCT en.id_entrevista) AS cnt_entrevistas
FROM puestos AS pu
JOIN postulaciones AS po
ON po.id_puesto = pu.id_puesto
JOIN entrevistas AS en
ON en.id_postulacion = po.id_postulacion
GROUP BY pu.id_puesto, pu.nombre_puesto;

-- Listar los reclutadores y cuántas postulaciones gestionaron.
SELECT
    re.id_reclutador,
    re.nombre,
    COUNT(DISTINCT asig.id_postulacion) AS cnt_postulaciones
FROM asignaciones AS asig
JOIN reclutadores AS re
ON re.id_reclutador = asig.id_reclutador
GROUP BY re.id_reclutador, re.nombre;

-- Mostrar candidatos cuyo número de entrevistas está por encima del promedio general.
SELECT
    ca.id_candidato,
    ca.nombre,
    COUNT(DISTINCT en.id_entrevista) AS cnt_entrevistas
FROM candidatos AS ca
JOIN postulaciones AS po
ON po.id_candidato = ca.id_candidato
JOIN entrevistas AS en
ON en.id_postulacion = po.id_postulacion
GROUP BY ca.id_candidato, ca.nombre
HAVING COUNT(DISTINCT en.id_entrevista) > (
    SELECT AVG(cnt1_entrevistas)
    FROM (
        SELECT COUNT(DISTINCT en2.id_entrevista) AS cnt1_entrevistas
        FROM candidatos AS ca2
        JOIN postulaciones AS po2
        ON po2.id_candidato = ca2.id_candidato
        JOIN entrevistas AS en2
        ON en2.id_postulacion = po2.id_postulacion
        GROUP BY ca2.id_candidato
    ) AS subquery
);

-- Listar los puestos que tienen más postulaciones que el promedio de postulaciones por puesto.
SELECT
    pu.id_puesto,
    pu.nombre_puesto,
    COUNT(DISTINCT po.id_postulacion) AS cnt_postulaciones
FROM puestos AS pu
JOIN postulaciones AS po
ON po.id_puesto = pu.id_puesto
GROUP BY pu.id_puesto, pu.nombre_puesto
HAVING COUNT(DISTINCT po.id_postulacion) > (
    SELECT AVG(cnt1_postulaciones)
    FROM (
        SELECT COUNT(DISTINCT po2.id_postulacion) AS cnt1_postulaciones
        FROM puestos AS pu2
        JOIN postulaciones AS po2
        ON po2.id_puesto = pu2.id_puesto
        GROUP BY pu2.id_puesto
    ) AS subquery
);
