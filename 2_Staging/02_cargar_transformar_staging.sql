USE BI_Staging;
GO

-- ============================================================
-- CARGA STG_Clientes - CORREGIDO
-- ============================================================
TRUNCATE TABLE STG_Clientes;

INSERT INTO STG_Clientes (ClienteID, NombreCompleto, Email, Telefono,
                           Ciudad, Departamento, FechaNacimiento,
                           FechaRegistro, EstadoRegistro, MensajeError)
SELECT
    c.ClienteID,
    LTRIM(RTRIM(c.NombreCompleto)),
    LOWER(LTRIM(RTRIM(c.Email))),
    c.Telefono,
    CASE 
        WHEN UPPER(LTRIM(RTRIM(c.Ciudad))) IN ('BOGOTA','BOGOTÁ','SANTA FE DE BOGOTA') THEN 'Bogotá'
        WHEN UPPER(LTRIM(RTRIM(c.Ciudad))) IN ('MEDELLIN','MEDELLÍN') THEN 'Medellín'
        WHEN UPPER(LTRIM(RTRIM(c.Ciudad))) IN ('CALI') THEN 'Cali'
        WHEN UPPER(LTRIM(RTRIM(c.Ciudad))) IN ('BARRANQUILLA') THEN 'Barranquilla'
        WHEN UPPER(LTRIM(RTRIM(c.Ciudad))) IN ('CARTAGENA') THEN 'Cartagena'
        ELSE LTRIM(RTRIM(c.Ciudad))
    END,
    LTRIM(RTRIM(c.Departamento)),
    c.FechaNacimiento,
    c.FechaRegistro,
    CASE
        WHEN c.NombreCompleto IS NULL OR LTRIM(RTRIM(c.NombreCompleto)) = '' THEN 'NULO'
        WHEN c.Email IS NULL OR c.Email NOT LIKE '%@%.%' THEN 'INVALIDO'
        ELSE 'OK'
    END,
    CASE
        WHEN c.NombreCompleto IS NULL OR LTRIM(RTRIM(c.NombreCompleto)) = '' THEN 'NombreCompleto nulo o vacío'
        WHEN c.Email IS NULL OR c.Email NOT LIKE '%@%.%' THEN 'Email inválido o nulo'
        ELSE NULL
    END
FROM DB_Proyecto3_OLTP.dbo.Clientes c;
GO

-- ============================================================
-- CARGA STG_Productos - CORREGIDO
-- ============================================================
TRUNCATE TABLE STG_Productos;

INSERT INTO STG_Productos (ProductoID, NombreProducto, CategoriaID, CategoriaNombre,
                            ProveedorID, PrecioCompra, PrecioVenta,
                            EstadoRegistro, MensajeError)
SELECT
    p.ProductoID,
    LTRIM(RTRIM(p.NombreProducto)),
    p.CategoriaID,
    UPPER(LTRIM(RTRIM(cat.NombreCategoria))),
    p.ProveedorID,
    p.PrecioCompra,
    p.PrecioVenta,
    CASE
        WHEN p.NombreProducto IS NULL THEN 'NULO'
        WHEN p.PrecioVenta <= 0 OR p.PrecioCompra <= 0 THEN 'INVALIDO'
        WHEN p.PrecioVenta < p.PrecioCompra THEN 'INVALIDO'
        WHEN p.CategoriaID NOT IN (SELECT CategoriaID FROM DB_Proyecto3_OLTP.dbo.Categorias) THEN 'INVALIDO'
        ELSE 'OK'
    END,
    CASE
        WHEN p.NombreProducto IS NULL THEN 'Nombre de producto nulo'
        WHEN p.PrecioVenta <= 0 OR p.PrecioCompra <= 0 THEN 'Precio inválido (<=0)'
        WHEN p.PrecioVenta < p.PrecioCompra THEN 'Precio venta menor que costo'
        WHEN p.CategoriaID NOT IN (SELECT CategoriaID FROM DB_Proyecto3_OLTP.dbo.Categorias) THEN 'CategoriaID inexistente'
        ELSE NULL
    END
FROM DB_Proyecto3_OLTP.dbo.Productos p
LEFT JOIN DB_Proyecto3_OLTP.dbo.Categorias cat ON p.CategoriaID = cat.CategoriaID;
GO

PRINT 'STG_Clientes y STG_Productos cargados correctamente.';
GO

-- ============================================================
-- CARGA STG_Ventas
-- ============================================================

TRUNCATE TABLE STG_Ventas;

INSERT INTO STG_Ventas
(
VentaID,
FechaVenta,
ClienteID,
ProductoID,
TiendaID,
VendedorID,
Cantidad,
PrecioUnitario,
ValorNeto,
MargenBruto,
Anio,
Mes
)

SELECT

v.VentaID,
v.FechaVenta,
v.ClienteID,
dv.ProductoID,
v.TiendaID,
v.VendedorID,
dv.Cantidad,
dv.PrecioUnitario,

dv.Cantidad*dv.PrecioUnitario,

(dv.Cantidad*dv.PrecioUnitario)
-
(dv.Cantidad*p.PrecioCompra),

YEAR(v.FechaVenta),
MONTH(v.FechaVenta)

FROM DB_Proyecto3_OLTP.dbo.Ventas v
INNER JOIN DB_Proyecto3_OLTP.dbo.DetalleVentas dv
ON v.VentaID=dv.VentaID
INNER JOIN DB_Proyecto3_OLTP.dbo.Productos p
ON dv.ProductoID=p.ProductoID;


-- ============================================================
-- CARGA STG_Inventario
-- ============================================================

TRUNCATE TABLE STG_Inventario;

INSERT INTO STG_Inventario

SELECT *
FROM DB_Proyecto3_OLTP.dbo.InventarioDiario;


-- ============================================================
-- CARGA STG_Compras
-- ============================================================

TRUNCATE TABLE STG_Compras;

INSERT INTO STG_Compras

SELECT *
FROM DB_Proyecto3_OLTP.dbo.Compras;


-- ============================================================
-- CARGA STG_Devoluciones
-- ============================================================

TRUNCATE TABLE STG_Devoluciones;

INSERT INTO STG_Devoluciones

SELECT *
FROM DB_Proyecto3_OLTP.dbo.Devoluciones;


-- ============================================================
-- CARGA STG_Metas
-- ============================================================

TRUNCATE TABLE STG_Metas;

INSERT INTO STG_Metas

SELECT *
FROM DB_Proyecto3_OLTP.dbo.MetasComerciales;

GO

PRINT 'STAGING cargado completamente';
GO