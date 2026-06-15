-- Active: 1756737494822@@localhost@3306@RRHH
USE RRHH;

-- 1. Consulta para calcular la edad promedio de los empleados del área de RRHH
SELECT
    ROUND(
        AVG(TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()))
    , 2) AS edad_promedio
FROM empleados
WHERE area = 'RRHH';

-- 2. Consulta para calcular la edad promedio de los empleados del área de Contabilidad
-- con el cargo de Practicante
SELECT
    ROUND(
        AVG(TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()))
    , 2) AS edad_promedio
FROM empleados
WHERE area = 'Contabilidad'
    AND cargo = 'Practicante';

-- 3. Consulta para obtener el nombre completo y el área de los empleados del área de RRHH
SELECT
    CONCAT_WS(' ', nombre, apellido) AS nombre_completo,
    area
FROM empleados
WHERE area = 'RRHH';

-- 4. Consulta para obtener el ID, nombre completo y salario de los empleados con salario 
--superior al de un empleado específico
SELECT
    id_empleado,
    CONCAT_WS(' ', nombre, apellido) AS nombre_completo
FROM empleados
WHERE salario > (
    SELECT salario
    FROM empleados
    WHERE id_empleado = 103
);

-- 5. Consulta para contar el número total de empleados que no han sido dados de baja
SELECT
    COUNT(DISTINCT e.id_empleado) AS total_empleados
FROM empleados AS e
LEFT JOIN rotacion AS r
    ON e.id_empleado = r.id_empleado
WHERE r.estado_baja = 0 
    OR r.id_empleado IS NULL;

-- 6. Consulta para obtener el promedio de rendimiento por área del año 2024,
-- considerando solo a los empleados que no han sido dados de baja
SELECT
    e.area,
    ROUND(
        AVG(d.score_rendimiento), 2
        ) AS avg_rendimiento
FROM empleados AS e
JOIN desempeno AS d
    ON e.id_empleado = d.id_empleado
WHERE e.fecha_ingreso <= '2024-12-31'
    AND NOT EXISTS (
        SELECT 1
        FROM rotacion AS r
        WHERE e.id_empleado = r.id_empleado
            AND r.estado_baja = 1
            AND r.fecha_salida < '2024-01-01'
)
AND d.fecha_evaluacion BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY e.area;

-- 7. Consulta para calcular la tasa de género de los empleados que ingresaron en el año 2024
SELECT
    genero,
    ROUND(
        COUNT(*) * 100.0 / 
        (SELECT COUNT(*)
        FROM empleados
        WHERE YEAR(fecha_ingreso) = YEAR(CURDATE()))
    , 2) AS tasa_genero
FROM empleados
WHERE YEAR(fecha_ingreso) = YEAR(CURDATE())
GROUP BY genero;

-- 8. Consulta para calcular la antigüedad promedio de los empleados del área de RRHH
SELECT
    AVG(
        TIMESTAMPDIFF(YEAR, e.fecha_ingreso, CURDATE())
    ) AS avg_antiguedad
FROM empleados AS e
WHERE e.area = 'RRHH'AND NOT EXISTS (
    SELECT 1
    FROM rotacion AS r
    WHERE e.id_empleado = r.id_empleado
        AND r.estado_baja = 1
);

-- 9. Consulta para obtener el nombre completo de los empleados que tienen el mismo jefe 
-- que el empleado con ID 169
SELECT
    e.id_empleado,
    CONCAT_WS(' ', e.nombre, e.apellido) AS nombre_completo,
    e.fecha_ingreso,
    e.area,
    e.id_jefe AS id_jefe,
    CONCAT_WS(' ', m.nombre, m.apellido) AS nombre_jefe
FROM empleados AS e
JOIN empleados AS m
    ON e.id_jefe = m.id_empleado
WHERE m.id_empleado = 200;

-- 10. Consulta para obtener el nombre completo, salario y área de los empleados
-- que trabajan en la mismo área que el empleado con ID 169
SELECT
    e.id_empleado,
    CONCAT_WS(' ', e.nombre, e.apellido) AS nombre_completo,
    e.salario,
    e.area
FROM empleados AS e
WHERE e.area = (
    SELECT
        area
    FROM empleados
    WHERE id_empleado = 169
);

