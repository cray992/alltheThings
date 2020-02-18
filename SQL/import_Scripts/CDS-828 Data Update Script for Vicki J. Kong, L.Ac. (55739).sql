USE superbill_55739_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

PRINT ''
PRINT 'Updating Patient...'
UPDATE dbo.Patient 
SET	DOB = '1901-01-01 12:00:00.000' ,
	ModifiedDate = GETDATE()
WHERE (DOB IS NULL OR DOB = '') AND PracticeID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT
