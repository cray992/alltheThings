-- Merge Diagnosis codes then delete the duplicate records

-- Create Temp Table of Duplicate DiagnosisCodeDictionaryID
-- These are the keepers and are based on Min IDs
DECLARE @Rows INT
DECLARE @Message VarChar(250)

Begin Transaction
Begin

SELECT 
MIN(DiagnosisCodeDictionaryID) AS MinDiagCodeDicID, 
DiagnosisCode, 
COUNT(DiagnosisCode) AS CntDiagCode
INTO #TempDiagCodes_KEEP
FROM DiagnosisCodeDictionary
GROUP BY DiagnosisCode
HAVING (COUNT(DiagnosisCode) > 1)

SET @Rows = @@RowCount
Select @Message = 'Duplicate Keepers in DiagnosisCodeDictionary Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- Create Temp Table of DiagCodes to delete
SELECT 
DiagnosisCodeDictionary.DiagnosisCodeDictionaryID, 
DiagnosisCodeDictionary.DiagnosisCode
INTO #TempDiagCodes_DELETE
FROM DiagnosisCodeDictionary 
INNER JOIN
#TempDiagCodes_KEEP AS Keepers 
ON DiagnosisCodeDictionary.DiagnosisCode = Keepers.DiagnosisCode 
AND DiagnosisCodeDictionary.DiagnosisCodeDictionaryID <> Keepers.MinDiagCodeDicID
GROUP BY DiagnosisCodeDictionary.DiagnosisCodeDictionaryID, DiagnosisCodeDictionary.DiagnosisCode

SET @Rows = @@RowCount
Select @Message = 'Duplicates to Delete in DiagnosisCodeDictionary Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- Update ContractFeeSchedule
UPDATE ContractFeeSchedule
SET ContractFeeSchedule.DiagnosisCodeDictionaryID = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM ContractFeeSchedule 
INNER JOIN #TempDiagCodes_DELETE 
ON  ContractFeeSchedule.DiagnosisCodeDictionaryID = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode


SET @Rows = @@RowCount
Select @Message = 'Duplicates to merge in ContractFeeSchedule Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- Update EncounterDiagnosis
UPDATE EncounterDiagnosis
SET EncounterDiagnosis.DiagnosisCodeDictionaryID = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN EncounterDiagnosis 
ON #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID = EncounterDiagnosis.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates to merge in EncounterDiagnosis Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- DiagnosisCategoryToDiagnosisCodeDictionary
UPDATE DiagnosisCategoryToDiagnosisCodeDictionary
SET DiagnosisCategoryToDiagnosisCodeDictionary.DiagnosisCodeDictionaryID = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN DiagnosisCategoryToDiagnosisCodeDictionary 
ON #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID = DiagnosisCategoryToDiagnosisCodeDictionary.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in DiagnosisCategoryToDiagnosisCodeDictionary Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- EncounterDiagnosis
UPDATE EncounterDiagnosis
SET EncounterDiagnosis.DiagnosisCodeDictionaryID = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN EncounterDiagnosis 
ON #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID = EncounterDiagnosis.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in EncounterDiagnosis Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- HandheldEncounter
UPDATE HandheldEncounter
SET HandheldEncounter.DiagnosisCodeDictionaryID1 = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN HandheldEncounter 
ON HandheldEncounter.DiagnosisCodeDictionaryID1 = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in HandheldEncounter-1 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- HandheldEncounter
UPDATE HandheldEncounter
SET HandheldEncounter.DiagnosisCodeDictionaryID2 = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN HandheldEncounter 
ON HandheldEncounter.DiagnosisCodeDictionaryID2 = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in HandheldEncounter-2 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- HandheldEncounter
UPDATE HandheldEncounter
SET HandheldEncounter.DiagnosisCodeDictionaryID3 = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN HandheldEncounter 
ON HandheldEncounter.DiagnosisCodeDictionaryID3 = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in HandheldEncounter-3 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- HandheldEncounter
UPDATE HandheldEncounter
SET HandheldEncounter.DiagnosisCodeDictionaryID4 = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN HandheldEncounter 
ON HandheldEncounter.DiagnosisCodeDictionaryID4 = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in HandheldEncounter-4 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- HandheldEncounterDetail-1
UPDATE HandheldEncounterDetail
SET HandheldEncounterDetail.DiagnosisCodeDictionaryID1 = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN HandheldEncounterDetail 
ON HandheldEncounterDetail.DiagnosisCodeDictionaryID1 = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in HandheldEncounterDetail-1 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- HandheldEncounterDetail-2
UPDATE HandheldEncounterDetail
SET HandheldEncounterDetail.DiagnosisCodeDictionaryID2 = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN HandheldEncounterDetail 
ON HandheldEncounterDetail.DiagnosisCodeDictionaryID2 = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in HandheldEncounterDetail-2 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- HandheldEncounterDetail-3
UPDATE HandheldEncounterDetail
SET HandheldEncounterDetail.DiagnosisCodeDictionaryID3 = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN HandheldEncounterDetail 
ON HandheldEncounterDetail.DiagnosisCodeDictionaryID3 = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in HandheldEncounterDetail-3 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- HandheldEncounterDetail-4
UPDATE HandheldEncounterDetail
SET HandheldEncounterDetail.DiagnosisCodeDictionaryID4 = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN HandheldEncounterDetail 
ON HandheldEncounterDetail.DiagnosisCodeDictionaryID4 = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in HandheldEncounterDetail-4 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- ProcedureMacroDetail-1
UPDATE ProcedureMacroDetail
SET ProcedureMacroDetail.DiagnosisCodeDictionaryID1 = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN ProcedureMacroDetail 
ON ProcedureMacroDetail.DiagnosisCodeDictionaryID1 = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in ProcedureMacroDetail-1 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- ProcedureMacroDetail-2
UPDATE ProcedureMacroDetail
SET ProcedureMacroDetail.DiagnosisCodeDictionaryID2 = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN ProcedureMacroDetail 
ON ProcedureMacroDetail.DiagnosisCodeDictionaryID2 = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in ProcedureMacroDetail-2 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- ProcedureMacroDetail-3
UPDATE ProcedureMacroDetail
SET ProcedureMacroDetail.DiagnosisCodeDictionaryID3 = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN ProcedureMacroDetail 
ON ProcedureMacroDetail.DiagnosisCodeDictionaryID3 = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in ProcedureMacroDetail-1 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- ProcedureMacroDetail-4
UPDATE ProcedureMacroDetail
SET ProcedureMacroDetail.DiagnosisCodeDictionaryID4 = #TempDiagCodes_KEEP.MinDiagCodeDicID
FROM #TempDiagCodes_DELETE 
INNER JOIN #TempDiagCodes_KEEP 
ON #TempDiagCodes_DELETE.DiagnosisCode = #TempDiagCodes_KEEP.DiagnosisCode 
INNER JOIN ProcedureMacroDetail 
ON ProcedureMacroDetail.DiagnosisCodeDictionaryID4 = #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates merged in ProcedureMacroDetail-4 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )



-- Delete duplicates in DiagnosisCodeDictionary
DELETE DiagnosisCodeDictionary
FROM #TempDiagCodes_DELETE 
INNER JOIN DiagnosisCodeDictionary 
ON #TempDiagCodes_DELETE.DiagnosisCodeDictionaryID = DiagnosisCodeDictionary.DiagnosisCodeDictionaryID

SET @Rows = @@RowCount
Select @Message = 'Duplicates Deleted in DiagnosisCodeDictionary Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

End
-- ROLLBACK
-- Commit Transaction

