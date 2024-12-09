# Storage Path Restructuring Function

This repository contains solutions for optimizing AppsFlyer's data processing pipeline, including storage restructuring and data deduplication.

## Repository Structure
```
.
├── Part 2/
│   ├── sql/
│   │   └── latest_batch_costs.sql    # SQL query for data deduplication
│   ├── src/
│   │   ├── main.py                   # Cloud Function implementation
│   │   └── requirements.txt          # Python dependencies
│   └── README.md                     # Project documentation
```

## Part 1: Storage Path Restructuring

### 1.1 Cloud Function Solution
A Cloud Function that automatically reorganizes the file structure of data files uploaded to Google Cloud Storage, transforming AppsFlyer's data organization pattern from `date/batch/table/data` to `date/table/batch/data`.

## Features
- Automatically triggered when files are uploaded to GCS
- Transforms path structure while maintaining file integrity
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

***

## Part 2: Data Deduplication

### 2.1 Query Solution
AppsFlyer sends four daily data batches with increasingly updated information. To prevent data duplication, we implemented a SQL query that selects only the most recent batch for each date.

[See query here!](https://github.com/raulvazquez7/data_engineer_challenge/blob/main/Part%202/sql/latest_batch_costs.sql)

#### Features
- Uses Window Functions (ROW_NUMBER) to identify the latest batch
- Groups data by date and app_id
- Aggregates cost and install metrics
- Orders results by date in descending order

#### Query Implementation
```sql
WITH latest_batch AS (
    SELECT 
        date,
        app_id,
        cost,
        original_cost,
        installs,
        ROW_NUMBER() OVER (PARTITION BY date, app_id ORDER BY batch DESC) as rn
    FROM appsflyer_cost.ext_channel
)
SELECT 
    date,
    app_id,
    CAST(SUM(cost) AS int) AS cost_cost,
    CAST(SUM(original_cost) AS int) AS cost_original_cost,
    SUM(installs) AS cost_installs
FROM latest_batch
WHERE rn = 1
GROUP BY 
    date,
    app_id
ORDER BY 
    date DESC;
```
