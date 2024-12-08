# AppsFlyer Data Structure Reorganizer

Este proyecto contiene una Cloud Function de Google Cloud Platform que reorganiza automáticamente la estructura de archivos de datos de AppsFlyer en Cloud Storage.

## Problema
AppsFlyer proporciona datos en una estructura: `date/batch/table/data`
Necesitamos transformarla a: `date/table/batch/data`

## Solución
La solución implementa una Cloud Function que:
1. Se activa cuando se sube un nuevo archivo al bucket de origen
2. Analiza la ruta del archivo
3. Reorganiza la estructura manteniendo los mismos datos
4. Elimina el archivo original

## Requisitos Previos
- Cuenta de Google Cloud Platform
- Google Cloud SDK instalado
- Python 3.9+
- Permisos necesarios en GCP:
  - `roles/storage.admin`
  - `roles/cloudfunctions.developer`

## Instalación y Configuración

1. Clonar el repositorio:

```
bash
git clone https://github.com/tu-usuario/appsflyer-reorganizer.git
cd appsflyer-reorganizer
```

2. Crear y activar entorno virtual:

```
bash
python -m venv venv
source venv/bin/activate # En Windows: venv\Scripts\activate
pip install -r src/requirements.txt
```

