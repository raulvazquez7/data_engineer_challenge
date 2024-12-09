CREATE OR REPLACE TABLE `labhouse.monthly_output` AS

WITH date_ranges AS (
  SELECT 
    DATE_TRUNC(DATE(start_time), MONTH) as month_start,
    LAST_DAY(DATE(start_time)) as month_end
  FROM `burnished-flare-384310.labhouse.revenuecat_data`
  GROUP BY 1, 2
),

mrr_calc AS (
  SELECT 
    date_ranges.month_start,
    ROUND(SUM(
      CASE 
        WHEN product_duration = 'P1W' THEN price_in_usd * 4
        WHEN product_duration = 'P1M' OR product_duration IS NULL THEN price_in_usd
        WHEN product_duration = 'P1Y' THEN price_in_usd * 0.08333
      END
    ), 2) as mrr
  FROM date_ranges
  LEFT JOIN `burnished-flare-384310.labhouse.revenuecat_data` data
    ON DATE(data.start_time) <= date_ranges.month_end
    AND DATE(data.effective_end_time) > date_ranges.month_end
  WHERE is_trial_period = FALSE
    AND TIMESTAMP_DIFF(end_time, start_time, SECOND) > 0
    AND ownership_type != 'FAMILY_SHARED'
    AND store != 'promotional'
    AND is_sandbox = FALSE
  GROUP BY date_ranges.month_start
),

active_subscriptions AS (
  SELECT
    DATE_TRUNC(date, MONTH) as month_start,
    COUNT(DISTINCT rc_original_app_user_id) as total_active_subscribers
  FROM UNNEST(GENERATE_DATE_ARRAY('2023-07-01', '2024-02-28', INTERVAL 1 MONTH)) as date
  LEFT JOIN `burnished-flare-384310.labhouse.revenuecat_data` data
    ON DATE(effective_end_time) > date
    AND DATE(start_time) <= date
  WHERE is_trial_period = FALSE
    AND TIMESTAMP_DIFF(end_time, start_time, SECOND) > 0
    AND ownership_type != 'FAMILY_SHARED'
    AND store != 'promotional'
    AND is_sandbox = FALSE
  GROUP BY 1
),

churned_users AS (
  SELECT
    DATE_TRUNC(DATE(unsubscribe_detected_at), MONTH) as churn_month,
    COUNT(DISTINCT rc_original_app_user_id) as churned_count
  FROM `burnished-flare-384310.labhouse.revenuecat_data`
  WHERE unsubscribe_detected_at IS NOT NULL
    AND is_trial_period = FALSE
    AND ownership_type != 'FAMILY_SHARED'
    AND store != 'promotional'
    AND is_sandbox = FALSE
  GROUP BY churn_month
)

SELECT 
  m.month_start,
  m.mrr,
  a.total_active_subscribers,
  ROUND(m.mrr / NULLIF(a.total_active_subscribers, 0), 2) as arpu,
  ROUND(SAFE_DIVIDE(ch.churned_count, a.total_active_subscribers) * 100, 2) as churn_rate_percentage,
  IFNULL(ch.churned_count, 0) as churned_users
FROM mrr_calc m
LEFT JOIN active_subscriptions a ON m.month_start = a.month_start
LEFT JOIN churned_users ch ON m.month_start = ch.churn_month
ORDER BY m.month_start;
