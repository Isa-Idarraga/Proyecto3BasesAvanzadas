USE BI_DW;
GO

DELETE FROM FactVentas;
GO

INSERT INTO FactVentas
(
FechaKey,
ClienteKey,
ProductoKey,
TiendaKey,
VendedorKey,
CanalKey,

Cantidad,
PrecioUnitario,
SubTotal,
TotalVenta
)

SELECT

CAST(FORMAT(v.FechaVenta,'yyyyMMdd') AS INT),

dc.ClienteKey,
dp.ProductoKey,
dt.TiendaKey,
dv.VendedorKey,
dcan.CanalKey,

dvta.Cantidad,
dvta.PrecioUnitario,

(dvta.Cantidad*dvta.PrecioUnitario),

v.TotalVenta

FROM DB_Proyecto3_OLTP.dbo.Ventas v

INNER JOIN DB_Proyecto3_OLTP.dbo.DetalleVentas dvta
ON v.VentaID=dvta.VentaID

INNER JOIN DimCliente dc
ON v.ClienteID=dc.ClienteID

INNER JOIN DimProducto dp
ON dvta.ProductoID=dp.ProductoID

INNER JOIN DimTienda dt
ON v.TiendaID=dt.TiendaID

INNER JOIN DimVendedor dv
ON v.VendedorID=dv.VendedorID

INNER JOIN DimCanalVenta dcan
ON v.CanalVenta=dcan.CanalVenta;

GO