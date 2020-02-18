USE superbill_39478_dev
--USE superbill_39478_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT

SET @PracticeID = 1

SET NOCOUNT ON 


PRINT ''
PRINT 'Updating Patient...'
UPDATE dbo.Patient 
	SET PhonecallRemindersEnabled = 1 ,
		SendEmailCorrespondence = 1
WHERE PracticeID = @PracticeID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT