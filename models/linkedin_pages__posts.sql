with share_statistic as (

    select *
    from {{ ref('stg_linkedin_pages__share_statistic') }}

),

post_share_statistic as (

    select *
    from {{ ref('int_linkedin_pages__latest_post') }}
    where is_most_recent_record = true

),

post_history as (

    select *
    from {{ ref('int_linkedin_pages__latest_post_history') }}
    where is_most_recent_record = true

),

post_content as (

    select *
    from {{ ref('stg_linkedin_pages__post_content') }}

),

share_content as (

    select *
    from {{ ref('stg_linkedin_pages__share_content') }}

),

organization as (

    select *
    from {{ ref('stg_linkedin_pages__organization') }}

),

organization_ugc_post as (

    select *
    from {{ ref('stg_linkedin_pages__organization_ugc_post') }}

),

organization_share as (

    select *
    from {{ ref('stg_linkedin_pages__organization_share') }}

),

joined as (

    select
        post_history.post_id,
        post_history.post_type,
        post_history.post_author,
        post_history.post_url,
        post_history.created_timestamp,
        post_history.first_published_timestamp,
        post_history.lifecycle_state,
        post_history.commentary,
        organization.organization_id,
        coalesce(
            post_content.article_title,
            post_content.media_title,
            share_content.article_title,
            share_content.media_title
        ) as post_title,
        coalesce(post_content.post_type, share_content.post_type) as content_type,
        organization.organization_name,
        share_statistic.click_count,
        share_statistic.comment_count,
        share_statistic.impression_count,
        share_statistic.like_count,
        share_statistic.share_count,
        post_history.source_relation
    from post_history

    -- Join post to share statistics mapping
    left join post_share_statistic
        on post_share_statistic.post_id = post_history.post_id
        and post_share_statistic.post_type = post_history.post_type
        and post_share_statistic.source_relation = post_history.source_relation

    -- Join to the shared share_statistic table
    left join share_statistic
        on share_statistic.share_statistic_id = post_share_statistic.statistic_id
        and share_statistic.source_relation = post_history.source_relation

    -- Join UGC post content for UGC posts
    left join post_content
        on post_history.post_type = 'ugc'
        and post_history.post_urn = post_content.ugc_post_urn
        and post_history.source_relation = post_content.source_relation

    -- Join share content for share posts
    left join share_content
        on post_history.post_type = 'share'
        and post_history.post_urn = share_content.share_urn
        and post_history.source_relation = share_content.source_relation

    -- Join organization via UGC post mapping for UGC posts
    left join organization_ugc_post
        on post_history.post_type = 'ugc'
        and post_history.post_id = organization_ugc_post.ugc_post_id
        and post_history.source_relation = organization_ugc_post.source_relation

    -- Join organization via share mapping for share posts
    left join organization_share
        on post_history.post_type = 'share'
        and post_history.post_id = organization_share.share_id
        and post_history.source_relation = organization_share.source_relation

    -- Join to organization table using coalesced organization IDs
    left join organization
        on organization.organization_id = coalesce(
            organization_ugc_post.organization_id,
            organization_share.organization_id
        )
        and organization.source_relation = post_history.source_relation

)

select *
from joined
