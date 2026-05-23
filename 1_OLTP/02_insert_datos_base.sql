USE DB_Proyecto3_OLTP;
GO

-- ============================================================
-- DATOS BASE: Categorias, Proveedores, Tiendas
-- ============================================================

-- Categorias
INSERT INTO Categorias (NombreCategoria, Descripcion, Estado) VALUES
('Electrónica',     'Dispositivos y accesorios electrónicos', 'A'),
('Ropa y Moda',     'Prendas de vestir para todas las edades', 'A'),
('Hogar y Cocina',  'Artículos para el hogar y cocina', 'A'),
('Deportes',        'Equipos y ropa deportiva', 'A'),
('Belleza',         'Cosméticos y cuidado personal', 'A'),
('Juguetes',        'Juguetes y juegos para niños', 'A'),
('Alimentos',       'Alimentos y bebidas', 'A'),
('Libros',          'Libros, revistas y papelería', 'A'),
('Mascotas',        'Productos para mascotas', 'A'),
('Ferretería',      'Herramientas y materiales de construcción', 'A');
GO

-- Proveedores
INSERT INTO Proveedores (NombreEmpresa, Contacto, Telefono, Email, Ciudad, Departamento, Direccion, Estado) VALUES
('Distribuidora Tech S.A.',   'Carlos Ruiz',    '3001234567', 'carlos@disttech.com',   'Bogotá',       'Cundinamarca', 'Cra 15 #80-20',  'A'),
('Moda Colombia Ltda.',       'Ana Gómez',      '3109876543', 'ana@modacol.com',        'Medellín',     'Antioquia',    'Cl 50 #40-10',   'A'),
('HogarPlus S.A.S.',          'Luis Martínez',  '3205551234', 'luis@hogarplus.com',     'Cali',         'Valle',        'Av 6N #23-45',   'A'),
('Deportes Andinos Ltda.',    'María Torres',   '3154443322', 'maria@depand.com',       'Bucaramanga',  'Santander',    'Cl 35 #20-15',   'A'),
('Belleza Total S.A.',        'Jorge Pérez',    '3006667788', 'jorge@bellezat.com',     'Barranquilla', 'Atlántico',    'Cra 43 #72-30',  'A'),
('Juguetes Felices Ltda.',    'Sandra López',   '3177778899', 'sandra@jugfelices.com',  'Bogotá',       'Cundinamarca', 'Cl 72 #50-18',   'A'),
('Alimentos del Valle S.A.',  'Pedro Ramos',    '3222223344', 'pedro@alimvalle.com',    'Cali',         'Valle',        'Cra 1 #10-05',   'A'),
('Editorial Norma Ltda.',     'Claudia Vera',   '3133334455', 'claudia@norma.com',      'Bogotá',       'Cundinamarca', 'Av El Dorado 68','A'),
('Mascotas Felices S.A.S.',   'Roberto Díaz',   '3044445566', 'roberto@mascfel.com',    'Medellín',     'Antioquia',    'Cra 80 #30-22',  'A'),
('Ferretería Industrial S.A.','Camila Ospina',  '3155556677', 'camila@ferind.com',      'Bogotá',       'Cundinamarca', 'Cl 13 #50-60',   'A');
GO

-- Tiendas
INSERT INTO Tiendas (NombreTienda, Ciudad, Departamento, Direccion, Telefono, Email, FechaApertura, Estado) VALUES
('Sede Bogotá Centro',      'Bogotá',       'Cundinamarca', 'Cra 7 #15-50',        '6011234567', 'bogota.centro@empresa.com',   '2018-01-15', 'A'),
('Sede Bogotá Norte',       'Bogotá',       'Cundinamarca', 'Cl 127 #15-30',       '6017654321', 'bogota.norte@empresa.com',    '2018-06-01', 'A'),
('Sede Medellín El Poblado','Medellín',     'Antioquia',    'Cl 10 #43-25',        '6042223344', 'medellin.poblado@empresa.com','2019-03-10', 'A'),
('Sede Medellín Laureles',  'Medellín',     'Antioquia',    'Cra 76 #33-10',       '6043334455', 'medellin.laureles@empresa.com','2019-08-20','A'),
('Sede Cali Chipichape',    'Cali',         'Valle',        'Av 6N #25-10 Local 5','6024445566', 'cali.chipichape@empresa.com', '2019-11-01', 'A'),
('Sede Cali Sur',           'Cali',         'Valle',        'Cl 5 #40-20',         '6025556677', 'cali.sur@empresa.com',        '2020-02-14', 'A'),
('Sede Barranquilla',       'Barranquilla', 'Atlántico',    'Cra 53 #72-50',       '6056667788', 'barranquilla@empresa.com',    '2020-05-01', 'A'),
('Sede Bucaramanga',        'Bucaramanga',  'Santander',    'Cl 35 #22-15',        '6077778899', 'bucaramanga@empresa.com',     '2020-09-15', 'A'),
('Sede Pereira',            'Pereira',      'Risaralda',    'Av 30 de Agosto 40-5','6068889900', 'pereira@empresa.com',         '2021-01-10', 'A'),
('Sede Manizales',          'Manizales',    'Caldas',       'Cra 23 #22-05',       '6069990011', 'manizales@empresa.com',       '2021-06-01', 'A');
GO

PRINT 'Categorias, Proveedores y Tiendas insertados correctamente.';
GO

-- ============================================================
-- PRODUCTOS (200)
-- ============================================================
DECLARE @cat INT, @prov INT, @i INT = 1;
DECLARE @nombres TABLE (n VARCHAR(100));
INSERT INTO @nombres VALUES
('Televisor'),('Celular'),('Audífonos'),('Tablet'),('Laptop'),
('Cámara'),('Parlante'),('Smartwatch'),('Teclado'),('Mouse'),
('Camisa'),('Pantalón'),('Vestido'),('Chaqueta'),('Zapatos'),
('Bolso'),('Gorra'),('Medias'),('Camiseta'),('Falda'),
('Olla'),('Sartén'),('Licuadora'),('Cafetera'),('Tostadora'),
('Juego de platos'),('Cuchillos'),('Batidora'),('Nevera'),('Horno'),
('Balón'),('Tenis deportivos'),('Pesas'),('Bicicleta'),('Raqueta'),
('Guantes'),('Casco'),('Cuerda de saltar'),('Maleta deportiva'),('Gafas de natación'),
('Crema facial'),('Shampoo'),('Perfume'),('Maquillaje'),('Protector solar'),
('Labial'),('Mascarilla'),('Tónico'),('Sérum'),('Body lotion'),
('Muñeca'),('Carro de juguete'),('Lego'),('Peluche'),('Juego de mesa'),
('Rompecabezas'),('Pelota'),('Pinturas'),('Plastilina'),('Títeres'),
('Arroz'),('Aceite'),('Atún en lata'),('Pasta'),('Sal'),
('Azúcar'),('Café'),('Leche'),('Galletas'),('Chocolate'),
('Novela'),('Libro de texto'),('Diccionario'),('Agenda'),('Cuaderno'),
('Lápices'),('Calculadora'),('Atlas'),('Revista'),('Resaltadores'),
('Alimento para perro'),('Alimento para gato'),('Arena para gato'),('Collar'),('Correa'),
('Juguete mascota'),('Vitaminas mascota'),('Champú mascota'),('Cama mascota'),('Jaula'),
('Martillo'),('Destornillador'),('Taladro'),('Sierra'),('Pintura'),
('Brocha'),('Cinta métrica'),('Nivel'),('Llave inglesa'),('Cemento');

WHILE @i <= 200
BEGIN
    SET @cat  = (@i % 10) + 1;
    SET @prov = (@i % 10) + 1;
    DECLARE @nom VARCHAR(100) = (SELECT TOP 1 n FROM @nombres ORDER BY NEWID());
    DECLARE @compra DECIMAL(12,2) = ROUND(10000 + RAND() * 490000, 0);
    DECLARE @venta  DECIMAL(12,2) = ROUND(@compra * (1.2 + RAND() * 0.8), 0);

    INSERT INTO Productos (CodigoSKU, NombreProducto, CategoriaID, ProveedorID,
                           PrecioCompra, PrecioVenta, StockMinimo, Unidad, Estado)
    VALUES (
        'SKU-' + RIGHT('0000' + CAST(@i AS VARCHAR), 4),
        @nom + ' ' + CAST(@i AS VARCHAR),
        @cat, @prov, @compra, @venta,
        CAST(5 + RAND() * 45 AS INT),
        'Unidad', 'A'
    );
    SET @i += 1;
END;
GO

PRINT '200 productos insertados.';
GO

-- ============================================================
-- CLIENTES (1.000)
-- ============================================================
DECLARE @i INT = 1;
DECLARE @ciudades TABLE (c VARCHAR(80), d VARCHAR(80));
INSERT INTO @ciudades VALUES
('Bogotá','Cundinamarca'),('Medellín','Antioquia'),('Cali','Valle'),
('Barranquilla','Atlántico'),('Bucaramanga','Santander'),
('Pereira','Risaralda'),('Manizales','Caldas'),('Cartagena','Bolívar'),
('Cúcuta','Norte de Santander'),('Ibagué','Tolima');

DECLARE @nombres1 TABLE (n VARCHAR(50));
INSERT INTO @nombres1 VALUES
('Carlos'),('María'),('Juan'),('Ana'),('Luis'),('Laura'),('Pedro'),
('Sandra'),('Jorge'),('Claudia'),('Andrés'),('Paola'),('Felipe'),
('Natalia'),('Sebastián'),('Valentina'),('David'),('Camila'),('Daniel'),('Sara');

DECLARE @apellidos TABLE (a VARCHAR(50));
INSERT INTO @apellidos VALUES
('García'),('Rodríguez'),('Martínez'),('López'),('González'),
('Pérez'),('Sánchez'),('Ramírez'),('Torres'),('Flores'),
('Rivera'),('Gómez'),('Díaz'),('Reyes'),('Cruz'),
('Morales'),('Ortiz'),('Vargas'),('Castillo'),('Ramos');

WHILE @i <= 1000
BEGIN
    DECLARE @nom1 VARCHAR(50) = (SELECT TOP 1 n FROM @nombres1 ORDER BY NEWID());
    DECLARE @ape  VARCHAR(50) = (SELECT TOP 1 a FROM @apellidos ORDER BY NEWID());
    DECLARE @ciu  VARCHAR(80);
    DECLARE @dep  VARCHAR(80);
    SELECT TOP 1 @ciu = c, @dep = d FROM @ciudades ORDER BY NEWID();
    DECLARE @seg VARCHAR(30);
    SET @seg = CASE WHEN @i % 10 = 0 THEN 'VIP'
                    WHEN @i % 5  = 0 THEN 'Premium'
                    WHEN @i % 3  = 0 THEN 'Corporativo'
                    ELSE 'Regular' END;
    INSERT INTO Clientes (TipoDocumento, NumeroDocumento, NombreCompleto,
                          Email, Telefono, Ciudad, Departamento,
                          Segmento, FechaRegistro, Estado)
    VALUES (
        'CC',
        CAST(10000000 + @i * 97 AS VARCHAR),
        @nom1 + ' ' + @ape,
        LOWER(@nom1) + CAST(@i AS VARCHAR) + '@email.com',
        '3' + RIGHT('000000000' + CAST(CAST(RAND()*999999999 AS BIGINT) AS VARCHAR), 9),
        @ciu, @dep, @seg,
        DATEADD(DAY, -CAST(RAND()*1825 AS INT), GETDATE()),
        'A'
    );
    SET @i += 1;
END;
GO

PRINT '1000 clientes insertados.';
GO

-- ============================================================
-- VENDEDORES (20)
-- ============================================================
DECLARE @i INT = 1;
WHILE @i <= 20
BEGIN
    DECLARE @tid INT = ((@i - 1) % 10) + 1;
    INSERT INTO Vendedores (NombreCompleto, Email, Telefono, TiendaID, Cargo, FechaIngreso, Estado)
    VALUES (
        'Vendedor ' + CAST(@i AS VARCHAR),
        'vendedor' + CAST(@i AS VARCHAR) + '@empresa.com',
        '3' + RIGHT('000000000' + CAST(@i * 12345678 AS VARCHAR), 9),
        @tid,
        CASE WHEN @i % 5 = 0 THEN 'Jefe de Ventas' ELSE 'Vendedor' END,
        DATEADD(DAY, -CAST(RAND() * 1825 AS INT), GETDATE()),
        'A'
    );
    SET @i += 1;
END;
GO

PRINT '20 vendedores insertados.';
GO
PRINT 'Script de datos base completado. Continuar con Ventas y DetalleVentas.';
GO