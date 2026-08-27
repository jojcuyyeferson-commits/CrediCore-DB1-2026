-- ============================================================
-- PRUEBAS DE DESTRUCCIÓN - CREDICORE
-- FASE 1 - DDL Y DOMINIOS
-- ============================================================

USE CrediCore;
GO

-- ============================================================
-- PRUEBA 1: MONTO DE CRÉDITO MENOR O IGUAL A Q1,000
-- Debe ser rechazado por CK_Creditos_Monto
-- ============================================================

INSERT INTO Operaciones.Creditos
(
    IdCliente,
    IdVehiculo,
    MontoCapital,
    TasaInteresMensual
)
VALUES
(
    1,
    1,
    500,
    5.00
);

-- ============================================================
-- PRUEBA 2: TASA DE INTERÉS NEGATIVA
-- Debe ser rechazada por CK_Credito_Tasa
-- ============================================================

INSERT INTO Operaciones.Creditos
(
    IdCliente,
    IdVehiculo,
    MontoCapital,
    TasaInteresMensual
)
VALUES
(
    1,
    1,
    5000,
    -10.00
);

-- ============================================================
-- PRUEBA 3: VEHÍCULO CON MÁS DE 15 AÑOS DE ANTIGÜEDAD
-- Año 1999 debe ser rechazado por CK_Vehiculos_Anio
-- ============================================================

INSERT INTO Garantias.Vehiculos
(
    Modelo,
    Marca,
    Anio,
    Color,
    NumeroTituloPropiedad,
    Placa,
    NumeroChasis
)
VALUES
(
    'Corolla',
    'Toyota',
    1999,
    'Rojo',
    'TIT-1999-001',
    'P1999ABC',
    'CHASIS1999001'
);

-- ============================================================
-- PRUEBA 4: PLACA DUPLICADA
-- Debe ser rechazada por UQ_Vehiculo_Placa
-- ============================================================

INSERT INTO Garantias.Vehiculos
(
    Modelo,
    Marca,
    Anio,
    Color,
    NumeroTituloPropiedad,
    Placa,
    NumeroChasis
)
VALUES
(
    'Corolla',
    'Toyota',
    2023,
    'Negro',
    'TIT-2023-002',
    'P2022ABC',
    'CHASIS2023002'
);