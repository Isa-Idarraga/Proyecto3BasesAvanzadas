USE BI_DW;
GO

DELETE FROM FactDevoluciones;
GO

INSERT INTO FactDevoluciones
(
    FechaKey,
    CantidadDevuelta,
    MontoDevuelto
)

SELECT

CAST(
FORMAT(FechaDevolucion,'yyyyMMdd')
AS INT),

CantidadDevuelta,
MontoDevuelto

FROM BI_Staging.dbo.STG_Devoluciones;

GO

PRINT 'FactDevoluciones cargada';
GO