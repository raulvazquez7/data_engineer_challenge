# RevenueCat - KPIs and Data Visualization

## Overview
This repository contains three SQL queries working with RevenueCat's Scheduled Data Exports and a link to the dashboard created in Looker Studio.

**Dashboard link:** https://lookerstudio.google.com/u/2/reporting/7fe52832-4598-4ccd-8ba1-fb008f92df85/page/p_fwj64pennd

## Queries Description

### 1. Monthly Subscription Metrics Query
**Purpose**: This query processes monthly global metrics that help understand business health and its evolution over time.

[See query here!](https://github.com/raulvazquez7/data_engineer_challenge/blob/main/Part%201/queries/labhouse_monthly_output.sql)
[See csv output here!](https://github.com/raulvazquez7/data_engineer_challenge/blob/main/Part%201/data/monthly_output.csv)

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

#### Data Granularity
- All metrics are calculated on a monthly basis

***

### 2. Daily Segmented Metrics Query
**Purpose**: This query provides granular daily metrics with multiple dimensions for detailed analysis and segmentation.

[See query here!](https://github.com/raulvazquez7/data_engineer_challenge/blob/main/Part%201/queries/labhouse_segmented_output.sql)
[See csv output here!](https://github.com/raulvazquez7/data_engineer_challenge/blob/main/Part%201/data/segmented_output.csv)

#### Data Filtering
The query applies consistent filters to ensure data quality:
- `is_trial_period = FALSE`: Excludes trial periods (except for trial-specific metrics)
- `ownership_type != 'FAMILY_SHARED'`: Excludes shared family subscriptions
- `store != 'promotional'`: Excludes promotions and free codes
- `is_sandbox = FALSE`: Excludes test/development data
- `TIMESTAMP_DIFF(end_time, start_time, SECOND) > 0`: Validates subscription duration

#### Key Metrics

**1. Proceeds (Revenue)**
- Calculated following RevenueCat's methodology
- Formula: `price_in_usd * (1 - tax_percentage - commission_percentage)`
- Represents net revenue after taxes and platform fees

**2. Transaction Metrics**
- Total transactions count
- New revenue (first-time purchases excluding trials)
- Renewal revenue (from subsequent purchases)

**3. Trial Metrics**
- Trials started: New trial subscriptions initiated
- Trials converted: Successfully converted trial subscriptions
- Average trial duration in days
- Conversion tracked through `is_trial_conversion`

**4. Segmentation Dimensions**
- Country
- Product identifier
- Store (App Store, Google Play)
- Platform (iOS, Android)
- Product duration (subscription length)

#### Key Assumptions
- Revenue is calculated net of taxes and platform fees
- Trial conversions are tracked through the `is_trial_conversion` flag
- First-time purchases are identified by `renewal_number = 1`
- All metrics are aggregated at a daily level
- Trial metrics include both converted and non-converted trials

#### Data Granularity
- All metrics are calculated on a daily basis
- Allows for flexible period-over-period analysis
- Enables detailed trend analysis by segment

***

### 3. Cohort LTV Analysis Query
**Purpose**: This query analyzes customer Lifetime Value (LTV) by cohorts based on first purchase date, providing insights into long-term customer value and retention patterns.

[See query here!](https://github.com/raulvazquez7/data_engineer_challenge/blob/main/Part%201/queries/labhouse_ltv_output.sql)
[See csv output here!](https://github.com/raulvazquez7/data_engineer_challenge/blob/main/Part%201/data/ltv_output.csv)

#### Data Filtering
The query applies consistent filters to ensure data quality:
- `is_trial_period = FALSE`: Excludes trial periods
- `ownership_type != 'FAMILY_SHARED'`: Excludes shared family subscriptions
- `store != 'promotional'`: Excludes promotions and free codes
- `is_sandbox = FALSE`: Excludes test/development data
- `TIMESTAMP_DIFF(end_time, start_time, SECOND) > 0`: Validates subscription duration
- `price_in_usd > 0`: Ensures only paid transactions
- `refunded_at IS NULL`: Excludes refunded transactions

#### Key Metrics

**1. Cohort Size**
- Number of unique users who made their first purchase on each date
- Represents the initial size of each customer cohort

**2. Average LTV by Time Periods**
- Calculated for multiple time windows:
  - Short term: 7 days, 14 days, 21 days
  - Medium term: 1 month, 3 months, 6 months
  - Long term: 12 months, 18 months, 24 months
- Each period includes cumulative revenue from first purchase

**3. Net Revenue Calculation**
- Formula: `price_in_usd * (1 - tax_percentage - commission_percentage)`
- Accounts for platform fees and taxes
- Provides actual realized revenue per customer

#### Key Assumptions
- Cohort date is determined by first non-trial purchase
- LTV is calculated on net revenue (after fees and taxes)
- Revenue is cumulative within each time period
- Each user belongs to exactly one cohort

#### Data Granularity
- Cohorts are created at daily level
- LTV is tracked across multiple time periods
- Enables both short-term and long-term value analysis
