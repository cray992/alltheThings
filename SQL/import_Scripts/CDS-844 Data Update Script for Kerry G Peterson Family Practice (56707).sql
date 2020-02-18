USE superbill_56707_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 1

SET NOCOUNT ON 

-- assign enoucnter diagnosis to encounter procedure. Bad join on import script via NET-14341
PRINT ''
PRINT 'Updating Encounter Procedure...'
UPDATE dbo.EncounterProcedure
	SET  EncounterDiagnosisID1 = ed_5.EncounterDiagnosisID ,
		 EncounterDiagnosisID2 = ed_6.EncounterDiagnosisID ,
		 EncounterDiagnosisID3 = ed_7.EncounterDiagnosisID ,
		 EncounterDiagnosisID4 = ed_8.EncounterDiagnosisID ,
		 EncounterDiagnosisID5 = ed_1.EncounterDiagnosisID ,
		 EncounterDiagnosisID6 = ed_2.EncounterDiagnosisID ,
		 EncounterDiagnosisID7 = ed_3.EncounterDiagnosisID ,
		 EncounterDiagnosisID8 = ed_4.EncounterDiagnosisID 
FROM dbo.EncounterProcedure e
LEFT JOIN dbo.EncounterDiagnosis ed_5 ON 
	ed_5.EncounterID = e.EncounterID  AND
    ed_5.ListSequence = 5 AND
    ed_5.VendorImportID = @VendorImportID AND
    RIGHT(ed_5.VendorID,LEN(ed_5.vendorid)-CHARINDEX('|',ed_5.VendorID)) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_6 ON 
	ed_6.EncounterID = e.EncounterID AND
    ed_6.ListSequence = 6 AND
    ed_6.VendorImportID = @VendorImportID AND
    RIGHT(ed_6.VendorID,LEN(ed_6.vendorid)-CHARINDEX('|',ed_6.VendorID)) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_7 ON 
	ed_7.EncounterID = e.EncounterID AND
    ed_7.ListSequence = 7 AND
    ed_7.VendorImportID = @VendorImportID AND
    RIGHT(ed_7.VendorID,LEN(ed_7.vendorid)-CHARINDEX('|',ed_7.VendorID)) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_8 ON 
	ed_8.EncounterID = e.EncounterID AND
    ed_8.ListSequence = 8 AND
    ed_8.VendorImportID = @VendorImportID AND
    RIGHT(ed_8.VendorID,LEN(ed_8.vendorid)-CHARINDEX('|',ed_8.VendorID)) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_1 ON 
	ed_1.EncounterID = e.EncounterID AND
    ed_1.ListSequence = 1 AND
    ed_1.VendorImportID = @VendorImportID AND
    RIGHT(ed_1.VendorID,LEN(ed_1.vendorid)-CHARINDEX('|',ed_1.VendorID)) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_2 ON 
	ed_2.EncounterID = e.EncounterID AND
    ed_2.ListSequence = 2 AND
    ed_2.VendorImportID = @VendorImportID AND
    RIGHT(ed_2.VendorID,LEN(ed_2.vendorid)-CHARINDEX('|',ed_2.VendorID)) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_3 ON 
	ed_3.EncounterID = e.EncounterID AND
    ed_3.ListSequence = 3 AND
    ed_3.VendorImportID = @VendorImportID AND
     RIGHT(ed_3.VendorID,LEN(ed_3.vendorid)-CHARINDEX('|',ed_3.VendorID)) = e.VendorID
LEFT JOIN dbo.EncounterDiagnosis ed_4 ON 
	ed_4.EncounterID = e.EncounterID AND
    ed_4.ListSequence = 4 AND
    ed_4.VendorImportID = @VendorImportID AND
    RIGHT(ed_4.VendorID,LEN(ed_4.vendorid)-CHARINDEX('|',ed_4.VendorID)) = e.VendorID
WHERE e.VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

-- Delete encounters that were assigned to a provider record not longer with the practice from source data
CREATE TABLE #encdelete (EncounterID INT)
INSERT INTO #encdelete ( EncounterID )
SELECT DISTINCT e.EncounterID
FROM dbo.Encounter e 
	INNER JOIN dbo._import_1_2_ChargeDetail impcd ON
		e.VendorID = impcd.visitfid
	INNER JOIN dbo._import_2_2_Appointments ia ON
		impcd.visitfid = ia.appointmentuid
	INNER JOIN dbo._import_1_2_Providers id ON 
		ia.pgproviderfid = id.pgprovideruid 
	INNER JOIN dbo.PatientCase pc ON
		e.PatientCaseID = pc.PatientCaseID
WHERE ia.pgproviderfid = 24 AND pc.VendorImportID = @VendorImportID

PRINT ''
PRINT 'Deleting From Encounter Diangnosis...'
DELETE FROM dbo.EncounterDiagnosis WHERE EncounterID IN (SELECT EncounterID FROM #encdelete) AND ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Encounter Procedure...'
DELETE FROM dbo.EncounterProcedure WHERE EncounterID IN (SELECT EncounterID FROM #encdelete) AND ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Encounter...'
DELETE FROM dbo.Encounter WHERE EncounterID IN (SELECT EncounterID FROM #encdelete) AND EncounterStatusID = 1 AND ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

DROP TABLE #encdelete

--ROLLBACK
--COMMIT



