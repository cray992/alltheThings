USE superbill_30681_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Deleting from Patient Case Date...'
DELETE FROM dbo.PatientCaseDate WHERE ModifiedUserID = -50 AND PatientCaseID IN 
	(SELECT PatientCaseID FROM dbo.PatientCase WHERE PatientID IN 
		(SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'


--ROLLBACK
--COMMIT

