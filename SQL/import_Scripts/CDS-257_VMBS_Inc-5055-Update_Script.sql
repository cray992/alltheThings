USE superbill_5055_dev
--USE superbill_5055_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 14
SET @VendorImportID = 2

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Imported Patients Default Service Location...'
UPDATE dbo.Patient
	SET DefaultServiceLocationID = 88
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Imported Appointment Service Locations...'
UPDATE dbo.Appointment
	SET ServiceLocationID = 88
FROM dbo.Appointment app
INNER JOIN dbo.Patient pat ON
	pat.PatientID = app.PatientID AND
	pat.VendorImportID = @VendorImportID
WHERE app.PracticeID = @PracticeID AND app.CreatedDate = '2014-05-02 13:11:53.087'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT