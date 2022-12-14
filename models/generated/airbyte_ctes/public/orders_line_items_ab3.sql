{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_public",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('orders_line_items_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_orders_hashid',
        adapter.quote('id'),
        'sku',
        adapter.quote('name'),
        'price',
        'taxes',
        'total',
        'quantity',
        'subtotal',
        'meta_data',
        'tax_class',
        'total_tax',
        'product_id',
        'subtotal_tax',
        'variation_id',
    ]) }} as _airbyte_line_items_hashid,
    tmp.*
from {{ ref('orders_line_items_ab2') }} tmp
-- line_items at orders/line_items
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

