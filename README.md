# Google Merchandise Store: Funnel and Channel Analysis

SQL analysis (BigQuery) of the public Google Merchandise Store GA4 sample dataset.

## Business question

Across traffic channels, where is the Merchandise Store losing visitors, and which channels deserve more marketing budget?

## Data

- Source: bigquery-public-data.ga4_obfuscated_sample_ecommerce (GA4 export, obfuscated)
- Period: 1 Nov 2020 to 31 Jan 2021 (includes Black Friday and the holiday season)
- A session is defined as user_pseudo_id + ga_session_id
- Scope: 360,129 sessions and 4,848 purchasing sessions

## Method

1. Event overview: list all event types to choose the funnel steps (sql/01_event_overview.sql)
2. Session funnel: flag each session for view_item, add_to_cart, begin_checkout and purchase (sql/02_session_funnel.sql)
3. Channel performance: sessions, conversion, revenue, average order value and revenue per session by traffic_source.medium (sql/03_channel_performance.sql)

## Findings

### Session funnel

| Step | Sessions | Share of previous step | Share of all sessions |
|---|---|---|---|
| All sessions | 360,129 | | 100% |
| view_item | 77,020 | 21.4% | 21.4% |
| add_to_cart | 15,188 | 19.7% | 4.2% |
| begin_checkout | 11,106 | 73.1% | 3.1% |
| purchase | 4,848 | 43.7% | 1.35% |

Most visitors are lost early: 78.6% of sessions never view a product, and 80.3% of product viewers never add to cart. Once a visitor starts checkout, 56% still do not complete the purchase.

### Channel performance (first-touch medium)

| Medium | Sessions | Purchasing sessions | Conversion | Revenue (USD) | Avg order value (USD) | Revenue per session (USD) |
|---|---|---|---|---|---|---|
| organic | 122,841 | 1,347 | 1.10% | 104,007 | 77.2 | 0.85 |
| (none) | 83,459 | 1,079 | 1.29% | 79,650 | 73.8 | 0.95 |
| referral | 63,524 | 1,056 | 1.66% | 83,521 | 79.1 | 1.31 |
| &lt;Other&gt; | 52,058 | 506 | 0.97% | 35,470 | 70.1 | 0.68 |
| (data deleted) | 22,629 | 707 | 3.12% | 50,461 | 71.4 | 2.23 |
| cpc | 15,618 | 153 | 0.98% | 9,056 | 59.2 | 0.58 |

Revenue per session is revenue divided by sessions, calculated from the columns above.

## Recommendation

- Referral is the strongest identifiable channel: the highest conversion (1.66%), the highest average order value (79.1 USD) and 1.31 USD per session, more than double cpc.
- Paid search (cpc) is the weakest channel on every measure: 0.98% conversion, 59.2 USD average order value and 0.58 USD per session, on only about 4% of sessions.
- Suggested test: move a share of the cpc budget toward referral and partner placements, and measure the change in revenue per session before scaling.

## Limitations

- traffic_source in the GA4 export is the user's first-touch acquisition medium, not the medium of each session, so channel results are approximate.
- The (data deleted) and &lt;Other&gt; groups cannot be attributed to a real channel.
- The funnel flags are independent per session (not strictly sequential), so step rates are approximate.
- cpc has only 153 purchases, so its figures are less stable.
- The period covers Black Friday and the holidays, so rates may be seasonally high or low.

## Repository contents

- sql/: the BigQuery queries
- results/: query outputs

## Status

Funnel and channel analyses are complete. Device/country and product-category breakdowns are planned next.
