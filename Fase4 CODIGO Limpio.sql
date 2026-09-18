-- =========================================================
-- CREDICORE - FASE 4
-- PROGRAMABILIDAD Y AUDITORÍA ACTIVA
-- =========================================================

USE CrediCore;


-- =========================================================
-- PARTE A - CAPA DE ABSTRACCIÓN
-- SALDO ACTUAL
-- =========================================================

-- Se agrega el saldo actual del crédito.
ALTER TABLE Operaciones.Creditos
ADD SaldoActual DECIMAL(18,2) NULL;

-- Inicialmente, el saldo actual es igual al monto del capital.
UPDATE Operaciones.Creditos
SET SaldoActual = MontoCapital;

-- Se establece el campo como obligatorio.
ALTER TABLE Operaciones.Creditos
ALTER COLUMN SaldoActual DECIMAL(18,2) NOT NULL;


-- =========================================================
-- PARTE B - HISTORIAL DE PAGOS
-- =========================================================

-- Tabla para almacenar los abonos realizados a los créditos.
CREATE TABLE Operaciones.HistorialPagos
(
    IdPago INT IDENTITY(1,1) PRIMARY KEY,
    IdCredito INT NOT NULL,
    MontoAbono DECIMAL(18,2) NOT NULL,
    FechaPago DATETIME NOT NULL
        CONSTRAINT DF_HistorialPagos_FechaPago
        DEFAULT GETDATE(),

    CONSTRAINT CK_HistorialPagos_Monto
        CHECK (MontoAbono > 0),

    CONSTRAINT FK_HistorialPagos_Creditos
        FOREIGN KEY (IdCredito)
        REFERENCES Operaciones.Creditos(IdCredito)
);


-- =========================================================
-- PARTE A - VIEW DE ATENCIÓN AL CLIENTE
-- =========================================================

-- Vista que muestra únicamente la información necesaria
-- para la atención al cliente, evitando datos sensibles.
CREATE VIEW vw_AtencionAlCliente
AS
SELECT
    CONCAT(c.Nombres, ' ', c.Apellidos) AS [Nombre del Cliente],
    cr.IdCredito AS [Numero de Credito],
    v.Marca AS [Marca del Vehiculo],
    cr.Estado AS [Estado del Credito],
    cr.SaldoActual AS [Saldo Actual]
FROM Operaciones.Clientes AS c
INNER JOIN Operaciones.Creditos AS cr
    ON c.IdCliente = cr.IdCliente
INNER JOIN Garantias.Vehiculos AS v
    ON cr.IdVehiculo = v.IdVehiculo;


-- =========================================================
-- PARTE B - PROCEDIMIENTO ALMACENADO
-- SP_ProcesarPago
-- =========================================================

-- Procesa un abono de forma segura utilizando transacciones.
CREATE PROCEDURE SP_ProcesarPago
    @IdCredito INT,
    @MontoAbono DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        DECLARE @SaldoActual DECIMAL(18,2);

        -- Obtener el saldo actual del crédito.
        SELECT @SaldoActual = SaldoActual
        FROM Operaciones.Creditos
        WHERE IdCredito = @IdCredito;

        -- Validar que el crédito exista.
        IF @SaldoActual IS NULL
        BEGIN
            RAISERROR('El crédito indicado no existe.', 16, 1);
        END;

        -- Validar que el abono sea mayor que cero.
        IF @MontoAbono <= 0
        BEGIN
            RAISERROR('El monto del abono debe ser mayor que cero.', 16, 1);
        END;

        -- Validar que el abono no supere el saldo actual.
        IF @MontoAbono > @SaldoActual
        BEGIN
            RAISERROR(
                'El monto del abono supera el saldo actual del crédito.',
                16,
                1
            );
        END;

        -- Registrar el pago en el historial.
        INSERT INTO Operaciones.HistorialPagos
        (
            IdCredito,
            MontoAbono
        )
        VALUES
        (
            @IdCredito,
            @MontoAbono
        );

        -- Actualizar el saldo del crédito.
        UPDATE Operaciones.Creditos
        SET SaldoActual = SaldoActual - @MontoAbono
        WHERE IdCredito = @IdCredito;

        -- Confirmar la transacción.
        COMMIT;
    END TRY

    BEGIN CATCH

        -- Si ocurrió un error, cancelar toda la operación.
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK;
        END;

        -- Mostrar nuevamente el error.
        THROW;

    END CATCH;
END;


-- =========================================================
-- PARTE C - AUDITORÍA
-- =========================================================

-- Crear el esquema de auditoría si todavía no existe.
IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'Auditoria'
)
BEGIN
    EXEC('CREATE SCHEMA Auditoria');
END;


-- =========================================================
-- TABLA DE LOGS DE CRÉDITOS
-- =========================================================

-- Almacena automáticamente los cambios sospechosos
-- realizados sobre la tasa de interés.
CREATE TABLE Auditoria.Logs_Creditos
(
    IdLog INT IDENTITY(1,1) PRIMARY KEY,
    Accion VARCHAR(50) NOT NULL,
    ValorAnterior DECIMAL(5,2) NOT NULL,
    ValorNuevo DECIMAL(5,2) NOT NULL,
    FechaHora DATETIME NOT NULL
        CONSTRAINT DF_Logs_Creditos_FechaHora
        DEFAULT GETDATE()
);


-- =========================================================
-- TRIGGER DE AUDITORÍA
-- =========================================================

-- Detecta automáticamente cuando se reduce
-- la tasa de interés de un crédito.
CREATE TRIGGER TR_Auditar_BajaTasa
ON Operaciones.Creditos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Auditoria.Logs_Creditos
    (
        Accion,
        ValorAnterior,
        ValorNuevo,
        FechaHora
    )
    SELECT
        'BAJA DE TASA',
        d.TasaInteresMensual,
        i.TasaInteresMensual,
        GETDATE()
    FROM inserted AS i
    INNER JOIN deleted AS d
        ON i.IdCredito = d.IdCredito
    WHERE i.TasaInteresMensual < d.TasaInteresMensual;
END;