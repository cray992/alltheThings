--USE superbill_42931_dev
USE superbill_42931_prod
GO


SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT

SET @PracticeID = 15

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting into AppointmenttoResource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          93 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment a
LEFT JOIN dbo.AppointmentToResource atr ON 
	a.AppointmentID = atr.AppointmentID AND 
	atr.PracticeID = @PracticeID
WHERE a.PracticeID = @PracticeID AND atr.AppointmentToResourceID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ROLLBACK
--COMMIT

