# 📚 Tema 6: Cláusulas fundamentales

## Objetivo

Dominar las cláusulas que acompañan a SELECT: WHERE avanzado, ORDER BY múltiple, LIMIT/OFFSET, DISTINCT. Son las que convierten una consulta simple en una consulta útil.

> 💡 Trabajaremos sobre la base escuela que creaste desde 0 en el mensaje anterior.

---

## 1. El orden lógico de ejecución de un SELECT

Antes de ver cláusulas, entiende el orden en que MySQL procesa (no en el que escribes):

```text
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

Esto explica por qué:

- No puedes usar un alias del SELECT en WHERE (el alias aún no existe cuando se evalúa WHERE).
- Sí puedes usar un alias en ORDER BY (ya existe).
- LIMIT se aplica al final, sobre el resultado ya ordenado.

---

## 2. WHERE avanzado

### 2.1 Operadores de comparación
 
```sql
SELECT * FROM alumnos WHERE activo = 1;
SELECT * FROM alumnos WHERE fecha_nacimiento <> '2000-05-14';   -- distinto
SELECT * FROM notas   WHERE nota >= 7 AND nota < 9;
```

### 2.2 Operadores lógicos: AND, OR, NOT

```sql
-- AND: ambas condiciones   (2 condiciones para aparecer la tabla)
SELECT * FROM alumnos WHERE activo = 1 AND fecha_nacimiento >= '2000-01-01';

-- OR: cualquiera           (Aparece cualquiera que pongas el dato)
SELECT * FROM alumnos WHERE nombre = 'Ana López' OR nombre = 'Marta Ruiz';

-- NOT: negación            (Niega cual va aparecer)
SELECT * FROM alumnos WHERE NOT activo = 1;      -- equivale a activo = 0
SELECT * FROM alumnos WHERE NOT (activo = 1 AND fecha_nacimiento > '2000-01-01');
```

> ⚠ Precedencia: AND se evalúa antes que OR. Si mezclas, usa paréntesis:

```sql
-- ❌ Mal interpretado: (activo=1 AND nombre='Ana') OR nombre='Marta'
SELECT * FROM alumnos WHERE activo = 1 AND nombre = 'Ana López' OR nombre = 'Marta Ruiz';

-- ✅ Correcto
SELECT * FROM alumnos
WHERE activo = 1 AND (nombre = 'Ana López' OR nombre = 'Marta Ruiz');
```

### 2.3 BETWEEN

Rango inclusivo (incluye ambos extremos):

```sql
SELECT * FROM notas WHERE nota BETWEEN 6 AND 9;          -- 6 <= nota <= 9
SELECT * FROM alumnos WHERE fecha_nacimiento BETWEEN '1999-01-01' AND '2000-12-31';
```

Equivale a `>= a AND <= b`.

### 2.4 IN / NOT IN

Para comparar contra una lista:

```sql
SELECT * FROM alumnos WHERE id IN (1, 3, 5);
SELECT * FROM cursos  WHERE nombre IN ('Matemáticas', 'Programación');
SELECT * FROM alumnos WHERE id NOT IN (1, 2);     -- todos menos 1 y 2
```

> ⚠ Cuidado con NULL en NOT IN: si la lista contiene NULL, NOT IN no devuelve nada. Ej: `id NOT IN (1, NULL)` → resultado vacío. Evítalo filtrando NULL antes.

### 2.5 LIKE y comodines

```sql
-- % = cualquier secuencia (incluida vacía)
SELECT * FROM alumnos WHERE email LIKE '%@mail.com';    -- termina en @mail.com
SELECT * FROM alumnos WHERE nombre LIKE 'M%';           -- empieza con M
SELECT * FROM alumnos WHERE nombre LIKE '%a%';          -- contiene 'a'

-- _ = exactamente un carácter
SELECT * FROM alumnos WHERE nombre LIKE 'A_a%';         -- "Ana...", "Ara...", etc.

-- ESCAPE para buscar % o _ literales
SELECT * FROM alumnos WHERE nombre LIKE '%\%%' ESCAPE '\';
```

> 💡 LIKE 'M%' puede usar índice (prefijo fijo). LIKE '%a%' no puede usarlo: recorre toda la tabla. Tenlo en cuenta para rendimiento.

### 2.6 IS NULL / IS NOT NULL

```sql
SELECT * FROM alumnos WHERE fecha_nacimiento IS NULL;
SELECT * FROM alumnos WHERE fecha_nacimiento IS NOT NULL;
```

> ⚠ Nunca uses `= NULL` ni `<> NULL`: siempre devuelven NULL (ni verdadero ni falso). Usa IS NULL / IS NOT NULL.

### 2.7 Comparaciones con fechas

```sql
SELECT * FROM alumnos WHERE fecha_nacimiento > '2000-01-01';
SELECT * FROM alumnos WHERE YEAR(fecha_nacimiento) = 2000;
SELECT * FROM alumnos WHERE fecha_nacimiento >= '2000-01-01'
                       AND fecha_nacimiento <  '2001-01-01';
