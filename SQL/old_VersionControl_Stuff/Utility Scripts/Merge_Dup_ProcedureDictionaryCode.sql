-- Script for merging duplicate ProcedureCodeDictionary records
-- CBagby 11/21/06

-- Create Temp Table of duplicate ProcedureCodeDictionary records to keep
-- this is based on Min IDs

SELECT ProcedureCodeDictionaryID, ProcedureCode
INTO #TempKeepPCD
FROM ProcedureCodeDictionary AS PCD_Out
WHERE EXISTS(
SELECT NULL AS Expr1
FROM ProcedureCodeDictionary AS PCD_in
WHERE PCD_in.ProcedureCode = PCD_Out.ProcedureCode
GROUP BY ProcedureCode
HAVING (PCD_Out.ProcedureCodeDictionaryID = MIN(PCD_In.ProcedureCodeDictionaryID))
AND (COUNT(ProcedureCode) > 1))
ORDER BY ProcedureCodeDictionaryID

-- TempTable of records to delete
SELECT ProcedureCodeDictionaryID, ProcedureCode
INTO #TempDeletePCD
FROM ProcedureCodeDictionary AS PCD_Out
WHERE EXISTS(
SELECT NULL AS Expr1
FROM ProcedureCodeDictionary AS PCD_in
WHERE PCD_in.ProcedureCode = PCD_Out.ProcedureCode
GROUP BY ProcedureCode
HAVING (PCD_Out.ProcedureCodeDictionaryID > MIN(PCD_In.ProcedureCodeDictionaryID))
AND (COUNT(ProcedureCode) > 1))
ORDER BY ProcedureCodeDictionaryID


-- Update EncounterProcedure table
UPDATE EncounterProcedure
SET EncounterProcedure.ProcedureCodeDictionaryID = TmpKeepPCD.ProcedureCodeDictionaryID
FROM EncounterProcedure 
INNER JOIN #TempDeletePCD AS TmpDeletePCD 
ON EncounterProcedure.ProcedureCodeDictionaryID = TmpDeletePCD.ProcedureCodeDictionaryID 
INNER JOIN #TempKeepPCD AS TmpKeepPCD 
ON TmpDeletePCD.ProcedureCode = TmpKeepPCD.ProcedureCode

-- Update ContractFeeSchedule
UPDATE ContractFeeSchedule
SET  ContractFeeSchedule.ProcedureCodeDictionaryID = TmpKeepPCD.ProcedureCodeDictionaryID
FROM #TempDeletePCD AS TmpDeletePCD 
INNER JOIN #TempKeepPCD AS TmpKeepPCD 
ON TmpDeletePCD.ProcedureCode = TmpKeepPCD.ProcedureCode 
INNER JOIN ContractFeeSchedule 
ON TmpDeletePCD.ProcedureCodeDictionaryID = ContractFeeSchedule.ProcedureCodeDictionaryID

-- Update ProcedureCategoryToProcedureCodeDictionary
UPDATE ProcedureCategoryToProcedureCodeDictionary
SET ProcedureCategoryToProcedureCodeDictionary.ProcedureCodeDictionaryID = TmpKeepPCD.ProcedureCodeDictionaryID
FROM #TempDeletePCD AS TmpDeletePCD 
INNER JOIN #TempKeepPCD AS TmpKeepPCD 
ON TmpDeletePCD.ProcedureCode = TmpKeepPCD.ProcedureCode 
INNER JOIN ProcedureCategoryToProcedureCodeDictionary 
ON TmpDeletePCD.ProcedureCodeDictionaryID = ProcedureCategoryToProcedureCodeDictionary.ProcedureCodeDictionaryID

--Add a Section changing ProcedureMacroDetail
UPDATE ProcedureMacroDetail
SET ProcedureMacroDetail.ProcedureCodeDictionaryID = TmpKeepPCD.ProcedureCodeDictionaryID
FROM #TempDeletePCD AS TmpDeletePCD 
INNER JOIN #TempKeepPCD AS TmpKeepPCD 
ON TmpDeletePCD.ProcedureCode = TmpKeepPCD.ProcedureCode 
INNER JOIN ProcedureMacroDetail 
ON TmpDeletePCD.ProcedureCodeDictionaryID = ProcedureMacroDetail.ProcedureCodeDictionaryID


--Add a Section changing HandheldEncounterDetail
UPDATE HandheldEncounterDetail
SET HandheldEncounterDetail.ProcedureCodeDictionaryID = TmpKeepPCD.ProcedureCodeDictionaryID
FROM #TempDeletePCD AS TmpDeletePCD 
INNER JOIN #TempKeepPCD AS TmpKeepPCD 
ON TmpDeletePCD.ProcedureCode = TmpKeepPCD.ProcedureCode 
INNER JOIN HandheldEncounterDetail 
ON TmpDeletePCD.ProcedureCodeDictionaryID = HandheldEncounterDetail.ProcedureCodeDictionaryID

