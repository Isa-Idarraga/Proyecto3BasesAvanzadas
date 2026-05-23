# Proyecto 3 — SI3009 Bases de Datos Avanzadas

**Integrantes:**
- Isabella Idarraga
- Juan José Rodríguez
- Nicolás Saldarriaga

---

## Descripción general

Implementación de una arquitectura de Business Intelligence completa para una cadena de retail colombiana con 10 sedes en 6 ciudades. El proyecto cubre desde la base transaccional (OLTP) hasta un dashboard analítico en Power BI, pasando por una zona de staging, un Data Warehouse dimensional y un proceso ETL.

---

## Arquitectura

```
OLTP (DB_Proyecto3_OLTP)
        │
        ▼
Staging (BI_Staging)          ← también recibe fuentes externas (CSV)
        │
        ▼
Data Warehouse (dimensiones + hechos)
        │
        ▼
Power BI Dashboard
```

---

## Estructura del repositorio

```
Proyecto3BasesAvanzadas/
├── 1_OLTP/                     Base de datos transaccional
│   ├── 01_crear_tablas_oltp.sql
│   ├── 02_insert_datos_base.sql
│   ├── 03_insert_ventas_detalle.sql
│   ├── 04_insert_inventario_diario.sql
│   ├── 05_insert_compras_detalle.sql
│   ├── 06_insert_devoluciones.sql
│   └── 07_insert_metas_comerciales.sql
├── 2_Staging/                  Capa intermedia de calidad
│   ├── 01_crear_bi_staging.sql
│   └── 02_cargar_transformar_staging.sql
├── 3_DataWarehouse/            Modelo dimensional
│   ├── 01_crear_dimensiones.sql
│   ├── 02_crear_hechos.sql
│   └── 03_etl_log.sql
├── 4_ETL/                      Carga incremental al DW
│   ├── 01_cargar_dim_fecha.sql
│   ├── 02_cargar_dim_cliente.sql
│   ├── 03_cargar_dim_producto.sql
│   ├── 04_cargar_fact_ventas.sql
│   ├── 05_cargar_fact_inventario.sql
│   ├── 06_cargar_fact_metas.sql
│   └── 07_validar_calidad_datos.sql
├── 5_FuentesExternas/          Datos externos en CSV
│   ├── metas_mensuales_externo.csv
│   └── inventario_fisico_ajustes.csv
├── 6_PowerBI/
│   └── dashboard_proyecto3.pbix
├── 7_Evidencias/               Capturas de ejecución
│   ├── evidencia_01_oltp_conteos.png
│   ├── evidencia_02_staging_calidad.png
│   ├── evidencia_03_campos_derivados.png
│   ├── evidencia_04_estandarizacion_ciudades.png
│   └── evidencia_05_estructura_staging.png
├── 8_Diagramas/
└── 9_informe/
```

---

## 1. Base de datos OLTP — `DB_Proyecto3_OLTP`

Motor: **SQL Server**. Contiene 13 tablas que modelan las operaciones diarias de la cadena.

| Tabla | Descripción |
|---|---|
| `Categorias` | 10 categorías jerárquicas (Electrónica, Ropa y Moda, Hogar, Deportes, Belleza, Juguetes, Alimentos, Libros, Mascotas, Ferretería) |
| `Proveedores` | 10 proveedores en distintas ciudades de Colombia |
| `Productos` | Catálogo con SKU único, precios de compra/venta y stock mínimo |
| `Tiendas` | 10 sedes activas en Bogotá, Medellín, Cali, Barranquilla, Bucaramanga, Pereira y Manizales |
| `Clientes` | Segmentación en Regular, Premium, VIP y Corporativo |
| `Vendedores` | Personal de ventas asociado a cada tienda |
| `Ventas` | Cabecera de factura con canal (Presencial / Online / Teléfono / App) |
| `DetalleVentas` | Líneas de venta con columna calculada `Subtotal` (persistida) |
| `InventarioDiario` | Registro diario de stock inicial, entradas, salidas y stock final por tienda/producto |
| `Compras` | Órdenes de compra a proveedores |
| `DetalleCompras` | Líneas de compra con columna calculada `Subtotal` (persistida) |
| `Devoluciones` | Gestión de devoluciones por venta y detalle |
| `MetasComerciales` | Metas mensuales por tienda, categoría y vendedor |

Todos los estados siguen restricciones `CHECK` con valores fijos (ej. `'A'/'I'` para activo/inactivo).

**Script de ejecución (orden):**
```sql
-- 1. Crear tablas
01_crear_tablas_oltp.sql

-- 2. Poblar datos maestros y transaccionales
02_insert_datos_base.sql
03_insert_ventas_detalle.sql
04_insert_inventario_diario.sql
05_insert_compras_detalle.sql
06_insert_devoluciones.sql
07_insert_metas_comerciales.sql
```

---

## 2. Staging — `BI_Staging`

Zona intermedia de limpieza y validación de calidad de datos. Replica las entidades del OLTP con campos de control adicionales en cada tabla:

| Campo | Tipo | Propósito |
|---|---|---|
| `FechaCarga` | DATETIME | Marca de tiempo de la extracción |
| `EstadoRegistro` | VARCHAR(20) | `'OK'`, `'DUPLICADO'`, `'NULO'`, `'INVALIDO'` |
| `MensajeError` | VARCHAR(500) | Descripción del problema detectado |

**Tablas staging:**
`STG_Clientes` · `STG_Productos` · `STG_Ventas` · `STG_DetalleVentas` · `STG_Inventario` · `STG_Metas` · `STG_Devoluciones` · `STG_Compras`

`STG_DetalleVentas` incluye además dos **campos derivados**:
- `ValorNeto` = `Cantidad × (PrecioUnitario − Descuento)`
- `MargenBruto` = `ValorNeto − Cantidad × CostoUnitario`

**Script de ejecución (orden):**
```sql
01_crear_bi_staging.sql
02_cargar_transformar_staging.sql
```

---

## 3. Data Warehouse

Modelo dimensional con estructura estrella. Los scripts definen:

- **`01_crear_dimensiones.sql`** — `Dim_Fecha`, `Dim_Cliente`, `Dim_Producto` (y posiblemente `Dim_Tienda`, `Dim_Vendedor`)
- **`02_crear_hechos.sql`** — `Fact_Ventas`, `Fact_Inventario`, `Fact_Metas`
- **`03_etl_log.sql`** — Tabla de auditoría del proceso ETL

---

## 4. ETL

Siete scripts que cargan y validan el DW desde staging:

| Script | Acción |
|---|---|
| `01_cargar_dim_fecha.sql` | Popula la dimensión de tiempo |
| `02_cargar_dim_cliente.sql` | Carga y deduplica clientes |
| `03_cargar_dim_producto.sql` | Carga productos con categoría |
| `04_cargar_fact_ventas.sql` | Inserta hechos de ventas |
| `05_cargar_fact_inventario.sql` | Inserta hechos de inventario |
| `06_cargar_fact_metas.sql` | Carga metas (OLTP + fuente externa) |
| `07_validar_calidad_datos.sql` | Validaciones post-carga |

---

## 5. Fuentes Externas

Archivos CSV que complementan los datos del OLTP:

| Archivo | Contenido |
|---|---|
| `metas_mensuales_externo.csv` | ~1 200 registros de metas por tienda, categoría, mes y canal de venta (2023-2024) |
| `inventario_fisico_ajustes.csv` | Ajustes de inventario provenientes de conteos físicos (mermas, ajustes positivos) con responsable y motivo |

---

## 6. Dashboard Power BI

El archivo `dashboard_proyecto3.pbix` conecta al Data Warehouse y presenta métricas de:
- Ventas vs. metas por tienda, categoría y canal
- Evolución de inventario y alertas de stock
- Análisis de devoluciones
- Cumplimiento de metas comerciales por vendedor

---

## Tecnologías

| Herramienta | Uso |
|---|---|
| SQL Server | Motor de bases de datos (OLTP, Staging, DW) |
| T-SQL | Scripts DDL y DML |
| Power BI | Visualización y dashboard |
| CSV | Fuentes externas de datos |

---

## Orden de ejecución completo

```
1. 1_OLTP/01_crear_tablas_oltp.sql
2. 1_OLTP/02_insert_datos_base.sql
3. 1_OLTP/03_insert_ventas_detalle.sql
4. 1_OLTP/04_insert_inventario_diario.sql
5. 1_OLTP/05_insert_compras_detalle.sql
6. 1_OLTP/06_insert_devoluciones.sql
7. 1_OLTP/07_insert_metas_comerciales.sql
8. 2_Staging/01_crear_bi_staging.sql
9. 2_Staging/02_cargar_transformar_staging.sql
   (importar CSVs de 5_FuentesExternas/ al staging)
10. 3_DataWarehouse/01_crear_dimensiones.sql
11. 3_DataWarehouse/02_crear_hechos.sql
12. 3_DataWarehouse/03_etl_log.sql
13. 4_ETL/01_cargar_dim_fecha.sql
14. 4_ETL/02_cargar_dim_cliente.sql
15. 4_ETL/03_cargar_dim_producto.sql
16. 4_ETL/04_cargar_fact_ventas.sql
17. 4_ETL/05_cargar_fact_inventario.sql
18. 4_ETL/06_cargar_fact_metas.sql
19. 4_ETL/07_validar_calidad_datos.sql
20. Abrir 6_PowerBI/dashboard_proyecto3.pbix
```
