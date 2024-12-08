# AppsFlyer Data Structure Reorganizer

Este proyecto proporciona soluciones para la gestión y transformación de datos de AppsFlyer en Google Cloud Platform.

## Problemas y Soluciones

### 1. Reorganización de Estructura de Archivos

**Problema:**
AppsFlyer proporciona datos en una estructura: `date/batch/table/data`
Necesitamos transformarla a: `date/table/batch/data`

**Solución:**
Implementación de una Cloud Function que:
1. Se activa cuando se sube un nuevo archivo al bucket de origen
2. Analiza la ruta del archivo
3. Reorganiza la estructura manteniendo los mismos datos
4. Elimina el archivo original

### 2. Gestión de Datos Duplicados

**Problema:**
Los datos de costos pueden contener múltiples lotes por fecha, generando duplicados.

**Solución:**
Query SQL optimizada que:
1. Identifica el lote más reciente para cada fecha
2. Elimina datos duplicados
3. Calcula agregaciones precisas de costos e instalaciones

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


