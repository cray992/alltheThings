--USE superbill_49117_dev
USE superbill_49117_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT

SET @PracticeID = 1

SET NOCOUNT ON 

PRINT ''
PRINT 'Updating Patient Appointment - Patient Case...'
UPDATE dbo.Appointment
	SET PatientCaseID = pc.PatientCaseID
FROM dbo.Appointment a 
	INNER JOIN dbo.Patient p ON
		a.PatientID = p.PatientID AND
        a.PracticeID = @PracticeID 
	LEFT JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2
							WHERE pc2.PatientID = p.PatientID AND pc2.PracticeID = @PracticeID)
WHERE a.PatientCaseID IS NULL AND a.AppointmentType = 'P'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT