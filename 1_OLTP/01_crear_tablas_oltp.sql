-- ============================================================
-- PROYECTO 3 - SI3009 Bases de datos avanzadas
-- Base de datos OLTP
-- Integrante: Isabella Idarraga, Juan José Rodríguez, Nicolá Saldarriaga
-- ============================================================

CREATE DATABASE DB_Proyecto3_OLTP;
GO

USE DB_Proyecto3_OLTP;
GO

-- ============================================================
-- 1. CATEGORIAS
-- ============================================================
CREATE TABLE Categorias (
    CategoriaID     INT IDENTITY(1,1) PRIMARY KEY,
    NombreCategoria VARCHAR(100) NOT NULL,
    Descripcion     VARCHAR(255) NULL,
    CategoriaParent INT NULL,
    Estado          CHAR(1) NOT NULL DEFAULT 'A'
        CONSTRAINT CHK_Cat_Estado CHECK (Estado IN ('A','I')),
    CONSTRAINT FK_Cat_Parent FOREIGN KEY (CategoriaParent)
        REFERENCES Categorias(CategoriaID)
);
GO

-- ============================================================
-- 2. PROVEEDORES
-- ============================================================
CREATE TABLE Proveedores (
    ProveedorID  INT IDENTITY(1,1) PRIMARY KEY,
    NombreEmpresa VARCHAR(150) NOT NULL,
    Contacto     VARCHAR(100) NULL,
    Telefono     VARCHAR(20)  NULL,
    Email        VARCHAR(100) NULL,
    Ciudad       VARCHAR(80)  NOT NULL,
    Departamento VARCHAR(80)  NOT NULL,
    Direccion    VARCHAR(200) NULL,
    Estado       CHAR(1) NOT NULL DEFAULT 'A'
        CONSTRAINT CHK_Prov_Estado CHECK (Estado IN ('A','I'))
);
GO

-- ============================================================
-- 3. PRODUCTOS
-- ============================================================
CREATE TABLE Productos (
    ProductoID   INT IDENTITY(1,1) PRIMARY KEY,
    CodigoSKU    VARCHAR(50)  NOT NULL UNIQUE,
    NombreProducto VARCHAR(150) NOT NULL,
    CategoriaID  INT NOT NULL,
    ProveedorID  INT NOT NULL,
    PrecioCompra DECIMAL(12,2) NOT NULL
        CONSTRAINT CHK_Prod_PrecioCompra CHECK (PrecioCompra >= 0),
    PrecioVenta  DECIMAL(12,2) NOT NULL
        CONSTRAINT CHK_Prod_PrecioVenta CHECK (PrecioVenta >= 0),
    StockMinimo  INT NOT NULL DEFAULT 10
        CONSTRAINT CHK_Prod_StockMin CHECK (StockMinimo >= 0),
    Unidad       VARCHAR(30) NOT NULL DEFAULT 'Unidad',
    Estado       CHAR(1) NOT NULL DEFAULT 'A'
        CONSTRAINT CHK_Prod_Estado CHECK (Estado IN ('A','I')),
    CONSTRAINT FK_Prod_Categoria FOREIGN KEY (CategoriaID)
        REFERENCES Categorias(CategoriaID),
    CONSTRAINT FK_Prod_Proveedor FOREIGN KEY (ProveedorID)
        REFERENCES Proveedores(ProveedorID)
);
GO

-- ============================================================
-- 4. TIENDAS
-- ============================================================
CREATE TABLE Tiendas (
    TiendaID    INT IDENTITY(1,1) PRIMARY KEY,
    NombreTienda VARCHAR(100) NOT NULL,
    Ciudad      VARCHAR(80)  NOT NULL,
    Departamento VARCHAR(80) NOT NULL,
    Direccion   VARCHAR(200) NOT NULL,
    Telefono    VARCHAR(20)  NULL,
    Email       VARCHAR(100) NULL,
    FechaApertura DATE        NOT NULL,
    Estado      CHAR(1) NOT NULL DEFAULT 'A'
        CONSTRAINT CHK_Tienda_Estado CHECK (Estado IN ('A','I'))
);
GO

-- ============================================================
-- 5. CLIENTES
-- ============================================================
CREATE TABLE Clientes (
    ClienteID   INT IDENTITY(1,1) PRIMARY KEY,
    TipoDocumento CHAR(2) NOT NULL
        CONSTRAINT CHK_Cli_TipoDoc CHECK (TipoDocumento IN ('CC','CE','NI','PA')),
    NumeroDocumento VARCHAR(20) NOT NULL,
    NombreCompleto VARCHAR(150) NOT NULL,
    Email        VARCHAR(100) NULL,
    Telefono     VARCHAR(20)  NULL,
    Ciudad       VARCHAR(80)  NOT NULL,
    Departamento VARCHAR(80)  NOT NULL,
    Direccion    VARCHAR(200) NULL,
    FechaNacimiento DATE       NULL,
    Segmento     VARCHAR(30) NOT NULL DEFAULT 'Regular'
        CONSTRAINT CHK_Cli_Segmento CHECK (Segmento IN ('Regular','Premium','VIP','Corporativo')),
    FechaRegistro DATE NOT NULL DEFAULT GETDATE(),
    Estado       CHAR(1) NOT NULL DEFAULT 'A'
        CONSTRAINT CHK_Cli_Estado CHECK (Estado IN ('A','I')),
    CONSTRAINT UQ_Cli_Documento UNIQUE (TipoDocumento, NumeroDocumento)
);
GO

-- ============================================================
-- 6. VENDEDORES
-- ============================================================
CREATE TABLE Vendedores (
    VendedorID   INT IDENTITY(1,1) PRIMARY KEY,
    NombreCompleto VARCHAR(150) NOT NULL,
    Email        VARCHAR(100) NOT NULL UNIQUE,
    Telefono     VARCHAR(20)  NULL,
    TiendaID     INT NOT NULL,
    Cargo        VARCHAR(80) NOT NULL DEFAULT 'Vendedor',
    FechaIngreso DATE NOT NULL,
    Estado       CHAR(1) NOT NULL DEFAULT 'A'
        CONSTRAINT CHK_Vend_Estado CHECK (Estado IN ('A','I')),
    CONSTRAINT FK_Vend_Tienda FOREIGN KEY (TiendaID)
        REFERENCES Tiendas(TiendaID)
);
GO

-- ============================================================
-- 7. VENTAS
-- ============================================================
CREATE TABLE Ventas (
    VentaID      INT IDENTITY(1,1) PRIMARY KEY,
    NumeroFactura VARCHAR(30) NOT NULL UNIQUE,
    FechaVenta   DATETIME    NOT NULL DEFAULT GETDATE(),
    ClienteID    INT NOT NULL,
    TiendaID     INT NOT NULL,
    VendedorID   INT NOT NULL,
    CanalVenta   VARCHAR(30) NOT NULL DEFAULT 'Presencial'
        CONSTRAINT CHK_Venta_Canal CHECK (CanalVenta IN ('Presencial','Online','Telefono','App')),
    SubTotal     DECIMAL(14,2) NOT NULL DEFAULT 0
        CONSTRAINT CHK_Venta_SubTotal CHECK (SubTotal >= 0),
    Descuento    DECIMAL(14,2) NOT NULL DEFAULT 0
        CONSTRAINT CHK_Venta_Descuento CHECK (Descuento >= 0),
    Impuesto     DECIMAL(14,2) NOT NULL DEFAULT 0
        CONSTRAINT CHK_Venta_Impuesto CHECK (Impuesto >= 0),
    TotalVenta   DECIMAL(14,2) NOT NULL DEFAULT 0
        CONSTRAINT CHK_Venta_Total CHECK (TotalVenta >= 0),
    Estado       CHAR(1) NOT NULL DEFAULT 'A'
        CONSTRAINT CHK_Venta_Estado CHECK (Estado IN ('A','C','N')),
    CONSTRAINT FK_Venta_Cliente  FOREIGN KEY (ClienteID)  REFERENCES Clientes(ClienteID),
    CONSTRAINT FK_Venta_Tienda   FOREIGN KEY (TiendaID)   REFERENCES Tiendas(TiendaID),
    CONSTRAINT FK_Venta_Vendedor FOREIGN KEY (VendedorID) REFERENCES Vendedores(VendedorID)
);
GO

