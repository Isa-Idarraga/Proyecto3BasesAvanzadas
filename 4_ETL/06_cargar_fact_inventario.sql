USE BI_DW;
GO

DELETE FROM FactInventarioDiario;
GO

INSERT INTO FactInventarioDiario
(
    FechaKey,
    ProductoKey,
    TiendaKey,

    StockInicial,
    Entradas,
    Salidas,
    StockFinal
)

SELECT

CAST(FORMAT(i.FechaRegistro,'yyyyMMdd') AS INT),

dp.ProductoKey,
dt.TiendaKey,

i.StockInicial,
i.Entradas,
i.Salidas,
i.StockFinal

FROM BI_Staging.dbo.STG_Inventario i

INNER JOIN DimProducto dp
ON i.ProductoID=dp.ProductoID

INNER JOIN DimTienda dt
ON i.TiendaID=dt.TiendaID;

GO

PRINT 'FactInventarioDiario cargada';
GO