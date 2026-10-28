-- 01: Which event types exist in the GA4 sample, and how often do they occur?
-- Purpose: pick the events that make up the purchase funnel.
-- Data: Google Merchandise Store, GA4 obfuscated sample (2020-11-01 to 2021-01-31).
SELECT
  event_name,
  COUNT(*) AS event_count
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY event_name
ORDER BY event_count DESC;
