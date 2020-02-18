USE superbill_11230_dev
-- USE superbill_11230_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 1
SET @PracticeID = 1



PRINT ''
PRINT 'Updating Imported Appointments to the correct Timezone'
UPDATE dbo.Appointment
	SET startdate = i.startdate ,
		EndDate = i.enddate ,
		starttm = i.starttm ,
		EndTm = i.endtm
FROM dbo.[_import_1_1_Appointment] i
	INNER JOIN dbo.Appointment a ON
		i.appointmentid = a.[Subject] AND
		a.PracticeID = @PracticeID 
WHERE a.modifieduserid = -50
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--ROLLBACK
--COMMIT