-- 11. Consulta para obtener el nombre completo, área y salario de los empleados
-- con el salario mínimo por área
WITH minimo AS (
    SELECT
        id_empleado,
        CONCAT_WS(' ', nombre, apellido) AS nombre_completo,
        area,
        salario,
        ROW_NUMBER() OVER(PARTITION BY area ORDER BY salario) AS rnk_salario
    FROM empleados
)
SELECT
    id_empleado,
    nombre_completo,
    area,
    salario
FROM minimo
WHERE rnk_salario = 1;

-- 12. Consulta para obtener el nombre completo y el área de los empleados cuyo nombre contiene la letra "t"
SELECT  
    area,
    id_empleado,
    CONCAT_WS(' ', nombre, apellido) AS nombre_completo
FROM empleados
WHERE LOWER(nombre) LIKE '%t%'
ORDER BY area, nombre_completo;

-- 13. Cantidad de empleados por área que no han sido dado de baja
SELECT
    e.area,
    COUNT(*) AS total_empleados
FROM empleados AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM rotacion AS r
    WHERE e.id_empleado = r.id_empleado
        AND r.estado_baja = 1
)
GROUP BY e.area
ORDER BY total_empleados DESC;

-- 14. Cantidad de empleados con mas de 3 tardanzas en el año 2024,
-- agrupados por área, considerando solo a los empleados que no han sido dados de baja
WITH tardanzas AS (
    SELECT
        e.area,
        e.id_empleado,
        CONCAT_WS(' ', e.nombre, e.apellido) AS nombre_completo,
        SUM(a.tardanzas) AS total_tardanzas,
        ROW_NUMBER() OVER(PARTITION BY e.area ORDER BY SUM(a.tardanzas) DESC) AS rnk
    FROM empleados AS e
    JOIN asistencia AS a
        ON e.id_empleado = a.id_empleado
    WHERE a.fecha BETWEEN '2024-01-01' AND '2024-12-31'
        AND NOT EXISTS (
            SELECT 1
            FROM rotacion AS r
            WHERE e.id_empleado = r.id_empleado
                AND r.estado_baja = 1
                AND r.fecha_salida < '2024-01-01'
        )
    GROUP BY e.area, e.id_empleado, nombre_completo
)
SELECT
    area,
    id_empleado,
    nombre_completo,
    total_tardanzas
FROM tardanzas
WHERE total_tardanzas > 3
ORDER BY total_tardanzas DESC;

-- Consulta para calcular la tasa de rotación por área en el año 2024,
-- considerando solo a los empleados que no han sido dados de baja
WITH bajas AS (
    SELECT
        e.area,
        COUNT(DISTINCT r.id_empleado) AS total_bajas
    FROM empleados AS e
    JOIN rotacion AS r
        ON e.id_empleado = r.id_empleado
    WHERE r.estado_baja = 1
        AND r.fecha_salida >= '2024-01-01'
        AND r.fecha_salida < '2025-01-01'
    GROUP BY e.area
),
inicio AS (
    SELECT
        e.area,
        COUNT(*) AS total_inicio
    FROM empleados AS e
    WHERE e.fecha_ingreso <= '2024-01-01'
        AND NOT EXISTS (
            SELECT 1
            FROM rotacion AS r
            WHERE e.id_empleado = r.id_empleado
                AND r.estado_baja = 1
                AND r.fecha_salida < '2024-01-01'
        )
    GROUP BY e.area
),
final AS (
    SELECT
        e.area,
        COUNT(*) AS total_final
    FROM empleados AS e
    WHERE e.fecha_ingreso <= '2024-12-31'
        AND NOT EXISTS (
            SELECT 1
            FROM rotacion AS r
            WHERE e.id_empleado = r.id_empleado
                AND r.estado_baja = 1
                AND r.fecha_salida <= '2024-12-31'
        )
    GROUP BY e.area
),
promedio AS (
    SELECT
        i.area,
        ROUND(
            ((i.total_inicio + f.total_final) / 2.0)
        , 2) AS promedio_empleados
    FROM inicio AS i
    JOIN final AS f
        ON i.area = f.area
)
SELECT
    p.area,
    COALESCE(b.total_bajas, 0) AS total_bajas,
    p.promedio_empleados,
    ROUND(
        (COALESCE(b.total_bajas, 0) * 100.0 / p.promedio_empleados)
    , 2) AS tasa_rotacion
FROM promedio AS p
LEFT JOIN bajas AS b
    ON p.area = b.area
ORDER BY tasa_rotacion DESC;

