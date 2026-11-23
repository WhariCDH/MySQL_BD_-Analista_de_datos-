# 📚 Tema 8: NULL y valores por defecto

## Objetivo

Entender qué es NULL, cómo se comporta (¡no es cero ni cadena vacía!), 
cómo afecta a comparaciones, agregaciones y JOINs, y cómo usar DEFAULT, NOT NULL, IFNULL, COALESCE y NULLIF para manejarlo con elegancia.

> 💡 Seguimos sobre escuela. Este tema es clave: la mayoría de bugs sutiles en SQL vienen de no entender NULL.

---

## 1. ¿Qué es NULL?

NULL significa "valor desconocido o ausente". No es:

| ❌ No es       | Ejemplo                               |
| ---             | ---                                   |
| Cero            | 0 es un valor conocido                |
| Cadena vacía    | '' es un valor conocido (texto vacío) |
| Espacio         | ' ' es un valor conocido              |
| 'NULL' (texto)  | Eso es una cadena de 4 caracteres     |

NULL es la ausencia de valor. Por eso:

```sql
SELECT NULL = NULL;          -- devuelve NULL (no TRUE)
SELECT NULL <> NULL;         -- devuelve NULL (no TRUE)
SELECT NULL + 5;             -- devuelve NULL
SELECT CONCAT('Hola', NULL); -- devuelve NULL
```

> 🧠 Regla mental: cualquier operación con NULL da NULL (salvo funciones que lo manejan explícitamente como COALESCE, IFNULL, IS NULL).

---

## 2. NULL en comparaciones: el error clásico

```sql
-- ❌ MAL: nunca devuelve filas
SELECT * FROM alumnos WHERE fecha_nacimiento = NULL;
SELECT * FROM alumnos WHERE fecha_nacimiento <> NULL;

-- ✅ BIEN
SELECT * FROM alumnos WHERE fecha_nacimiento IS NULL;      -- Muestra todas las fecha_nacimiento vacias
SELECT * FROM alumnos WHERE fecha_nacimiento IS NOT NULL;  -- Muestra todas las fecha_nacimiento que no esteen vacias
```

¿Por qué? Porque fecha = NULL se evalúa como NULL (desconocido), y WHERE solo deja pasar filas donde la condición es verdadera (TRUE). 
NULL no es TRUE, así que la fila se descarta.

### Tabla de verdad de NULL (lógica de 3 valores)

| A     | B    | A AND B | A OR B |
| ---   | ---  | ---     | ---    |
| TRUE  | NULL | NULL    | TRUE   |
| FALSE | NULL | FALSE   | NULL   |
| NULL  | NULL | NULL    | NULL   |

> 💡 NULL en WHERE se comporta como "no cumple". Por eso NOT (NULL) tampoco es TRUE: es NULL, y se descarta.

---

## 3. NULL en agregaciones

Las funciones de agregación ignoran NULL (salvo COUNT(*)):

```sql
-- Supongamos que inserts un alumno sin fecha:
INSERT INTO alumnos (nombre, email) VALUES ('Test Sin Fecha', 'test@mail.com');

SELECT COUNT(*)              FROM alumnos;   -- 8 (cuenta la fila)
SELECT COUNT(fecha_nacimiento) FROM alumnos; -- 7 (ignora el NULL)
SELECT AVG(fecha_nacimiento) FROM alumnos;   -- promedio solo de las 7 no NULL
```

> ⚠ Cuidado con AVG: si tienes 10 filas y 3 tienen NULL, AVG(col) divide entre 7, no entre 10. Si quieres que los NULL cuenten como 0, usa AVG(COALESCE(col, 0)) (pero piénsalo bien: ¿tiene sentido?).

### SUM con NULL

```sql
SELECT SUM(nota) FROM notas;   -- ignora NULL; si TODAS son NULL, devuelve NULL (no 0)
```

> 💡 Si necesitas 0 cuando no hay filas o todas son NULL: `SELECT COALESCE(SUM(nota), 0) FROM notas;`.

---

## 4. NULL en ORDER BY

En MySQL, NULL se considera menor que cualquier valor:

```sql
SELECT nombre, fecha_nacimiento 
FROM alumnos 
ORDER BY fecha_nacimiento ASC;
-- NULLs primero, luego fechas ascendentes

SELECT nombre, fecha_nacimiento 
FROM alumnos 
ORDER BY fecha_nacimiento DESC;
-- Fechas descendentes, NULLs al final
```

Control explícito (no-NULL primero, luego NULL):

```sql
SELECT nombre, fecha_nacimiento
FROM alumnos
ORDER BY fecha_nacimiento IS NULL, fecha_nacimiento ASC;
```

`fecha_nacimiento IS NULL` devuelve 0 (no es NULL) o 1 (es NULL). Al ordenar ascendente, los 0 (no NULL) van primero.

---

## 5. NULL en GROUP BY y DISTINCT  (Mostrara un solo NULL aun que exista varios)

GROUP BY trata todos los NULL como un solo grupo.

DISTINCT también los colapsa en uno solo.

```sql
SELECT DISTINCT fecha_nacimiento FROM alumnos;   -- un solo NULL, aunque haya varias filas NULL
```

---

## 6. NULL en JOINs (avance del Tema 12)

NULL no matchea con nada, ni siquiera con otro NULL:

```sql
-- Si notas.id_alumno fuera NULL, este JOIN no lo traería
SELECT * FROM notas n JOIN alumnos a ON n.id_alumno = a.id;
```

Por eso las columnas de relación (id_alumno, id_curso) deben ser NOT NULL. Lo veremos a fondo en el Tema 9 (FK) y Tema 12 (JOINs).

---

## 7. Restricciones: NOT NULL y DEFAULT

### NOT NULL

Obliga a que la columna tenga valor. Nunca puede ser NULL.

```sql
CREATE TABLE ejemplo (
    id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,     -- obligatorio
    email  VARCHAR(255) NOT NULL UNIQUE,
    bio    TEXT                        -- opcional (admite NULL)
);
```

Insertar sin nombre falla:

```sql
INSERT INTO ejemplo (email) VALUES ('x@mail.com');
-- ERROR 1364: Field 'nombre' doesn't have a default value
```

### DEFAULT

Valor que se usa si no especificas la columna en el INSERT.

```sql
CREATE TABLE ejemplo2 (
    id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    activo    TINYINT(1)  DEFAULT 1,
    creado_en TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    estado    VARCHAR(20) DEFAULT 'pendiente'
);
```

Insertar sin esas columnas:

```sql
INSERT INTO ejemplo2 () VALUES ();   -- o: INSERT INTO ejemplo2 (id) VALUES (NULL);
SELECT * FROM ejemplo2;              -- activo=1, creado_en=ahora, estado='pendiente'
```

> 💡 Diferencia clave:
>
> - NOT NULL sin DEFAULT → obliga a dar valor en el INSERT.
> - DEFAULT sin NOT NULL → si no das valor, usa el default; pero puedes dar NULL explícito.
> - NOT NULL DEFAULT x → si no das valor, usa x; y no puedes dar NULL.

### DEFAULT con NULL explícito

```sql
INSERT INTO ejemplo2 (activo) VALUES (NULL);   -- ❌ falla si activo es NOT NULL
                                                -- ✅ funciona si activo admite NULL (guarda NULL, ignora DEFAULT)
```

> ⚠ DEFAULT solo se aplica si omites la columna. Si escribes NULL explícito, se guarda NULL (si la columna lo permite).

---

## 8. Funciones para manejar NULL

### IFNULL(x, valor)

Si x es NULL, devuelve valor; si no, devuelve x.

```sql
SELECT nombre, 
IFNULL(fecha_nacimiento, 'sin fecha') 
AS nacimiento FROM alumnos;
```

> ⚠ IFNULL es específico de MySQL. En PostgreSQL/Oracle es NVL o COALESCE.

### COALESCE(a, b, c, ...)

Devuelve el primer valor no NULL de la lista. Estándar SQL, más flexible.

```sql
SELECT COALESCE(telefono, email, 'sin contacto') AS contacto FROM alumnos;
-- si telefono es NULL, usa email; si ambos NULL, 'sin contacto'
```

> 💡 COALESCE(x, y) equivale a IFNULL(x, y), pero COALESCE acepta N argumentos y es portable. Prefiérelo.

### NULLIF(a, b)

Devuelve NULL si a = b; si no, devuelve a.

```sql
SELECT NULLIF(nota, 0) FROM notas;   -- convierte 0 en NULL
SELECT NULLIF(stock, 0) FROM productos;   -- evita división por cero
```

Uso típico: evitar división por cero

```sql
SELECT total / NULLIF(cantidad, 0) AS promedio FROM pedidos;
-- Si cantidad = 0 → NULLIF devuelve NULL → total/NULL = NULL (no error)
```

### IF(cond, a, b) con NULL

```sql
SELECT nombre, 
IF(fecha_nacimiento IS NULL, 'sin fecha', DATE_FORMAT(fecha_nacimiento,'%d/%m/%Y')) AS nacimiento
FROM alumnos;
```

---

## 9. Ejemplo integrador con escuela

Primero, inserta un alumno sin fecha para ver el efecto:

```sql
INSERT INTO alumnos (nombre, email) VALUES ('Test Sin Fecha', 'test@mail.com');
```

Consultas:

```sql
-- Contar total vs con fecha
SELECT COUNT(*) AS total, COUNT(fecha_nacimiento) AS con_fecha FROM alumnos;

-- Mostrar "sin fecha" cuando sea NULL
SELECT nombre, COALESCE(DATE_FORMAT(fecha_nacimiento,'%d/%m/%Y'), 'sin fecha') AS nacimiento
FROM alumnos;

-- Alumnos sin fecha
SELECT nombre FROM alumnos WHERE fecha_nacimiento IS NULL;

-- Alumnos con fecha, ordenados, NULL al final
SELECT nombre, fecha_nacimiento
FROM alumnos
ORDER BY fecha_nacimiento IS NULL, fecha_nacimiento ASC;

-- Evitar división por cero (ejemplo con notas)
SELECT id_alumno, id_curso, nota, nota / NULLIF(nota, 0) AS ratio FROM notas;
```

---

## 10. Buenas prácticas con NULL

- En columnas de relación (id_cliente, id_curso): NOT NULL. Una FK NULL suele ser un error de diseño.
- En columnas opcionales (teléfono, bio, fecha_nacimiento): permite NULL, pero documenta qué significa.
- Nunca uses = NULL: siempre IS NULL / IS NOT NULL.
- COUNT(*) vs COUNT(col): elige según quieras contar filas o valores no nulos.
- COALESCE > IFNULL por portabilidad y flexibilidad.
- NULLIF para evitar división por cero.
- Cuidado con NOT IN + NULL: si la lista contiene NULL, NOT IN no devuelve nada. Filtra NULL antes o usa NOT EXISTS.
- DEFAULT no es lo mismo que NOT NULL: combínalos según necesidad (NOT NULL DEFAULT x es muy común).
- En ORDER BY, controla los NULL explícitamente si el orden importa.
- En agregaciones, recuerda que NULL se ignora: AVG divide entre no-NULL.

---

## 11. ✅ Mini ejercicio

Con escuela (y el alumno "Test Sin Fecha" insertado):

1. Cuenta cuántos alumnos hay en total y cuántos tienen fecha_nacimiento NULL.
2. Muestra nombre y fecha_nacimiento, reemplazando NULL por 'sin fecha' con COALESCE.
3. Lista los alumnos sin fecha de nacimiento.
4. Ordena todos los alumnos por fecha_nacimiento ascendente, pero con los NULL al final.
5. Usa NULLIF para mostrar NULL en lugar de 0 en una columna (puedes probar con nota o crear un ejemplo).
6. Inserta un curso sin especificar creditos (¿funciona? ¿por qué?).
7. Crea una tabla productos con precio DECIMAL(10,2) NOT NULL DEFAULT 0 y stock INT DEFAULT 0. Inserta una fila sin especificar precio y otra con precio = NULL. ¿Qué pasa en cada caso?
8. Bonus: muestra el promedio de nota y el promedio de COALESCE(nota, 0). ¿Son iguales? ¿Por qué?

---

## 🎯 Resumen

| Concepto | Clave |
| --- | --- |
| NULL | Ausencia de valor; no es 0 ni '' |
| Comparar NULL | IS NULL / IS NOT NULL; nunca = NULL |
| Operaciones con NULL | Suelen dar NULL |
| Agregaciones | Ignoran NULL (salvo COUNT(*)) |
| ORDER BY | NULL es menor; controla con IS NULL |
| NOT NULL | Obliga a dar valor |
| DEFAULT | Valor si omites la columna (no si pones NULL explícito) |
| IFNULL / COALESCE | Reemplazan NULL por un valor |
| NULLIF | Convierte un valor en NULL (útil para división por cero) |
| Diseño | FK y columnas clave → NOT NULL |

Regla de oro: NULL no es un valor, es la ausencia de valor. Trátalo como tal en comparaciones, agregaciones y diseño de tablas.