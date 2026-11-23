-- 📚 TEMA 3: Tipos de datos en MySQL
-- Apunte: elegir bien el tipo = menos espacio, más velocidad, menos errores.

-- Ejemplo 1: CHAR vs VARCHAR
-- CHAR(2) = siempre 2 letras, VARCHAR = solo ocupa lo que uses
CREATE TABLE ejemplo_texto (
  codigo_pais CHAR(2),       -- siempre 2 letras: 'PE', 'CO'
  nombre      VARCHAR(100),  -- hasta 100, ocupa lo que necesite
  email       VARCHAR(255)   -- estándar para emails
);

-- Ejemplo 2: Fechas
CREATE TABLE ejemplo_fechas (
  fecha_nacimiento DATE,
  creado_en        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  actualizado_en   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Ejemplo 3: ENUM
CREATE TABLE ejemplo_enum (
  estado ENUM('pendiente','pagado','enviado','cancelado')
);

-- Ejemplo 4: Tabla bien tipada
CREATE TABLE productos (
    id             INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre         VARCHAR(150) NOT NULL,
    descripcion    TEXT,
    precio         DECIMAL(10,2) NOT NULL, -- DINERO SIEMPRE DECIMAL
    stock          INT UNSIGNED DEFAULT 0,
    activo         TINYINT(1) DEFAULT 1, -- BOOLEANO en MySQL
    categoria      ENUM('electronica','ropa','alimentos','otros') DEFAULT 'otros',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ✅ RETO DEL TEMA: Crea la tabla empleados
-- Pista:
-- id_cliente -> INT UNSIGNED AUTO_INCREMENT PRIMARY KEY
-- nombre_completo -> VARCHAR(150)
-- salario -> DECIMAL(10,2)
-- fecha_contratacion -> DATE
-- esta_activo -> TINYINT(1)
-- biografia -> TEXT
-- codigo_postal -> CHAR(5)

-- Escribe tu respuesta aquí abajo:
-- CREATE TABLE empleados (
-- ...
-- );