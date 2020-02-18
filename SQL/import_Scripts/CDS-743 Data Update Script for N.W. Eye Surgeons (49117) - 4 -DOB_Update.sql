--USE superbill_49117_dev
USE superbill_49117_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

PRINT ''
PRINT 'Updating Patient - DOB'
UPDATE dbo.Patient 
	SET DOB = '1901-01-01 12:00:00.000'
WHERE DOB IS NULL AND PracticeID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT