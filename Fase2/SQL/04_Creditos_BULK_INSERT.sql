-- CrediCore - Fase 2
-- Ingesta plana con BULK INSERT.
-- La ruta corresponde al archivo dentro del contenedor Docker.

USE CrediCore;
GO

DROP TABLE IF EXISTS #CreditosImport;

CREATE TABLE #CreditosImport (
    Campo1 VARCHAR(50), -- referencia
    Campo2 VARCHAR(50), -- IdCliente
    Campo3 VARCHAR(50), -- MontoCapital
    Campo4 VARCHAR(50), -- TasaInteresMensual
    Campo5 VARCHAR(50), -- Estado
    Campo6 VARCHAR(50)  -- FechaDesembolso
);

BULK INSERT #CreditosImport
FROM '/tmp/import/creditos_2000.txt'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '0x0a'
);

-- Transformación y carga hacia la tabla destino.
-- IdCredito es IDENTITY y no se inserta manualmente.
INSERT INTO Operaciones.Creditos
(
    IdCliente,
    IdVehiculo,
    MontoCapital,
    TasaInteresMensual,
    Estado,
    FechaDesembolso
)
SELECT
    CAST(Campo2 AS INT),
    ((CAST(Campo1 AS INT) - 1) % 1500) + 1,
    CAST(Campo3 AS DECIMAL(18,2)),
    CAST(Campo4 AS DECIMAL(5,2)),
    Campo5,
    CAST(Campo6 AS DATETIME)
FROM #CreditosImport;

SELECT COUNT(*) AS TotalCreditos
FROM Operaciones.Creditos;
