from google.cloud import storage
import os
import logging

# Configurar logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def reorganize_storage_structure(event, context):
    """
    Cloud Function para reorganizar la estructura de archivos en Cloud Storage.
    
    Args:
        event (dict): Metadata del evento de Cloud Storage
        context (google.cloud.functions.Context): Metadata de la ejecución
    """
    try:
        # Obtener detalles del archivo
        bucket_name = event['bucket']
        file_path = event['name']
        
        # Validar estructura del path
        path_parts = file_path.split('/')
        if len(path_parts) != 4:
            logger.error(f"Formato de ruta no válido: {file_path}")
            return
        
        date, batch, table, filename = path_parts
        
        # Crear nueva ruta
        new_path = f"{date}/{table}/{batch}/{filename}"
        
        # Inicializar cliente
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)
        
        # Obtener blob original
        blob = bucket.blob(file_path)
        
        # Copiar a nueva ubicación
        new_blob = bucket.copy_blob(
            blob, bucket,
            new_path
        )
        
        # Eliminar original
        blob.delete()
        
        logger.info(f"Archivo reorganizado exitosamente: {file_path} -> {new_path}")
        
    except Exception as e:
        logger.error(f"Error procesando archivo {file_path}: {str(e)}")
        raise
