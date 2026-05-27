USE DB_Proyecto3_OLTP;
GO

DELETE FROM InventarioDiario;
GO

;WITH Fechas AS
(
    SELECT CAST('2023-01-01' AS DATE) AS FechaRegistro

    UNION ALL

    SELECT DATEADD(DAY,1,FechaRegistro)
    FROM Fechas
    WHERE FechaRegistro < '2023-12-31'
)

INSERT INTO InventarioDiario
(
    FechaRegistro,
    ProductoID,
    TiendaID,
    StockInicial,
    Entradas,
    Salidas,
    StockFinal
)

SELECT

f.FechaRegistro,
p.ProductoID,
t.TiendaID,

v.StockInicial,
v.Entradas,
v.Salidas,

CASE
    WHEN v.StockInicial + v.Entradas - v.Salidas < 0
    THEN 0
    ELSE v.StockInicial + v.Entradas - v.Salidas
END

FROM Fechas f
CROSS JOIN Productos p
CROSS JOIN Tiendas t

CROSS APPLY
(
    SELECT
        (ABS(CHECKSUM(NEWID())) % 200)+10 AS StockInicial,
        (ABS(CHECKSUM(NEWID())) % 50) AS Entradas,
        (ABS(CHECKSUM(NEWID())) % 30) AS Salidas
) v

OPTION(MAXRECURSION 366);

GO

PRINT 'InventarioDiario cargado';
GO
