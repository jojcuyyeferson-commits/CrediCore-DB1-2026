USE CrediCore;

-- ============================================================
-- FASE 3 - PARTE A
-- ACTIVACIÓN DE INTEGRIDAD REFERENCIAL
-- ============================================================

-- A.1 - Relación entre Créditos y Clientes

ALTER TABLE Operaciones.Creditos
ADD CONSTRAINT FK_Creditos_Clientes
FOREIGN KEY (IdCliente)
REFERENCES Operaciones.Clientes(IdCliente);


-- A.2 - Relación entre Créditos y Vehículos

ALTER TABLE Operaciones.Creditos
ADD CONSTRAINT FK_Creditos_Vehiculos
FOREIGN KEY (IdVehiculo)
REFERENCES Garantias.Vehiculos(IdVehiculo);


-- A.3 - PRUEBA DE DESTRUCCIÓN
-- Se intenta eliminar un cliente que posee créditos.
-- SQL Server debe bloquear la operación debido a la
-- integridad referencial establecida por la FOREIGN KEY.

DELETE FROM Operaciones.Clientes
WHERE IdCliente = 1;


-- ============================================================
-- PARTE B - RECONSTRUCCIÓN DE LA REALIDAD
-- ============================================================

-- B.1 - REPORTE MAESTRO
-- INNER JOIN entre Clientes, Créditos y Vehículos.
-- Muestra únicamente los registros que tienen correspondencia
-- en las tres tablas.

SELECT
    CONCAT(cl.Nombres, ' ', cl.Apellidos) AS [Nombre del Cliente],
    cl.Telefono AS [Teléfono],
    v.Marca AS [Marca del Vehículo],
    v.Placa AS [Placa],
    c.MontoCapital AS [Monto del Crédito],
    c.Estado AS [Estado actual]
FROM Operaciones.Clientes AS cl
INNER JOIN Operaciones.Creditos AS c
    ON cl.IdCliente = c.IdCliente
INNER JOIN Garantias.Vehiculos AS v
    ON c.IdVehiculo = v.IdVehiculo;


-- B.2 - MINERÍA DE POTENCIALES CLIENTES
-- LEFT JOIN para encontrar clientes que nunca han
-- tramitado un crédito.

SELECT
    CONCAT(cl.Nombres, ' ', cl.Apellidos) AS [Nombre del Cliente],
    cl.Telefono AS [Teléfono]
FROM Operaciones.Clientes AS cl
LEFT JOIN Operaciones.Creditos AS c
    ON cl.IdCliente = c.IdCliente
WHERE c.IdCliente IS NULL;


-- ============================================================
-- DATOS DE PRUEBA PARA B.2
-- ============================================================

-- Cliente registrado que no posee ningún crédito.

INSERT INTO Operaciones.Clientes
(
    Nombres,
    Apellidos,
    DPI,
    Telefono,
    Correo
)
VALUES
(
    'Cliente',
    'Sin Credito',
    '9999999999999',
    '40009999',
    'sincredito@credicore.com'
);


-- B.2 - EVIDENCIA DEL VALOR NULL
-- Se muestra el cliente sin crédito y el valor NULL
-- proveniente de la tabla Operaciones.Creditos.

SELECT
    CONCAT(cl.Nombres, ' ', cl.Apellidos) AS [Nombre del Cliente],
    cl.Telefono AS [Teléfono],
    c.IdCliente AS [IdCliente en Creditos]
FROM Operaciones.Clientes AS cl
LEFT JOIN Operaciones.Creditos AS c
    ON cl.IdCliente = c.IdCliente
WHERE c.IdCliente IS NULL;


-- ============================================================
-- PARTE C - EL CEREBRO ANALÍTICO
-- ============================================================

-- C.1 - FILTRO DINÁMICO
-- Muestra los créditos cuyo monto de capital es
-- estrictamente mayor al promedio histórico de todos
-- los créditos registrados.
-- No se utiliza un valor numérico fijo.

SELECT
    CONCAT(cl.Nombres, ' ', cl.Apellidos) AS [Nombre del Cliente],
    c.MontoCapital AS [Monto del Crédito]
FROM Operaciones.Creditos AS c
INNER JOIN Operaciones.Clientes AS cl
    ON c.IdCliente = cl.IdCliente
WHERE c.MontoCapital >
(
    SELECT AVG(MontoCapital)
    FROM Operaciones.Creditos
);


-- C.2 - PATRONES ANIDADOS
-- Subconsulta con IN para identificar créditos asociados
-- a vehículos del año 2011 o anteriores.

SELECT
    CONCAT(cl.Nombres, ' ', cl.Apellidos) AS [Nombre del Cliente],
    c.IdCredito AS [Número de Crédito]
FROM Operaciones.Creditos AS c
INNER JOIN Operaciones.Clientes AS cl
    ON c.IdCliente = cl.IdCliente
WHERE c.IdVehiculo IN
(
    SELECT v.IdVehiculo
    FROM Garantias.Vehiculos AS v
    WHERE v.Anio <= 2011
);