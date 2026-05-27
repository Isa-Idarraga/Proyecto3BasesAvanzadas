USE BI_DW;
GO

CREATE TABLE ETL_Log
(
    IdLog INT IDENTITY(1,1) PRIMARY KEY,

    NombreProceso VARCHAR(100),
    FechaInicio DATETIME,
    FechaFin DATETIME,

    Estado VARCHAR(30),

    RegistrosLeidos INT,
    RegistrosCargados INT,
    RegistrosRechazados INT,

    MensajeError VARCHAR(MAX)
);

GO