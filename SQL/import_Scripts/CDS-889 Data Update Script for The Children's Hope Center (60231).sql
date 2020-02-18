USE superbill_60231_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 1
SET @SourcePracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

CREATE TABLE #DelAppts  (ApptID INT)
INSERT INTO #DelAppts ( ApptID )

--Bad Appointment Insert Joins to Patient in NET-15265 caused Appointment records to be created with a NULL PatientID. 
--This script deletes the appointments where the PatientID is NULL since these appointment records were created via NET-15336

SELECT a.appointmentid 
FROM dbo.Appointment a
LEFT JOIN 
	(
		SELECT AppointmentID , [subject] , patientid 
		FROM dbo.Appointment 
		WHERE AppointmentType = 'P' AND ModifiedUserID = 0 AND patientid IS NULL
	)	AS ApptDel ON a.AppointmentID = ApptDel.AppointmentID
WHERE ApptDel.AppointmentID = a.AppointmentID

DELETE FROM dbo.AppointmentRecurrenceException WHERE AppointmentID IN (SELECT ApptID FROM #DelAppts)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment Recurrence Exception Records Deleted... '
DELETE FROM dbo.AppointmentRecurrence WHERE AppointmentID IN (SELECT ApptID FROM #DelAppts)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment Recurrence Records Deleted... '
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT ApptID FROM #DelAppts)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment To Appointment Reason Records Deleted... '
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT ApptID FROM #DelAppts)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment to Resource Records Deleted... '
DELETE FROM dbo.Appointment WHERE AppointmentID IN (SELECT ApptID FROM #DelAppts)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment Records Deleted... '
PRINT ''

DROP TABLE #DelAppts

--ROLLBACK
--COMMIT
