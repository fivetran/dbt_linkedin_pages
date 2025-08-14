with ugc_post_history as (

    select *
    from {{ ref('stg_linkedin_pages__ugc_post_history') }}

), is_most_recent as (

    select
        *,
        row_number() over (partition by ugc_post_id, source_relation order by last_modified_timestamp desc) = 1 as is_most_recent_record
    from ugc_post_history

)

select *
from is_most_recent
