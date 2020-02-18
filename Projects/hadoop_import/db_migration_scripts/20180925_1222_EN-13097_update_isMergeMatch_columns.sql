Use ReportingLog;

--ClaimAccounting_Errors Updating all the columns needed to set the bucketed columns.
update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'ClaimAccounting_Errors'
  and C.ColumnName in ('PracticeId','ClaimId');

--ClaimAccounting_FollowUp Updating all the columns needed to set the bucketed columns.
update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'ClaimAccounting_FollowUp'
  and C.ColumnName in ('PracticeId','ClaimId');


--TaxonomySpecialty Updating all the columns needed to set the bucketed columns.
update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'TaxonomySpecialty'
  and C.ColumnName in ('TaxonomyTypeCode','TaxonomySpecialtyCode');