with fct as (
    select count(*) as fct_rows from {{ ref('fct_transactions') }}
),

stg as (
    select count(*) as stg_rows from {{ ref('stg_transactions') }}
)

select 
    fct.fct_rows,
    stg.stg_rows
from fct
cross join stg
where fct.fct_rows != stg.stg_rows