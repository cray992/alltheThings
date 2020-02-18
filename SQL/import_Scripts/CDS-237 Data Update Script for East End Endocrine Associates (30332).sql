USE superbill_30332_dev
--USE superbill_30332_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 2
SET @PracticeID = 1


PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Appointment to Resource...'
UPDATE dbo.AppointmentToResource 
	SET AppointmentResourceTypeID = 1 ,
		ResourceID = 1
FROM dbo.[_import_2_1_AppointmentToResource] i
INNER JOIN dbo.AppointmentToResource atr ON
	atr.AppointmentID = i.appointmentid AND
	atr.PracticeID = @PracticeID
WHERE atr.ResourceID = 67
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--ROLLBACK
--COMMIT