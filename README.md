# banking-dbt

dbt project for a near-real-time banking pipeline on Snowflake. It turns CDC data replicated from Postgres into a star schema, with tests, snapshots and dashboard aggregates.

Part of a three-repo project:

| Repo | Purpose |
| --- | --- |
| **banking-dbt** (this repo) | Transformations: staging, snapshots, marts, tests |
| https://github.com/mahamfs2703/banking_generator | Simulated source activity |
| Python generator that keeps the source database changing |
| https://github.com/mahamfs2703/banking_live_dashboard | Streamlit in Snowflake dashboard on the marts layer |

## Architecture

Python generator -> Neon Postgres (schema `banking`) -> Fivetran (log-based CDC) -> Snowflake RAW (`DB_BANKING.POSTGRES_BANKING`) -> dbt (this repo) -> `DB_BANKING.MARTS` -> Streamlit dashboard

- Source tables: `customers`, `accounts`, `merchants`, `transactions`.
- Fivetran adds `_FIVETRAN_SYNCED` (incremental watermark) and `_FIVETRAN_DELETED` (soft-delete flag) to each RAW table.
- dbt runs as a **dbt Projects on Snowflake** object and is scheduled with a Snowflake task.

## Snowflake objects

| Object | Name |
| --- | --- |
| Database | `DB_BANKING` |
| RAW schema (Fivetran) | `POSTGRES_BANKING` |
| dbt output schemas | `STAGING`, `SNAPSHOTS`, `MARTS` |
| dbt project object | `DB_BANKING.DBT_OPS.BANKING_DBT` |
| Task | `DB_BANKING.DBT_OPS.RUN_BANKING_DBT` |
| Warehouse | `DBT_PRACTICE_WH` (XS, 60 s auto-suspend) |
| Role | `DBT_ROLE` |

## Data layers

| Layer | Contents |
| --- | --- |
| Sources | The four RAW tables, with freshness checks on `_FIVETRAN_SYNCED` |
| Staging | Renamed and typed columns. The Fivetran soft-delete flag is kept. |
| Snapshots | SCD Type 2 history for customers and accounts |
| Marts | `dim_customer`, `dim_account`, `dim_merchant`, `dim_date`, `fct_transactions`, plus four aggregates |

### Marts

- **`dim_date`**: covers 2024-01-01 to 2028-12-31.
- **`fct_transactions`**: incremental, merging on `transaction_id` with a `_FIVETRAN_SYNCED` watermark.
  - Soft-deleted source rows are **kept** with `is_deleted = true`, so history is not lost. Consumers filter them out.
  - Dimension joins are point-in-time on `transaction_ts`.
  - Rows whose account or customer key is still null (late-arriving dimension rows) are re-processed on later runs.
- **Aggregates** (all filter `where not is_deleted`):
  - `agg_daily_kpis`: one row per day with counts, success rate, completed amount and average ticket size.
  - `agg_txn_volume_per_minute`: transaction count and amount per minute, for the live trend.
  - `agg_failed_rate_hourly`: failed-transaction rate per hour (UTC hour buckets).
  - `agg_top_merchants`: merchants ranked by completed value.

## Tests

- Generic: `unique`, `not_null`, `relationships`, and `accepted_values` for transaction status (`PENDING`, `COMPLETED`, `FAILED`, `REVERSED`).
- Four custom singular tests in `tests/` [TODO: list the test names if you want them documented].

## Running

Manual run from SQL:

```sql
EXECUTE DBT PROJECT DB_BANKING.DBT_OPS.BANKING_DBT ARGS='build';
```

Scheduled run: the task `RUN_BANKING_DBT` executes the same command every 6 hours, matching the Fivetran sync interval.

```sql
ALTER TASK DB_BANKING.DBT_OPS.RUN_BANKING_DBT RESUME;   -- start
ALTER TASK DB_BANKING.DBT_OPS.RUN_BANKING_DBT SUSPEND;  -- stop
```

Notes:

- `DBT_ROLE` needs `USAGE` and `MONITOR` on the dbt project object, plus access to the warehouse and schemas.
- Only one `EXECUTE DBT PROJECT` can run at a time on the same project object, so keep the task interval longer than one run (a full build takes under a minute).
- For a short live demo, the task interval can be lowered to 5 minutes (`ALTER TASK ... SET SCHEDULE = '5 MINUTES'`) and reverted afterwards.

## Design decisions

- **Incremental models** over dynamic tables, to practise the merge and watermark pattern used in production.
- **Soft deletes kept in the fact table** so late deletes and audits stay possible.
- **dbt Projects on Snowflake** keeps transformations, scheduling and monitoring inside Snowflake.

## Time zones

Timestamps are stored in UTC (`TIMESTAMP_TZ`). The dashboard converts to IST at query time.