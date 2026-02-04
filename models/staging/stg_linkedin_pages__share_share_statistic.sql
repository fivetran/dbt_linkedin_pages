
with base as (

    select *
    from {{ ref('stg_linkedin_pages__share_share_statistic_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_linkedin_pages__share_share_statistic_tmp')),
                staging_columns=get_share_share_statistic_columns()
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
        cast(share_id as {{ dbt.type_string() }}) as share_id,
        share_statistic_id,
        source_relation
    from fields
)

select *
from final
