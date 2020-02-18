USE superbill_30806_dev
--superbill_40806_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT

SET @PracticeID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Patient - Primary Care PhysicianID...'
UPDATE dbo.Patient 
	SET PrimaryCarePhysicianID = 617
WHERE PrimaryCarePhysicianID = 998
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT