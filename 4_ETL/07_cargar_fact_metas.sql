USE BI_DW;
GO

DELETE FROM FactMetasComerciales;
GO

INSERT INTO FactMetasComerciales
(
FechaKey,
TiendaKey,
VendedorKey,
CategoriaKey,
CanalKey,
ValorMeta
)

SELECT

CAST(
CAST(m.Anio AS VARCHAR)
+
RIGHT('00'+CAST(m.Mes AS VARCHAR),2)
+
'01'
AS INT),

dt.TiendaKey,

dv.VendedorKey,

dcat.CategoriaKey,

dcan.CanalKey,

m.ValorMeta

FROM BI_Staging.dbo.STG_Metas m

INNER JOIN DimTienda dt
ON m.TiendaID=dt.TiendaID

INNER JOIN DimCategoria dcat
ON m.CategoriaID=dcat.CategoriaID

INNER JOIN DimCanalVenta dcan
ON m.CanalVenta=dcan.CanalVenta

INNER JOIN DimVendedor dv
ON ISNULL(m.VendedorID,-1)
=
dv.VendedorID;

GO