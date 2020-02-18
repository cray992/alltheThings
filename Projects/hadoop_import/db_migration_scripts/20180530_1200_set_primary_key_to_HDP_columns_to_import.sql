Use ReportingLog;

update dbo.HDP_ColumnsToImport
set isMergeMatch = 1
where ColumnName = 'AppointmentToResourceID'
and TableID in (select TableID from dbo.HDP_TablesToImport where TableName = 'AppointmentToResource');

update dbo.HDP_ColumnsToImport
set isMergeMatch = 1
where ColumnName = 'Country'
and TableID in (select TableID from dbo.HDP_TablesToImport where TableName = 'Country');

update dbo.HDP_ColumnsToImport
set isMergeMatch = 1
where ColumnName = 'EncounterHealthCodeID'
and TableID in (select TableID from dbo.HDP_TablesToImport where TableName = 'EncounterHealthCode')

update dbo.HDP_ColumnsToImport
set isMergeMatch = 1
where ColumnName = 'HealthCodeID'
and TableID in (select TableID from dbo.HDP_TablesToImport where TableName = 'HealthCode')

update dbo.HDP_ColumnsToImport
set isMergeMatch = 1
where ColumnName = 'TypeOfServiceCode'
and TableID in (select TableID from dbo.HDP_TablesToImport where TableName = 'TypeOfService')

update dbo.HDP_TablesToImport
set ImportTypeID = 2
where TableName = 'RemittanceRemark';

