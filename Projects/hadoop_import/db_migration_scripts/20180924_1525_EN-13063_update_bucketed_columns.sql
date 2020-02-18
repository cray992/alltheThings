
Use ReportingLog;

--PaymentClaim Updating all the columns needed to set the bucketed columns.
update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'PaymentClaim'
  and C.ColumnName in ('PaymentId','PracticeId','ClaimId');


--AdjusmentReason Updating all the columns needed to set the bucketed column.
update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'AdjustmentReason'
  and C.ColumnName = 'AdjustmentReasonCode';

--RemittanceRemark Updating all the columns needed to set the bucketed column.
update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'RemittanceRemark'
  and C.ColumnName = 'RemittanceID';

--SF_Account Updating all the columns needed to set the bucketed column.
update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'SF_Account'
  and C.ColumnName = 'ETL_ID';

--SF_Account Updating all the columns needed to set the bucketed column.
update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'SF_User'
  and C.ColumnName = 'ETL_ID';

--ProviderType Updating all the columns needed to set the bucketed column.
update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'ProviderType'
  and C.ColumnName = 'ProviderTypeId';
