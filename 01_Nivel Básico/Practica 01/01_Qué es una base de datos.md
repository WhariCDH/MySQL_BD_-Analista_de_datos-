# 📚 Tema 1: ¿Qué es una base de datos?

## 1. Definición simple
Una base de datos es una colección organizada de información (datos) que se almacena de forma estructurada para poder consultarla, modificarla y gestionarla fácilmente.

Imagina una agenda de contactos: tienes nombres, teléfonos y correos. Si está en papel, es difícil buscar "todos los que empiecen con A". 
Si está en una base de datos, lo buscas en milisegundos.

**SGBD (Sistema Gestor de Bases de Datos)** es el software que administra esa base de datos. **MySQL** es uno de los más populares, es libre y de código abierto.

## 2. Conceptos fundamentales (con analogía de Excel)

|       Concepto SQL       |       Analogía en Excel       |                Qué es                          |
| :---                     | :---                          | :---                                           |
|       Base de datos      |       Un libro de Excel       |      Contenedor que agrupa varias tablas       |
| Tabla                    | Una hoja del libro            | Guarda datos de un mismo tipo (ej: "clientes") |
| Registro / Fila          | Una fila de Excel             | Un elemento individual (ej: un cliente)        |
| Campo / Columna          | Una columna de Excel          | Un atributo (ej: "nombre", "email")            |
| Valor                    | Una celda                     | El dato concreto (ej: "Juan")                  |
| Clave primaria (PK)      | —                             | Columna que identifica de forma única cada fila (ej: ID) |

### Ejemplo visual: tabla clientes

|id(PK)| nombre     | email          | ciudad |
| :--- | :---       | :---           | :---   |
| 1    | Ana López  | ana@mail.com   | Lima   |
| 2    | Luis Pérez | luis@mail.com  | Bogotá |
| 3    | Marta Ruiz | marta@mail.com | Lima   |
 
- La tabla es `clientes`.
- Cada fila es un cliente.
- Cada columna es un campo.
- `id` es la clave primaria porque no se repite.

## 3. ¿Por qué usar una BD y no Excel?

- **Volumen:** maneja millones de registros sin problema.
- **Velocidad:** búsquedas muy rápidas gracias a los índices.
- **Concurrencia:** muchos usuarios pueden leer/escribir sin corromper datos.
- **Integridad:** reglas que evitan datos malos (ej: no permitir email duplicado).
- **Seguridad:** permisos por usuario.
- **Relaciones:** conectar tablas entre sí (clientes ↔ pedidos).

## 4. Tipos de bases de datos

- **Relacionales (SQL):** datos en tablas con relaciones. Ej: MySQL, PostgreSQL, SQL Server, 【entity-Oracle¦canonical_name=Oracle】. **← Aquí trabajaremos.**
- **No relacionales (NoSQL):** documentos, grafos, clave-valor. Ej: 【entity-MongoDB¦canonical_name=MongoDB】, Redis, Neo4j.

MySQL es relacional y usa SQL para hablar con ella.

## 5. ¿Qué es SQL?
Es el idioma estándar para bases de datos relacionales. Se divide en:

- **DDL (Definición):** CREATE, ALTER, DROP → definir estructura.
- **DML (Manipulación):** INSERT, UPDATE, DELETE, SELECT → manejar datos.
- **DCL (Control):** GRANT, REVOKE → permisos.
- **TCL (Transacciones):** COMMIT, ROLLBACK.

## 6. ✅ Mini ejercicio de reflexión
1. En una tabla `productos`, ¿qué sería la clave primaria y por qué?
2. ¿Cuál es la diferencia entre una fila y una columna?
3. Menciona 2 ventajas de usar una BD frente a Excel.
4. ¿MySQL es relacional o NoSQL?

## 🎯 Resumen
- Base de datos = colección organizada de datos.
- SGBD = software que la administra (MySQL).
- Tabla = filas + columnas, como Excel pero mucho más potente.
- Clave primaria = identifica cada fila de forma única.
- SQL = lenguaje para interactuar con la BD.