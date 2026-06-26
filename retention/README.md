# Employee Retention Analysis

## Descripción

Este proyecto desarrolla un análisis de retención de empleados utilizando técnicas de People Analytics con el objetivo de identificar los factores asociados a la permanencia y rotación del talento dentro de una organización.

A partir de variables demográficas, laborales y organizacionales, se exploran patrones de comportamiento que permitan comprender qué características se relacionan con una mayor probabilidad de abandono o permanencia.

---

## Objetivos

- Analizar los factores asociados a la retención de empleados.
- Identificar variables con mayor influencia en la permanencia laboral.
- Detectar segmentos de empleados con mayor riesgo de rotación.
- Generar insights accionables para estrategias de Recursos Humanos.
- Apoyar la toma de decisiones basada en datos.

---

## Dataset

**Fuente:** IBM HR Analytics Employee Attrition Dataset.

Características principales:

- 1,470 registros de empleados.
- 35 variables demográficas, laborales y organizacionales.
- Variables relacionadas con:
  - Edad.
  - Experiencia laboral.
  - Ingresos.
  - Antigüedad.
  - Satisfacción laboral.
  - Balance vida-trabajo.
  - Desarrollo profesional.

---


## Preguntas de Negocio

El análisis busca responder preguntas como:

- ¿Qué características presentan los empleados con mayor permanencia?
- ¿Existen diferencias importantes entre empleados que permanecen y quienes abandonan la organización?
- ¿Qué variables laborales tienen mayor impacto en la retención?
- ¿Qué grupos requieren estrategias específicas de fidelización?
---

## Metodología

### 1. Exploración de Datos (EDA)

- Análisis descriptivo.
- Identificación de valores faltantes.
- Detección de valores atípicos.
- Análisis de distribuciones.
- Correlaciones entre variables.

### 2. Análisis de Retención

Se evalúan diferencias significativas entre grupos de empleados para identificar patrones asociados a la permanencia laboral.

### 3. Visualización

Se utilizan gráficos para:

- Comparar indicadores de retención.
- Analizar relaciones entre variables.
- Identificar segmentos críticos.
- Comunicar hallazgos de forma clara.

---

## Principales Variables Analizadas

### Demográficas

- Age
- Gender
- MaritalStatus

### Laborales

- JobRole
- Department
- MonthlyIncome
- TotalWorkingYears
- YearsAtCompany
- YearsInCurrentRole

### Organizacionales

- JobSatisfaction
- EnvironmentSatisfaction
- WorkLifeBalance
- JobInvolvement

---

## Hallazgos Esperados

El análisis permite identificar:

- Factores que favorecen la permanencia.
- Variables asociadas a la rotación.
- Perfiles con alto riesgo de abandono.
- Oportunidades de mejora en gestión del talento.
- Recomendaciones para incrementar la retención organizacional.

---

## Tecnologías Utilizadas

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Scikit-Learn
- Jupyter Notebook

---

## Estructura del Proyecto

```text
retention/
│
├── notebooks/
│   └── retention_analysis.ipynb
│
└── README.md