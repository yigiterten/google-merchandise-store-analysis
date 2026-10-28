-- 03: Channel performance by traffic_source.medium.
-- A session = user_pseudo_id + ga_session_id.
-- Caution: in the GA4 export, traffic_source describes how the USER was first acquired
-- (first touch), not the medium of each individual session.
-- Revenue = sum of ecommerce.purchase_revenue_in_usd on purchase events.
WITH s AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS sid,
    ANY_VALUE(traffic_source.medium) AS medium,
    LOGICAL_OR(event_name = 'purchase') AS p,
    SUM(IF(event_name = 'purchase', ecommerce.purchase_revenue_in_usd, 0)) AS rev
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  GROUP BY user_pseudo_id, sid
)
SELECT
  medium,
  COUNT(*) AS sessions,
  COUNTIF(p) AS purchasing_sessions,
  ROUND(SAFE_DIVIDE(COUNTIF(p), COUNT(*)) * 100, 2) AS conv_pct,
  ROUND(SUM(rev), 0) AS revenue_usd,
  ROUND(SAFE_DIVIDE(SUM(rev), COUNTIF(p)), 1) AS aov_usd,
  ROUND(SAFE_DIVIDE(SUM(rev), COUNT(*)), 2) AS revenue_per_session_usd
FROM s
GROUP BY medium
ORDER BY sessions DESC;
