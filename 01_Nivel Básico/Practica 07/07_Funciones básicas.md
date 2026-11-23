# 📚 Tema 7: Funciones básicas en MySQL

## Objetivo

Aprender a agregar datos (contar, sumar, promediar, mínimo, máximo) y a transformar valores con funciones de texto y fecha. Estas funciones son la base de los reportes y de casi cualquier consulta real.

> 💡 Seguimos sobre la base escuela. Las funciones se agrupan en: agregación, texto, fecha/hora, matemáticas y conversión.

---

## 1. Funciones de agregación

Operan sobre muchas filas y devuelven un solo valor (o uno por grupo si usas GROUP BY).

| Función    | Qué hace               | Ignora NULL |
| ---        | ---                    | ---         |
| COUNT(*)   | Cuenta filas           | No aplica   |
| COUNT(col) | Cuenta valores no NULL | Sí          |
| SUM(col)   | Suma                   | Sí          |
| AVG(col)   | Promedio               | Sí          |
| MIN(col)   | Mínimo                 | Sí          |
| MAX(col)   | Máximo                 | Sí          |

### COUNT

```sql
SELECT COUNT(*) AS total_alumnos FROM alumnos;          -- 7
SELECT COUNT(fecha_nacimiento) FROM alumnos;            -- solo no NULL
SELECT COUNT(   id_curso) FROM notas;             -- cursos con notas
```

> ⚠ COUNT(*) cuenta filas (incluidas las que tienen NULL). COUNT(col) cuenta solo las filas donde col no es NULL. Diferencia clave.

### SUM, AVG, MIN, MAX

```sql
SELECT SUM(creditos) AS total_creditos FROM cursos;     -- 5+4+6+3+4 = 22
SELECT AVG(creditos) AS promedio FROM cursos;           -- 4.4000
SELECT MIN(nota) AS nota_min, MAX(nota) AS nota_max FROM notas;  -- 4.25, 9.50
SELECT AVG(nota) FROM notas;                            -- promedio de las 9 notas
```

### Redondear promedios

```sql
SELECT ROUND(AVG(nota), 2) AS promedio FROM notas;      -- 7.33   -- ROUND(,2) redondea los decimales a 0,00 osea 2
```

> 💡 AVG devuelve muchos decimales; ROUND(x, 2) lo deja legible. Para dinero, usa DECIMAL y ROUND con cuidado (o TRUNCATE si quieres cortar sin redondear).

### Agregación con filtro

```sql
SELECT COUNT(*) FROM alumnos WHERE activo = 1;          -- activos
SELECT AVG(nota) FROM notas WHERE id_curso = 1;         -- promedio del curso 1
SELECT MAX(nota) FROM notas WHERE id_alumno = 1;
```

### Agregación + GROUP BY (avance del Tema 14)

```sql
SELECT id_curso, COUNT(*) AS cantidad, ROUND(AVG(nota),2) AS promedio
FROM notas
GROUP BY id_curso;
```

Esto ya es agregación por grupo; lo veremos a fondo en el Tema 14, pero conviene verlo aquí porque las funciones de agregación se usan casi siempre con GROUP BY.

> ⚠ Si mezclas columnas normales con agregaciones sin GROUP BY, MySQL (con ONLY_FULL_GROUP_BY, activo por defecto en 8.0) lanza error. Ejemplo incorrecto:

```sql
SELECT id_curso, AVG(nota) FROM notas;   -- ❌ error en 8.0
```

---

## 2. Funciones de texto (cadena)

| Función                 | Qué hace                | Ejemplo                         |
| ---                     | ---                     | ---                             |
| CONCAT(a,b,...)         | Une textos              | CONCAT(nombre,' <',email,'>')   |
| CONCAT_WS(sep,a,b)      | Une con separador       | CONCAT_WS(' - ', nombre, email) |
| LENGTH(s)               | Bytes                   | LENGTH('hola') → 4              |
| CHAR_LENGTH(s)          | Caracteres              | CHAR_LENGTH('ñ') → 1            |
| UPPER(s) / LOWER(s)     | Mayúsculas / minúsculas | UPPER(nombre)                   |
| TRIM(s) / LTRIM / RTRIM | Quita espacios          | TRIM(' hola ')                  |
| SUBSTRING(s, pos, len)  | Subcadena               | SUBSTRING(nombre,1,3)           | 
| LEFT(s,n) / RIGHT(s,n)  | Primeros / últimos n    | LEFT(email,3)                   |
| REPLACE(s, de, a)       | Reemplaza               | REPLACE(email,'@mail.com','')   |
| LOCATE(sub, s)          | Posición de sub         | LOCATE('@', email)              |
| LPAD(s,n,c) / RPAD      | Rellena                 | LPAD(id,5,'0')                  |
| REVERSE(s)              | Invierte                | REVERSE('abc') → 'cba'          |

