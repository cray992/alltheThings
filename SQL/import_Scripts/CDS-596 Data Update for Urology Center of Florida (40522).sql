USE superbill_40522_dev
--USE superbill_40522_prod
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
PRINT 'Update Appointment to Resource...'
UPDATE dbo.AppointmentToResource
	SET ResourceID = 3
FROM dbo.AppointmentToResource atr
INNER JOIN dbo.Appointment a ON
	atr.AppointmentID = a.AppointmentID AND
    atr.PracticeID = @PracticeID
INNER JOIN dbo.[_import_1_1_aptfile] i ON
	a.StartDate = CAST(i.startdate AS DATETIME) AND
	a.EndDate = CAST(i.enddate AS DATETIME) AND
	a.PracticeID = @PracticeID
INNER JOIN dbo.Patient p ON 
	i.aptaccount = p.VendorID AND 
	p.VendorImportID = @VendorImportID
WHERE i.aptdr IN (2,5)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT


