-- CrediCore - Fase 2
-- Reportes de Inteligencia de Negocios

USE CrediCore;
GO

-- 1. Riesgo acumulado
SELECT
    Estado,
    SUM(MontoCapital) AS TotalCapitalPrestado,
    AVG(TasaInteresMensual) AS PromedioTasaInteres
FROM Operaciones.Creditos
GROUP BY Estado
ORDER BY Estado;
GO

-- 2. Concentración vehicular
SELECT
    V.Marca,
    COUNT(C.IdCredito) AS TotalCreditos
FROM Operaciones.Creditos AS C
INNER JOIN Garantias.Vehiculos AS V
    ON C.IdVehiculo = V.IdVehiculo
GROUP BY V.Marca
HAVING COUNT(C.IdCredito) > 50
ORDER BY TotalCreditos DESC;
GO

-- 3. Análisis de extremos
SELECT
    MAX(MontoCapital) AS PrestamoMayor,
    MIN(MontoCapital) AS PrestamoMenor
FROM Operaciones.Creditos;
GO
