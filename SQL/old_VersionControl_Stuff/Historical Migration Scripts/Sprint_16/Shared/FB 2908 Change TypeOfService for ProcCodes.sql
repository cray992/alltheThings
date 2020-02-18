UPDATE dbo.ProcedureCodeDictionary
SET TypeOfServiceCode = '1', ModifiedDate = GETDATE()
WHERE ProcedureCode LIKE 'H%'