--RUN THIS SCRIPT ONLY IN DR

Use ReportingLog;

update dbo.HDP_TablesToImport
set ImportTypeID = 2
where TableName='Contract' and SourceID = 1

update dbo.HDP_TablesToImport
set ImportTypeID = 2
where TableName='ContractFeeSchedule' and SourceID = 1

update dbo.HDP_TablesToImport
set ImportTypeID = 0
where TableName='AdjustmentReason' and SourceID = 2

update dbo.HDP_TablesToImport
set ImportTypeID = 1
where TableName='AdjustmentReason' and SourceID = 1

update dbo.HDP_TablesToImport
set ImportTypeID = 2
where TableName='CapitatedAccountToPayment' and SourceID = 1

