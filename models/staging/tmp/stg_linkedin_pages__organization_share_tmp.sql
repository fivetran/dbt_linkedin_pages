{% if var('linkedin_pages_union_schemas', []) | length > 0 or var('linkedin_pages_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='organization_share',
        database_variable='linkedin_pages_database',
        schema_variable='linkedin_pages_schema',
        default_database=target.database,
        default_schema='linkedin_company_pages',
        default_variable='organization_share',
        union_schema_variable='linkedin_pages_union_schemas',
        union_database_variable='linkedin_pages_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='linkedin_pages_sources',
        single_source_name='linkedin_pages',
        single_table_name='organization_share'
    )
}}

{% endif %}