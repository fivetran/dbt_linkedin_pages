with base as (

    select *
    from {{ ref('stg_linkedin_pages__organization_share_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin_pages__organization_share_tmp')),
                staging_columns=get_organization_share_columns()
            )
        }}

        {{ fivetran_utils.apply_source_relation(package_name='linkedin_pages') }}

    from base
),

final as (

    select
        _fivetran_synced,
        organization_id,
        cast(share_id as {{ dbt.type_string() }}) as share_id,
        source_relation
    from fields
)

select * 
from final