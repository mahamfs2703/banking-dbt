-- one row per minute, for the live trend chart

select

    date_trunc('minute', transaction_ts) as minute_ts,
    count(*) as txn_count,
    sum(amount) as total_amount

from {{ ref('fct_transactions') }}
where not is_deleted
group by 1