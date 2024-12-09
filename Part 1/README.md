# RevenueCat - KPIs and Data Visualization

## Overview
This repository contains three SQL queries working with RevenueCat's Scheduled Data Exports and a link to the dashboard created in Looker Studio.

**Dashboard link:** https://lookerstudio.google.com/u/2/reporting/7fe52832-4598-4ccd-8ba1-fb008f92df85/page/p_fwj64pennd

## Queries Description

### 1. Monthly Subscription Metrics Query
**Purpose**: This query processes monthly global metrics that help understand business health and its evolution over time.

#### Data Filtering
The query applies consistent filters to ensure data quality:
- `is_trial_period = FALSE`: Excludes trial periods
- `ownership_type != 'FAMILY_SHARED'`: Excludes shared family subscriptions
- `store != 'promotional'`: Excludes promotions and free codes
- `is_sandbox = FALSE`: Excludes test/development data
- `TIMESTAMP_DIFF(end_time, start_time, SECOND) > 0`: Validates subscription duration

#### Key Metrics

**1. Monthly Recurring Revenue (MRR)**
- Normalizes revenue based on product duration:
  - Weekly (P1W): price × 4
  - Monthly (P1M): price × 1
  - Yearly (P1Y): price × 0.08333 (1/12)

**2. Active Subscriptions**
- Counts active users at the end of each month
- Considers subscriptions where:
  - `effective_end_time > current_date`
  - `start_time <= current_date`

**3. Average Revenue Per User (ARPU)**
- Calculated as: `MRR / total_active_subscribers`
- Represents average monthly revenue per active user

**4. Churn Rate**
- Percentage of users canceling in the month
- Based on `unsubscribe_detected_at`
- Formula: `(churned_users / active_users) * 100`

#### Key Assumptions
- Subscriptions without `product_duration` are treated as monthly
- Analysis period is fixed between '2023-07-01' and '2024-02-28'
- Churn is considered when `unsubscribe_detected_at` exists
- MRR calculations assume consistent billing cycles
