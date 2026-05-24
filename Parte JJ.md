# Documentación Técnica – Desarrollo Parte Juan José

## Proyecto Final Business Intelligence

### 1. Introducción

Este documento describe el desarrollo e implementación de la parte correspondiente a Juan José dentro del proyecto de Business Intelligence. El objetivo principal de esta fase fue diseñar y construir la arquitectura analítica encargada de transformar datos operacionales provenientes del sistema OLTP en un modelo dimensional optimizado para análisis y visualización en herramientas de inteligencia de negocio.

La implementación incluyó la construcción de las capas de Staging, Data Warehouse y ETL, además de procesos de validación y control de calidad de datos.

---

# 2. Alcance del desarrollo

La responsabilidad asignada comprendió los siguientes componentes:

* Construcción de la capa Staging.
* Diseño e implementación del Data Warehouse.
* Creación de dimensiones analíticas.
* Construcción de tablas de hechos.
* Desarrollo de procesos ETL.
* Implementación de claves sustitutas (Surrogate Keys).
* Procesos de validación y control de calidad.
* Preparación de estructuras para integración con Power BI.

No se incluyeron componentes correspondientes a visualización ni dashboard final.

---

# 3. Arquitectura implementada

El flujo general implementado fue:

```text
Fuentes OLTP
       │
       ▼
Staging Layer
       │
       ▼
Transformación ETL
       │
       ▼
Data Warehouse
       │
       ▼
Power BI
```

El modelo implementado sigue una arquitectura de tipo dimensional basada en tablas de hechos y dimensiones.

---

# 4. Capa OLTP

La capa operacional fue utilizada como origen de datos y contenía información relacionada con:

* Clientes
* Productos
* Categorías
* Ventas
* DetalleVentas
* Compras
* DetalleCompras
* InventarioDiario
* MetasComerciales
* Devoluciones
* Vendedores
* Tiendas
* Proveedores

Durante la implementación se realizaron ajustes sobre algunos procesos de generación de datos para garantizar integridad y rendimiento.

## 4.1 Optimización de InventarioDiario

Inicialmente el proceso utilizaba estructuras iterativas mediante ciclos anidados (`WHILE`) para generar aproximadamente:

```text
365 × 200 × 10 = 730000 registros
```

Este enfoque generaba tiempos de ejecución elevados.

Se reemplazó por una estrategia basada en operaciones de conjuntos utilizando:

* Common Table Expressions (CTE)
* CROSS JOIN
* CROSS APPLY

Beneficios obtenidos:

* Reducción significativa de tiempos de ejecución.
* Mejor escalabilidad.
* Menor consumo de recursos.

---

## 4.2 Corrección proceso Compras y DetalleCompras

Se identificaron conflictos de claves foráneas causados por la generación aleatoria de identificadores inexistentes.

Se implementó una estrategia de selección únicamente sobre identificadores válidos:

* Proveedores existentes
* Productos existentes
* Tiendas existentes

Resultados:

```text
Compras: 2000 registros
DetalleCompras: 6036 registros
```

---

# 5. Capa Staging

La capa Staging fue implementada como zona intermedia para limpieza, estandarización y preparación de datos antes de ser cargados al Data Warehouse.

Tablas implementadas:

* STG_Clientes
* STG_Productos
* STG_Ventas
* STG_Inventario
* STG_Compras
* STG_Devoluciones
* STG_Metas

---

## 5.1 Procesos de transformación realizados

### Clientes

Transformaciones aplicadas:

* Eliminación de espacios innecesarios.
* Estandarización de nombres de ciudades.
* Conversión de correos a minúsculas.
* Validación de correos electrónicos.
* Detección de valores nulos.

---

### Productos

Transformaciones aplicadas:

* Validación de precios.
* Validación de categorías.
* Verificación de relaciones costo–venta.
* Estandarización de nombres.

---

### Ventas e Inventario

Se agregaron atributos derivados:

* Año
* Mes
* Día

