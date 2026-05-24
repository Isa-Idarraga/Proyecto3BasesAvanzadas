USE BI_DW;
GO

CREATE TABLE FactVentas
(
    VentaKey BIGINT IDENTITY(1,1) PRIMARY KEY,

    FechaKey INT,
    ClienteKey INT,
    ProductoKey INT,
    TiendaKey INT,
    VendedorKey INT,
    CanalKey INT,

    Cantidad INT,
    PrecioUnitario DECIMAL(14,2),

    SubTotal DECIMAL(14,2),
    TotalVenta DECIMAL(14,2)
);



CREATE TABLE FactInventarioDiario
(
    InventarioKey BIGINT IDENTITY(1,1) PRIMARY KEY,

    FechaKey INT,
    ProductoKey INT,
    TiendaKey INT,

    StockInicial INT,
    Entradas INT,
    Salidas INT,
    StockFinal INT
);



CREATE TABLE FactMetasComerciales
(
    MetaKey BIGINT IDENTITY(1,1) PRIMARY KEY,

    FechaKey INT,
    TiendaKey INT,
    VendedorKey INT,
    CategoriaKey INT,
    CanalKey INT,

    ValorMeta DECIMAL(14,2)
);


CREATE TABLE FactCompras
(
    CompraKey BIGINT IDENTITY(1,1) PRIMARY KEY,

    FechaKey INT,
    ProveedorKey INT,
    TiendaKey INT,

    TotalCompra DECIMAL(14,2)
);



CREATE TABLE FactDevoluciones
(
    DevolucionKey BIGINT IDENTITY(1,1) PRIMARY KEY,

    FechaKey INT,

    CantidadDevuelta INT,
    MontoDevuelto DECIMAL(14,2)
);



CREATE TABLE FactRentabilidad
(
    RentabilidadKey BIGINT IDENTITY(1,1) PRIMARY KEY,

    FechaKey INT,
    ProductoKey INT,
    TiendaKey INT,

    Ingresos DECIMAL(14,2),
    Costos DECIMAL(14,2),
    Utilidad DECIMAL(14,2)
);

GO