import os
from google.cloud import storage

def reorganize_storage_structure(event, context):
    """
    This function is triggered when an object is created/finalized in the bucket.
    event: Dictionary with event data.
    context: Event context (id, timestamp, etc.)
    """

    # Name of the uploaded file
    object_name = event['name']
    bucket_name = event['bucket']

    # Original path is assumed: date/batch/table/data
    # We need to restructure to: date/table/batch/data
    # Example:
    # Original: 2024-01-01/12345/sales/sales_data.csv
    # Desired: 2024-01-01/sales/12345/sales_data.csv

    # Split by "/"
    parts = object_name.split('/')

    # Ensure original path has exactly 4 parts: date, batch, table, data
    if len(parts) < 4:
        print(f"Object path does not match expected pattern: {object_name}")
        return
    
    date_str, batch_str, table_str = parts[0], parts[1], parts[2]
    # The rest of parts from parts[3:] is the original filename (could be a deeper path)
    data_filename = "/".join(parts[3:])

    # New path: date/table/batch/filename
    new_object_name = f"{date_str}/{table_str}/{batch_str}/{data_filename}"

    # Initialize storage client
    client = storage.Client()
    bucket = client.bucket(bucket_name)
    
    # Get original blob
    original_blob = bucket.blob(object_name)

    # Copy blob to new location
    new_blob = bucket.copy_blob(
        original_blob,
        bucket,
        new_object_name
    )

    # Delete original blob
    original_blob.delete()

    print(f"File {object_name} restructured to {new_object_name}")


# Entry point for GCF
# (Optional, depending on configuration, sometimes directly points to the function.)
if __name__ == "__main__":
    # This is just an example test local. 
    # It will not be called like this in the Cloud Function.
    event_test = {
        "bucket": "labhouse_origin",
        "name": "2024-01-01/12345/sales/sales_data.csv"
    }
    reorganize_storage_structure(event_test, None)
