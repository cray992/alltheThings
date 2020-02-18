USE superbill_2039_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @OldVendorImportID INT

SET @PracticeID = 37
SET @VendorImportID = 57
SET @OldVendorImportID = 52

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
PRINT 'OldVendorImportID = ' + CAST(@OldVendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Updating Patient Date of Birth...'
UPDATE dbo.Patient
	SET DOB = imp.dateofbirth
	from dbo.[_import_57_37_PatientDemographics] AS imp
	WHERE Patient.VendorImportID = @OldVendorImportID AND Patient.PracticeID = @PracticeID 
		  AND Patient.MedicalRecordNumber = imp.chartnumber AND
		  Patient.FirstName = imp.firstname AND Patient.LastName = imp.lastname
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT 