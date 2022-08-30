
select schema_name,table_name,reserved_space_GB,index_type_desc,row_count 
from platform_dwlab_prod.VtableSize where reserved_space_GB >2 and distribution_policy_name='ROUND_ROBIN' and schema_name like '%dwlab%'
order by reserved_space_GB desc --89

select schema_name,table_name,reserved_space_GB,index_type_desc,row_count 
from platform_dwlab_prod.VtableSize where reserved_space_GB >2 and distribution_policy_name='ROUND_ROBIN' and schema_name  not like '%dwlab%'
order by reserved_space_GB desc --394

--get tble update frequency
