# CrediCore-DB1-2026

## Proyecto de Base de Datos I

**Sistema:** CrediCore  
**Fase:** 1 - DDL y Dominios  
**Año:** 2026

---

## Descripción

CrediCore es un proyecto de base de datos desarrollado para la gestión de clientes, vehículos utilizados como garantía y créditos financieros.

Esta primera fase corresponde a la construcción de la estructura base de la base de datos mediante DDL (Data Definition Language) y la implementación de restricciones y dominios para garantizar la integridad de los datos.

---

## Objetivos de la Fase 1

- Crear la base de datos CrediCore.
- Crear los esquemas de trabajo.
- Crear las tablas principales.
- Definir claves primarias.
- Definir restricciones UNIQUE.
- Implementar restricciones CHECK.
- Implementar valores DEFAULT.
- Utilizar campos IDENTITY.
- Garantizar la integridad de los datos mediante reglas de dominio.
- Realizar pruebas de validación sobre las restricciones implementadas.

---

## Estructura de la Base de Datos

### Esquemas

- `Operaciones`
- `Garantias`

### Tablas

#### Operaciones.Clientes

Almacena la información básica de los clientes.

#### Garantias.Vehiculos

Almacena los vehículos utilizados como garantía de los créditos.

#### Operaciones.Creditos

Almacena la información de los créditos otorgados por CrediCore.

---

## Restricciones Implementadas

### Clientes

- Clave primaria para `IdCliente`.
- DPI obligatorio y único.

### Vehículos

- Clave primaria para `IdVehiculo`.
- Antigüedad máxima de 15 años.
- Placa única.
- Número de chasis único.

### Créditos

- Clave primaria para `IdCredito`.
- Monto de capital superior a Q1,000.
- Tasa de interés mensual no negativa.
- Estado con valor por defecto `Activo`.
- Fecha de desembolso generada automáticamente mediante `GETDATE()`.

---

## Scripts

### Fase1Limpio.sql

Contiene únicamente la estructura DDL de la Fase 1:

- Creación de la base de datos.
- Creación de esquemas.
- Creación de tablas.
- Claves primarias.
- Restricciones UNIQUE.
- Restricciones CHECK.
- Valores DEFAULT.

### CodigoMalicioso.sql

Contiene pruebas intencionalmente incorrectas para verificar que las restricciones de la base de datos funcionen correctamente.

Las pruebas incluyen:

1. Crédito con monto menor o igual a Q1,000.
2. Tasa de interés negativa.
3. Vehículo con más de 15 años de antigüedad.
4. Placa duplicada.

Estas operaciones deben ser rechazadas por las restricciones definidas en la base de datos.

---

## Tecnologías

- Microsoft SQL Server
- SQL / T-SQL
- DBeaver
- GitHub

---

## Proyecto Académico

**Curso:** Base de Datos I  
**Proyecto:** CrediCore  
**Fase:** 1 - DDL y Dominios  
**Año:** 2026
