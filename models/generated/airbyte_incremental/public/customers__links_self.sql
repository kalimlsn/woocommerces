{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('customers__links_self_ab3') }}
select
    _airbyte__links_hashid,
    href,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_self_hashid
from {{ ref('customers__links_self_ab3') }}
-- self at customers/_links/self from {{ ref('customers__links') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