--Add a Section changing HandheldEncounter1
UPDATE HandheldEncounter
SET HandheldEncounter.ProcedureCodeDictionaryID1 = TmpKeepPCD.ProcedureCodeDictionaryID
FROM #TempDeletePCD AS TmpDeletePCD 
INNER JOIN #TempKeepPCD AS TmpKeepPCD 
ON TmpDeletePCD.ProcedureCode = TmpKeepPCD.ProcedureCode 
INNER JOIN HandheldEncounter 
ON HandheldEncounter.ProcedureCodeDictionaryID1 = TmpDeletePCD.ProcedureCodeDictionaryID


--Add a Section changing HandheldEncounter2
UPDATE HandheldEncounter
SET HandheldEncounter.ProcedureCodeDictionaryID2 = TmpKeepPCD.ProcedureCodeDictionaryID
FROM #TempDeletePCD AS TmpDeletePCD 
INNER JOIN #TempKeepPCD AS TmpKeepPCD 
ON TmpDeletePCD.ProcedureCode = TmpKeepPCD.ProcedureCode 
INNER JOIN HandheldEncounter 
ON HandheldEncounter.ProcedureCodeDictionaryID2 = TmpDeletePCD.ProcedureCodeDictionaryID


--Add a Section changing HandheldEncounter3
UPDATE HandheldEncounter
SET HandheldEncounter.ProcedureCodeDictionaryID3 = TmpKeepPCD.ProcedureCodeDictionaryID
FROM #TempDeletePCD AS TmpDeletePCD 
INNER JOIN #TempKeepPCD AS TmpKeepPCD 
ON TmpDeletePCD.ProcedureCode = TmpKeepPCD.ProcedureCode 
INNER JOIN HandheldEncounter 
ON HandheldEncounter.ProcedureCodeDictionaryID3 = TmpDeletePCD.ProcedureCodeDictionaryID


--Add a Section changing HandheldEncounter4
UPDATE HandheldEncounter
SET HandheldEncounter.ProcedureCodeDictionaryID4 = TmpKeepPCD.ProcedureCodeDictionaryID
FROM #TempDeletePCD AS TmpDeletePCD 
INNER JOIN #TempKeepPCD AS TmpKeepPCD 
ON TmpDeletePCD.ProcedureCode = TmpKeepPCD.ProcedureCode 
INNER JOIN HandheldEncounter 
ON HandheldEncounter.ProcedureCodeDictionaryID4 = TmpDeletePCD.ProcedureCodeDictionaryID

--Add a Section changing HandheldEncounter5
UPDATE HandheldEncounter
SET HandheldEncounter.ProcedureCodeDictionaryID5 = TmpKeepPCD.ProcedureCodeDictionaryID
FROM #TempDeletePCD AS TmpDeletePCD 
INNER JOIN #TempKeepPCD AS TmpKeepPCD 
ON TmpDeletePCD.ProcedureCode = TmpKeepPCD.ProcedureCode 
INNER JOIN HandheldEncounter 
ON HandheldEncounter.ProcedureCodeDictionaryID5 = TmpDeletePCD.ProcedureCodeDictionaryID

--Add a Section changing HandheldEncounter6
UPDATE HandheldEncounter
SET HandheldEncounter.ProcedureCodeDictionaryID6 = TmpKeepPCD.ProcedureCodeDictionaryID
FROM #TempDeletePCD AS TmpDeletePCD 
INNER JOIN #TempKeepPCD AS TmpKeepPCD 
ON TmpDeletePCD.ProcedureCode = TmpKeepPCD.ProcedureCode 
INNER JOIN HandheldEncounter 
ON HandheldEncounter.ProcedureCodeDictionaryID6 = TmpDeletePCD.ProcedureCodeDictionaryID

--Add a Section changing MasterFee
UPDATE MasterFee
SET MasterFee.ProcedureCodeDictionaryID = TmpKeepPCD.ProcedureCodeDictionaryID
FROM #TempDeletePCD AS TmpDeletePCD 
INNER JOIN #TempKeepPCD AS TmpKeepPCD 
ON TmpDeletePCD.ProcedureCode = TmpKeepPCD.ProcedureCode 
INNER JOIN MasterFee 
ON MasterFee.ProcedureCodeDictionaryID = TmpDeletePCD.ProcedureCodeDictionaryID

-- Delete Duplicates in ProcedureCodeDictionary
DELETE FROM ProcedureCodeDictionary
FROM  #TempDeletePCD AS TmpDeletePCD 
INNER JOIN ProcedureCodeDictionary 
ON TmpDeletePCD.ProcedureCodeDictionaryID = ProcedureCodeDictionary.ProcedureCodeDictionaryID


DROP TABLE #TempKeepPCD
DROP TABLE #TempDeletePCD