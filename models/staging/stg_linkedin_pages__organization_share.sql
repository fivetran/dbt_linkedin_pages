
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

        {{ fivetran_utils.source_relation(
            union_schema_variable='linkedin_pages_union_schemas',
            union_database_variable='linkedin_pages_union_databases')
        }}

    from base
),

final as (

    select
        _fivetran_synced,
        organization_id,

        case
            when lower(share_id) like '%urn:li:share:%'
                then replace(share_id, 'urn:li:share:', '')
            when lower(share_id) like '%urn:li:ugcpost:%'
                then replace(lower(share_id), 'urn:li:ugcpost:', '')
            else share_id
        end as share_id,

        source_relation
    from fields
)

select * from final
