with ugc_post_share_statistic as (

    select *
    from {{ ref('stg_linkedin_pages__ugc_post_share_statistic') }}

),

share_share_statistic as (

    select *
    from {{ ref('stg_linkedin_pages__share_share_statistic') }}

),

ugc_posts as (

    select
        ugc_post_id as post_id,
        share_statistic_id,
        _fivetran_synced,
        source_relation,
        'ugc' as content_type
    from ugc_post_share_statistic

),

share_posts as (

    select
        share_id as post_id,
        share_statistic_id,
        _fivetran_synced,
        source_relation,
        'share' as content_type
    from share_share_statistic

),

unioned as (

    select * from ugc_posts
    union all
    select * from share_posts

),

is_most_recent as (

    select
        *,
        row_number() over (partition by ugc_post_id, content_type, source_relation order by _fivetran_synced desc) = 1 as is_most_recent_record
    from unioned

)

select *
from is_most_recent