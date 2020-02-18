Use ReportingLog;
-- Clearing PaymentClaimID flag
update C
  set C.isMergeMatch = 0
from HDP_ColumnsToImport C
  inner join HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'PaymentClaim'
  and C.ColumnName = 'PaymentClaimID';
-- Setting 3 columns PK to true
update C
  set C.isMergeMatch = 1
from HDP_ColumnsToImport C
  inner join HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'PaymentClaim'
  and C.ColumnName in ('PaymentId','PracticeId','ClaimId');