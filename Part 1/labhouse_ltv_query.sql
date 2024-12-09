CREATE OR REPLACE TABLE `labhouse.cohort_ltv` AS

WITH first_purchase_dates AS (
  SELECT
    rc_original_app_user_id,
    MIN(DATE(start_time)) as cohort_date
  FROM `burnished-flare-384310.labhouse.revenuecat_data`
  WHERE is_trial_period = FALSE
    AND ownership_type != 'FAMILY_SHARED'
    AND store != 'promotional'
    AND is_sandbox = FALSE
    AND price_in_usd > 0
  GROUP BY 1
),

cohort_revenue AS (
  SELECT
    fpd.cohort_date,
    fpd.rc_original_app_user_id,
    data.start_time,
    data.price_in_usd * (1 - data.tax_percentage - data.commission_percentage) as net_revenue
  FROM first_purchase_dates fpd
  JOIN `burnished-flare-384310.labhouse.revenuecat_data` data
    ON fpd.rc_original_app_user_id = data.rc_original_app_user_id
  WHERE data.is_trial_period = FALSE
    AND data.ownership_type != 'FAMILY_SHARED'
    AND data.store != 'promotional'
    AND data.is_sandbox = FALSE
    AND data.price_in_usd > 0
    AND refunded_at IS NULL 
),

ltv_periods AS (
  SELECT
    cohort_date,
    rc_original_app_user_id,
    -- LTV por períodos específicos
    SUM(CASE 
      WHEN DATE_DIFF(DATE(start_time), cohort_date, DAY) <= 7 
      THEN net_revenue ELSE 0 
    END) as ltv_7_days,
    SUM(CASE 
      WHEN DATE_DIFF(DATE(start_time), cohort_date, DAY) <= 14 
      THEN net_revenue ELSE 0 
    END) as ltv_14_days,
    SUM(CASE 
      WHEN DATE_DIFF(DATE(start_time), cohort_date, DAY) <= 21 
      THEN net_revenue ELSE 0 
    END) as ltv_21_days,
    SUM(CASE 
      WHEN DATE_DIFF(DATE(start_time), cohort_date, DAY) <= 30 
      THEN net_revenue ELSE 0 
    END) as ltv_1_month,
    SUM(CASE 
      WHEN DATE_DIFF(DATE(start_time), cohort_date, DAY) <= 90 
      THEN net_revenue ELSE 0 
    END) as ltv_3_months,
    SUM(CASE 
      WHEN DATE_DIFF(DATE(start_time), cohort_date, DAY) <= 180 
      THEN net_revenue ELSE 0 
    END) as ltv_6_months,
    SUM(CASE 
      WHEN DATE_DIFF(DATE(start_time), cohort_date, DAY) <= 365 
      THEN net_revenue ELSE 0 
    END) as ltv_12_months,
    SUM(CASE 
      WHEN DATE_DIFF(DATE(start_time), cohort_date, DAY) <= 548 
      THEN net_revenue ELSE 0 
    END) as ltv_18_months,
    SUM(CASE 
      WHEN DATE_DIFF(DATE(start_time), cohort_date, DAY) <= 730 
      THEN net_revenue ELSE 0 
    END) as ltv_24_months
  FROM cohort_revenue
  GROUP BY 1, 2
)

SELECT
  cohort_date,
  COUNT(DISTINCT rc_original_app_user_id) as cohort_size,
  ROUND(AVG(ltv_7_days), 2) as avg_ltv_7_days,
  ROUND(AVG(ltv_14_days), 2) as avg_ltv_14_days,
  ROUND(AVG(ltv_21_days), 2) as avg_ltv_21_days,
  ROUND(AVG(ltv_1_month), 2) as avg_ltv_1_month,
  ROUND(AVG(ltv_3_months), 2) as avg_ltv_3_months,
  ROUND(AVG(ltv_6_months), 2) as avg_ltv_6_months,
  ROUND(AVG(ltv_12_months), 2) as avg_ltv_12_months,
  ROUND(AVG(ltv_18_months), 2) as avg_ltv_18_months,
  ROUND(AVG(ltv_24_months), 2) as avg_ltv_24_months
FROM ltv_periods
GROUP BY cohort_date
ORDER BY cohort_date;
