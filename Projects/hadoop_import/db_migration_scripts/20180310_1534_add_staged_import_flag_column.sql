Use ReportingLog;

IF NOT EXISTS (
SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID(N'dbo.HDP_ColumnsToImport')
AND name = 'StagedImportFlag'
)
ALTER TABLE dbo.HDP_ColumnsToImport
Add StagedImportFlag bit DEFAULT ((1)) NOT NULL;

UPDATE dbo.HDP_ColumnsToImport
set StagedImportFlag = ColumnImportFlag;