### Ejemplos con escuela

```sql
SELECT CONCAT(nombre, ' <', email, '>') AS contacto FROM alumnos;

SELECT UPPER(nombre) AS nombre_mayus FROM alumnos;

SELECT nombre, CHAR_LENGTH(nombre) AS largo FROM alumnos ORDER BY largo DESC;

-- Extraer el dominio del email (todo lo que va después de @)
SELECT email, SUBSTRING(email, LOCATE('@', email) + 1) AS dominio FROM alumnos;

-- Usuario del email (antes de @)
SELECT email, LEFT(email, LOCATE('@', email) - 1) AS usuario FROM alumnos;

-- Limpiar espacios
SELECT TRIM('   Ana López   ') AS limpio;
```

> ⚠ LENGTH cuenta bytes; CHAR_LENGTH cuenta caracteres. Con utf8mb4, "ñ" ocupa 2 bytes pero es 1 carácter. Para longitud visible, usa CHAR_LENGTH.

---

## 3. Funciones de fecha y hora
 
| Función                         | Qué devuelve              | Ejemplo                                          |
| ---                             | ---                       |  ---                                             |
| NOW()                           | Fecha y hora actual       | 2026-11-16 10:30:00                              |
| CURDATE()                       | Fecha actual              | 2026-11-16                                       |
| CURTIME()                       | Hora actual               | 10:30:00                                         |
| YEAR(d) / MONTH(d) / DAY(d)     | Parte de fecha            | YEAR('2000-05-14') → 2000                        |
| HOUR(t) / MINUTE(t) / SECOND(t) | Parte de hora             | HOUR(NOW())                                      |
| DATE(d)                         | Solo fecha de un DATETIME | DATE(NOW())                                      |
| DATEDIFF(a,b)                   | Días entre fechas         | DATEDIFF('2026-11-16','2000-05-14')              |
| TIMESTAMPDIFF(u,a,b)            | Diferencia en unidad      | TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) |
| DATE_ADD(d, INTERVAL n u)       | Suma intervalo            | DATE_ADD(CURDATE(), INTERVAL 7 DAY)              |
| DATE_SUB(d, INTERVAL n u)       | Resta intervalo           | DATE_SUB(CURDATE(), INTERVAL 1 MONTH)            |
| DATE_FORMAT(d, fmt)             | Formatea                  | DATE_FORMAT(NOW(),'%d/%m/%Y')                    |
| DAYNAME(d) / MONTHNAME(d)       | Nombre día/mes            | DAYNAME('2000-05-14') → 'Sunday'                 |
| LAST_DAY(d)                     | Último día del mes        | LAST_DAY('2026-02-10') → '2026-02-28'            |

### Ejemplos con escuela

```sql
-- Edad de cada alumno
SELECT nombre,
       TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad
FROM alumnos
ORDER BY edad DESC;

-- Alumnos mayores de 25 años
SELECT nombre, fecha_nacimiento
FROM alumnos
WHERE TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) > 25;

-- Formatear fecha legible
SELECT nombre, DATE_FORMAT(fecha_nacimiento, '%d/%m/%Y') AS nacimiento
FROM alumnos;

-- Días desde que se inscribió
SELECT nombre, DATEDIFF(CURDATE(), DATE(inscrito_en)) AS dias_inscrito
FROM alumnos;

-- Alumnos nacidos en mayo
SELECT nombre, fecha_nacimiento
FROM alumnos
WHERE MONTH(fecha_nacimiento) = 5;
```

> 💡 Para "alumnos mayores de X años" conviene TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) en vez de restar años a mano: maneja correctamente los cumpleaños no cumplidos aún.

---

## 4. Funciones matemáticas

| Función              | Qué hace                            |
| ---                  | ---                                 |
| ROUND(x, d)          | Redondea a d decimales              | \
| TRUNCATE(x, d)       | Corta a d decimales (sin redondear) |
| CEIL(x) / CEILING(x) | Entero hacia arriba                 | \
| FLOOR(x)             | Entero hacia abajo                  | \
| ABS(x)               | Valor absoluto                      |
| MOD(a,b)             | Resto                               |
| POW(a,b)             | Potencia                            |
| SQRT(x)              | Raíz cuadrada                       |

```sql
SELECT ROUND(AVG(nota),2) AS prom, FLOOR(AVG(nota)) AS piso, CEIL(AVG(nota)) AS techo
FROM notas;

SELECT MOD(id, 2) AS par_impar FROM alumnos;   -- 0 = par, 1 = impar
```

---

## 5. Funciones de conversión y control de NULL

