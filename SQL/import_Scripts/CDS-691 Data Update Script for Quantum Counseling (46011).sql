USE superbill_46011_dev
--superbill_46011_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT

SET @PracticeID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Patient - Enabling PhonecallRemindersEnabled '
UPDATE dbo.Patient 
	SET PhonecallRemindersEnabled = 1
WHERE PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT
