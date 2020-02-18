USE superbill_37912_dev
--USE superbill_37912_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1


PRINT ''
PRINT 'Updating Appointment StartDates and EndDates...'
UPDATE dbo.Appointment 
	SET StartDate = CAST([date] AS DATETIME) + starttime ,
		EndDate = CAST([date] AS DATETIME) + DATEADD(n, CAST([length] AS INT) ,starttime) ,
		StartTM = CAST(REPLACE(starttime,':','') AS SMALLINT) ,
		EndTm = REPLACE(LTRIM(REPLACE(LEFT(REPLACE(REPLACE(CAST(DATEADD(n, CAST([length] AS INT), starttime) AS TIME),':',''),'.',''), 4),'0', ' ')),' ','0')
FROM dbo.[_import_2_1_Appointment] i 
INNER JOIN dbo.Appointment a ON 
	REVERSE(LEFT(REVERSE(a.Subject), CHARINDEX(' ',REVERSE(a.Subject)) - 1)) = i.id AND
    a.PracticeID = 1
WHERE a.ModifiedUserID = 0 AND a.AppointmentType = 'O'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

