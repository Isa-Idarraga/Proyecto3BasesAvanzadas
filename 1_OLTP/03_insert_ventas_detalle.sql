USE DB_Proyecto3_OLTP;
GO

-- ============================================================
-- VENTAS Y DETALLE VENTAS (50.000 ventas, ~150.000 detalles)
-- ============================================================
DECLARE @i          INT = 1;
DECLARE @fechaBase  DATE = '2023-01-01';
DECLARE @ventaID    INT;
DECLARE @clienteID  INT;
DECLARE @tiendaID   INT;
DECLARE @vendedorID INT;
DECLARE @canal      VARCHAR(30);
DECLARE @fecha      DATETIME;
DECLARE @subtotal   DECIMAL(14,2);
DECLARE @descuento  DECIMAL(14,2);
DECLARE @impuesto   DECIMAL(14,2);
DECLARE @total      DECIMAL(14,2);
DECLARE @nDetalle   INT;
DECLARE @j          INT;
DECLARE @prodID     INT;
DECLARE @precio     DECIMAL(12,2);
DECLARE @costo      DECIMAL(12,2);
DECLARE @cant       INT;
DECLARE @descDet    DECIMAL(12,2);

WHILE @i <= 50000
BEGIN
    SET @clienteID  = (ABS(CHECKSUM(NEWID())) % 1000) + 1;
    SET @tiendaID   = (ABS(CHECKSUM(NEWID())) % 10)   + 1;
    SET @vendedorID = ((@tiendaID - 1) * 2) + (ABS(CHECKSUM(NEWID())) % 2) + 1;
    IF @vendedorID > 20 SET @vendedorID = 20;

    SET @canal = CASE (ABS(CHECKSUM(NEWID())) % 4)
                    WHEN 0 THEN 'Presencial'
                    WHEN 1 THEN 'Online'
                    WHEN 2 THEN 'Telefono'
                    ELSE        'App'
                 END;

    SET @fecha = DATEADD(MINUTE,
                    ABS(CHECKSUM(NEWID())) % 525600,
                    CAST(@fechaBase AS DATETIME));

    INSERT INTO Ventas (NumeroFactura, FechaVenta, ClienteID, TiendaID,
                        VendedorID, CanalVenta, SubTotal, Descuento,
                        Impuesto, TotalVenta, Estado)
    VALUES (
        'FAC-' + RIGHT('000000' + CAST(@i AS VARCHAR), 6),
        @fecha, @clienteID, @tiendaID, @vendedorID, @canal,
        0, 0, 0, 0, 'A'
    );

    SET @ventaID  = SCOPE_IDENTITY();
    SET @nDetalle = (ABS(CHECKSUM(NEWID())) % 4) + 1; -- 1 a 4 líneas por venta (promedio ~3)
    SET @subtotal = 0;
    SET @j = 1;

    WHILE @j <= @nDetalle
    BEGIN
        SET @prodID   = (ABS(CHECKSUM(NEWID())) % 200) + 1;
        SET @precio   = (SELECT PrecioVenta  FROM Productos WHERE ProductoID = @prodID);
        SET @costo    = (SELECT PrecioCompra FROM Productos WHERE ProductoID = @prodID);
        SET @cant     = (ABS(CHECKSUM(NEWID())) % 5) + 1;
        SET @descDet  = ROUND(@precio * (ABS(CHECKSUM(NEWID())) % 15) / 100.0, 2);

        INSERT INTO DetalleVentas (VentaID, ProductoID, Cantidad,
                                   PrecioUnitario, Descuento, CostoUnitario)
        VALUES (@ventaID, @prodID, @cant, @precio, @descDet, @costo);

        SET @subtotal += @cant * (@precio - @descDet);
        SET @j += 1;
    END;

    SET @descuento = ROUND(@subtotal * (ABS(CHECKSUM(NEWID())) % 10) / 100.0, 2);
    SET @impuesto  = ROUND((@subtotal - @descuento) * 0.19, 2);
    SET @total     = @subtotal - @descuento + @impuesto;

    UPDATE Ventas
    SET SubTotal   = @subtotal,
        Descuento  = @descuento,
        Impuesto   = @impuesto,
        TotalVenta = @total
    WHERE VentaID  = @ventaID;

    SET @i += 1;
END;
GO

PRINT '50.000 ventas y detalles insertados correctamente.';
GO
