with ugc_post_history as (

    select *
    from {{ ref('stg_linkedin_pages__ugc_post_history') }}

),

share_history as (

    select *
    from {{ ref('stg_linkedin_pages__share_history') }}

),

ugc_posts as (

    select
        ugc_post_id as post_id,
        ugc_post_urn as post_urn,
        post_author,
        commentary,
        created_actor,
        created_timestamp,
        first_published_timestamp,
        last_modified_actor,
        last_modified_timestamp,
        lifecycle_state,
        visibility,
        post_url,
        source_relation,
        _fivetran_synced,
        'ugc' as post_type
    from ugc_post_history

),

share_posts as (

    select
        share_id as post_id,
        share_urn as post_urn,
        post_author,
        commentary,
        created_actor,
        created_timestamp,
        first_published_timestamp,
        last_modified_actor,
        last_modified_timestamp,
        lifecycle_state,
        visibility,
        post_url,
        source_relation,
        _fivetran_synced,
        'share' as post_type
    from share_history

),

unioned as (

    select * from ugc_posts
    union all
    select * from share_posts

)

select * from unioned
