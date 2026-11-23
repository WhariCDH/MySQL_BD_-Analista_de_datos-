-- 📚 TEMA 1: ¿Qué es una base de datos?

-- Ejemplo de la tabla clientes del apunte:
-- id = Clave Primaria (PK), no se repite
-- nombre, email, ciudad = Campos / Columnas
-- Cada INSERT = un Registro / Fila

CREATE DATABASE practica;
USE practica;

CREATE TABLE clientes (
  id INT PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100),
  ciudad VARCHAR(100)
);

INSERT INTO clientes VALUES (1, 'Ana López', 'ana@mail.com', 'Lima');
INSERT INTO clientes VALUES (2, 'Luis Pérez', 'luis@mail.com', 'Bogotá');
INSERT INTO clientes VALUES (3, 'Marta Ruiz', 'marta@mail.com', 'Lima');
INSERT INTO clientes VALUES (4, 'Carlos Huaripata', 'carlos@gmail.com', 'Lima');

-- Ver toda la tabla
SELECT * FROM clientes;

-- Borrar para actualizar la lista cliente
DROP TABLE clientes; 