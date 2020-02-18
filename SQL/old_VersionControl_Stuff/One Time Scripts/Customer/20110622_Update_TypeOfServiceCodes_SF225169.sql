-- SF 225169

UPDATE dbo.ProcedureCodeDictionary
SET TypeOfServiceCode = 5
WHERE ProcedureCode IN ('82271', '82270', '17311', '17312', '17313', '17314', '17315') AND TypeOfServiceCode = 1