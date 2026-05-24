USE BI_DW;
GO

DELETE FROM DimCliente;

INSERT INTO DimCliente
(
ClienteID,
NombreCompleto,
Ciudad,
Departamento
)
SELECT
ClienteID,
NombreCompleto,
Ciudad,
Departamento
FROM BI_Staging.dbo.STG_Clientes
WHERE EstadoRegistro='OK';

GO