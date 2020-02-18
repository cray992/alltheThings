USE superbill_57421_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID: ' + CAST(@PracticeID AS VARCHAR)
PRINT 'VendorImportID: ' + CAST(@VendorImportID AS VARCHAR)
PRINT ''

UPDATE dbo.Patient 
SET Suffix = '' , 
	CreatedDate = GETDATE() , 
	ModifiedDate = GETDATE()
WHERE Suffix <> '' AND VendorImportID = @VendorImportID AND PracticeID = @PracticeID AND ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient records updated - Suffix'

--ROLLBACK
--COMMIT



