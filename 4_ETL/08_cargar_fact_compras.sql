USE BI_DW;
GO

DELETE FROM FactCompras;
GO

INSERT INTO FactCompras
(
    FechaKey,
    ProveedorKey,
    TiendaKey,
    TotalCompra
)

SELECT

CAST(FORMAT(c.FechaCompra,'yyyyMMdd') AS INT),

dp.ProveedorKey,
dt.TiendaKey,

c.TotalCompra

FROM BI_Staging.dbo.STG_Compras c

INNER JOIN DimProveedor dp
ON c.ProveedorID=dp.ProveedorID

INNER JOIN DimTienda dt
ON c.TiendaID=dt.TiendaID;

GO

PRINT 'FactCompras cargada';
GO