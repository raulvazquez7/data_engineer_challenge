# RevenueCat Metrics Analysis

## Overview
This repository contains the SQL query and documentation for analyzing key subscription metrics using RevenueCat data. The analysis focuses on four main metrics: MRR (Monthly Recurring Revenue), Active Subscriptions, ARPU (Average Revenue Per User), and Churn Rate.

## Query Structure
The query is organized into several Common Table Expressions (CTEs) for clarity and maintainability:

### 1. date_ranges
- Generates monthly date ranges for analysis
- Creates start and end dates for each month in the dataset

### 2. mrr_calc
Calculates Monthly Recurring Revenue following RevenueCat's methodology:
- Weekly subscriptions (P1W): price × 4
- Monthly subscriptions (P1M): price × 1
- Annual subscriptions (P1Y): price × 0.08333 (≈ 1/12)

### 3. active_subscriptions
Calculates active subscriptions at the end of each month, following RevenueCat's official definition:
- Counts unique paid subscriptions that haven't expired
- Represents a snapshot at the end of each period
- Excludes trials, family sharing, and promotional subscriptions

### 4. churned_users
Tracks subscription cancellations:
- Based on unsubscribe_detected_at timestamp
- Counts unique users who cancelled in each month

## Key Metrics

### 1. MRR (Monthly Recurring Revenue)
- Normalized monthly recurring revenue
- Excludes trials, family sharing, promotions, and sandbox data
- Normalized based on subscription duration

### 2. Active Subscriptions
- Number of active subscriptions at the end of each month
- Follows RevenueCat's official definition
- Important: This is a point-in-time metric, not cumulative

### 3. ARPU (Average Revenue Per User)
- Calculated as MRR / monthly_active_subscribers
- Indicates average revenue generated per active user
- Useful for monitoring monetization efficiency

### 4. Churn Rate
- Percentage of users who cancelled in a given month
- Calculated as (churned_users / monthly_active_subscribers) * 100
- Key indicator for user retention

## Important Considerations

### Data Quality Filters
The query excludes:
- Trial periods (is_trial_period = FALSE)
- Family shared subscriptions
- Promotional transactions
- Sandbox data

### Assumptions
1. Product Durations
   - Supports P1W, P1M, and P1Y
   - Other durations default to monthly

2. Active Status
   - A subscription is considered active until its effective end date
   - Includes grace periods
   - Cancelled but not expired subscriptions count as active

### Limitations
1. Churn Calculation
   - Based on unsubscribe_detected_at
   - Doesn't distinguish between voluntary and involuntary churn

2. Grace Periods
   - Included in active subscriptions
   - May affect churn timing

## Dashboard Visualization Recommendations

### 1. MRR
- Line chart showing monthly trend
- Include month-over-month growth percentage

### 2. Active Subscriptions
- Line chart showing end-of-month numbers
- Add annotations for significant changes

### 3. ARPU
- Line chart with MRR correlation
- Include industry benchmarks if available

### 4. Churn Rate
- Bar chart with threshold indicators
- Include monthly trend line

## Data Source
- Table: `burnished-flare-384310.labhouse.revenuecat_data`
- Based on RevenueCat's subscription data export

## References
- [RevenueCat Active Subscriptions Documentation](https://www.revenuecat.com/docs/dashboard-and-metrics/charts/active-subscriptions-chart)
- [RevenueCat MRR Calculation Guide](https://www.revenuecat.com/docs/integrations/scheduled-data-exports)
