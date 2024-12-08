# SQL Queries Documentation

Este directorio contiene las queries SQL utilizadas en el proyecto de reorganización de datos de AppsFlyer.

## Queries

### latest_batch_costs.sql
Query para obtener los datos de costos del lote más reciente para cada fecha, eliminando datos duplicados.

#### Descripción
- Utiliza una CTE (Common Table Expression) para identificar el lote más reciente
- Agrupa los datos por fecha y app_id
- Calcula costos totales y número de instalaciones
- Elimina duplicados manteniendo solo el lote más reciente

#### Columnas de salida
- `date`: Fecha del registro
- `app_id`: ID de la aplicación
- `cost_cost`: Costo total (convertido a entero)
- `cost_original_cost`: Costo original total (convertido a entero)
- `cost_installs`: Número total de instalaciones

#### Uso
```
sql
-- Ejecutar la query directamente
\i latest_batch_costs.sql
```

