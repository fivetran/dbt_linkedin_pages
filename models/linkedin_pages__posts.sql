with share_statistic as (

    select *
    from {{ var('share_statistic') }}

),

ugc_post_share_statistic as (

    select *
    from {{ var('ugc_post_share_statistic') }}

),

ugc_post_history as (

    select *
    from {{ var('ugc_post_history') }}

),

ugc_post_share_content_media as (

    select *
    from {{ var('ugc_post_share_content_media') }}

),

organization as (

    select *
    from {{ var('organization') }}

),

organization_ugc_post as (

    select *
    from {{ var('organization_ugc_post') }}

),

joined as (

    select 
        share_statistic.click_count,
        share_statistic.comment_count,
        share_statistic.impression_count,
        share_statistic.like_count,
        share_statistic.share_count,
        ugc_post_share_statistic.ugc_post_id,
        ugc_post_history.post_author,
        ugc_post_history.created_timestamp,
        ugc_post_history.first_published_timestamp,
        ugc_post_history.lifecycle_state,
        ugc_post_history.version_tag,
        ugc_post_history.specific_content_share_commentary_text,
        ugc_post_share_content_media.title_text,
        ugc_post_share_content_media.original_url,
        organization.organization_id,
        organization.name_localized as organization_name
    from share_statistic
    left join ugc_post_share_statistic
        on share_statistic.share_statistic_id = ugc_post_share_statistic.share_statistic_id
    left join ugc_post_history
        on ugc_post_share_statistic.ugc_post_id = ugc_post_history.ugc_post_id
    left join ugc_post_share_content_media
        on ugc_post_history.ugc_post_id = ugc_post_share_content_media.ugc_post_id
    left join organization_ugc_post
        on ugc_post_history.ugc_post_id = organization_ugc_post.ugc_post_id
    left join organization
        on organization_ugc_post.organization_id = organization.organization_id

)

select *
from joined