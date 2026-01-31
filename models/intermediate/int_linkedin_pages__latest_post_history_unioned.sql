with post_history_unioned as (

    select *
    from {{ ref('int_linkedin_pages__post_history_unioned') }}

),

is_most_recent as (

    select
        *,
        row_number() over (partition by post_id, source_relation order by last_modified_timestamp desc) = 1 as is_most_recent_record
    from post_history_unioned

)

select *
from is_most_recent
