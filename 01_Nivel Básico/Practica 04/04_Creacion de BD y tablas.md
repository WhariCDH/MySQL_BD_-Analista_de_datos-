# 📚 Tema 4: Creación de bases de datos y tablas

## Objetivo

Aprender a crear bases de datos y tablas en MySQL, aplicar los tipos de datos del tema anterior, y entender las restricciones básicas al definir columnas.

---

## 1. Crear una base de datos

```sql
CREATE DATABASE tienda;
```

Con buenas prácticas (evitar errores si ya existe y definir codificación):

```sql
CREATE DATABASE IF NOT EXISTS tienda
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
```

- **IF NOT EXISTS:** no falla si ya existe.
- **utf8mb4:** soporta todos los caracteres Unicode, incluidos emojis. Recomendado siempre.
- **COLLATE:** reglas de comparación/ordenación de texto.

### Ver y seleccionar bases de datos

```sql
SHOW DATABASES;        -- lista todas
USE tienda;            -- selecciona la BD activa
SELECT DATABASE();     -- muestra cuál está activa
```

> 💡 Todo lo que crees después de `USE tienda;` irá dentro de esa base de datos.

### Eliminar una base de datos (con cuidado)

```sql
DROP DATABASE IF EXISTS tienda;   -- ⚠ borra todo, irreversible
```

---

## 2. Crear una tabla: sintaxis general

```sql
CREATE TABLE nombre_tabla (
    columna1  tipo  [restricciones],
    columna2  tipo  [restricciones],
    ...
    [restricciones de tabla]
);
```

### Ejemplo básico

```sql
USE tienda;

CREATE TABLE clientes (
    id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL,
    email     VARCHAR(255) NOT NULL,
    telefono  VARCHAR(20),
    ciudad    VARCHAR(80),
    activo    TINYINT(1) DEFAULT 1,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Ver la estructura creada

```sql
DESCRIBE clientes;      -- o: DESC clientes;
SHOW TABLES;            -- lista tablas de la BD activa
SHOW CREATE TABLE clientes;   -- muestra el SQL exacto de creación
```

---

## 3. Restricciones (constraints) esenciales

| Restricción       | Qué hace                                                                                    |
| ---               | ---                                                                                         |
| PRIMARY KEY       | Identifica cada fila de forma única. No admite NULL ni duplicados                           |
| NOT NULL          | Obliga a que la columna tenga valor                                                         |
| UNIQUE            | No permite valores duplicados (pero sí varios NULL)                                         |
| DEFAULT valor     | Valor por defecto si no se especifica                                                       |
| AUTO_INCREMENT    | Genera números consecutivos automáticamente (solo una columna por tabla, normalmente la PK) |
| CHECK (condición) | Valida una condición (MySQL 8.0+)                                                           |
| FOREIGN KEY       | Relaciona con otra tabla (lo veremos en el Tema 9)                                          |

### Clave primaria: dos formas de declararla

En la columna:

```sql
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
```

Al final, como restricción de tabla (útil para claves compuestas):

```sql
id INT UNSIGNED AUTO_INCREMENT,
PRIMARY KEY (id)
```

### Ejemplo con varias restricciones

```sql
CREATE TABLE productos (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo      VARCHAR(20)  NOT NULL UNIQUE,
    nombre      VARCHAR(150) NOT NULL,
    precio      DECIMAL(10,2) NOT NULL,
    stock       INT UNSIGNED DEFAULT 0,
    categoria   ENUM('electronica','ropa','alimentos','otros') DEFAULT 'otros',
    activo      TINYINT(1) DEFAULT 1,
    creado_en   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (precio >= 0)
);
```

- **codigo** es UNIQUE: no puede repetirse.
- **precio** tiene un CHECK que impide negativos.
- **stock** y **activo** tienen DEFAULT.

---

## 4. Tablas con clave primaria compuesta

Cuando ninguna columna sola identifica la fila, se combinan varias:

```sql
CREATE TABLE inscripciones (
    id_alumno  INT UNSIGNED NOT NULL,
    id_curso   INT UNSIGNED NOT NULL,
    fecha      DATE NOT NULL,
    nota       DECIMAL(4,2),
    PRIMARY KEY (id_alumno, id_curso)
);
```

Aquí la combinación (id_alumno, id_curso) es única: un alumno no puede inscribirse dos veces al mismo curso.

---

## 5. Buenas prácticas al crear tablas

- Nombres en minúsculas y sin espacios (clientes, detalle_pedido).
- Siempre define una PK, aunque sea un id autoincremental.
- Usa utf8mb4 a nivel de BD para evitar problemas con acentos y emojis.
- Pon NOT NULL en columnas que realmente deban tener valor.
- Usa DEFAULT para valores predecibles (activo, fechas de creación).
- Nunca guardes contraseñas en texto plano (lo veremos en seguridad).
- Documenta con COMMENT si algo no es obvio:

```sql
estado VARCHAR(20) COMMENT 'pendiente, pagado, enviado'
```

---

## 6. Ejemplo integrador: mini esquema de tienda

```sql
CREATE DATABASE IF NOT EXISTS tienda
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE tienda;

CREATE TABLE clientes (
    id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL,
    email     VARCHAR(255) NOT NULL UNIQUE,
    telefono  VARCHAR(20),
    activo    TINYINT(1) DEFAULT 1,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE productos (
    id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo    VARCHAR(20) NOT NULL UNIQUE,
    nombre    VARCHAR(150) NOT NULL,
    precio    DECIMAL(10,2) NOT NULL,
    stock     INT UNSIGNED DEFAULT 0,
    activo    TINYINT(1) DEFAULT 1,
    CHECK (precio >= 0)
);

CREATE TABLE pedidos (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_cliente  INT UNSIGNED NOT NULL,
    fecha       DATETIME DEFAULT CURRENT_TIMESTAMP,
    total       DECIMAL(10,2) DEFAULT 0,
    estado      ENUM('pendiente','pagado','enviado','cancelado') DEFAULT 'pendiente'
);
```

> 🔎 Nota: pedidos.id_cliente apunta a clientes.id, pero la FOREIGN KEY formal la agregaremos en el Tema 9. Por ahora solo guardamos la columna.

---

## 7. ✅ Mini ejercicio

1. Crea una base de datos llamada escuela con utf8mb4.
2. Dentro de ella, crea la tabla alumnos con:
   - id entero autoincremental como PK
   - nombre obligatorio, hasta 100 caracteres
   - email único y obligatorio
   - fecha_nacimiento solo fecha
   - activo booleano con default 1
   - inscrito_en timestamp con default al momento actual
3. Crea la tabla cursos con id, nombre, creditos (entero, mayor a 0 con CHECK).
4. Ejecuta DESCRIBE alumnos; y verifica los tipos.
5. Ejecuta SHOW CREATE TABLE cursos; y observa el SQL que genera MySQL.
6. Bonus: crea la tabla notas con clave primaria compuesta (id_alumno, id_curso).

---

## 🎯 Resumen

- CREATE DATABASE + USE para trabajar en una BD.
- CREATE TABLE define columnas con su tipo y restricciones.
- PRIMARY KEY identifica filas; UNIQUE, NOT NULL, DEFAULT, CHECK refuerzan la integridad.
- AUTO_INCREMENT genera IDs automáticos.
- DESCRIBE y SHOW CREATE TABLE para inspeccionar.
- Nombres claros, utf8mb4, y siempre una PK.