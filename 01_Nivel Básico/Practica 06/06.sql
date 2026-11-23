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
-- VERIFICAR DATOS
-- ============================================
SELECT * FROM alumnos;
SELECT * FROM cursos;
SELECT * FROM notas;

-- ************************************************************************************************************
-- 1: Alumnos nacidos entre 1999 y 2001 (inclusive), ordenados por fecha ascendente
SELECT nombre, fecha_nacimiento
FROM alumnos 
WHERE fecha_nacimiento BETWEEN '1999-01-01' AND '2001-12-31'
ORDER BY fecha_nacimiento ASC;

-- 2: Cursos con 4 o 6 créditos usando IN   (DISTRINCT para que no repita cursos)
SELECT DISTINCT nombre, creditos   
FROM cursos
WHERE creditos IN (4,6);

-- 3: Nombre y email de alumnos cuyo nombre contenga "a" y estén activos
SELECT nombre, email
FROM alumnos
WHERE nombre LIKE '%a%'
AND activo = 1;

-- 4: Notas ≥ 8, ordenadas por id_curso ASC y luego por nota DESC
SELECT id_alumno, id_curso, nota
FROM notas
WHERE nota >= 8
ORDER BY id_curso ASC, nota DESC;

-- 5: Página 2 de cursos, 2 por página, ordenados por nombre
SELECT * 
FROM cursos
ORDER BY nombre ASC
LIMIT 2 OFFSET 2;

-- 6: Valores únicos de nota en notas
SELECT DISTINCT nota
FROM notas
ORDER BY nota; 

-- 7: Alumnos con fecha_nacimiento NULL
SELECT * 
FROM alumnos
WHERE fecha_nacimiento IS NULL;

-- 8: Top 2 de las notas más bajas
SELECT id_alumno, id_curso, nota
FROM notas
ORDER BY nota ASC
LIMIT 2;

-- 9: Bonus: nombre empieza con "M" o email contiene "ana", solo activos
SELECT nombre, email, activo
FROM alumnos
WHERE activo = 1
   AND (nombre LIKE 'M%' OR email LIKE '%ana%');
   

