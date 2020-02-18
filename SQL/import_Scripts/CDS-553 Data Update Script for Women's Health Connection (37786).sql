USE superbill_37786_dev
--USE superbill_37786_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Patient MRN...'
UPDATE dbo.Patient
	SET MedicalRecordNumber = CASE WHEN i.newmrn = 'NULL' THEN '' ELSE i.newmrn END
FROM dbo.[_import_2_2_mrnupdate] i
INNER JOIN dbo.Patient p ON
	i.existingmrn = p.MedicalRecordNumber AND
	p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT