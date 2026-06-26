# Segmentación de Perfiles Laborales Similares

## Descripción del Proyecto

Este proyecto aplica técnicas de **Machine Learning No Supervisado** para identificar perfiles laborales similares dentro de una organización utilizando datos de recursos humanos.

El objetivo es descubrir grupos homogéneos de empleados mediante algoritmos de clustering, permitiendo comprender mejor las características asociadas al desarrollo profesional, experiencia laboral y niveles salariales.

El análisis fue desarrollado utilizando el dataset **IBM HR Analytics Employee Attrition & Performance**, ampliamente utilizado en proyectos de People Analytics.

---

## Objetivos

- Identificar perfiles laborales similares mediante técnicas de clustering.
- Comparar el desempeño de diferentes algoritmos de agrupamiento.
- Analizar las variables que más contribuyen a la segmentación de empleados.
- Generar información útil para estrategias de People Analytics y Gestión del Talento.

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

## Metodología

### 1. Preprocesamiento

- Identificación de variables numéricas y categóricas.
- Escalamiento de variables numéricas.
- Codificación de variables categóricas mediante One-Hot Encoding.
- Construcción de pipelines para asegurar la reproducibilidad del análisis.

### 2. Algoritmos Evaluados

#### K-Means

Algoritmo basado en centroides que busca minimizar la distancia interna entre observaciones dentro de cada cluster.

#### DBSCAN

Método basado en densidad capaz de detectar ruido y agrupamientos de forma arbitraria.

#### Agglomerative Clustering

Técnica jerárquica que construye clusters mediante fusiones sucesivas de observaciones similares.

### 3. Evaluación

Los modelos fueron comparados utilizando el indicador:

- **Silhouette Score**

Esta métrica evalúa simultáneamente:

- Cohesión interna de cada cluster.
- Separación entre clusters.

Valores más altos indican una segmentación de mejor calidad.

---

## Resultados

Los resultados muestran que:

| Modelo | Desempeño |
|----------|----------|
| K-Means | Mejor desempeño |
| Agglomerative Clustering | Buen desempeño |
| DBSCAN | Menor capacidad de segmentación |

El algoritmo **K-Means** obtuvo el mayor valor de **Silhouette Score**, evidenciando una mejor separación entre grupos y una mayor consistencia interna, por lo que fue seleccionado para el análisis detallado de perfiles laborales.

---

## Variables Más Relevantes

Las variables con mayor capacidad discriminativa entre clusters fueron:

### Desarrollo Profesional

- TotalWorkingYears
- YearsAtCompany
- YearsInCurrentRole

### Características Demográficas

- Age

### Compensación

- MonthlyIncome

---

## Variables Menos Discriminativas

Las variables con menor capacidad para diferenciar perfiles fueron:

- JobSatisfaction
- JobInvolvement

Esto sugiere que la segmentación está impulsada principalmente por factores estructurales del empleo y trayectoria profesional, más que por variables actitudinales.

---

## Principales Hallazgos

Los clusters identificados permiten distinguir, principalmente:

- Empleados junior vs senior.
- Empleados con baja vs alta experiencia.
- Empleados con bajo vs alto nivel salarial.
- Empleados con menor vs mayor permanencia en la organización.

En consecuencia, las agrupaciones reflejan distintas etapas del ciclo profesional de los colaboradores.

---

## Tecnologías Utilizadas

- Python
- Pandas
- NumPy
- Scikit-Learn
- Matplotlib
- Seaborn
- SciPy

---

## Estructura del Proyecto

```text
profiles/
│
├── notebooks/
│   └── similar_profiles.ipynb
│
└── README.md