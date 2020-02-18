USE superbill_8811_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT 
SET @PracticeID = 5 


PRINT 'PracticeID: ' + CAST(@PracticeID AS VARCHAR) PRINT ''

UPDATE dbo.Appointment
	SET EndDate = DATEADD(hh,-14,EndDate) , 
		ModifiedDate = GETDATE() , 
		CreatedDate = GETDATE()
WHERE CreatedDate IN ('2016-12-13 16:59:50.580','2016-12-13 16:59:49.593') AND PracticeID = @PracticeID AND ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment Records Updated'


--ROLLBACK
--COMMIT
    
	