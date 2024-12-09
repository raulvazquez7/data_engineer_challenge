# Storage Path Restructuring Function

## Overview
This Cloud Function automatically reorganizes the file structure of data files uploaded to Google Cloud Storage. It's specifically designed to transform AppsFlyer's data organization pattern from `date/batch/table/data` to `date/table/batch/data` for optimal database ingestion.

## Features
- Automatically triggered when files are uploaded to GCS
- Transforms path structure while maintaining file integrity
- Handles both cost data and attribution data
- Maintains original file metadata
- Includes error handling and logging

## Requirements
- Google Cloud Platform account
- Python 3.9
- Google Cloud Storage bucket
- Appropriate IAM permissions

## Setup
1. Create a new Google Cloud Function
2. Set the runtime to Python 3.9
3. Set the trigger to Cloud Storage
4. Configure the trigger for object finalization events
5. Deploy the function with the provided code

## Configuration
```
bash
gcloud functions deploy reorganize_storage_structure \
--runtime python39 \
--trigger-event google.storage.object.finalize \
--trigger-resource YOUR_BUCKET_NAME \
--source src \
--region YOUR_REGION
```

## Usage
The function works automatically once deployed. When files are uploaded to the specified bucket following the pattern `date/batch/table/data`, they will be automatically reorganized to `date/table/batch/data`.

### Example
Original path:
`2024-01-01/12345/sales/sales_data.csv`

Transformed path:
`2024-01-01/sales/12345/sales_data.csv`

## Monitoring
- Monitor function execution in Google Cloud Console
- Check function logs for execution details and any potential errors
- Verify file structure changes in Cloud Storage

