USE superbill_18338_dev
--USE superbill_18338_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

PRINT ''
PRINT 'Updating Appointment to Resource...'
UPDATE dbo.AppointmentToResource 
	SET AppointmentResourceTypeID = 1 ,
		ResourceID = 13
WHERE ResourceID IN (12,13,14,15,16,20,21,28,29) AND AppointmentResourceTypeID = 2 AND PracticeID = 5
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated...'



--ROLLBACK
--COMMIT

