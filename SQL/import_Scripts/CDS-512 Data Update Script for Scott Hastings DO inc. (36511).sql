USE superbill_36511_dev
--USE superbill_36511_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Appointment StartDate and EndDates...'
UPDATE dbo.Appointment 
	SET StartDate = '2013-01-01 12:00:00.000' ,
		EndDate = '2013-01-01 12:00:00.000' ,
		StartTm = '0' , 
		Endtm = '0' ,
		StartDKPracticeID = 4750 ,
		EndDKPracticeID = 4750
WHERE ModifiedUserID = 0 AND CreatedUserID = 0 AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

