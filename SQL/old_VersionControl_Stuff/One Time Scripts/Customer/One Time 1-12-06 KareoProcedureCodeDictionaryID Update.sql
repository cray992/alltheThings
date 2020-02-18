UPDATE PCD SET KareoProcedureCodeDictionaryID=SPCD.ProcedureCodeDictionaryID
FROM ProcedureCodeDictionary PCD INNER JOIN superbill_shared..ProcedureCodeDictionary SPCD
ON PCD.ProcedureCode=SPCD.ProcedureCode
