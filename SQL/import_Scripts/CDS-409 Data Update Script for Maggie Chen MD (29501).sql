USE superbill_29501_dev
--USE superbill_29501_prod
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
PRINT 'Updating Patient Phone Records for Import Patients...'
UPDATE dbo.Patient
	SET HomePhone = i.homephone ,
		HomePhoneExt = i.homephoneext ,
		WorkPhone = i.workphone , 
		WorkPhoneExt = i.workphoneext ,
		MobilePhone = i.mobilephone ,
		MobilePhoneExt = i.mobilephoneext
FROM dbo.[_import_5_1_PatientPhone] i
	INNER JOIN dbo.Patient p ON 
		i.id = p.PatientID AND
		p.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


--ROLLBACK
--COMMIT