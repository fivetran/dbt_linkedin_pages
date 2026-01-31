with share_post as (

    select *
    from {{ ref('stg_linkedin_pages__share_share_statistics') }}

),

is_most_recent as (

    select
        *,
        row_number() over (partition by share_id, source_relation order by _fivetran_synced desc) = 1 as is_most_recent_record
    from share_post

)

select *
from is_most_recent
