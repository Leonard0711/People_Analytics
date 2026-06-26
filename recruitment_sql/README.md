# Indicadores de Reclutamiento y Selección con MySQL

## Descripción

Proyecto de análisis de datos de reclutamiento y selección utilizando consultas SQL en MySQL.

El objetivo es construir indicadores de RR. HH. (People Analytics) que permitan evaluar la eficiencia del proceso de contratación mediante métricas como:

- Efectividad de fuentes de reclutamiento.
- Conversión entre etapas del proceso de selección.
- Puntaje promedio por etapa.
- Tiempo promedio entre etapas.
- Tiempo de cobertura de vacantes.
- Cantidad de postulantes por puesto.
- Tasa de contratación por reclutador.
- Identificación de candidatos con postulaciones repetidas.

---

## Tecnologías utilizadas

- MySQL 8+
- Funciones de ventana (`LEAD`)
- Expresiones comunes de tabla (CTE)
- Funciones agregadas (`COUNT`, `AVG`, `SUM`)
- Funciones de fecha (`DATEDIFF`)

---

## Modelo de negocio

El proyecto representa un proceso típico de reclutamiento:

```text
Fuente de Reclutamiento
          │
          ▼
     Postulación
          │
          ▼
      Evaluación
          │
          ▼
        Etapas
          │
          ▼
    Contratación
```

---

## Estructura de tablas

### fuentes

```sql
id_fuente INT PRIMARY KEY,
nombre_fuente VARCHAR(100)
```

### candidatos

```sql
id_candidato INT PRIMARY KEY,
nombre VARCHAR(100)
```

### reclutadores

```sql
id_reclutador INT PRIMARY KEY,
nombre VARCHAR(100)
```

### puestos

```sql
id_puesto INT PRIMARY KEY,
nombre_puesto VARCHAR(100)
```

### requerimientos

```sql
id_requerimiento INT PRIMARY KEY,
id_puesto INT,
id_reclutador INT,
fecha_requerimiento DATE,
fecha_cierre DATE
```

### postulaciones

```sql
id_postulacion INT PRIMARY KEY,
id_candidato INT,
id_requerimiento INT,
id_fuente INT,
estado_postulacion VARCHAR(50)
```

### etapas

```sql
id_etapa INT PRIMARY KEY,
nombre_etapa VARCHAR(100),
orden_etapa INT
```

### evaluaciones

```sql
id_evaluacion INT PRIMARY KEY,
id_postulacion INT,
id_etapa INT,
puntaje DECIMAL(5,2),
fecha_evaluacion DATE
```

---

# Indicadores Implementados

## 1. Efectividad de las fuentes de reclutamiento

### Objetivo

Medir qué porcentaje de postulaciones provenientes de cada fuente termina en una contratación.

### Fórmula

```text
Efectividad = Contrataciones / Total de postulaciones × 100
```

### Utilidad

Permite identificar qué canal genera candidatos de mejor calidad:

- LinkedIn
- Computrabajo
- Referidos
- Ferias laborales
- Redes sociales

### Ejemplo

| Fuente | Efectividad |
|----------|----------|
| LinkedIn | 66.67% |
| Computrabajo | 50.00% |

---

## 2. Conversión entre etapas

### Objetivo

Construir el embudo de reclutamiento y medir cuántos candidatos avanzan entre etapas.

### Fórmula

```text
Conversión = Candidatos en etapa siguiente /
             Candidatos en etapa actual × 100
```

### Ejemplo

| Etapa | Conversión |
|---------|---------|
| CV Revisado → RH | 80% |
| RH → Técnica | 62.5% |
| Técnica → Oferta | 40% |

### Utilidad

Permite detectar:

- Cuellos de botella.
- Procesos demasiado restrictivos.
- Puntos donde se pierden candidatos.

---

## 3. Puntaje promedio por etapa

### Objetivo

Analizar el desempeño promedio de los candidatos en cada etapa.

### Fórmula

```text
Promedio = SUM(Puntajes) / Número de evaluaciones
```

### Utilidad

- Detectar etapas más exigentes.
- Comparar dificultad entre filtros.
- Complementar el análisis de conversión.

### Ejemplo

| Etapa | Promedio |
|---------|---------|
| Revisión CV | 80 |
| Entrevista RH | 70 |
| Entrevista Técnica | 85 |

---

## 4. Tiempo promedio por transición entre etapas

### Objetivo

Calcular cuántos días tardan los candidatos en avanzar entre etapas del proceso.

### Utilidad

Permite identificar retrasos operativos.

### Ejemplo

| Transición | Días promedio |
|------------|------------|
| CV → RH | 4 |
| RH → Técnica | 6.33 |

### Interpretación

La transición RH → Técnica es la más lenta del proceso.

---

## 5. Tiempo promedio de cobertura por puesto

### Objetivo

Medir el tiempo necesario para cubrir una vacante.

### Fórmula

```text
Tiempo de cobertura =
Fecha de cierre - Fecha de requerimiento
```

### Ejemplo

| Puesto | Días promedio |
|----------|------------|
| Analista de Datos | 25 |
| Desarrollador Backend | 40 |

### Utilidad

Permite identificar posiciones difíciles de cubrir.

---

## 6. Cantidad de postulantes por puesto

### Objetivo

Conocer cuántas postulaciones recibe cada puesto.

### Ejemplo

| Puesto | Postulantes |
|----------|----------|
| Analista de Datos | 5 |
| Desarrollador Backend | 4 |
| Diseñador UX | 1 |

### Utilidad

Ayuda a determinar:

- Popularidad del puesto.
- Escasez de talento.
- Necesidad de nuevas estrategias de reclutamiento.

---

## 7. Tasa de contratación por reclutador

### Objetivo

Evaluar el desempeño de cada reclutador.

### Fórmula

```text
Tasa de contratación =
Contratados / Total de postulantes × 100
```

### Ejemplo

| Reclutador | Tasa |
|------------|------|
| Ana Pérez | 60% |
| Carlos Ruiz | 33.33% |

### Utilidad

Permite:

- Comparar desempeño.
- Detectar necesidades de capacitación.
- Asignar futuros requerimientos.

---

## 8. Candidatos que postulan varias veces al mismo puesto

### Objetivo

Identificar candidatos que muestran interés recurrente por una misma posición.

### Ejemplo

| Candidato | Puesto | Veces |
|------------|---------|---------|
| Juan Pérez | Analista de Datos | 3 |
| Carlos Díaz | Desarrollador Backend | 3 |

### Utilidad

- Detectar candidatos persistentes.
- Analizar repostulaciones.
- Mantener una base de talento para futuras vacantes.

---

## Autor

Leonardo Quilca