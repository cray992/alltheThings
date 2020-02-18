USE superbill_33693_dev
--USE superbill_33693_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON

--Adjusting for Daylight Savings Time

UPDATE dbo.Appointment
SET StartDate = DATEADD(hh,-1,StartDate) ,
	EndDate = DATEADD(hh,-1,EndDate) ,
	EndTm = -100 ,
	StartTm = -100
FROM dbo.Appointment
WHERE StartDate > '2014-11-01 00:00:00.000' AND StartDate < '2015-03-12 00:00:00.000' OR
	  StartDate > '2016-11-06 00:00:00.000' AND StartDate < '2017-03-12 00:00:00.000' AND 
	  CreatedUserID = 0 AND ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

