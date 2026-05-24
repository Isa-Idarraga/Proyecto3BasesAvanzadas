USE DB_Proyecto3_OLTP;
GO

-- Limpiar inserciones parciales anteriores
DELETE FROM DetalleCompras;
DELETE FROM Compras;
GO

-- ============================================================
-- COMPRAS Y DETALLE COMPRAS (~2.000 compras)
-- Versión corregida y robusta
-- ============================================================

DECLARE @i INT = 1;
DECLARE @compraID INT;
DECLARE @provID INT;
DECLARE @tiendaID INT;
DECLARE @fecha DATE;
DECLARE @total DECIMAL(14,2);
DECLARE @nDetalle INT;
DECLARE @j INT;
DECLARE @prodID INT;
DECLARE @costo DECIMAL(12,2);
DECLARE @cant INT;

WHILE @i <= 2000
BEGIN

    -- Tomar IDs existentes reales
    SELECT TOP 1 @provID = ProveedorID
    FROM Proveedores
    ORDER BY NEWID();

    SELECT TOP 1 @tiendaID = TiendaID
    FROM Tiendas
    ORDER BY NEWID();

    SET @fecha =
        DATEADD(
            DAY,
            ABS(CHECKSUM(NEWID())) % 365,
            '2023-01-01'
        );

    SET @total = 0;

    INSERT INTO Compras
    (
        NumeroOrden,
        FechaCompra,
        ProveedorID,
        TiendaID,
        TotalCompra,
        Estado
    )
    VALUES
    (
        'OC-' + RIGHT('000000' + CAST(@i AS VARCHAR),6),
        @fecha,
        @provID,
        @tiendaID,
        0,
        'R'
    );

    SET @compraID = SCOPE_IDENTITY();

    SET @nDetalle =
        (ABS(CHECKSUM(NEWID())) % 5) + 1;

    SET @j = 1;

    WHILE @j <= @nDetalle
    BEGIN

        -- Producto real existente
        SELECT TOP 1
            @prodID = ProductoID,
            @costo = PrecioCompra
        FROM Productos
        ORDER BY NEWID();

        SET @cant =
            (ABS(CHECKSUM(NEWID())) % 100) + 10;

        INSERT INTO DetalleCompras
        (
            CompraID,
            ProductoID,
            Cantidad,
            PrecioUnitario
        )
        VALUES
        (
            @compraID,
            @prodID,
            @cant,
            @costo
        );

        SET @total =
            @total + (@cant * @costo);

        SET @j = @j + 1;

    END

    UPDATE Compras
    SET TotalCompra=@total
    WHERE CompraID=@compraID;

    SET @i=@i+1;

END
GO

PRINT '2.000 compras y detalles insertados correctamente';
GO