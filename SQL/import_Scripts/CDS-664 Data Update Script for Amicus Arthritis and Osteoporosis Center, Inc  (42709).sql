USE superbill_42709_dev
--superbill_42709_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

PRINT ''
PRINT 'Updating Patient...'
UPDATE dbo.Patient
	SET ModifiedDate = GETDATE()
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT