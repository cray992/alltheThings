
update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'AdjustmentReason'
  and C.ColumnName = 'AdjustmentReasonCode';


update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'RemittanceRemark'
  and C.ColumnName = 'RemittanceID';


update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'SF_Account'
  and C.ColumnName = 'ETL_ID';

 update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'SF_User'
  and C.ColumnName = 'ETL_ID';


 update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'ProviderType'
  and C.ColumnName = 'ProviderTypeId';


 update C
  set C.ColumnImportFlag = 1,
  C.StagedImportFlag = 1,
  C.isMergeMatch = 1
from dbo.HDP_ColumnsToImport C
  inner join dbo.HDP_TablesToImport T on T.TableID = C.TableID
where T.TableName = 'TaxonomySpecialty'
  and C.ColumnName in ('TaxonomyTypeCode','TaxonomySpecialtyCode');