---

# 6. Diseño del Data Warehouse

Se implementó un modelo dimensional compuesto por dimensiones y hechos.

---

## 6.1 Dimensiones implementadas

### DimFecha

Contiene:

* FechaKey
* Fecha
* Día
* Mes
* NombreMes
* Trimestre
* Año

Registros:

```text
365
```

---

### DimCliente

Contiene información relacionada con:

* Cliente
* Ciudad
* Departamento

Registros:

```text
1000
```

---

### DimProducto

Contiene:

* Producto
* Categoría
* PrecioCompra
* PrecioVenta

Registros:

```text
200
```

---

### DimTienda

Registros:

```text
10
```

---

### DimVendedor

Incluye:

* Vendedores reales
* Registro adicional "Sin asignar"

Registros:

```text
21
```

---

### DimProveedor

Registros:

```text
10
```

---

### DimCanalVenta

Canales implementados:

* App
* Online
* Presencial
* Teléfono

Registros:

```text
4
```

---

### DimCategoria

Registros:

```text
10
```

---

# 7. Tablas de hechos implementadas

---

## FactVentas

Granularidad:

```text
1 fila = una línea de venta por producto
```

Registros:

```text
125366
```

Métricas:

* Cantidad
* PrecioUnitario
* SubTotal
* TotalVenta

---

## FactInventarioDiario

Granularidad:

```text
Inventario diario por producto y tienda
```

Registros:

```text
730000
```

Métricas:

* StockInicial
* Entradas
* Salidas
* StockFinal

---

## FactMetasComerciales

Granularidad:

```text
Meta por fecha, tienda, categoría, canal y vendedor
```

Registros:

```text
1440
```

Métricas:

* ValorMeta

---

## FactCompras

Registros:

```text
2000
```

---

## FactDevoluciones

Registros:

```text
1500
```

---

## FactRentabilidad

Registros:

```text
125366
```

Métricas:

* Ingresos
* Costos
* Utilidad

---

# 8. Implementación ETL

Los procesos ETL implementados realizaron:

1. Extracción desde OLTP.
2. Transformación y limpieza en Staging.
3. Resolución de claves sustitutas.
4. Carga al Data Warehouse.
5. Validación de consistencia.

Los procesos desarrollados fueron:

```text
01_cargar_dim_fecha.sql
02_cargar_dim_cliente.sql
03_cargar_dim_producto.sql
04_cargar_dimensiones_restantes.sql
05_cargar_fact_ventas.sql
06_cargar_fact_inventario.sql
07_cargar_fact_metas.sql
08_cargar_fact_compras.sql
09_cargar_fact_devoluciones.sql
10_cargar_fact_rentabilidad.sql
11_validar_calidad_datos.sql
```

---

# 9. Validación y control de calidad

Se implementó un proceso automático de validación que permitió:

* Verificación de conteos.
* Validación de valores nulos.
* Validación de dimensiones.
* Validación de tablas de hechos.
* Verificación de métricas de rentabilidad.

Resultados finales:

### Dimensiones

```text
DimFecha           365
DimCliente         1000
DimProducto        200
DimTienda          10
DimVendedor        21
DimProveedor       10
DimCanalVenta      4
DimCategoria       10
```

### Hechos

```text
FactVentas               125366
FactInventarioDiario     730000
FactMetasComerciales     1440
FactCompras              2000
FactDevoluciones         1500
FactRentabilidad         125366
```

---

# 10. Conclusiones

La implementación permitió construir una arquitectura de Business Intelligence funcional y escalable, asegurando integridad referencial y disponibilidad de datos para procesos analíticos posteriores.

El modelo dimensional implementado proporciona una estructura adecuada para soportar análisis de ventas, inventario, rentabilidad y cumplimiento de metas comerciales mediante herramientas de visualización como Power BI.

La solución desarrollada garantiza consistencia de datos, rendimiento adecuado y capacidad de crecimiento para futuras necesidades analíticas.
