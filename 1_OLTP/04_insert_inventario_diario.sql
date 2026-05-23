USE DB_Proyecto3_OLTP;
GO

-- ============================================================
-- INVENTARIO DIARIO (365 días x 200 productos x 10 tiendas)
-- ============================================================
DECLARE @fecha     DATE = '2023-01-01';
DECLARE @fechaFin  DATE = '2023-12-31';
DECLARE @tienda    INT;
DECLARE @producto  INT;
DECLARE @stockAnt  INT;
DECLARE @entradas  INT;
DECLARE @salidas   INT;
DECLARE @stockFin  INT;

WHILE @fecha <= @fechaFin
BEGIN
    SET @tienda = 1;
    WHILE @tienda <= 10
    BEGIN
        SET @producto = 1;
        WHILE @producto <= 200
        BEGIN
            SET @entradas = (ABS(CHECKSUM(NEWID())) % 50);
            SET @salidas  = (ABS(CHECKSUM(NEWID())) % 30);
            SET @stockAnt = (ABS(CHECKSUM(NEWID())) % 200) + 10;
            SET @stockFin = @stockAnt + @entradas - @salidas;
            IF @stockFin < 0 SET @stockFin = 0;

            INSERT INTO InventarioDiario
                (ProductoID, TiendaID, FechaRegistro, StockInicial,
                 Entradas, Salidas, StockFinal)
            VALUES (
                @producto, @tienda, @fecha, @stockAnt,
                @entradas, @salidas, @stockFin
            );

            SET @producto += 1;
        END;
        SET @tienda += 1;
    END;
    SET @fecha = DATEADD(DAY, 1, @fecha);
END;
GO

PRINT 'InventarioDiario insertado correctamente (730.000 filas).';
GO
