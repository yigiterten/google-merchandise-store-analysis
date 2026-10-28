-- 02: Session-level purchase funnel.
-- A session = user_pseudo_id + ga_session_id.
-- For each session, flag whether it contained each funnel event, then count flagged sessions.
-- Note: flags are independent (not strictly sequential), so step rates are approximate.
WITH s AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS sid,
    LOGICAL_OR(event_name = 'view_item') AS v,
    LOGICAL_OR(event_name = 'add_to_cart') AS a,
    LOGICAL_OR(event_name = 'begin_checkout') AS c,
    LOGICAL_OR(event_name = 'purchase') AS p
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  GROUP BY user_pseudo_id, sid
)
SELECT
  COUNT(*) AS sessions,
  COUNTIF(v) AS view_item,
  COUNTIF(a) AS add_to_cart,
  COUNTIF(c) AS begin_checkout,
  COUNTIF(p) AS purchase
FROM s;