-- ============================================================
-- 8. DETALLE VENTAS
-- ============================================================
CREATE TABLE DetalleVentas (
    DetalleID    INT IDENTITY(1,1) PRIMARY KEY,
    VentaID      INT NOT NULL,
    ProductoID   INT NOT NULL,
    Cantidad     INT NOT NULL
        CONSTRAINT CHK_Det_Cantidad CHECK (Cantidad > 0),
    PrecioUnitario DECIMAL(12,2) NOT NULL
        CONSTRAINT CHK_Det_Precio CHECK (PrecioUnitario >= 0),
    Descuento    DECIMAL(12,2) NOT NULL DEFAULT 0
        CONSTRAINT CHK_Det_Descuento CHECK (Descuento >= 0),
    CostoUnitario DECIMAL(12,2) NOT NULL
        CONSTRAINT CHK_Det_Costo CHECK (CostoUnitario >= 0),
    Subtotal     AS (Cantidad * (PrecioUnitario - Descuento)) PERSISTED,
    CONSTRAINT FK_Det_Venta    FOREIGN KEY (VentaID)    REFERENCES Ventas(VentaID),
    CONSTRAINT FK_Det_Producto FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);
GO

-- ============================================================
-- 9. INVENTARIO DIARIO
-- ============================================================
CREATE TABLE InventarioDiario (
    InventarioID  INT IDENTITY(1,1) PRIMARY KEY,
    FechaRegistro DATE NOT NULL,
    ProductoID    INT  NOT NULL,
    TiendaID      INT  NOT NULL,
    StockInicial  INT  NOT NULL DEFAULT 0
        CONSTRAINT CHK_Inv_Inicial CHECK (StockInicial >= 0),
    Entradas      INT  NOT NULL DEFAULT 0
        CONSTRAINT CHK_Inv_Entradas CHECK (Entradas >= 0),
    Salidas       INT  NOT NULL DEFAULT 0
        CONSTRAINT CHK_Inv_Salidas CHECK (Salidas >= 0),
    StockFinal    INT  NOT NULL DEFAULT 0
        CONSTRAINT CHK_Inv_Final CHECK (StockFinal >= 0),
    CONSTRAINT UQ_Inv_Dia UNIQUE (FechaRegistro, ProductoID, TiendaID),
    CONSTRAINT FK_Inv_Producto FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    CONSTRAINT FK_Inv_Tienda   FOREIGN KEY (TiendaID)   REFERENCES Tiendas(TiendaID)
);
GO

-- ============================================================
-- 10. COMPRAS
-- ============================================================
CREATE TABLE Compras (
    CompraID      INT IDENTITY(1,1) PRIMARY KEY,
    NumeroOrden   VARCHAR(30) NOT NULL UNIQUE,
    FechaCompra   DATE        NOT NULL DEFAULT GETDATE(),
    ProveedorID   INT         NOT NULL,
    TiendaID      INT         NOT NULL,
    TotalCompra   DECIMAL(14,2) NOT NULL DEFAULT 0
        CONSTRAINT CHK_Comp_Total CHECK (TotalCompra >= 0),
    Estado        CHAR(1) NOT NULL DEFAULT 'P'
        CONSTRAINT CHK_Comp_Estado CHECK (Estado IN ('P','R','C')),
    CONSTRAINT FK_Comp_Proveedor FOREIGN KEY (ProveedorID) REFERENCES Proveedores(ProveedorID),
    CONSTRAINT FK_Comp_Tienda    FOREIGN KEY (TiendaID)    REFERENCES Tiendas(TiendaID)
);
GO

