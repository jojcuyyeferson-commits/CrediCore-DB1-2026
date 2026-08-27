-- ============================================================
-- CREDICORE - FASE 1
-- DDL Y DOMINIOS
-- ============================================================
-- Proyecto: DB1-CrediCore-2026
-- Descripción: Creación de la estructura base de CrediCore
-- ============================================================


-- ============================================================
-- PASO 1: CREACIÓN DE LA BASE DE DATOS
-- ============================================================

IF DB_ID('CrediCore') IS NULL
BEGIN
    EXEC('CREATE DATABASE CrediCore');
END;


-- ============================================================
-- PASO 2: SELECCIÓN DE LA BASE DE DATOS
-- ============================================================

USE CrediCore;


-- ============================================================
-- PASO 3: CREACIÓN DE ESQUEMAS
-- ============================================================

-- Esquema destinado a las operaciones financieras
CREATE SCHEMA Operaciones;
GO

-- Esquema destinado a la administración de garantías
CREATE SCHEMA Garantias;
GO


-- ============================================================
-- PASO 4: CREACIÓN DE LA TABLA DE CLIENTES
-- ============================================================

-- Tabla que almacena la información básica de los clientes.

CREATE TABLE Operaciones.Clientes
(
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,

    Nombres VARCHAR(100) NOT NULL,

    Apellidos VARCHAR(100) NOT NULL,

    DPI VARCHAR(13) NOT NULL UNIQUE,

    Telefono VARCHAR(15) NOT NULL,

    Correo VARCHAR(150) NOT NULL
);


-- ============================================================
-- PASO 5: CREACIÓN DE LA TABLA DE VEHÍCULOS
-- ============================================================

-- Tabla destinada al registro de vehículos
-- utilizados como garantía de los créditos.

CREATE TABLE Garantias.Vehiculos
(
    IdVehiculo INT IDENTITY(1,1) PRIMARY KEY,

    Modelo VARCHAR(50) NOT NULL,

    Marca VARCHAR(50) NOT NULL,

    Anio INT NOT NULL,

    Color VARCHAR(30) NOT NULL,

    NumeroTituloPropiedad VARCHAR(50) NOT NULL,

    Placa VARCHAR(30) NOT NULL,

    NumeroChasis VARCHAR(30) NOT NULL,


    -- El vehículo debe tener una antigüedad
    -- máxima de 15 años.

    CONSTRAINT CK_Vehiculos_Anio
    CHECK (Anio >= 2011),


    -- La placa no puede repetirse.

    CONSTRAINT UQ_Vehiculo_Placa
    UNIQUE (Placa),


    -- El número de chasis no puede repetirse.

    CONSTRAINT UQ_Vehiculo_Chasis
    UNIQUE (NumeroChasis)
);


-- ============================================================
-- PASO 6: CREACIÓN DE LA TABLA DE CRÉDITOS
-- ============================================================

-- Tabla que almacena la información de los préstamos
-- otorgados por CrediCore.

CREATE TABLE Operaciones.Creditos
(
    IdCredito INT IDENTITY(1,1) PRIMARY KEY,

    IdCliente INT NOT NULL,

    IdVehiculo INT NOT NULL,

    MontoCapital DECIMAL(18,2) NOT NULL,

    TasaInteresMensual DECIMAL(5,2) NOT NULL,

    -- Todo crédito inicia automáticamente como Activo.

    Estado VARCHAR(20) NOT NULL
        CONSTRAINT DF_Creditos_Estado
        DEFAULT 'Activo',

    -- Fecha y hora proporcionada automáticamente
    -- por el servidor.

    FechaDesembolso DATETIME NOT NULL
        CONSTRAINT DF_Creditos_FechaDesembolso
        DEFAULT GETDATE(),


    -- El monto debe ser estrictamente mayor
    -- a Q1,000.

    CONSTRAINT CK_Creditos_Monto
    CHECK (MontoCapital > 1000),


    -- La tasa de interés no puede ser negativa.

    CONSTRAINT CK_Credito_Tasa
    CHECK (TasaInteresMensual >= 0)
);


-- ============================================================
-- FIN DEL SCRIPT DDL - CREDICORE FASE 1
-- ============================================================