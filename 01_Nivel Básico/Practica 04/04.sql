-- 01: Crea una base de datos
DROP DATABASE escuela;

CREATE DATABASE IF NOT EXISTS escuela
	CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE escuela;

-- 02: Crear la tabla alumnos
CREATE TABLE alumnos (
    id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre            VARCHAR(100) NOT NULL,
    email             VARCHAR(255) NOT NULL UNIQUE,
    fecha_nacimiento  DATE,
    activo            TINYINT(1) DEFAULT 1,
    inscrito_en       TIMESTAMP DEFAULT CURRENT_TIMESTAMP      -- Se llena solo 
);

-- 03: Crea la tabla cursos
CREATE TABLE curso (
    id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre            VARCHAR(150) NOT NULL,
    credito           INT UNSIGNED NOT NULL,
    CHECK (credito > 0)
);

-- 04: Describe alumnos
DESCRIBE alumnos;
DESCRIBE curso;

-- 05: SHOW CREATE TABLE curso;
SHOW CREATE TABLE curso;

-- 06: Bonus: Tabla notas con clave primaria compuesta
CREATE TABLE notas (
	id_alumno INT UNSIGNED NOT NULL,
    id_curso  INT UNSIGNED NOT NULL,
    nota      DECIMAL(4,2),
    PRIMARY KEY (id_alumno, id_curso)
);

-- 07: Prueba opcional 

-- ✅ Debe funcionar
INSERT INTO curso (nombre, credito) VALUES ('Matemáticas', 5);
SELECT*FROM curso;

-- ❌ Debe fallar por CHECK (creditos > 0)
INSERT INTO curso (nombre, creditos) VALUES ('Física', 0);

-- ✅ Debe funcionar
INSERT INTO alumnos (nombre, email) VALUES ('Ana López', 'ana@mail.com');
SELECT*FROM alumnos; 

-- ❌ Debe fallar por UNIQUE en email
INSERT INTO alumno (nombre, email) VALUES ('Otro Ana', 'ana@mail.com');

-- ❌ Debe fallar por NOT NULL en nombre
INSERT INTO alumno (email) VALUES ('sin_nombre@mail.com');

