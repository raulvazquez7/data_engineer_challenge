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
