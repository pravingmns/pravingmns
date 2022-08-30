
--Audit log tables
[beamauditlogs_ingest_prod].SynapseDiagnosticlogs_Querylogs
[beamauditlogs_ingest_prod].SynapseDiagnosticlogs_FactTables_Querylogs
[dbadmin].[SynapseAuditLogs_Fact_tables]
[dbadmin].[synapse_UserActivity_WLM_sessions_history]
[beamauditlogs_ingest_prod].[requeststeps]

--Replicate cache status
SELECT schema_name(schema_id) schema_name,[ReplicatedTable] = t.[name],create_date,modify_date,state
  FROM sys.tables t  
  JOIN sys.pdw_replicated_table_cache_state c  
    ON c.object_id = t.object_id
  JOIN sys.pdw_table_distribution_properties p
    ON p.object_id = t.object_id
  WHERE --c.[state] = 'NotReady' AND
	p.[distribution_policy_desc] = 'REPLICATE'

-- platform_dwlab_prod.TableSizeRefresh
select top 10 * from platform_dwlab_prod.VtableSize with(nolock)


