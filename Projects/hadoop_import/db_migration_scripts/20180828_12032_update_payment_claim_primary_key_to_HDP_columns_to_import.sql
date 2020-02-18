Use ReportingLog;

update dbo.HDP_ColumnsToImport
set ColumnImportFlag = 1, isMergeMatch = 1, StagedImportFlag = 1
where ColumnName = 'PaymentClaimID'
and TableID in (select TableID from dbo.HDP_TablesToImport where TableName = 'PaymentClaim');

update dbo.HDP_ColumnsToImport
set ColumnImportFlag = 1, isMergeMatch = 0, StagedImportFlag = 1
where ColumnName = 'ClaimID'
and TableID in (select TableID from dbo.HDP_TablesToImport where TableName = 'PaymentClaim');