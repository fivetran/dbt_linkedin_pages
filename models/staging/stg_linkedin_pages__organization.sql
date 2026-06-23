with base as (

    select * 
    from {{ ref('stg_linkedin_pages__organization_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin_pages__organization_tmp')),
                staging_columns=get_organization_columns()
            )
        }}
        
        {{ fivetran_utils.apply_source_relation(package_name='linkedin_pages') }}
        
    from base
),

final as (
    
    select 
        id as organization_id,
        localized_name as organization_name,
        source_relation
    from fields
)

select * from final