| Función             | Qué hace                        |
| ---                 |---                              |
| CAST(x AS tipo)     | Convierte tipo                  |
| CONVERT(x, tipo)    | Similar                         |
| IFNULL(x, valor)    | Si x es NULL, devuelve valor    |
| COALESCE(a,b,c,...) | Primer valor no NULL            |
| NULLIF(a,b)         | NULL si a = b, si no devuelve a |
| IF(cond, a, b)      | Condicional simple              |

### Ejemplos

```sql
-- Mostrar "sin fecha" cuando sea NULL
SELECT nombre, IFNULL(DATE_FORMAT(fecha_nacimiento,'%d/%m/%Y'), 'sin fecha') AS nacimiento
FROM alumnos;

-- COALESCE con varias opciones
SELECT COALESCE(telefono, email, 'sin contacto') AS contacto FROM alumnos;  -- si tuvieras telefono

-- IF condicional
SELECT nombre, nota, IF(nota >= 6, 'aprobado', 'desaprobado') AS estado
FROM notas;

-- Cast
SELECT CAST('123' AS UNSIGNED) + 1 AS resultado;   -- 124
SELECT CAST(nota AS CHAR) FROM notas;
```

> 💡 IFNULL es específico de MySQL; COALESCE es estándar SQL y acepta varias opciones. Prefiere COALESCE para portabilidad.

---

## 6. Combinando todo: consultas de reporte

Promedio general, mínimo y máximo de notas:

```sql
SELECT
    COUNT(*)                AS total_notas,
    ROUND(AVG(nota), 2)     AS promedio,
    MIN(nota)               AS minima,
    MAX(nota)               AS maxima
FROM notas;
```

Cantidad de alumnos activos y edad promedio:

```sql
SELECT
    COUNT(*) AS activos,
    ROUND(AVG(TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE())), 1) AS edad_prom
FROM alumnos
WHERE activo = 1;
```

Reporte por curso (avance de GROUP BY):

```sql
SELECT
    id_curso,
    COUNT(*)             AS cantidad_notas,
    ROUND(AVG(nota), 2)  AS promedio,
    MIN(nota)            AS minima,
    MAX(nota)            AS maxima
FROM notas
GROUP BY id_curso
ORDER BY promedio DESC;
```

Nombre en mayúsculas + edad + estado de notas:

```sql
SELECT
    UPPER(nombre) AS alumno,
    TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad,
    DATE_FORMAT(fecha_nacimiento, '%d/%m/%Y') AS nacimiento
FROM alumnos
ORDER BY edad DESC;
```

---

## 7. ✅ Mini ejercicio

Con escuela:

1. Cuenta cuántos alumnos hay en total y cuántos tienen fecha_nacimiento no nula.
2. Muestra la suma total de créditos de todos los cursos y el promedio redondeado a 2 decimales.
3. Muestra la nota mínima, máxima y promedio (redondeado a 2) de la tabla notas.
4. Lista nombre y email concatenados como "Nombre <email>".
5. Muestra el dominio de cada email (lo que va después de @).
6. Calcula la edad actual de cada alumno y ordénalos de mayor a menor.
7. Muestra los alumnos nacidos en mayo (usa MONTH).
8. Para cada nota, muestra id_alumno, nota y una columna estado con 'aprobado' si nota >= 6, si no 'desaprobado' (usa IF).
9. Muestra cuántos días han pasado desde inscrito_en hasta hoy (usa DATEDIFF).
10. Bonus: muestra el promedio de notas por curso (GROUP BY id_curso) con el promedio redondeado a 2 y ordenado de mayor a menor.

---

## 🎯 Resumen

| Grupo | Funciones clave |
| --- | --- |
| Agregación | COUNT, SUM, AVG, MIN, MAX (ignoran NULL salvo COUNT(*)) |
| Texto | CONCAT, UPPER/LOWER, TRIM, SUBSTRING, LEFT/RIGHT, REPLACE, LOCATE, CHAR_LENGTH |
| Fecha | NOW, CURDATE, YEAR/MONTH/DAY, DATEDIFF, TIMESTAMPDIFF, DATE_ADD/SUB, DATE_FORMAT |
| Matemáticas | ROUND, TRUNCATE, CEIL, FLOOR, ABS, MOD |
| NULL/Conversión | IFNULL, COALESCE, IF, CAST |

Reglas de oro:

- COUNT(*) vs COUNT(col) según quieras contar filas o valores no nulos.
- ROUND(AVG(x), 2) para promedios legibles.
- TIMESTAMPDIFF(YEAR, fecha, CURDATE()) para edades correctas.
- COALESCE para manejar NULL con elegancia.
- Agregaciones + columnas normales → necesitas GROUP BY (Tema 14).