USE BI_DW;
GO

DELETE FROM FactRentabilidad;
GO

INSERT INTO FactRentabilidad
(
FechaKey,
ProductoKey,
TiendaKey,

Ingresos,
Costos,
Utilidad
)

SELECT

CAST(
FORMAT(v.FechaVenta,'yyyyMMdd')
AS INT),

dp.ProductoKey,
dt.TiendaKey,

(dv.Cantidad*dv.PrecioUnitario),

(dv.Cantidad*p.PrecioCompra),

((dv.Cantidad*dv.PrecioUnitario)
-
(dv.Cantidad*p.PrecioCompra))

FROM DB_Proyecto3_OLTP.dbo.Ventas v

INNER JOIN DB_Proyecto3_OLTP.dbo.DetalleVentas dv
ON v.VentaID=dv.VentaID

INNER JOIN DB_Proyecto3_OLTP.dbo.Productos p
ON dv.ProductoID=p.ProductoID

INNER JOIN DimProducto dp
ON p.ProductoID=dp.ProductoID

INNER JOIN DimTienda dt
ON v.TiendaID=dt.TiendaID;

GO

PRINT 'FactRentabilidad cargada';
GO