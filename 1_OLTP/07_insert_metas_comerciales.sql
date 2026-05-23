USE DB_Proyecto3_OLTP;
GO

DELETE FROM MetasComerciales;
GO

-- ============================================================
-- METAS COMERCIALES - CORREGIDO (CategoriaID siempre requerido)
-- ============================================================
DECLARE @mes        INT = 1;
DECLARE @tiendaID   INT;
DECLARE @catID      INT;
DECLARE @vendedorID INT;
DECLARE @canal      VARCHAR(30);
DECLARE @valor      DECIMAL(14,2);
DECLARE @v          INT;

WHILE @mes <= 12
BEGIN
    SET @tiendaID = 1;
    WHILE @tiendaID <= 10
    BEGIN
        -- Meta por tienda x categoría
        SET @catID = 1;
        WHILE @catID <= 10
        BEGIN
            SET @canal = CASE (ABS(CHECKSUM(NEWID())) % 4)
                            WHEN 0 THEN 'Presencial'
                            WHEN 1 THEN 'Online'
                            WHEN 2 THEN 'Telefono'
                            ELSE        'App'
                         END;
            SET @valor = ROUND((RAND(CHECKSUM(NEWID())) * 45000000) + 5000000, 2);

            INSERT INTO MetasComerciales
                (Anio, Mes, TiendaID, CategoriaID, VendedorID, ValorMeta, CanalVenta)
            VALUES (2023, @mes, @tiendaID, @catID, NULL, @valor, @canal);

            SET @catID += 1;
        END;

        -- Meta por vendedor (con categoría aleatoria)
        SET @v = 1;
        WHILE @v <= 2
        BEGIN
            SET @vendedorID = ((@tiendaID - 1) * 2) + @v;
            SET @catID      = (ABS(CHECKSUM(NEWID())) % 10) + 1;
            SET @canal      = CASE (ABS(CHECKSUM(NEWID())) % 4)
                                WHEN 0 THEN 'Presencial'
                                WHEN 1 THEN 'Online'
                                WHEN 2 THEN 'Telefono'
                                ELSE        'App'
                              END;
            SET @valor = ROUND((RAND(CHECKSUM(NEWID())) * 20000000) + 2000000, 2);

            INSERT INTO MetasComerciales
                (Anio, Mes, TiendaID, CategoriaID, VendedorID, ValorMeta, CanalVenta)
            VALUES (2023, @mes, @tiendaID, @catID, @vendedorID, @valor, @canal);

            SET @v += 1;
        END;

        SET @tiendaID += 1;
    END;
    SET @mes += 1;
END;
GO

PRINT 'MetasComerciales insertadas correctamente.';
GO
