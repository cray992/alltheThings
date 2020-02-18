USE superbill_28561_dev
--USE superbill_28561_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 1
SET @PracticeID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Updating Imported Patient Demos with DOB and Gender...'
UPDATE dbo.Patient
	SET DOB = i.birthdate , 
		Gender = i.gender
FROM dbo.Patient p
	INNER JOIN dbo.[_import_2_1_PatientDemoUpdate] i ON
		p.MedicalRecordNumber = i.patientid AND
		p.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '

--ROLLBACK
--COMMIT


