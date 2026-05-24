USE BI_DW;
GO

DELETE FROM DimProducto;

INSERT INTO DimProducto
(
ProductoID,
NombreProducto,
Categoria,
PrecioCompra,
PrecioVenta
)
SELECT
ProductoID,
NombreProducto,
CategoriaNombre,
PrecioCompra,
PrecioVenta
FROM BI_Staging.dbo.STG_Productos
WHERE EstadoRegistro='OK';

GO