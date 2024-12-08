import unittest
from unittest.mock import Mock, patch
from src.main import reorganize_storage_structure

class TestReorganizeStorageStructure(unittest.TestCase):
    
    @patch('google.cloud.storage.Client')
    def test_valid_file_structure(self, mock_storage_client):
        # Preparar el mock
        event = {
            'bucket': 'test-bucket',
            'name': '2024-03-20/batch1/users/data.csv'
        }
        context = Mock()
        
        # Configurar mocks necesarios
        mock_bucket = Mock()
        mock_blob = Mock()
        mock_storage_client.return_value.bucket.return_value = mock_bucket
        mock_bucket.blob.return_value = mock_blob
        
        # Ejecutar función
        reorganize_storage_structure(event, context)
        
        # Verificar que se llamó a copy_blob con la nueva estructura
        mock_bucket.copy_blob.assert_called_once()
        mock_blob.delete.assert_called_once()

    @patch('google.cloud.storage.Client')
    def test_invalid_file_structure(self, mock_storage_client):
        event = {
            'bucket': 'test-bucket',
            'name': 'invalid/path'
        }
        context = Mock()
        
        # Ejecutar función
        reorganize_storage_structure(event, context)
        
        # Verificar que no se realizó ninguna operación
        mock_storage_client.return_value.bucket.return_value.copy_blob.assert_not_called()

if __name__ == '__main__':
    unittest.main()
