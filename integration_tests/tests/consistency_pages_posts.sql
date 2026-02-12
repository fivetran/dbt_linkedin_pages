
{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

{% set exclude_columns = var('consistency_test_exclude_metrics', []) %}
with prod as (
    select {{ dbt_utils.star(from=ref('linkedin_pages__posts'), except=exclude_columns) }}
    from {{ target.schema }}_linkedin_pages_prod.linkedin_pages__posts
),

dev as (
    select {{ dbt_utils.star(from=ref('linkedin_pages__posts'), except=exclude_columns) }}
    from {{ target.schema }}_linkedin_pages_dev.linkedin_pages__posts
),

prod_not_in_dev as (
    -- rows from prod not found in dev
    select * from prod
    except distinct
    select * from dev
),

dev_not_in_prod as (
    -- rows from dev not found in prod
    select * from dev
    except distinct
    select * from prod
),

final as (
    select
        *,
        'from prod' as source
    from prod_not_in_dev

    union all -- union since we only care if rows are produced

    select
        *,
        'from dev' as source
    from dev_not_in_prod
)

select *
from final