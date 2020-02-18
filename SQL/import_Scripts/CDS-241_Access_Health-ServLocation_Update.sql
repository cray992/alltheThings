USE superbill_25921_dev
--USE superbill_25921_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT

SET @PracticeID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))


PRINT ''
PRINT 'Updating Patient Records with San Francisco Service Location'
Update dbo.patient
      Set DefaultServiceLocationID = 2
WHERE DefaultServiceLocationID IS NULL AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT