USE superbill_15808_dev
--USE superbill_15808_prod
GO

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID =	2
SET @PracticeID = 3


PRINT 'Updating ResourceID for Imported Appointments...'
UPDATE dbo.AppointmentToResource
	SET ResourceID = 7
FROM dbo.AppointmentToResource ar
INNER JOIN dbo.Appointment a ON
	ar.AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment a2 
							INNER JOIN dbo.[_import_2_3_Appointment] i ON
								a2.PatientID = a.PatientID AND
								a2.StartDate = CAST(DATEADD(hh,-3,i.startdate) AS DATETIME)  AND
								a2.EndDate = CAST(DATEADD(hh,-3,i.enddate) AS DATETIME) AND
								a.[Subject] = i.pid + ' - ' + i.[resource]
								WHERE i.[resource] = 'E. APPIADU')
WHERE a.ModifiedUserID = -50
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'
							
--ROLLBACK
--COMMIT