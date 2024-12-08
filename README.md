# RevenueCat Metrics Analysis

## Overview
This repository contains the SQL query and documentation for analyzing key subscription metrics using RevenueCat data. The analysis follows RevenueCat's official methodology to calculate MRR, Active Subscriptions, ARPU, and Churn Rate.

## Query Structure
The query is organized into several Common Table Expressions (CTEs):

### 1. date_ranges
- Generates monthly date ranges for analysis
- Uses GENERATE_DATE_ARRAY to ensure consistent date coverage
- Covers the period from July 2023 to February 2024

### 2. mrr_calc
Calculates Monthly Recurring Revenue following RevenueCat's methodology:
- Weekly subscriptions (P1W): price × 4
- Monthly subscriptions (P1M): price × 1
- Annual subscriptions (P1Y): price × 0.08333 (≈ 1/12)
- Calculated at the end of each month

### 3. active_subscriptions
Implements RevenueCat's official active subscriptions calculation:
- Counts unique paid subscriptions that haven't expired at the end of each period
- Uses exact date matching logic from RevenueCat's documentation
- Ensures consistency with RevenueCat's dashboard metrics

### 4. churned_users
Tracks subscription cancellations:
- Based on unsubscribe_detected_at timestamp
- Counts unique users who cancelled in each month

## Key Metrics

### 1. MRR (Monthly Recurring Revenue)
- Normalized monthly recurring revenue
- Excludes trials, family sharing, promotions, and sandbox data
- Normalized based on subscription duration
- Calculated at month end

### 2. Active Subscriptions
- Follows RevenueCat's official definition
- Counts subscriptions where:
  - start_time <= current_date
  - effective_end_time > current_date
- Point-in-time metric at the end of each month
- Excludes trials, family sharing, and promotional subscriptions

### 3. ARPU (Average Revenue Per User)
- Calculated as MRR / total_active_subscribers
- Uses the same subscriber count as Active Subscriptions metric
- Provides insight into revenue per active subscriber

### 4. Churn Rate
- Percentage of users who cancelled in a given month
- Calculated as (churned_users / total_active_subscribers) * 100
- Based on active subscribers count from RevenueCat's methodology

## Important Considerations

### Data Quality Filters
All metrics consistently apply these filters:
- Exclude trial periods (is_trial_period = FALSE)
- Exclude family shared subscriptions
- Exclude promotional transactions
- Exclude sandbox data
- Require positive duration (TIMESTAMP_DIFF(end_time, start_time, SECOND) > 0)

### Assumptions
1. Product Durations
   - Supports three types: P1W, P1M, and P1Y
   - Other durations default to monthly pricing

2. Active Status
   - Follows RevenueCat's definition of active subscriptions
   - Includes grace periods
   - Counts cancelled but not expired subscriptions

### Limitations
1. Churn Calculation
   - Based on unsubscribe_detected_at
   - Doesn't distinguish between voluntary and involuntary churn

2. Grace Periods
   - Included in active subscriptions as per RevenueCat's methodology
   - May affect timing of churn metrics

## Dashboard Visualization Recommendations

### 1. MRR
- Line chart showing monthly trend
- Include month-over-month growth percentage
- Annotate significant changes

### 2. Active Subscriptions
- Line chart showing end-of-month numbers
- Match exactly with RevenueCat's dashboard numbers
- Include growth rate indicators

### 3. ARPU
- Line chart with MRR correlation
- Highlight trends and anomalies
- Consider segmentation by product duration

### 4. Churn Rate
- Bar chart with threshold indicators
- Include industry benchmarks
- Flag significant deviations

## Data Source
- Table: `burnished-flare-384310.labhouse.revenuecat_data`
- Based on RevenueCat's subscription data export
- Period: July 2023 - February 2024

## References
- [RevenueCat Active Subscriptions Documentation](https://www.revenuecat.com/docs/dashboard-and-metrics/charts/active-subscriptions-chart)
- [RevenueCat MRR Calculation Guide](https://www.revenuecat.com/docs/integrations/scheduled-data-exports)
