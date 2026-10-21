{{
    config(
    
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='transaction_id',
        on_schema_change='append_new_columns'
        
    )
}}

-- Incremental on the Fivetran watermark. ">=" re-reads the latest batch on
-- every run, which is safe because the merge on transaction_id is idempotent.
-- Soft-deleted rows stay in the table with is_deleted = true.

with txn as (

    select * from {{ ref('stg_transactions') }}
    {% if is_incremental() %}
        where fivetran_synced_at >= 
            (select coalesce(max(fivetran_synced_at), to_timestamp_tz('1990-01-01 00:00:00')) from {{ this }})
    {% endif %} 
    
),

acct as (

    select account_key, account_id, customer_id, valid_from, valid_to
    from {{ ref('dim_account') }}
    
),

cust as (

    select customer_key, customer_id, valid_from, valid_to
    from {{ ref('dim_customer') }}

),

merch as (

    select merchant_key, merchant_id
    from {{ ref('dim_merchant') }}

)

select 
    t.transaction_id,
    a.account_key,
    c.customer_key,
    m.merchant_key,
    to_number(to_char(cast(t.transaction_ts as date), 'YYYYMMDD')) as date_key,
    t.transaction_type,
    t.status,
    t.amount,
    t.currency,
    t.status = 'COMPLETED' as is_completed,
    t.status = 'FAILED' as is_failed,
    t.transaction_ts,
    t.created_at,
    t.updated_at,
    t.fivetran_synced_at,
    t.is_deleted
from txn t 
left join acct a 
    on a.account_id = t.account_id
    and t.transaction_ts >= a.valid_from
    and t.transaction_ts < a.valid_to
left join cust c
    on c.customer_id = a.customer_id
    and t.transaction_ts >= c.valid_from
    and t.transaction_ts < c.valid_to
left join merch m
    on m.merchant_id = t.merchant_id