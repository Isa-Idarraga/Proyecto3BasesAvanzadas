CREATE DATABASE BI_DW;
GO

USE BI_DW;
GO

-- ==========================================
-- DimFecha
-- ==========================================

CREATE TABLE DimFecha
(
    FechaKey INT PRIMARY KEY,
    Fecha DATE,
    Dia INT,
    Mes INT,
    NombreMes VARCHAR(20),
    Trimestre INT,
    Anio INT
);

-- ==========================================
-- DimCliente
-- ==========================================

CREATE TABLE DimCliente
(
    ClienteKey INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT,
    NombreCompleto VARCHAR(150),
    Ciudad VARCHAR(100),
    Departamento VARCHAR(100),
    FechaInicio DATETIME DEFAULT GETDATE(),
    FechaFin DATETIME NULL,
    Activo BIT DEFAULT 1
);

-- ==========================================
-- DimProducto
-- ==========================================

CREATE TABLE DimProducto
(
    ProductoKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductoID INT,
    NombreProducto VARCHAR(150),
    Categoria VARCHAR(100),
    PrecioCompra DECIMAL(14,2),
    PrecioVenta DECIMAL(14,2),
    FechaInicio DATETIME DEFAULT GETDATE(),
    FechaFin DATETIME NULL,
    Activo BIT DEFAULT 1
);

-- ==========================================
-- DimTienda
-- ==========================================

CREATE TABLE DimTienda
(
    TiendaKey INT IDENTITY(1,1) PRIMARY KEY,
    TiendaID INT,
    NombreTienda VARCHAR(100),
    Ciudad VARCHAR(100),
    Departamento VARCHAR(100)
);

-- ==========================================
-- DimVendedor
-- ==========================================

CREATE TABLE DimVendedor
(
    VendedorKey INT IDENTITY(1,1) PRIMARY KEY,
    VendedorID INT,
    NombreCompleto VARCHAR(150)
);

-- ==========================================
-- DimProveedor
-- ==========================================

CREATE TABLE DimProveedor
(
    ProveedorKey INT IDENTITY(1,1) PRIMARY KEY,
    ProveedorID INT,
    NombreProveedor VARCHAR(150)
);

-- ==========================================
-- DimCanalVenta
-- ==========================================

CREATE TABLE DimCanalVenta
(
    CanalKey INT IDENTITY(1,1) PRIMARY KEY,
    CanalVenta VARCHAR(50)
);

-- ==========================================
-- DimPromocion
-- ==========================================

CREATE TABLE DimPromocion
(
    PromocionKey INT IDENTITY(1,1) PRIMARY KEY,
    NombrePromocion VARCHAR(100)
);

-- ==========================================
-- DimGeografia
-- ==========================================

CREATE TABLE DimGeografia
(
    GeografiaKey INT IDENTITY(1,1) PRIMARY KEY,
    Ciudad VARCHAR(100),
    Departamento VARCHAR(100)
);

GO