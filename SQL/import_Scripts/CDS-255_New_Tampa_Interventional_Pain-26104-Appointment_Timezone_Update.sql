USE superbill_26104_dev
--USE superbill_26104_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 6

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Imported Appointments Timezone'
UPDATE dbo.Appointment
	SET StartDate = DATEADD(hh , 3 , StartDate) ,
		EndDate = DATEADD(hh , 3 , EndDate) ,
		StartTm = StartTm + 300 ,
		EndTm = EndTm + 300
	FROM dbo.Appointment AS app
	INNER JOIN dbo.Patient AS pat ON
		pat.PatientID = app.PatientID AND
		pat.VendorImportID = @VendorImportID AND
		pat.PracticeID = @PracticeID
WHERE app.CreatedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT