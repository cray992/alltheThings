USE ReportingLog

UPDATE c SET StagedImportFlag=1
FROM HDP_ColumnsToImport c join HDP_TablesToImport t on c.TableId=t.TableId
WHERE c.ColumnName='RelativePrecedence' and t.TableName='ClaimAccounting_Assignments'
