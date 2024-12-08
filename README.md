# RevenueCat Analytics Queries

## Overview
This repository contains two complementary SQL queries for analyzing RevenueCat subscription data at different granularities and purposes. Both queries follow RevenueCat's official methodology and best practices.

## Queries Description

### 1. Monthly Subscription Metrics Query
**Purpose**: Provides high-level monthly KPIs for business performance monitoring and strategic decision-making.

**Key Metrics**:
- Monthly Recurring Revenue (MRR)
- Active Subscriptions
- Average Revenue Per User (ARPU)
- Churn Rate

**Use Cases**:
- Board reporting
- Strategic planning
- Investor updates
- Long-term trend analysis

### 2. Daily Segmented Metrics Query
**Purpose**: Offers detailed daily metrics with multiple dimensions for operational analysis and segmentation.

**Key Metrics**:
- Daily Proceeds
- Transaction Count
- New vs Renewal Revenue
- Trial Starts and Conversions

**Dimensions**:
- Country
- Product Identifier
- Store
- Platform
- Product Duration

**Use Cases**:
- Marketing campaign analysis
- Product performance monitoring
- Geographic analysis
- Platform comparison

## Key Differences

### 1. Time Granularity
- **Monthly Query**: End-of-month snapshots
- **Daily Query**: Daily aggregations

### 2. Metric Focus
- **Monthly Query**: 
  - Focuses on subscription health metrics
  - Emphasizes recurring revenue patterns
  - Tracks user retention through churn
- **Daily Query**:
  - Focuses on transactional metrics
  - Emphasizes revenue segmentation
  - Tracks trial performance

### 3. Data Structure
- **Monthly Query**:
  - Uses point-in-time calculations
  - Implements RevenueCat's active subscription logic
  - Calculates derived metrics (ARPU, churn)
- **Daily Query**:
  - Uses aggregated daily transactions
  - Implements RevenueCat's proceeds calculation
  - Segments data across multiple dimensions

## Common Elements

### Data Quality Filters
Both queries consistently apply these filters:
- Exclude family shared subscriptions
- Exclude promotional transactions
- Exclude sandbox data
- Filter out invalid transactions

### RevenueCat Methodology
Both queries follow RevenueCat's official calculation methods:
- Revenue normalization
- Subscription status determination
- Trial handling

## Implementation Details

### Monthly Query Structure

sql
1. date_ranges CTE
2. mrr_calc CTE
3. active_subscriptions CTE
4. churned_users CTE
5. Final SELECT with metrics


### Daily Query Structure

sql
1. date_ranges CTE
2. filtered_data CTE
3. daily_metrics CTE
4. Final SELECT with dimensions

## Use Case Scenarios

### Monthly Query
- When to use:
  - Reporting to stakeholders
  - Analyzing subscription growth
  - Monitoring business health
  - Tracking retention metrics

### Daily Query
- When to use:
  - Analyzing marketing campaigns
  - Monitoring regional performance
  - Product-level analysis
  - Platform comparison
  - Trial funnel optimization

## Dashboard Integration

### Monthly Dashboard
- MRR trend line
- Active subscriptions growth
- ARPU development
- Churn rate monitoring

### Daily Dashboard
- Revenue by dimension
- Trial conversion funnel
- Geographic heat maps
- Product performance comparison

## Best Practices

### Query Maintenance
- Update date ranges regularly
- Monitor for new product durations
- Validate against RevenueCat dashboard
- Document any custom modifications

### Data Analysis
- Cross-reference between queries
- Validate totals match
- Monitor for anomalies
- Regular reconciliation with RevenueCat dashboard

## Technical Notes

### Performance Considerations
- Both queries use CTEs for readability
- Filtered_data CTE reduces data scanning
- Appropriate indexing recommended
- Consider partitioning for large datasets

### Data Requirements
- RevenueCat data export table
- Complete transaction history
- Valid subscription metadata
- Accurate trial and conversion tracking

## References
- [RevenueCat Active Subscriptions Documentation](https://www.revenuecat.com/docs/dashboard-and-metrics/charts/active-subscriptions-chart)
- [RevenueCat MRR Calculation Guide](https://www.revenuecat.com/docs/integrations/scheduled-data-exports)
- [RevenueCat Metrics Definitions](https://www.revenuecat.com/docs/dashboard-and-metrics)


