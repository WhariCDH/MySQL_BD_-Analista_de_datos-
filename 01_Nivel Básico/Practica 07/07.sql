-- ============================================
-- CREAR LA BASE DE DATOS
-- ============================================
DROP DATABASE IF EXISTS escuela;   -- ⚠️ Solo si quieres empezar limpio

CREATE DATABASE escuela
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE escuela;

-- ============================================
-- CREAR TABLAS
-- ============================================

-- Tabla alumnos
CREATE TABLE alumnos (
    id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL,
    email            VARCHAR(255) NOT NULL UNIQUE,
    fecha_nacimiento DATE,
    activo           TINYINT(1) DEFAULT 1,
    inscrito_en      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla cursos
CREATE TABLE cursos (
    id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre   VARCHAR(150) NOT NULL,
    creditos INT UNSIGNED NOT NULL,
    CHECK (creditos > 0)
);

-- Tabla notas (clave primaria compuesta)
CREATE TABLE notas (
    id_alumno INT UNSIGNED NOT NULL,
    id_curso  INT UNSIGNED NOT NULL,
    nota      DECIMAL(4,2),
    PRIMARY KEY (id_alumno, id_curso)
);

-- ============================================
-- VERIFICAR ESTRUCTURA
-- ============================================
DESCRIBE alumnos;
DESCRIBE cursos;
DESCRIBE notas;
SHOW CREATE TABLE cursos;

-- ============================================
-- DATOS DE PRUEBA
-- ============================================

-- Alumnos
INSERT INTO alumnos (nombre, email, fecha_nacimiento) VALUES
    ('Ana López',   'ana@mail.com',   '2000-05-14'),
    ('Luis Pérez',  'luis@mail.com',  '1999-11-02'),
    ('Marta Ruiz',  'marta@mail.com', '2001-03-20'),
    ('Pedro Gómez', 'pedro@mail.com', '2000-08-09'),
    ('Sofía Torres','sofia@mail.com', '2001-07-30'),
    ('Miguel Ramos','miguel@mail.com','1998-12-05'),
    ('María Castro','maria@mail.com', '2002-04-18');

-- Cursos
INSERT INTO cursos (nombre, creditos) VALUES
    ('Matemáticas',  5),
    ('Historia',     4),
    ('Programación', 6),
    ('Química',      3),
    ('Literatura',   4);

-- Notas
INSERT INTO notas (id_alumno, id_curso, nota) VALUES
    (1, 1, 9.50),
    (1, 3, 8.75),
    (2, 1, 7.00),
    (2, 2, 5.50),
    (3, 3, 9.00),
    (4, 4, 4.25),
    (5, 5, 6.75),
    (6, 1, 8.00),
    (7, 2, 7.25);

-- ============================================
-- 1. Total de alumnos y cuántos tienen fecha_nacimiento no nula
SELECT
    COUNT(*)                    AS total_alumnos,
    COUNT(fecha_nacimiento)     AS con_fecha
FROM alumnos;

-- 2. Suma total de créditos y promedio redondeado a 2 decimales
SELECT
    SUM(creditos)              AS total_creditos,
    ROUND(AVG(creditos), 2)    AS promedio_creditos
FROM cursos;

-- 3. Nota mínima, máxima y promedio (redondeado a 2) de notas
SELECT
    MIN(nota)                  AS nota_min,
    MAX(nota)                  AS nota_max,
    ROUND(AVG(nota), 2)        AS nota_prom
FROM notas;

-- 4. nombre y email concatenados como "Nombre <email>"
SELECT
    CONCAT(nombre, ' <', email, '>') AS contacto
FROM alumnos;

-- 5. Dominio de cada email (lo que va después de @)
SELECT
    email,
    SUBSTRING(email, LOCATE('@', email) + 1) AS dominio
FROM alumnos;

-- 6. Edad actual de cada alumno, ordenados de mayor a menor
SELECT
    nombre,
    fecha_nacimiento,
    TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad
FROM alumnos
ORDER BY edad DESC;

-- 7. Alumnos nacidos en mayo (usando MONTH)
SELECT nombre, fecha_nacimiento
FROM alumnos
WHERE MONTH(fecha_nacimiento) = 5;

-- 8. Para cada nota: id_alumno, nota y estado con IF
SELECT
    id_alumno,
    nota,
    IF(nota >= 6, 'aprobado', 'desaprobado') AS estado
FROM notas
ORDER BY id_alumno, nota;

-- 9. Días transcurridos desde inscrito_en hasta hoy
SELECT
    nombre,
    DATE(inscrito_en) AS fecha_inscripcion,
    DATEDIFF(CURDATE(), DATE(inscrito_en)) AS dias_transcurridos
FROM alumnos
ORDER BY dias_transcurridos DESC;

-- 10. Bonus: promedio de notas por curso, redondeado a 2, ordenado de mayor a menor
SELECT
    id_curso,
    COUNT(*)                 AS cantidad_notas,
    ROUND(AVG(nota), 2)      AS promedio
FROM notas
GROUP BY id_curso
ORDER BY promedio DESC;