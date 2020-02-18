-- DROP all 'dt_%'
declare @procName varchar(500)
declare cur cursor 

FOR SELECT [name]
FROM sys.procedures
WHERE name LIKE 'dt_%'
open cur
fetch next from cur into @procName
while @@fetch_status = 0
begin
    exec('drop procedure ' + @procName)
    fetch next from cur into @procName
end
close cur
deallocate cur

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Shared_AggregateReportingData')
	DROP PROC Shared_AggregateReportingData
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'ReportDataProvider_CustomerGradInfo')
	DROP PROC ReportDataProvider_CustomerGradInfo
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Shared_CustomerDataProvider_RecreateCustomerDatabase')
	DROP PROC Shared_CustomerDataProvider_RecreateCustomerDatabase
