--USE superbill_50391_dev
USE superbill_50391_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT
SET @PracticeID = 1

PRINT ''
PRINT 'Deleting From Encounter Diagnosis...'
DELETE FROM dbo.EncounterDiagnosis 
WHERE PracticeID = @PracticeID AND VendorImportID IN (1,3,8) AND ModifiedUserID = 0 AND CreatedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Encounter Procedure...'
DELETE FROM dbo.EncounterProcedure
WHERE PracticeID = @PracticeID AND VendorImportID IN (1,3,8) AND ModifiedUserID = 0 AND CreatedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Encounter...'
DELETE FROM dbo.Encounter
WHERE PracticeID = @PracticeID AND VendorImportID IN (1,3,8) AND ModifiedUserID = 0 AND CreatedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Patient Alert...'
DELETE FROM dbo.PatientAlert 
WHERE ModifiedUserID = 0 AND CAST(AlertMessage AS VARCHAR (MAX)) = 'Balance Forward Encounter is Present'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'


--ROLLBACK
--COMMIT
