-- Query to get cost data from the most recent batch for each date
-- Eliminates duplicate data by selecting only the latest batch

WITH latest_batch AS (
    SELECT 
        date,
        app_id,
        cost,
        original_cost,
        installs,
        ROW_NUMBER() OVER (PARTITION BY date, app_id ORDER BY batch DESC) as rn
    FROM appsflyer_cost.ext_channel
)
SELECT 
    date,
    app_id,
    CAST(SUM(cost) AS int) AS cost_cost,
    CAST(SUM(original_cost) AS int) AS cost_original_cost,
    SUM(installs) AS cost_installs
FROM latest_batch
WHERE rn = 1
GROUP BY 
    date,
    app_id
ORDER BY 
    date DESC;
