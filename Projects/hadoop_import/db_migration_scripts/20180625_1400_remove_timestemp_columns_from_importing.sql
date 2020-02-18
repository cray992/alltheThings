Use ReportingLog;

update dbo.HDP_columnsToImport
set ColumnImportFlag = 0
where columnType = 'timestamp'
