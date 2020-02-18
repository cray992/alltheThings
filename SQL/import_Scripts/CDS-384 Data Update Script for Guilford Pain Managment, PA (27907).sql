USE superbill_27907_dev
--USE superbill_27907_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 1
SET @PracticeID = 1

PRINT ''
PRINT 'Updating All Imported Appointments to Void Resource...'
UPDATE dbo.AppointmentToResource
	SET ResourceID = 1 ,
		AppointmentResourceTypeID = 2
FROM dbo.AppointmentToResource atr
	INNER JOIN dbo.Appointment a ON
		a.AppointmentID = atr.AppointmentID AND
		a.PracticeID = @PracticeID
	INNER JOIN dbo.[_import_1_1_Appointments] i ON 
		a.[Subject] = i.clpatid AND
		a.StartDate = CAST(i.startdateest AS DATETIME) AND
		a.EndDate = CAST(i.enddateest AS DATETIME)
WHERE atr.AppointmentResourceTypeID = 1
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '

		

--ROLLBACK
--COMMIT