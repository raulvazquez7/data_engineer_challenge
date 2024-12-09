# Historical Data Retention in BigQuery

## Objective

The goal is to maintain a complete historical dataset in BigQuery, independent of AppsFlyer's 60-day data retention window. Currently, the system mirrors AppsFlyer's data daily, but only retains a 60-day history. We aim to create a growing historical dataset that remains unaffected when AppsFlyer purges data.

## Current Setup

- **Source of Truth**: AppsFlyer provides daily data.
- **Current Pipeline**: Data is uploaded to Google Cloud Storage (GCS) and then to BigQuery daily. After 60 days, AppsFlyer no longer retains this data, but we want to keep it in BigQuery.

## Conceptual Design

### Datasets in BigQuery

1. **Transactional/Staging Dataset**: Stores fresh data from the last 60 days, reflecting the current state from AppsFlyer.
2. **Historical Dataset**: Consolidates all historical data without deletion.

### Proposed Pipeline

1. **Daily Data Load**: Load daily data from AppsFlyer into a "transactional" dataset in BigQuery.
2. **Data Consolidation**: A daily process (e.g., Cloud Composer task, Cloud Function via Cloud Scheduler, or internal cron job) merges new data from the transactional dataset into the historical dataset.
3. **Data Retention**: The historical dataset retains data indefinitely, or deletes it based on different criteria.

### Partitioning and Storage Strategy

- **Date Partitioning**: Use date partitions in BigQuery for efficient data management.
- **Table Design**: Consider partitioned tables by date (e.g., `historical_data_YYYYMMDD`) or a single table partitioned by a date column.

### Consolidation Mechanism

- **MERGE Operation**: Use BigQuery's MERGE to combine new data with existing data, ensuring no duplicates.
- **Daily Job Execution**: After loading data, execute a consolidation job to copy fresh data to the historical dataset.

### Cost and Maintenance

- **Storage Costs**: The historical dataset will grow indefinitely, so consider BigQuery storage costs.
- **Archiving Strategy**: Archive very old data to cheaper storage (e.g., GCS in parquet/ORC format) if BigQuery costs become high, keeping only recent data "hot" in BigQuery.


## Summary

The proposed solution involves a pipeline that daily copies new data to a "historical dataset" in BigQuery that is not purged, allowing for indefinite retention. This dataset is designed with partitioning and merge/upsert strategies to ensure quality and efficiency, complemented by cost, maintenance, and security considerations.
