USE DB_Proyecto3_OLTP;
GO

-- Limpiar lo que se insertó mal antes
DELETE FROM DetalleCompras;
DELETE FROM Compras;
GO

-- ============================================================
-- COMPRAS Y DETALLE COMPRAS (~2.000 compras) - CORREGIDO
-- ============================================================
DECLARE @i          INT = 1;
DECLARE @compraID   INT;
DECLARE @provID     INT;
DECLARE @tiendaID   INT;
DECLARE @fecha      DATE;
DECLARE @total      DECIMAL(14,2);
DECLARE @nDetalle   INT;
DECLARE @j          INT;
DECLARE @prodID     INT;
DECLARE @costo      DECIMAL(12,2);
DECLARE @cant       INT;

WHILE @i <= 2000
BEGIN
    SET @provID   = (ABS(CHECKSUM(NEWID())) % 20) + 1;
    SET @tiendaID = (ABS(CHECKSUM(NEWID())) % 10) + 1;
    SET @fecha    = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, '2023-01-01');
    SET @total    = 0;

    INSERT INTO Compras (NumeroOrden, FechaCompra, ProveedorID, TiendaID,
                         TotalCompra, Estado)
    VALUES (
        'OC-' + RIGHT('000000' + CAST(@i AS VARCHAR), 6),
        @fecha, @provID, @tiendaID, 0, 'R'
    );

    SET @compraID = SCOPE_IDENTITY();
    SET @nDetalle = (ABS(CHECKSUM(NEWID())) % 5) + 1;
    SET @j = 1;

    WHILE @j <= @nDetalle
    BEGIN
        SET @prodID = (ABS(CHECKSUM(NEWID())) % 200) + 1;
        SET @costo  = (SELECT PrecioCompra FROM Productos WHERE ProductoID = @prodID);
        SET @cant   = (ABS(CHECKSUM(NEWID())) % 100) + 10;

        INSERT INTO DetalleCompras (CompraID, ProductoID, Cantidad, PrecioUnitario)
        VALUES (@compraID, @prodID, @cant, @costo);

        SET @total += @cant * @costo;
        SET @j += 1;
    END;

    UPDATE Compras
    SET TotalCompra = @total
    WHERE CompraID  = @compraID;

    SET @i += 1;
END;
GO

PRINT '2.000 compras y detalles insertados correctamente.';
GO