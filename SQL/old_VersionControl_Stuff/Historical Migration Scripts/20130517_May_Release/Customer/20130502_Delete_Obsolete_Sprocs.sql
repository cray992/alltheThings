-- DROP all 'esop_%', 'mm_%', and 'apl_%' sprocs
declare @procName varchar(500)
declare cur cursor 

FOR SELECT [name]
FROM sys.procedures
WHERE name LIKE 'eosp_%' OR name LIKE 'mm_%' OR name LIKE 'apl_%'
open cur
fetch next from cur into @procName
while @@fetch_status = 0
BEGIN
	exec('drop procedure ' + @procName)
	fetch next from cur into @procName
end
close cur
deallocate cur

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'ReportDataProvider_ContractsAndFees_SuccessMetrics')
	DROP PROC ReportDataProvider_ContractsAndFees_SuccessMetrics 
--IF EXISTS (SELECT * FROM sys.views WHERE name = 'ReportDataProvider_vProcedureCodeRevenueCenterCategory')
	--DROP VIEW ReportDataProvider_vProcedureCodeRevenueCenterCategory
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'PracticeDataProvider_GetPracticeByEIN')
	DROP PROC PracticeDataProvider_GetPracticeByEIN
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'PracticeDataProvider_GetEligibilityVendorTransportInfo')
	DROP PROC PracticeDataProvider_GetEligibilityVendorTransportInfo
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'Shared_CustomerDataProvider_CreateCustomerDatabase')
	DROP PROC Shared_CustomerDataProvider_CreateCustomerDatabase
	
