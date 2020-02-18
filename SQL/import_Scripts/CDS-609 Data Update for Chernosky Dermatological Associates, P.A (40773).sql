USE superbill_40773_dev
--USE superbill_40773_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

PRINT 'Updating Appointments...'
UPDATE dbo.Appointment
	SET StartDate = DATEADD(hh,-2,StartDate) , 
		EndDate = DATEADD(hh,-2,EndDate) , 
		EndTm = EndTm - 200 ,
		StartTm = StartTm - 200
WHERE CreatedDate = '2015-07-27 14:29:02.063' AND ModifiedDate = '2015-07-27 14:29:02.063'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

