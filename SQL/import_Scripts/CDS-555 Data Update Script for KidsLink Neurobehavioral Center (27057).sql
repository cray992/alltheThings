USE superbill_27057_dev
--USE superbill_27057_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 5

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Update Patient Address...'
UPDATE dbo.Patient
	SET AddressLine1 = i.street1 ,
		AddressLine2 = i.street2 ,
		City = i.city ,
		[State] = i.[state] ,
		ZipCode = i.zipcode
FROM dbo.[_import_6_1_KidsLinkNeurobehavioralCenter] i
INNER JOIN dbo.Patient p ON
p.VendorImportID = @VendorImportID AND 
p.MedicalRecordNumber = i.chartnumber
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT