# 📚 Tema 5: Operaciones CRUD básicas

## ¿Qué es CRUD?

CRUD son las 4 operaciones fundamentales sobre datos:

| Letra  | Operación  | Comando SQL |
| ---    | ---        | ---         |
| Create | Crear      | INSERT      |
| Read   | Leer       | SELECT      |
| Update | Actualizar | UPDATE      |
| Delete | Borrar     | DELETE      |

Todo lo demás (JOINs, vistas, procedimientos) se construye sobre estas cuatro.

> 💡 Trabajaremos sobre el esquema escuela del tema anterior. Si no lo tienes, ejecuta primero el SQL del Tema 4.

---

## 1. INSERT — Insertar datos

### Sintaxis básica (una fila)

```sql
INSERT INTO tabla (columna1, columna2, ...)
VALUES (valor1, valor2, ...);
```

### Ejemplo

```sql
USE escuela;

INSERT INTO alumnos (nombre, email, fecha_nacimiento)
VALUES ('Ana López', 'ana@mail.com', '2000-05-14');
```

¿Qué pasó?

- **id** → lo generó AUTO_INCREMENT (1).
- **activo** → tomó el DEFAULT (1).
- **inscrito_en** → tomó CURRENT_TIMESTAMP (ahora).
- No listamos esas columnas porque se llenan solas.

### Insertar varias filas a la vez (más eficiente)

```sql
INSERT INTO alumnos (nombre, email, fecha_nacimiento) VALUES
    ('Luis Pérez',  'luis@mail.com',  '1999-11-02'),
    ('Marta Ruiz',  'marta@mail.com', '2001-03-20'),
    ('Pedro Gómez', 'pedro@mail.com', '2000-08-09');
```

### Insertar especificando todas las columnas

```sql
INSERT INTO alumnos (id, nombre, email, fecha_nacimiento, activo, inscrito_en)
VALUES (10, 'Carla Díaz', 'carla@mail.com', '2002-01-15', 0, '2026-01-10 09:30:00');
```

> ⚠ Si omites la lista de columnas (`INSERT INTO alumnos VALUES (...)`), debes dar todos los valores en el orden exacto de la tabla. Es frágil: mejor siempre listar columnas.

### Insertar en cursos y notas

```sql
INSERT INTO cursos (nombre, creditos) VALUES
    ('Matemáticas', 5),
    ('Historia',    4),
    ('Programación', 6);

INSERT INTO notas (id_alumno, id_curso, nota) VALUES
    (1, 1, 9.50),
    (1, 3, 8.75),
    (2, 1, 7.00);
```

---

## 2. SELECT — Consultar datos

### Sintaxis básica

```sql
SELECT columnas FROM tabla [WHERE condición] [ORDER BY ...] [LIMIT n];
```

### Consultas esenciales

Todo:

```sql
SELECT * FROM alumnos;
```

Columnas específicas:

```sql
SELECT nombre, email FROM alumnos;
```

Con alias (para renombrar en la salida):

```sql
SELECT nombre AS alumno, email AS correo FROM alumnos;
```

Filtrar con WHERE:

```sql
SELECT * FROM alumnos WHERE activo = 1;
SELECT * FROM alumnos WHERE fecha_nacimiento > '2000-01-01';
SELECT * FROM alumnos WHERE nombre = 'Ana López';
```

Combinar condiciones (AND / OR):

```sql
SELECT * FROM alumnos
WHERE activo = 1 AND fecha_nacimiento >= '2000-01-01';
```

Ordenar (ASC por defecto, DESC descendente):

```sql
SELECT nombre, fecha_nacimiento
FROM alumnos
ORDER BY fecha_nacimiento DESC;
```

Limitar resultados:

```sql
SELECT * FROM alumnos LIMIT 2;              -- primeros 2
SELECT * FROM alumnos LIMIT 2 OFFSET 2;     -- salta 2, toma 2 (paginación)
```

Valores únicos (sin repetir):

```sql
SELECT DISTINCT activo FROM alumnos;
```

### Operadores útiles en WHERE

| Operador | Ejemplo |
| --- | --- |
| = <> (!=) | WHERE activo = 1 / WHERE activo <> 1 |
| > < >= <= | WHERE nota >= 8 |
| BETWEEN a AND b | WHERE fecha_nacimiento BETWEEN '1999-01-01' AND '2000-12-31' |
| IN (lista) | WHERE id IN (1, 3, 5) |
| LIKE | WHERE nombre LIKE 'Ana%' (% = cualquier cosa, _ = un carácter) |
| IS NULL / IS NOT NULL | WHERE fecha_nacimiento IS NULL |

Ejemplo con LIKE:

```sql
SELECT * FROM alumnos WHERE email LIKE '%@mail.com';
SELECT * FROM alumnos WHERE nombre LIKE 'A%';   -- empieza con A
```

---

## 3. UPDATE — Actualizar datos

### Sintaxis

```sql
UPDATE tabla SET columna1 = valor1, columna2 = valor2 WHERE condición;
```

### Ejemplos

Actualizar un campo:

```sql
UPDATE alumnos SET activo = 0 WHERE id = 3;
```

Actualizar varios campos:

```sql
UPDATE alumnos
SET email = 'ana.lopez@mail.com', activo = 1
WHERE id = 1;
```

Actualizar varias filas:

```sql
UPDATE cursos 
SET creditos = creditos + 1 
WHERE creditos < 5;
```

Actualizar nota:

```sql
UPDATE notas 
SET nota = 9.00 
WHERE id_alumno = 2 
AND id_curso = 1;
```

> ⚠ Regla de oro: SIEMPRE usa WHERE

```sql
UPDATE alumnos SET activo = 0;   -- ❌ ¡desactiva TODOS los alumnos!
```

> 💡 Antes de un UPDATE o DELETE peligroso, ejecuta primero el SELECT con el mismo WHERE para ver qué filas serán afectadas:

```sql
SELECT * FROM alumnos 
WHERE id = 3;      -- reviso
UPDATE alumnos 
SET activo = 0 
WHERE id = 3;  -- actualizo
```

---

## 4. DELETE — Borrar datos

### Sintaxis

```sql
DELETE FROM tabla WHERE condición;
```

### Ejemplos

```sql
DELETE FROM notas 
WHERE nota < 5;

DELETE FROM alumnos 
WHERE id = 4;
```

> ⚠ Reglas de oro
>
> - Siempre con WHERE. `DELETE FROM alumnos;` vacía la tabla entera.
> - DELETE borra filas, no la tabla. Para eliminar la estructura: DROP TABLE.
> - DELETE es reversible solo si estás dentro de una transacción (Tema 21) o tienes backup.

### DELETE vs TRUNCATE vs DROP

| Comando | Qué hace | ¿Se puede deshacer? |
| --- | --- | --- |
| DELETE FROM t WHERE ... | Borra filas que cumplan condición | Sí, con transacción |
| DELETE FROM t; | Borra todas las filas (una a una) | Sí, con transacción |
| TRUNCATE TABLE t; | Vacía la tabla rápido (reinicia AUTO_INCREMENT) | No |
| DROP TABLE t; | Elimina la tabla completa | No |

---

## 5. Flujo CRUD completo (ejemplo integrador)

```sql
USE escuela;

-- CREATE
INSERT INTO alumnos (nombre, email, fecha_nacimiento)
VALUES ('Sofía Torres', 'sofia@mail.com', '2001-07-30');

-- READ (verificar que entró)
SELECT * FROM alumnos WHERE email = 'sofia@mail.com';

-- UPDATE (corregir fecha)
UPDATE alumnos
SET fecha_nacimiento = '2001-07-31'
WHERE email = 'sofia@mail.com';

-- READ (verificar cambio)
SELECT nombre, fecha_nacimiento FROM alumnos WHERE email = 'sofia@mail.com';

-- DELETE (borrar el registro de prueba)
DELETE FROM alumnos WHERE email = 'sofia@mail.com';

-- READ (confirmar que ya no está)
SELECT * FROM alumnos WHERE email = 'sofia@mail.com';   -- 0 filas
```

---

## 6. ✅ Mini ejercicio

Con el esquema escuela:

1. Inserta 3 alumnos nuevos en una sola sentencia.
2. Inserta 2 cursos nuevos.
3. Consulta todos los alumnos ordenados por nombre ascendente.
4. Muestra solo nombre y email de los alumnos nacidos después del 2000.
5. Actualiza el email del alumno con id = 2.
6. Sube en 1 los créditos de todos los cursos con menos de 5 créditos.
7. Elimina las notas con nota < 6.
8. Muestra cuántos alumnos hay en total. (pista: SELECT COUNT(*) FROM alumnos;)
9. Bonus: muestra los alumnos cuyo nombre empiece con "M" y estén activos.

---

## 🎯 Resumen

- **INSERT:** crear filas. Lista columnas y usa valores múltiples para eficiencia.
- **SELECT:** leer con WHERE, ORDER BY, LIMIT, DISTINCT, LIKE, IN, BETWEEN.
- **UPDATE:** modificar. Siempre con WHERE.
- **DELETE:** borrar filas. Siempre con WHERE.
- Antes de UPDATE/DELETE, prueba el WHERE con un SELECT.
- COUNT(*) te cuenta filas.