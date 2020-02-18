USE ReportingLog

update C
  set C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'CapitatedAccountToPayment'
  and C.ColumnName = 'CapitatedAccountID';
