{% macro get_share_share_statistics_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "share_id", "datatype": dbt.type_string()},
    {"name": "share_statistics_id", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
