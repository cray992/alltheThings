Use ReportingLog;

UPDATE HDP_TablesToImport SET ImportTypeID=2
WHERE TableName IN ('Contract','ContractFeeSchedule', 'EncounterHistory', 'ICD9ToICD10Crosswalk')
AND ImportTypeId >0;

UPDATE HDP_TablesToImport SET ImportTypeID=0
WHERE TableName IN ('RemittanceRemark');

UPDATE HDP_ColumnsToImport SET isMergeMatch=1
WHERE ColumnID in
(
SELECT c.ColumnID
FROM HDP_ColumnsToImport c
JOIN HDP_TablesToImport t ON c.tableID=t.tableId
WHERE
(
    (TableName = 'AdjustmentReason' AND ColumnName='AdjustmentReasonCode') OR
    (TableName = 'ProcedureCodeDictionary' AND ColumnName='ProcedureCodeDictionaryID') OR
    (TableName = 'ICD9ToICD10Crosswalk' AND ColumnName='ICD9ToICD10CrosswalkId') OR
    (TableName = 'EncounterHistory' AND ColumnName='EncounterID')
)
AND t.ImportTypeId >0
);
