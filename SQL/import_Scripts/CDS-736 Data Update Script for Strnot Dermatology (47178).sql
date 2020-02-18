--USE superbill_47178_dev
USE superbill_47178_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT ''
PRINT 'Update Appointment Start and End Times...'
UPDATE dbo.Appointment 
	SET StartDate = DATEADD(hh,-2,StartDate) , 
		EndDate = DATEADD(hh,-2,EndDate) , 
		EndTm = EndTm - 200 , 
		StartTm = StartTm - 200
WHERE CreatedDate = '2016-01-14 19:09:02.870' AND ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

