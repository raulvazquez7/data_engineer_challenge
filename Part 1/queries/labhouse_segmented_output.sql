CREATE OR REPLACE TABLE `labhouse.segmented_output` AS

WITH date_ranges AS (
  SELECT 
    DATE_TRUNC(DATE(start_time), DAY) as date
  FROM `burnished-flare-384310.labhouse.revenuecat_data`
  GROUP BY 1
),

filtered_data AS (
  SELECT
    DATE(start_time) AS date,
    start_time,
    rc_original_app_user_id,
    price_in_usd,
    tax_percentage,
    commission_percentage,
    is_trial_period,
    is_auto_renewable,
    renewal_number,
    is_trial_conversion,
    store_transaction_id,
    effective_end_time,
    country,
    product_identifier,
    store,
    platform,
    product_duration
  FROM `burnished-flare-384310.labhouse.revenuecat_data`
  WHERE ownership_type != 'FAMILY_SHARED'
    AND store != 'promotional'
    AND is_sandbox = FALSE
    AND TIMESTAMP_DIFF(end_time, start_time, SECOND) > 0
),

daily_metrics AS (
  SELECT
    date,
    country,
    product_identifier,
    store,
    platform,
    product_duration,
    -- Proceeds calculation following RevenueCat's methodology (Revenue)
    SUM(price_in_usd * (1 - tax_percentage - commission_percentage)) AS proceeds,
    -- Transactions
    COUNT(DISTINCT store_transaction_id) AS transactions,
    -- New revenue from first-time purchases (excluding trials) 
    SUM(CASE 
        WHEN renewal_number = 1 
            AND is_trial_period = FALSE 
        THEN price_in_usd * (1 - tax_percentage - commission_percentage)
        ELSE 0
    END) AS new_revenue,
    -- Revenue from renewals
    SUM(CASE 
        WHEN renewal_number > 1 
        THEN price_in_usd * (1 - tax_percentage - commission_percentage)
        ELSE 0
    END) AS renewal_revenue,
    -- Trial metrics following RevenueCat's definitions 
    COUNT(DISTINCT CASE 
        WHEN is_trial_period = TRUE 
            AND renewal_number = 1 
        THEN rc_original_app_user_id 
        ELSE NULL 
    END) AS trials_started,
    COUNT(DISTINCT CASE 
        WHEN is_trial_conversion = TRUE 
        THEN rc_original_app_user_id 
        ELSE NULL 
    END) AS trials_converted,
    -- Average trial duration in days 
    ROUND(AVG(CASE 
        WHEN is_trial_period = TRUE 
            AND renewal_number = 1
            AND effective_end_time IS NOT NULL
            AND effective_end_time > start_time
        THEN TIMESTAMP_DIFF(effective_end_time, start_time, DAY)
        ELSE NULL
    END), 1) as avg_trial_duration_days
  FROM filtered_data
  GROUP BY 
    date, 
    country, 
    product_identifier, 
    store, 
    platform, 
    product_duration
)

SELECT
  dm.date,
  dm.country,
  dm.product_identifier,
  dm.store,
  dm.platform,
  dm.product_duration,
  dm.transactions,
  dm.proceeds,
  dm.new_revenue,
  dm.renewal_revenue,
  dm.trials_started,
  dm.trials_converted,
  avg_trial_duration_days
FROM daily_metrics dm
ORDER BY dm.date;
