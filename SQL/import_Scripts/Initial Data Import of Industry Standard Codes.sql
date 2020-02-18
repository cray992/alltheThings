---------------------------------------------------------------------------------------
--case 3632 - Initial data import of industry standard procedure codes

--INSERT Existing Procedures Codes
INSERT INTO superbill_shared.dbo.ProcedureCodeDictionary(ProcedureCode,ProcedureName,Description)
SELECT ProcedureCode,ProcedureName,Description
FROM superbill_0001_dev.dbo.ProcedureCodeDictionary

--Create The Association to Shared by Updating the KareoProcedureCodeDictionaryID &
--KareoLastModifiedDate fields
UPDATE superbill_0001_dev.dbo.ProcedureCodeDictionary
SET KareoProcedureCodeDictionaryID=S.ProcedureCodeDictionaryID,
KareoLastModifiedDate=S.CreatedDate
FROM superbill_0001_dev.dbo.ProcedureCodeDictionary C INNER JOIN 
superbill_shared.dbo.ProcedureCodeDictionary S ON C.ProcedureCode=S.ProcedureCode

--Uncomment if you want to 
--Clear Out Existing Procedure Codes From Dictionary Table, and 
--Insert new Kareo codes
-- DELETE CustomerModel.dbo.ProcedureCategoryToProcedureCodeDictionary
-- 
-- DELETE CustomerModel.dbo.ProcedureCategory
-- 
-- DELETE CustomerModel.dbo.ProcedureCodeDictionary
-- 
-- INSERT INTO CustomerModel.dbo.ProcedureCodeDictionary(ProcedureCode,ProcedureName,Description,
-- KareoProcedureCodeDictionaryID,KareoLastModifiedDate)
-- SELECT ProcedureCode,ProcedureName,Description,ProcedureCodeDictionaryID,CreatedDate)
-- FROM superbill_shared.dbo.ProcedureCodeDictionary

--Create The Association to CustomerModel by Updating the 
--KareoProcedureCodeDictionaryID,KareoLastModifiedDate fields
UPDATE CustomerModel.dbo.ProcedureCodeDictionary
SET KareoProcedureCodeDictionaryID=S.ProcedureCodeDictionaryID,
KareoLastModifiedDate=S.CreatedDate
FROM CustomerModel.dbo.ProcedureCodeDictionary C INNER JOIN 
superbill_shared.dbo.ProcedureCodeDictionary S ON C.ProcedureCode=S.ProcedureCode

---------------------------------------------------------------------------------------
--case 3633 - Initial data import of industry standard diagnosis codes

--INSERT Existing Diagnosis Codes
INSERT INTO superbill_shared.dbo.DiagnosisCodeDictionary(DiagnosisCode,DiagnosisName,Description)
SELECT DiagnosisCode,DiagnosisName,Description
FROM superbill_0001_dev.dbo.DiagnosisCodeDictionary

--Create The Association to Shared by Updating the KareoDiagnosisCodeDictionaryID &
--KareoLastModifiedDate fields
UPDATE C_DC
SET KareoDiagnosisCodeDictionaryID=S.DiagnosisCodeDictionaryID,
KareoLastModifiedDate=S.CreatedDate
FROM superbill_0001_dev.dbo.DiagnosisCodeDictionary C_DC INNER JOIN 
superbill_shared.dbo.DiagnosisCodeDictionary S ON 
C_DC.DiagnosisCode=S.DiagnosisCode

--DELETE Previous Customer Model default Diagnosis list and add new Kareo list
DELETE CustomerModel.dbo.DiagnosisCodeDictionary

INSERT INTO CustomerModel.dbo.DiagnosisCodeDictionary(DiagnosisCode,DiagnosisName,Description,
KareoDiagnosisCodeDictionaryID, KareoLastModifiedDate)
SELECT DiagnosisCode,DiagnosisName,Description,DiagnosisCodeDictionaryID,CreatedDate
FROM superbill_shared.dbo.DiagnosisCodeDictionary