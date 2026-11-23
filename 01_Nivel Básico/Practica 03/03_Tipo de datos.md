# 📚 Tema 3: Tipos de datos en MySQL

## ¿Por qué es importante?
Cuando creas una tabla, cada columna debe tener un tipo de dato. Elegir bien:

- **Ahorra espacio** en disco.
- Hace las consultas **más rápidas**.
- **Evita errores** (ej: guardar texto en una columna numérica).

MySQL agrupa los tipos en 4 familias: numéricos, cadenas de texto, fecha/hora y otros especiales.

## 1. Tipos numéricos

### Enteros

|    Tipo    | Bytes | Rango con signo                | Uso típico                     |
| :---       | :---  | :---                           | :---                           |
| TINYINT    | 1     | -128 a 127                     | Booleanos, edades, flags       |
| SMALLINT   | 2     | -32,768 a 32,767               | Contadores pequeños            |
| MEDIUMINT  | 3     | -8,388,608 a 8,388,607         | Poco usado                     |
| INT        | 4     | -2,147,483,648 a 2,147,483,647 | El más común (IDs, cantidades) |
| BIGINT     | 8     | Hasta 9.2 quintillones         | IDs gigantes, timestamps       |

> 💡 Puedes agregar `UNSIGNED` para no permitir negativos y duplicar el rango positivo: `INT UNSIGNED` va de 0 a 4,294,967,295.

### Decimales

|     Tipo     |           Uso            | Ejemplo                     |
| :---         | :---                     | :---                        |
| DECIMAL(M,D) | Exacto — dinero, precios | DECIMAL(10,2) → 12345678.90 |
| FLOAT        | Aproximado, 4 bytes      | Científico, coordenadas     |
| DOUBLE       | Aproximado, 8 bytes      | Mayor precisión aproximada  |

> ⚠️ **Regla de oro:** para dinero usa siempre **DECIMAL**, nunca FLOAT. Los flotantes pierden precisión: `0.1 + 0.2 ≠ 0.3` exacto.

> **BIT:** `BIT(1)` guarda 0 o 1. MySQL no tiene BOOLEAN nativo: usa `TINYINT(1)`. MySQL acepta `BOOLEAN` como alias de `TINYINT(1)`.

## 2. Tipos de cadena de texto

|     Tipo    | Longitud máxima | Uso                                                |
| :---        | :---            | :---                                               |
| CHAR(n)     | 0–255           | Longitud fija (ej: códigos de país "PE", "CO")     |
| VARCHAR(n)  | 0–65,535        | Longitud variable — el más usado (nombres, emails) |
| TINYTEXT    | 255             | Textos cortos                                      |
| TEXT        | 65,535          | Descripciones, comentarios                         |
| MEDIUMTEXT  | 16 MB           | Documentos                                         |
| LONGTEXT    | 4 GB            | Textos enormes                                     |
| BLOB        | Binario         | Imágenes, archivos (poco recomendado)              |

### CHAR vs VARCHAR (diferencia clave)
- **CHAR(10):** siempre ocupa 10 caracteres (rellena con espacios). Rápido para longitudes fijas.
- **VARCHAR(50):** ocupa solo lo que uses + 1-2 bytes de control. Ideal para longitud variable.

> 💡 `VARCHAR(255)` es el tamaño típico para emails y URLs. No pongas `VARCHAR(10000)` "por si acaso": malgasta y ralentiza.

## 3. Tipos de fecha y hora

|     Tipo    | Formato             | Rango                    | Uso                           |
| :---        | :---                | :---                     | :---                          |
| DATE        | YYYY-MM-DD          | 1000-01-01 a 9999-12-31  | Solo fecha (cumpleaños)       |
| TIME        | HH:MM:SS            | -838:59:59 a 838:59:59   | Solo hora o duración          |
| DATETIME    | YYYY-MM-DD HH:MM:SS | 1000 a 9999              | Fecha + hora (el más común)   |
| TIMESTAMP   | YYYY-MM-DD HH:MM:SS | 1970 a 2038              | Fecha + hora con zona horaria |
| YEAR        | YYYY                | 1901 a 2155              | Solo año                      |

### DATETIME vs TIMESTAMP
- **DATETIME:** guarda la fecha tal cual la escribes, sin conversión de zona horaria.
- **TIMESTAMP:** se convierte a UTC internamente y tiene límite en 2038. Útil para `created_at`, `updated_at`.

## 4. Tipos especiales

| Tipo                   | Para qué                                                                         |
| :---                   | :---                                                                             |
| ENUM('a','b','c')      | Solo permite uno de los valores listados. Ej: `estado ENUM('activo','inactivo')` |
| SET('a','b','c')       | Permite varios valores de la lista                                               |
| JSON                   | Guarda documentos JSON (MySQL 5.7+)                                              |
| GEOMETRY, POINT, etc.  | Datos espaciales (mapas)                                                         |

> **ENUM:** útil pero con cuidado. Ventaja: ahorra espacio y valida. Desventaja: cambiar los valores requiere `ALTER TABLE`.

## 5. Reglas prácticas para elegir tipos

- **IDs** → `INT UNSIGNED AUTO_INCREMENT` (o BIGINT si esperas >4 mil millones).
- **Dinero** → `DECIMAL(10,2)` siempre.
- **Nombres, emails** → `VARCHAR` con tamaño razonable.
- **Textos largos** → `TEXT`.
- **Fechas con hora** → `DATETIME` o `TIMESTAMP`.
- **Booleanos** → `TINYINT(1)`.
- **Valores fijos** → `ENUM` (con moderación).

No abuses de `TEXT` si no lo necesitas: ocupa más y no se puede indexar completo fácilmente.

## 6. ✅ Mini ejercicio
Para cada columna, elige el tipo más adecuado y justifica:

1. `id_cliente` (identificador único, no negativo)
2. `nombre_completo` (hasta 150 caracteres)
3. `salario` (con 2 decimales exactos)
4. `fecha_contratacion` (solo fecha)
5. `esta_activo` (sí/no)
6. `biografia` (texto largo, variable)
7. `codigo_postal` (siempre 5 caracteres)

**Bonus:** intenta escribir el `CREATE TABLE empleados (...)` con esos campos.

## 🎯 Resumen
- 4 familias: numéricos, texto, fecha/hora, especiales.
- INT para IDs, DECIMAL para dinero, VARCHAR para texto variable, DATETIME/TIMESTAMP para fechas.
- CHAR = fijo, VARCHAR = variable.
- ENUM para valores fijos, TINYINT(1) como booleano.
- Elegir bien = menos espacio, más velocidad, menos errores.