```

> 💡 Para rangos de fecha, el patrón `>= inicio AND < fin` es el más seguro (evita problemas con horas en DATETIME).

---

## 3. ORDER BY múltiple

Puedes ordenar por varias columnas; se aplican en orden de izquierda a derecha:

```sql
-- Primero por activo (desc), y dentro de cada grupo, por nombre (asc)
SELECT * FROM alumnos
ORDER BY activo DESC, nombre ASC;
```

Ejemplo más claro con notas:

```sql
SELECT * FROM notas
ORDER BY nota DESC, id_alumno ASC;
```

Esto ordena de mayor a menor nota; si hay empate, por id_alumno ascendente.

### Ordenar con expresiones o alias

```sql
SELECT nombre, (2026 - YEAR(fecha_nacimiento)) AS edad
FROM alumnos
ORDER BY edad DESC;                 -- alias permitido en ORDER BY
```

### Ordenar con NULLs

En MySQL, NULL se considera menor que cualquier valor:

- ORDER BY col ASC → NULLs primero.
- ORDER BY col DESC → NULLs últimos.

Si quieres controlarlo explícitamente:

```sql
SELECT * FROM alumnos
ORDER BY fecha_nacimiento IS NULL, fecha_nacimiento ASC;
```

Eso pone los no-NULL primero y luego los NULL.

---

## 4. LIMIT y OFFSET (paginación) (salto)

```sql
SELECT * FROM alumnos LIMIT 3;              -- primeras 3 filas
SELECT * FROM alumnos LIMIT 3 OFFSET 3;     -- salta 3, toma 3 (página 2)
SELECT * FROM alumnos LIMIT 3, 3;           -- sintaxis alternativa (offset, count)
```

### Paginación típica

| Página | Consulta                 |
| ---    | ---                      |
| 1      | LIMIT 10 OFFSET 0        |
| 2      | LIMIT 10 OFFSET 10       |
| 3      | LIMIT 10 OFFSET 20       |
| N      | LIMIT 10 OFFSET (N-1)*10 |

> ⚠ Sin ORDER BY, LIMIT no es determinista: MySQL puede devolver filas en cualquier orden. Siempre acompaña LIMIT de un ORDER BY si necesitas resultados estables.

```sql
SELECT * FROM alumnos ORDER BY id LIMIT 3 OFFSET 0;
```

### Top-N por grupo (concepto)

LIMIT se aplica al resultado completo, no por grupo. Para "las 2 mejores notas de cada alumno" necesitas window functions (Tema 18) o subconsultas. Aquí solo el concepto.

---

## 5. DISTINCT

Elimina filas duplicadas del resultado:

```sql
SELECT DISTINCT activo FROM alumnos;              -- devuelve 1 (y 0 si hubiera)
SELECT DISTINCT id_curso FROM notas;              -- cursos que tienen al menos una nota
```

### DISTINCT con varias columnas (Quita los repetidos de la tabla) (Empaquetado)

Se aplica a la combinación de columnas, no a cada una por separado:

```sql
SELECT DISTINCT id_alumno, id_curso FROM notas;
```

Devuelve pares únicos (que en notas ya son únicos por la PK compuesta).

### DISTINCT vs GROUP BY

Para "valores únicos", DISTINCT suele ser más claro. GROUP BY es para agregar (Tema 14):

```sql
SELECT DISTINCT id_curso FROM notas;                 -- simple
SELECT id_curso FROM notas GROUP BY id_curso;        -- equivalente
```

---

## 6. Ejemplos integradores con escuela

Alumnos activos nacidos en 2000 o después, ordenados por nombre:

```sql
SELECT nombre, email, fecha_nacimiento
FROM alumnos
WHERE activo = 1 AND fecha_nacimiento >= '2000-01-01'
ORDER BY nombre ASC;
```

Notas entre 7 y 9 (inclusive), de mayor a menor:

```sql
SELECT id_alumno, id_curso, nota
FROM notas
WHERE nota BETWEEN 7 AND 9
ORDER BY nota DESC;
```

Alumnos cuyo email termina en mail.com y cuyo nombre empieza con M:

```sql
SELECT nombre, email
FROM alumnos
WHERE email LIKE '%@mail.com' AND nombre LIKE 'M%'
ORDER BY nombre;
```

Top 3 de mejores notas:

```sql
SELECT id_alumno, id_curso, nota
FROM notas
ORDER BY nota DESC
LIMIT 3;
```

Página 2 de alumnos (3 por página), ordenados por id:

```sql
SELECT * FROM alumnos
ORDER BY id
LIMIT 3 OFFSET 3;
```

Cursos que tienen al menos una nota registrada:

```sql
SELECT DISTINCT id_curso FROM notas ORDER BY id_curso;
```

---

## 7. ✅ Mini ejercicio

Con la base escuela:

1. Muestra los alumnos nacidos entre 1999 y 2001 (inclusive), ordenados por fecha de nacimiento ascendente.
2. Lista los cursos con 4 o 6 créditos usando IN.
3. Muestra nombre y email de alumnos cuyo nombre contenga la letra "a" y estén activos.
4. Muestra las notas mayores o iguales a 8, ordenadas por id_curso ascendente y luego por nota descendente.
5. Obtén la página 2 de cursos con 2 cursos por página, ordenados por nombre.
6. Lista los valores únicos de nota en la tabla notas.
7. Muestra los alumnos cuya fecha_nacimiento sea NULL (si no hay, igual escribe la consulta).
8. Top 2 de las notas más bajas (usa ORDER BY ... ASC LIMIT 2).
9. Bonus: muestra los alumnos cuyo nombre empiece con "M" o cuyo email contenga "ana", pero solo los activos. Usa paréntesis para agrupar correctamente.

---

## 🎯 Resumen

| Cláusula | Para qué | Clave |
| --- | --- | --- |
| WHERE | Filtrar filas | AND/OR con paréntesis; IS NULL, IN, BETWEEN, LIKE |
| ORDER BY | Ordenar | Múltiples columnas; ASC/DESC; NULLs al inicio en ASC |
| LIMIT/OFFSET | Paginar | Siempre con ORDER BY para resultados estables |
| DISTINCT | Únicos | Se aplica a la combinación de columnas |

Orden de ejecución: FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT.