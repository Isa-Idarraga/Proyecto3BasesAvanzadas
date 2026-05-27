USE BI_DW;
GO

DELETE FROM DimTienda;

INSERT INTO DimTienda
(TiendaID,
NombreTienda,
Ciudad,
Departamento
)
SELECT
TiendaID,
NombreTienda,
Ciudad,
Departamento
FROM DB_Proyecto3_OLTP.dbo.Tiendas;



DELETE FROM DimVendedor;

INSERT INTO DimVendedor
(
VendedorID,
NombreCompleto
)
SELECT
VendedorID,
NombreCompleto
FROM DB_Proyecto3_OLTP.dbo.Vendedores;



DELETE FROM DimProveedor;

INSERT INTO DimProveedor
(
ProveedorID,
NombreProveedor
)

SELECT
ProveedorID,
NombreEmpresa
FROM DB_Proyecto3_OLTP.dbo.Proveedores;



DELETE FROM DimCanalVenta;

INSERT INTO DimCanalVenta
(
CanalVenta
)

SELECT DISTINCT
CanalVenta
FROM BI_Staging.dbo.STG_Ventas;

GO