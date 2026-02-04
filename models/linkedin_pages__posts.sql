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

ugc_post_content as (

    select *
    from {{ ref('stg_linkedin_pages__post_content') }}

),

shares_content as (

    select *
    from {{ ref('stg_linkedin_pages__share_content') }}

),

-- Union UGC post content and share content
content as (

    select
        ugc_post_urn as post_urn,
        article_title,
        media_title,
        post_type,
        source_relation,
        'ugc' as content_type
    from ugc_post_content

    union all

    select
        share_urn as post_urn,
        article_title,
        media_title,
        post_type,
        source_relation,
        'share' as content_type
    from shares_content

),

organization as (

    select *
    from {{ ref('stg_linkedin_pages__organization') }}

),

ugc_organization_mapping as (

    select *
    from {{ ref('stg_linkedin_pages__organization_ugc_post') }}

),

share_organization_mapping as (

    select *
    from {{ ref('stg_linkedin_pages__organization_share') }}

),

-- Union organization mappings for UGC posts and shares
organization_post as (

    select
        ugc_post_id,
        organization_id,
        source_relation,
        'ugc' as content_type
    from ugc_organization_mapping

    union all

    select
        share_id as ugc_post_id,
        organization_id,
        source_relation,
        'share' as content_type
    from share_organization_mapping

),

joined as (

    select
        post_history.ugc_post_id,
        post_history.post_author,
        post_history.post_url,
        post_history.created_timestamp,
        post_history.first_published_timestamp,
        post_history.lifecycle_state,
        post_history.commentary,
        organization.organization_id,
        coalesce(content.article_title, content.media_title) as post_title,
        content.post_type,
        content.content_type,
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
        on post_share_statistic.ugc_post_id = post_history.ugc_post_id
        and post_share_statistic.content_type = post_history.content_type
        and post_share_statistic.source_relation = post_history.source_relation

    -- Join to the shared share_statistic table
    left join share_statistic
        on share_statistic.share_statistic_id = post_share_statistic.share_statistic_id
        and share_statistic.source_relation = post_history.source_relation

    -- Join unified content
    left join content
        on content.post_urn = post_history.post_urn
        and content.content_type = post_history.content_type
        and content.source_relation = post_history.source_relation

    -- Join unified organization mapping
    left join organization_post
        on organization_post.ugc_post_id = post_history.ugc_post_id
        and organization_post.content_type = post_history.content_type
        and organization_post.source_relation = post_history.source_relation

    -- Join to organization table
    left join organization
        on organization.organization_id = organization_post.organization_id
        and organization.source_relation = post_history.source_relation

)

select *
from joined
