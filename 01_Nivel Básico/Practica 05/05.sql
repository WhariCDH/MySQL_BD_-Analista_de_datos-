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
-- 1: Insertar 3 alumnos nuevos en una sola sentencia

USE escuela;

INSERT INTO alumnos (nombre, email, fecha_nacimiento) VALUES
    ('Daniel Huaripata', 'daniel@mail.com', '1998-07-15'),
    ('Marina Saul', 'marina@mail.com', '2020-07-14'),
    ('Dayana Garcia', 'dayana@mail.com', '2021-02-01');
    
SELECT * FROM alumnos;

-- 2: Insertar 2 cursos nuevos 
INSERT INTO cursos (nombre, creditos) VALUES
     ('Lenguaje', 3),
     ('Sistemas', 4);

SELECT*FROM cursos;

-- 3: Todos los alumnos ordenados por nombre ascendente 
SELECT * FROM alumnos
ORDER BY nombre ASC;       -- Ordenado en forma ascendente 

-- 4: Solo nombre y email de alumnos nacidos después del 2000
SELECT nombre, email
FROM alumnos
WHERE fecha_nacimiento > '2000-12-31';

-- 5: Actualizar el email del alumno con id = 2
UPDATE alumnos
SET email = 'whari@mail.com'
WHERE id=20;

-- Verificamos 
SELECT id, nombre, email 
FROM alumnos 
WHERE id= 20;

-- 6: Subir en 1 los créditos de los cursos con menos de 5 créditos
UPDATE cursos
SET creditos = creditos + 1
WHERE creditos < 5;

SELECT*FROM cursos; 

-- 7: Elimar las notas con nota < 6
DELETE FROM notas
WHERE nota < 6;

SELECT*FROM notas;

-- 8: Mostrar cuántos alumnos hay en total
SELECT COUNT(*) AS total_alumnos FROM alumnos;  -- COUNT(*) = cuantas filas

-- 9: Bonus: alumnos cuyo nombre empiece con "M" y estén activos
SELECT * FROM alumnos
WHERE nombre LIKE 'M%'    -- LIKE 'M%' cuantos empiezan con M mayuscula 
   AND activo = 1; 
