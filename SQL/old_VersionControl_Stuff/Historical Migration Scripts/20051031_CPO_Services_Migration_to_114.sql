/*
Imports into 114 database
*/

INSERT INTO  ProcedureCodeDictionary (ProcedureCode, ProcedureName, TypeOfServiceCode)
SELECT dbo.TranCodeImported.Code, dbo.TranCodeImported.[Description], dbo.TranCodeImported.Type 
FROM dbo.TranCodeImported
WHERE dbo.TranCodeImported.Code NOT IN (SELECT ProcedureCode FROM ProcedureCodeDictionary)


INSERT INTO dbo.PracticeFee (PracticeFeeScheduleID, PracticeID, ProcedureCodeDictionaryID, ChargeAmount)
SELECT 1, 1, ProcedureCodeDictionary.ProcedureCodeDictionaryID, Convert(money, dbo.TranCodeImported.[Default Charge]) 
FROM  ProcedureCodeDictionary, TranCodeImported 
WHERE dbo.TranCodeImported.Code = ProcedureCodeDictionary.ProcedureCode

INSERT INTO dbo.DiagnosisCodeDictionary (DiagnosisCode, DiagnosisName)
	SELECT [ICD 9], [Description] FROM dbo.DiagnosisImported


