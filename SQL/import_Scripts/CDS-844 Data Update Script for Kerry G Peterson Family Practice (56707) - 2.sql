USE superbill_56707_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 1

SET NOCOUNT ON 

-- Deleting Balance Forward Encounters where a Claim has not been created
PRINT 'Deleting From Encounter Diagnosis...'
DELETE FROM dbo.EncounterDiagnosis WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE VendorImportID = @VendorImportID AND 
PracticeID = @PracticeID AND EncounterStatusID = 1)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT 'Deleting From Encounter Procedure...'
DELETE FROM dbo.EncounterProcedure WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE VendorImportID = @VendorImportID AND 
PracticeID = @PracticeID AND EncounterStatusID = 1)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT 'Deleting From Encounter...'
DELETE FROM dbo.Encounter WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID AND EncounterStatusID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

--ROLLBACK
--COMMIT

