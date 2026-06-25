USE RECRUITMENT;

-- Efectividad de las fuentes de reclutamiento
SELECT
    f.id_fuente,
    f.nombre_fuente,
    ROUND(
        SUM(CASE WHEN p.estado_postulacion = 'Contratado' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS efectividad
FROM fuentes AS f
JOIN postulaciones AS p
    ON f.id_fuente = p.id_fuente
GROUP BY f.id_fuente, f.nombre_fuente
ORDER BY efectividad DESC;

-- Conversión entre etapas
WITH etapas_totales AS (
    SELECT
        et.orden_etapa,
        et.nombre_etapa,
        COUNT(*) AS total
    FROM etapas AS et
    JOIN evaluaciones AS ev
        ON et.id_etapa = ev.id_etapa
    GROUP BY et.id_etapa, et.nombre_etapa, et.orden_etapa
)
SELECT
    orden_etapa,
    nombre_etapa,
    total,
    LEAD(total) OVER(ORDER BY orden_etapa) AS siguiente_total,
    ROUND(
        LEAD(total) OVER(ORDER BY orden_etapa) * 100.0 / total, 2
    ) AS conversion_siguiente
FROM etapas_totales
ORDER BY orden_etapa;

-- Puntaje promedio por etapa
SELECT
    et.id_etapa,
    et.nombre_etapa,
    et.orden_etapa,
    AVG(ev.puntaje) AS avg_puntaje
FROM etapas AS et
JOIN evaluaciones AS ev
    ON et.id_etapa = ev.id_etapa
GROUP BY et.id_etapa, et.nombre_etapa, et.orden_etapa
ORDER BY et.orden_etapa;

-- Promedio de tiempo por transición de etapas
WITH transiciones AS (
    SELECT
        et.nombre_etapa AS etapa_actual,
        LEAD(et.nombre_etapa) OVER(
            PARTITION BY ev.id_postulacion
            ORDER BY ev.fecha_evaluacion, ev.id_evaluacion
        ) AS etapa_siguiente,
        DATEDIFF(
            LEAD(ev.fecha_evaluacion) OVER(
                PARTITION BY ev.id_postulacion
                ORDER BY ev.fecha_evaluacion, ev.id_evaluacion
            ), ev.fecha_evaluacion
        ) AS dias
    FROM etapas AS et
    JOIN evaluaciones AS ev
        ON et.id_etapa = ev.id_etapa
)
SELECT
    etapa_actual,
    etapa_siguiente,
    AVG(dias) AS promedio_dias
FROM transiciones
WHERE etapa_siguiente IS NOT NULL
GROUP BY etapa_actual, etapa_siguiente;

-- Tiempo promedio de cobertura por puesto
SELECT
    p.id_puesto,
    p.nombre_puesto,
    ROUND(
        AVG(
            DATEDIFF(r.fecha_cierre, r.fecha_requerimiento)
        )
    , 2) AS promedio_dias
FROM puestos AS p
JOIN requerimientos AS r
    ON p.id_puesto = r.id_puesto
GROUP BY p.id_puesto, p.nombre_puesto;

-- Fuentes de reclutamiento generaron más ingreso de personal
SELECT
    f.id_Fuente,
    f.nombre_fuente,
    COUNT(*) AS cantidad_contratados
FROM fuentes AS f
LEFT JOIN postulaciones AS p
    ON f.id_fuente = p.id_fuente
        AND p.estado_postulacion = 'Contratado'
GROUP BY f.id_fuente, f.nombre_fuente
ORDER BY cantidad_contratados;

-- Cantidad de postulantes por puesto
SELECT
    p.id_puesto,
    p.nombre_puesto,
    COUNT(*) AS cantidad_postulantes
FROM requerimientos AS r
JOIN puestos AS p
    ON r.id_puesto = p.id_puesto
JOIN postulaciones AS pos
    ON pos.id_requerimiento = r.id_requerimiento
GROUP BY p.id_puesto, p.nombre_puesto
ORDER BY cantidad_postulantes DESC;

-- Tasa de aprobación por etapa
SELECT
    et.id_etapa,
    et.nombre_etapa,
    COUNT(*) AS total_evaluados,
    SUM(
        CASE WHEN e.resultado_etapa = 'Aprobado' THEN 1 ELSE 0 END
    ) AS cantidad_aprobados,
    ROUND(
        SUM(
            CASE WHEN  e.resultado_etapa = 'Aprobado' THEN 1 ELSE 0 END
        ) * 100.0 / COUNT(*)
    , 2) AS tasa_aprobados
FROM etapas AS et
LEFT JOIN evaluaciones AS e
    ON et.id_etapa = e.id_etapa
GROUP BY et.id_etapa, et.nombre_etapa
ORDER BY et.orden_etapa;

-- Tasa de contrataciones por reclutador
SELECT
	r.id_reclutador,
	r.nombre,
	COUNT(*) AS cantidad_postulantes,
	SUM(
		CASE WHEN p.estado_postulacion = 'Contratado' THEN 1 ELSE 0 END) AS cantidad_contratados,
	ROUND(
		SUM(
		CASE WHEN p.estado_postulacion = 'Contratado' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)
	, 2) AS tasa_contratados
FROM requerimientos AS req
JOIN reclutadores AS r
	ON req.id_reclutador = req.id_reclutador
JOIN postulaciones AS p
	ON req.id_requerimiento = p.id_requerimiento
GROUP BY r.id_reclutador, r.nombre 
ORDER BY cantidad_contratados DESC; 

-- Candidatos que han postulado más de una vez a un mismo puesto y cuántas veces lo han hecho
SELECT
    c.id_candidato,
    c.nombre,
    p.id_puesto,
    p.nombre_puesto,
    COUNT(*) AS veces
FROM requerimientos AS r
JOIN postulaciones AS pos
    ON r.id_requerimiento = pos.id_requerimiento
JOIN puestos AS p
    ON r.id_puesto = p.id_puesto
JOIN candidatos AS c
    ON pos.id_candidato = c.id_candidato
GROUP BY c.id_candidato, c.nombre, p.id_puesto, p.nombre_puesto
HAVING COUNT(*) > 1
ORDER BY veces DESC;

-- Cantidad de postulaciones de cada candidato por puesto
SELECT
    c.id_candidato,
    c.nombre,
    p.nombre_puesto,
    COUNT(*) AS veces
FROM requerimientos r
JOIN postulaciones pos
    ON r.id_requerimiento = pos.id_requerimiento
JOIN puestos p
    ON r.id_puesto = p.id_puesto
JOIN candidatos c
    ON pos.id_candidato = c.id_candidato
GROUP BY c.id_candidato, c.nombre, p.id_puesto, p.nombre_puesto
ORDER BY c.nombre, veces DESC;



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