-- ============================================================
-- 11. DETALLE COMPRAS
-- ============================================================
CREATE TABLE DetalleCompras (
    DetalleCompraID INT IDENTITY(1,1) PRIMARY KEY,
    CompraID        INT NOT NULL,
    ProductoID      INT NOT NULL,
    Cantidad        INT NOT NULL
        CONSTRAINT CHK_DetC_Cantidad CHECK (Cantidad > 0),
    PrecioUnitario  DECIMAL(12,2) NOT NULL
        CONSTRAINT CHK_DetC_Precio CHECK (PrecioUnitario >= 0),
    Subtotal        AS (Cantidad * PrecioUnitario) PERSISTED,
    CONSTRAINT FK_DetC_Compra   FOREIGN KEY (CompraID)   REFERENCES Compras(CompraID),
    CONSTRAINT FK_DetC_Producto FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);
GO

-- ============================================================
-- 12. DEVOLUCIONES
-- ============================================================
CREATE TABLE Devoluciones (
    DevolucionID   INT IDENTITY(1,1) PRIMARY KEY,
    VentaID        INT NOT NULL,
    DetalleID      INT NOT NULL,
    FechaDevolucion DATE NOT NULL DEFAULT GETDATE(),
    CantidadDevuelta INT NOT NULL
        CONSTRAINT CHK_Dev_Cantidad CHECK (CantidadDevuelta > 0),
    MotivoDevolucion VARCHAR(200) NOT NULL,
    TipoDevolucion CHAR(1) NOT NULL DEFAULT 'P'
        CONSTRAINT CHK_Dev_Tipo CHECK (TipoDevolucion IN ('P','C','N')),
    MontoDevuelto  DECIMAL(12,2) NOT NULL DEFAULT 0
        CONSTRAINT CHK_Dev_Monto CHECK (MontoDevuelto >= 0),
    Estado         CHAR(1) NOT NULL DEFAULT 'P'
        CONSTRAINT CHK_Dev_Estado CHECK (Estado IN ('P','A','R')),
    CONSTRAINT FK_Dev_Venta   FOREIGN KEY (VentaID)   REFERENCES Ventas(VentaID),
    CONSTRAINT FK_Dev_Detalle FOREIGN KEY (DetalleID) REFERENCES DetalleVentas(DetalleID)
);
GO

-- ============================================================
-- 13. METAS COMERCIALES
-- ============================================================
CREATE TABLE MetasComerciales (
    MetaID      INT IDENTITY(1,1) PRIMARY KEY,
    Anio        INT NOT NULL
        CONSTRAINT CHK_Meta_Anio CHECK (Anio >= 2020),
    Mes         INT NOT NULL
        CONSTRAINT CHK_Meta_Mes CHECK (Mes BETWEEN 1 AND 12),
    TiendaID    INT NOT NULL,
    CategoriaID INT NOT NULL,
    VendedorID  INT NULL,
    ValorMeta   DECIMAL(14,2) NOT NULL
        CONSTRAINT CHK_Meta_Valor CHECK (ValorMeta > 0),
    CanalVenta  VARCHAR(30) NULL,
    CONSTRAINT UQ_Meta UNIQUE (Anio, Mes, TiendaID, CategoriaID, VendedorID),
    CONSTRAINT FK_Meta_Tienda    FOREIGN KEY (TiendaID)    REFERENCES Tiendas(TiendaID),
    CONSTRAINT FK_Meta_Categoria FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID),
    CONSTRAINT FK_Meta_Vendedor  FOREIGN KEY (VendedorID)  REFERENCES Vendedores(VendedorID)
);
GO

PRINT 'Base de datos OLTP creada exitosamente con 13 tablas.';
GO