USE superbill_30681_dev	
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON


PRINT ''
PRINT 'Updating Patient Case Date...'
UPDATE dbo.PatientCaseDate 
	SET StartDate = EndDate ,
		EndDate = NULL
WHERE CreatedUserID = -50
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

