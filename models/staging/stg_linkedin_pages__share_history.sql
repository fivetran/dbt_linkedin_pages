with base as (

    select *
    from {{ ref('stg_linkedin_pages__share_history_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin_pages__share_history_tmp')),
                staging_columns=get_share_history_columns()
            )
        }}

        {{ fivetran_utils.apply_source_relation(package_name='linkedin_pages') }}

    from base
),

final as (

    select
        _fivetran_synced,
        author as post_author,
        commentary,
        created_time as created_timestamp,
        first_published_at as first_published_timestamp,
        cast(id as {{ dbt.type_string() }}) as share_id,
        {{ dbt.concat(["'urn:li:share:'", "cast(id as " ~ dbt.type_string() ~ ")"]) }} as share_urn,
        {{ dbt.concat(["'https://www.linkedin.com/embed/feed/update/urn:li:share:'", "cast(id as " ~ dbt.type_string() ~ ")"]) }} as post_url,
        last_modified_time as last_modified_timestamp,
        lifecycle_state,
        visibility,
        source_relation
    from fields
)

select * 
from final