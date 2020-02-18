--USE superbill_49117_dev
USE superbill_49117_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT

SET @PracticeID = 1

SET NOCOUNT ON

UPDATE dbo.[_import_26_1_ApptUpdate]
SET locname = CASE locname
					WHEN 'Mira Vista Care Center' THEN 'Z Mira Vista Care Center'
					WHEN 'SRUCK Skagit Regional Urgent Care' THEN 'Z SRUCK Skagit Regional Urgent C'
					WHEN 'SRUCF Skagit Regional Urgent Care' THEN 'Z SRUCF Skagit Regional Urgent C'
					WHEN 'BASC Bellingham Ambulatory Surgery Cntr' THEN 'Z BASC Bellingham Ambulatory Sur'
					WHEN 'SLS NW Eye Surgeons' THEN 'Z SLS NW Eye Surgeons'
					WHEN 'NSSC North Seattle Surgery Center' THEN 'Z NSSC North Seattle Surgery Cen'
					WHEN 'VMC Valley Medical Center Hospital' THEN 'VMC Valley Medical Center Hospit'
		      ELSE locname END  

PRINT ''
PRINT 'Updating Appointment - Confirmation Status Code...'
UPDATE dbo.Appointment
SET AppointmentConfirmationStatusCode = 'N'
FROM dbo.Appointment a 
INNER JOIN dbo.Patient p ON
	a.PatientID = p.PatientID AND 
    p.PracticeID = @PracticeID
INNER JOIN dbo.ServiceLocation sl ON 
	a.ServiceLocationID = sl.ServiceLocationID AND 
	sl.PracticeID = @PracticeID
INNER JOIN dbo.[_import_26_1_ApptUpdate] i ON 
	p.LastName + ', ' + p.FirstName + ' ' + p.MiddleName = i.patname AND
	sl.Name = i.locname AND
	a.StartDate = CAST(i.startdate AS DATETIME)
WHERE CAST(a.Notes AS VARCHAR(25)) <> 'Conversion Error'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT
