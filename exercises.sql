
"""Consulta que muestre el nombre (apellido y nombre) para los
empleados que ganan más que el empleado con el ID 103."""
SELECT hr.name, hr.last_name
FROM hr_data AS hr
JOIN hr_data AS hr2
ON hr2.id = 123
WHERE hr2.salary > hr.salary;

"""Consulta que muestre a los empleados del mismo departamento que el 
empleado con id = 169 cuyo salario es mayor que el de ese empleado."""
SELECT
    hr.name,
    hr.last_name
FROM hr_data AS hr 
JOIN hr_data AS hr1
ON hr1.id = 169
WHERE hr.id_department = hr1.id_department
AND hr.salary > hr1.salary;

"""Consulta que muestre aquellos empleados que ganan el salario más bajo 
de todos los departamentos."""
SELECT
    hr.id_department,
    hr.name,
    hr.last_name
FROM hr_data AS hr
JOIN (
    SELECT
        id_department,
        MIN(salary) AS min_salary
    FROM hr_data
    GROUP BY id_department
) AS m
ON hr.id_department = m.id_department
WHERE hr.salary = m.min_salary;

"""Consulta que muestra los nombres completos de los empleados que reportan 
a un jefe directo con apellido “Gonzales”."""
SELECT
    CONCAT(hr.name, " ", hr.last_name) AS full_name
FROM hr_data AS hr
JOIN hr_data AS hr2
ON hr.id_employee = hr2.id_manager
WHERE hr2.last_name = "Gonzales";

"""Consulta que muestra los empleados que ganan más que el salario promedio 
de toda la empresa."""
SELECT
    CONCAT(name, " ", last_name) AS full_name,
    salary
FROM hr_data
WHERE salary > (
    SELECT AVG(salary)
    FROM hr_data
)

"""Consulta que muestra el nombre del departamento que tiene la mayor 
cantidad de empleados."""
SELECT DISTINCT
    name_department
FROM hr_data
WHERE id_department = (
    SELECT
        id_department
    FROM hr_data
    GROUP BY id_department
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

"""Consulta que muestra los empleados cuyo salario es mayor que 
el salario promedio de su propio departamento"""
WITH avg_depto (
    SELECT
        id_department,
        AVG(salary) AS avg_salary
    FROM hr_data
    GROUP BY id_department
)
SELECT
    CONCAT(name, " ", last_name) AS full_name,
    salary,
    name_department
FROM hr_data AS hr
JOIN avg_depto AS ad
ON hr.id_department = ad.id_department
WHERE hr.salary > ad.avg_salary;

