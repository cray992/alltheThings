--USE superbill_43280_dev
USE superbill_43280_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Deleting From PatientCaseDate...'
DELETE FROM dbo.PatientCaseDate 
	WHERE PatientCaseID IN 
		(SELECT PatientCaseID FROM dbo.PatientCase WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
	
--ROLLBACK
--COMMIT



