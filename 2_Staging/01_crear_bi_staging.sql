-- ============================================================
-- CREACIÓN BASE DE DATOS STAGING
-- ============================================================
CREATE DATABASE BI_Staging;
GO

USE BI_Staging;
GO

-- Staging Clientes
CREATE TABLE STG_Clientes (
    ClienteID       INT,
    NombreCompleto  VARCHAR(200),
    Email           VARCHAR(150),
    Telefono        VARCHAR(20),
    Ciudad          VARCHAR(100),
    Departamento    VARCHAR(100),
    FechaNacimiento DATE,
    Genero          CHAR(1),
    FechaRegistro   DATE,
    -- Campos de control
    FechaCarga      DATETIME DEFAULT GETDATE(),
    EstadoRegistro  VARCHAR(20),  -- 'OK', 'DUPLICADO', 'NULO', 'INVALIDO'
    MensajeError    VARCHAR(500)
);
GO

-- Staging Productos
CREATE TABLE STG_Productos (
    ProductoID      INT,
    NombreProducto  VARCHAR(200),
    CategoriaID     INT,
    CategoriaNombre VARCHAR(100),
    ProveedorID     INT,
    PrecioCompra    DECIMAL(12,2),
    PrecioVenta     DECIMAL(12,2),
    Stock           INT,
    Activo          BIT,
    FechaCarga      DATETIME DEFAULT GETDATE(),
    EstadoRegistro  VARCHAR(20),
    MensajeError    VARCHAR(500)
);
GO

-- Staging Ventas
CREATE TABLE STG_Ventas (
    VentaID         INT,
    NumeroFactura   VARCHAR(20),
    FechaVenta      DATETIME,
    Anio            INT,
    Mes             INT,
    Dia             INT,
    ClienteID       INT,
    TiendaID        INT,
    VendedorID      INT,
    CanalVenta      VARCHAR(30),
    SubTotal        DECIMAL(14,2),
    Descuento       DECIMAL(14,2),
    Impuesto        DECIMAL(14,2),
    TotalVenta      DECIMAL(14,2),
    Estado          CHAR(1),
    FechaCarga      DATETIME DEFAULT GETDATE(),
    EstadoRegistro  VARCHAR(20),
    MensajeError    VARCHAR(500)
);
GO

-- Staging DetalleVentas
CREATE TABLE STG_DetalleVentas (
    DetalleID       INT,
    VentaID         INT,
    ProductoID      INT,
    Cantidad        INT,
    PrecioUnitario  DECIMAL(12,2),
    Descuento       DECIMAL(12,2),
    CostoUnitario   DECIMAL(12,2),
    ValorNeto       DECIMAL(14,2),  -- campo derivado: cant*(precio-desc)
    MargenBruto     DECIMAL(14,2),  -- campo derivado: ValorNeto - cant*costo
    FechaCarga      DATETIME DEFAULT GETDATE(),
    EstadoRegistro  VARCHAR(20),
    MensajeError    VARCHAR(500)
);
GO

-- Staging Inventario
CREATE TABLE STG_Inventario (
    InventarioID    INT,
    ProductoID      INT,
    TiendaID        INT,
    FechaRegistro   DATE,
    Anio            INT,
    Mes             INT,
    StockInicial    INT,
    Entradas        INT,
    Salidas         INT,
    StockFinal      INT,
    FechaCarga      DATETIME DEFAULT GETDATE(),
    EstadoRegistro  VARCHAR(20),
    MensajeError    VARCHAR(500)
);
GO

-- Staging Metas
CREATE TABLE STG_Metas (
    MetaID          INT,
    Anio            INT,
    Mes             INT,
    TiendaID        INT,
    CategoriaID     INT,
    VendedorID      INT,
    ValorMeta       DECIMAL(14,2),
    CanalVenta      VARCHAR(30),
    FechaCarga      DATETIME DEFAULT GETDATE(),
    EstadoRegistro  VARCHAR(20),
    MensajeError    VARCHAR(500)
);
GO

-- Staging Devoluciones
CREATE TABLE STG_Devoluciones (
    DevolucionID     INT,
    VentaID          INT,
    DetalleID        INT,
    FechaDevolucion  DATE,
    CantidadDevuelta INT,
    MotivoDevolucion VARCHAR(200),
    TipoDevolucion   CHAR(1),
    MontoDevuelto    DECIMAL(12,2),
    Estado           CHAR(1),
    FechaCarga       DATETIME DEFAULT GETDATE(),
    EstadoRegistro   VARCHAR(20),
    MensajeError     VARCHAR(500)
);
GO

-- Staging Compras
CREATE TABLE STG_Compras (
    CompraID        INT,
    NumeroOrden     VARCHAR(20),
    FechaCompra     DATE,
    Anio            INT,
    Mes             INT,
    ProveedorID     INT,
    TiendaID        INT,
    TotalCompra     DECIMAL(14,2),
    Estado          CHAR(1),
    FechaCarga      DATETIME DEFAULT GETDATE(),
    EstadoRegistro  VARCHAR(20),
    MensajeError    VARCHAR(500)
);
GO

PRINT 'BI_Staging creado con todas las tablas correctamente.';
GO