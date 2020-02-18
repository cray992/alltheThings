USE superbill_42709_dev
--superbill_42709_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

PRINT ''
PRINT 'Updating Appointment - LastModifiedDate'
UPDATE dbo.Appointment SET ModifiedDate = GETDATE()
WHERE PracticeID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'



--ROLLBACK
--COMMIT