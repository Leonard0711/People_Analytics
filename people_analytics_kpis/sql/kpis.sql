-- KPIs People Analytics

-- 1. Headcount: Total del número de empleados activos en la empresa.
SELECT
    COUNT(*) AS headcount
FROM employees
WHERE termination_date IS NULL;

-- 2. Turnover Rate: Porcentaje de empleados que dejaron la empresa durante un período específico.
WITH exits AS (
    SELECT
        COUNT(*) total_exits
    FROM employees
    WHERE termination_date >= '2020-01-01' 
    AND termination_date <= '2020-12-31'
)
headcount_start AS (
    SELECT
        COUNT(*) AS cnt
    FROM employees
    WHERE hire_date < '2020-01-01' AND (
        termination_date IS NULL OR termination_date >= '2020-01-01'
    )
)
headcount_end AS (
    SELECT
        COUNT(*) AS cnt
    FROM employees
    WHERE hire_date < '2020-01-01' AND (
        termination_date IS NULL OR termination_date >= '2020-01-01'
    )
)
SELECT
    e.total_exits * 100.0 /
    ((h_start.cnt + h_end.cnt) / 2) AS turnover_rate
FROM exits e
CROSS JOIN headcount_start h_start
CROSS JOIN headcount_end h_end;

-- 3. Average Age: Promedio de edad que tiene los empleados en la empresa.
SELECT
    AVG(TIMESTAMPDIFF(YEAR, birth_date, CURDATE())) AS average_age
FROM employees
WHERE termination_date IS NULL;

-- 4. Average Tenure: Promedio de años que los empleados han estado en la empresa.
-- agrupadas por departamento.
SELECT
    department,
    AVG(TIMESTAMPDIFF(YEAR, hire_date, CURDATE())) AS average_tenure
FROM employees
WHERE termination_date IS NULL
GROUP BY department;

-- 5. Gender Diversity: Porcentaje de empleados por género en la empresa.
SELECT
    gender,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS percentage
FROM employees
WHERE termination_date IS NULL
GROUP BY gender;