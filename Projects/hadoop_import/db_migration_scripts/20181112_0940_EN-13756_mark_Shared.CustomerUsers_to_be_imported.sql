USE ReportingLog

UPDATE HDP_TablesToImport SET ImportTypeID=1 where TableName = 'CustomerUsers' and SourceId = 2

update C
  set C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'CustomerUsers'
  and T.SourceId=2
  and C.ColumnName in ('CustomerID', 'UserID')
