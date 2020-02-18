USE superbill_27495_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT

SET @VendorImportID = 4
SET @PracticeID = 1 


PRINT ''
PRINT 'Removing Medical Record Number from Imported Patients...'
UPDATE dbo.Patient 
	SET MedicalRecordNumber = ''
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'



PRINT ''
PRINT 'Updating Medical Record Number for Imported Patients...'
UPDATE dbo.Patient
	SET MedicalRecordNumber = i.mrn
FROM dbo.Patient p
INNER JOIN dbo.[_import_5_1_patientdemographics] i ON
p.VendorID = i.patientname AND p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT