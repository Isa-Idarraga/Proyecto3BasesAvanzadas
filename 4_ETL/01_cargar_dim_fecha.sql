USE BI_DW;
GO

INSERT INTO DimFecha
(
    FechaKey,
    Fecha,
    Dia,
    Mes,
    NombreMes,
    Trimestre,
    Anio
)

SELECT
    CAST(FORMAT(Fecha,'yyyyMMdd') AS INT),
    Fecha,
    DAY(Fecha),
    MONTH(Fecha),
    DATENAME(MONTH,Fecha),
    DATEPART(QUARTER,Fecha),
    YEAR(Fecha)

FROM
(
    SELECT CAST('2023-01-01' AS DATE) Fecha

    UNION ALL

    SELECT DATEADD(DAY,1,Fecha)
    FROM
    (
        SELECT TOP(364)
        DATEADD(
            DAY,
            ROW_NUMBER() OVER(ORDER BY (SELECT NULL)),
            '2023-01-01'
        ) Fecha
        FROM sys.objects
    ) x
) f

WHERE NOT EXISTS
(
    SELECT 1
    FROM DimFecha d
    WHERE d.Fecha =
    f.Fecha
);

GO

PRINT 'DimFecha cargada';
GO