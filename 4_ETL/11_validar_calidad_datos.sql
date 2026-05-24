USE BI_DW;
GO

PRINT '========== VALIDACION DATA WAREHOUSE ==========';


-- ======================================
-- VALIDACION DIMENSIONES
-- ======================================

SELECT 'DimFecha' Tabla, COUNT(*) Registros
FROM DimFecha

UNION ALL

SELECT 'DimCliente',COUNT(*)
FROM DimCliente

UNION ALL

SELECT 'DimProducto',COUNT(*)
FROM DimProducto

UNION ALL

SELECT 'DimTienda',COUNT(*)
FROM DimTienda

UNION ALL

SELECT 'DimVendedor',COUNT(*)
FROM DimVendedor

UNION ALL

SELECT 'DimProveedor',COUNT(*)
FROM DimProveedor

UNION ALL

SELECT 'DimCanalVenta',COUNT(*)
FROM DimCanalVenta

UNION ALL

SELECT 'DimCategoria',COUNT(*)
FROM DimCategoria;


PRINT '========== VALIDACION HECHOS ==========';


SELECT 'FactVentas',COUNT(*)
FROM FactVentas

UNION ALL

SELECT 'FactInventarioDiario',COUNT(*)
FROM FactInventarioDiario

UNION ALL

SELECT 'FactMetasComerciales',COUNT(*)
FROM FactMetasComerciales

UNION ALL

SELECT 'FactCompras',COUNT(*)
FROM FactCompras

UNION ALL

SELECT 'FactDevoluciones',COUNT(*)
FROM FactDevoluciones

UNION ALL

SELECT 'FactRentabilidad',COUNT(*)
FROM FactRentabilidad;



PRINT '========== VALIDACION NULOS ==========';


SELECT
'FactVentas' Tabla,
COUNT(*) RegistrosNulos
FROM FactVentas
WHERE FechaKey IS NULL
OR ClienteKey IS NULL
OR ProductoKey IS NULL
OR TiendaKey IS NULL


UNION ALL


SELECT
'FactInventarioDiario',
COUNT(*)
FROM FactInventarioDiario
WHERE FechaKey IS NULL
OR ProductoKey IS NULL
OR TiendaKey IS NULL


UNION ALL


SELECT
'FactMetasComerciales',
COUNT(*)
FROM FactMetasComerciales
WHERE FechaKey IS NULL
OR TiendaKey IS NULL;



PRINT '========== VALIDACION RENTABILIDAD ==========';


SELECT TOP 10
FechaKey,
Ingresos,
Costos,
Utilidad
FROM FactRentabilidad
ORDER BY Utilidad DESC;

GO

PRINT 'Validacion final completada';
GO