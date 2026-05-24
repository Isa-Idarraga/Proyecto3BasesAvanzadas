USE DB_Proyecto3_OLTP;
GO

-- Limpiar devoluciones mal insertadas
DELETE FROM Devoluciones;
GO

-- ============================================================
-- DEVOLUCIONES (~1.500) - CORREGIDO
-- ============================================================
DECLARE @i          INT = 1;
DECLARE @ventaID    INT;
DECLARE @detalleID  INT;
DECLARE @fecha      DATE;
DECLARE @cantidad   INT;
DECLARE @monto      DECIMAL(12,2);
DECLARE @motivo     VARCHAR(100);
DECLARE @tipo       CHAR(1);

WHILE @i <= 1500
BEGIN
    SELECT TOP 1
        @ventaID   = dv.VentaID,
        @detalleID = dv.DetalleID,
        @cantidad  = (ABS(CHECKSUM(NEWID())) % dv.Cantidad) + 1,
        @monto     = dv.PrecioUnitario * ((ABS(CHECKSUM(NEWID())) % dv.Cantidad) + 1)
    FROM DetalleVentas dv
    ORDER BY NEWID();

    SET @fecha = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 30 + 1,
                    (SELECT FechaVenta FROM Ventas WHERE VentaID = @ventaID));

    SET @motivo = CASE (ABS(CHECKSUM(NEWID())) % 5)
                    WHEN 0 THEN 'Producto defectuoso'
                    WHEN 1 THEN 'Talla incorrecta'
                    WHEN 2 THEN 'No era lo esperado'
                    WHEN 3 THEN 'Duplicado en pedido'
                    ELSE        'Cambio de opinion'
                  END;

    SET @tipo = CASE (ABS(CHECKSUM(NEWID())) % 3)
                    WHEN 0 THEN 'N'
                    WHEN 1 THEN 'C'
                    ELSE        'P'
                END;

    INSERT INTO Devoluciones (VentaID, DetalleID, FechaDevolucion,
                               CantidadDevuelta, MotivoDevolucion,
                               TipoDevolucion, MontoDevuelto, Estado)
    VALUES (@ventaID, @detalleID, @fecha,
            @cantidad, @motivo, @tipo, @monto, 'A');

    SET @i += 1;
END;
GO

PRINT '1.500 devoluciones insertadas correctamente.';
GO
