USE superbill_42731_prod
--USE superbill_42731_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

PRINT ''
PRINT 'Updating Appointment to Resource...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = 3 
WHERE ResourceID = 8 AND ModifiedDate = '2016-08-09 15:53:35.887'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

