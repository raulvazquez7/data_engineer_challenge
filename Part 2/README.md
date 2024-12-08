# AppsFlyer Data Structure Reorganizer

Este proyecto proporciona dos soluciones independientes para la gestión y transformación de datos de AppsFlyer en Google Cloud Platform:
1. Una Cloud Function para reorganizar la estructura de archivos
2. Una Query SQL para gestionar datos duplicados en lotes

## Problemas y Soluciones

### Componente 1: Query SQL para Gestión de Lotes

**Problema:**
- Los datos de costos tienen múltiples lotes por fecha
- Esto genera duplicados en los análisis
- Se necesita considerar solo el lote más reciente

**Solución:**
Query SQL optimizada que:
- Identifica automáticamente el lote más reciente por fecha
- Elimina datos duplicados de lotes anteriores
- Calcula agregaciones precisas de:
  - Costos totales
  - Costos originales
  - Número de instalaciones

**Tecnologías:**
- SQL (BigQuery compatible)
- Common Table Expressions (CTE)
- Window Functions

### Componente 2: Cloud Function para Reorganización de Archivos

**Problema:**
- AppsFlyer almacena datos en GCS con estructura: `date/batch/table/data`
- Esta estructura no es óptima para la ingesta en base de datos
- Se necesita transformar a: `date/table/batch/data`

**Solución:**
Cloud Function en Python que:
- Se activa automáticamente cuando llega un nuevo archivo
- Analiza la ruta del archivo entrante
- Crea nueva estructura manteniendo los mismos datos
- Elimina el archivo original
- Zero-maintenance: solo se ejecuta cuando es necesario

**Tecnologías:**
- Google Cloud Functions
- Python 3.9+
- Google Cloud Storage API

## Estructura del Proyecto
```
.
├── src/           # Código fuente de la Cloud Function
├── sql/           # Queries SQL y documentación
├── tests/         # Tests unitarios
├── Makefile       # Comandos útiles para desarrollo
└── .gitignore     # Archivos a ignorar por git
```

## Requisitos Previos
- Cuenta de Google Cloud Platform
- Google Cloud SDK instalado
- Python 3.9+
- Permisos necesarios en GCP:
  - `roles/storage.admin`
  - `roles/cloudfunctions.developer`

## Instalación y Configuración

1. Clonar el repositorio:
```bash
git clone https://github.com/tu-usuario/appsflyer-reorganizer.git
cd appsflyer-reorganizer
```

2. Crear y activar entorno virtual:
```bash
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
pip install -r src/requirements.txt
```

3. Configurar Google Cloud:
```bash
gcloud auth login
gcloud config set project TU_PROYECTO_ID
```

## Componentes Principales

### 1. Cloud Function
Despliega la función para reorganizar archivos:
```bash
gcloud functions deploy reorganize_storage_structure \
    --runtime python39 \
    --trigger-event google.storage.object.finalize \
    --trigger-resource TU_BUCKET_ORIGEN \
    --source src \
    --region REGION
```

### 2. Queries SQL
Consulta las queries y su documentación en:
- `/sql/latest_batch_costs.sql`: Query principal para análisis de costos
- `/sql/README.md`: Documentación detallada de las queries

## Pruebas

### Cloud Function
1. Crear bucket de prueba:
```bash
gsutil mb gs://tu-bucket-prueba
```

2. Subir archivo de prueba:
```bash
gsutil cp test.csv gs://tu-bucket-prueba/2024-03-20/batch1/users/test.csv
```

3. Verificar reorganización:
```bash
gsutil ls gs://tu-bucket-prueba/2024-03-20/users/batch1/
```

### SQL Queries
Las queries pueden ejecutarse en tu cliente SQL preferido. Ver `/sql/README.md` para instrucciones detalladas.

## Desarrollo

1. Instalar dependencias de desarrollo:
```bash
pip install -r src/requirements-dev.txt
```

2. Ejecutar tests:
```bash
make test
```

## Monitoreo
- Cloud Functions Dashboard
- Cloud Logging
- Cloud Monitoring

## Contribuir
1. Fork el repositorio
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Crea un Pull Request

## Licencia
MIT


