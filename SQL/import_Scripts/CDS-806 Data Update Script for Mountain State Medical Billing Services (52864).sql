--USE superbill_52864_dev
USE superbill_52864_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 4

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Updating Patient - ZipCode...'
UPDATE dbo.Patient
	SET ZipCode = REPLACE(REPLACE(i.zipcode,'.00',''),'-','')
FROM dbo.[_import_5_1_PatientDemographics] i 
	INNER JOIN dbo.Patient p ON 
		i.chartnumber = p.VendorID AND 
		p.VendorImportID = @VendorImportID
WHERE p.CreatedUserID = 0 AND p.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT


