
alter PROC platform_dwlab_prod.TableSizeRefresh
as

IF EXISTS (SELECT 1 FROM sys.tables t WHERE t.name = 'TMAP' and schema_name(t.schema_id)='dbo') DROP TABLE dbo.TMAP;
IF EXISTS (SELECT 1 FROM sys.tables t WHERE t.name = 'NTABLES' and schema_name(t.schema_id)='dbo') DROP TABLE dbo.NTABLES;
IF EXISTS (SELECT 1 FROM sys.tables t WHERE t.name = 'PNPStats' and schema_name(t.schema_id)='dbo') DROP TABLE dbo.PNPStats;

CREATE TABLE dbo.TMAP
WITH(DISTRIBUTION=HASH(object_id),CLUSTERED COLUMNSTORE INDEX)
as
SELECT * FROM [sys].[pdw_permanent_table_mappings]

CREATE TABLE dbo.NTables
WITH (DISTRIBUTION=HASH(object_id),CLUSTERED COLUMNSTORE INDEX)
as
SELECT * FROM sys.pdw_nodes_tables;

CREATE TABLE dbo.PNPStats
WITH (DISTRIBUTION=HASH(object_id),CLUSTERED COLUMNSTORE INDEX)
as
SELECT * FROM [sys].[dm_pdw_nodes_db_partition_stats];

IF EXISTS (SELECT 1 FROM sys.tables t WHERE t.name = 'VtableSize' and schema_name(t.schema_id)='platform_dwlab_prod') DROP TABLE platform_dwlab_prod.VtableSize;
create table platform_dwlab_prod.VtableSize
with(distribution=round_robin)
as
SELECT 
	schema_name
	,table_name
	,[distribution_policy_name]
	,[distribution_column]
	,[index_type_desc]
	,sum([row_count]) as [row_count]
	,sum([reserved_space_GB]) as [reserved_space_GB]
	,sum([unused_space_GB]) as [unused_space_GB]
	,sum([data_space_GB]) as [data_space_GB]
	,sum([index_space_GB]) as [index_space_GB]
FROM vTableSizes with(nolock)
GROUP BY 
	schema_name
	,table_name
	,[distribution_policy_name]
	,[distribution_column]
	,[index_type_desc]
