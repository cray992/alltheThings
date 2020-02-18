--CCHCA appointment script

USE superbill_39795_prod
GO

DECLARE @PracticeID INT

SET @PracticeID = 46

SELECT DISTINCT i.elationapptid AS [ElationApptID] , a.AppointmentID AS [KareoApptID] , i.chartnumber AS [ElationPatientID] ,
a.PatientID AS [KareoPatientID], a.StartDate , a.EndDate
FROM dbo.Appointment a
INNER JOIN dbo.Patient p ON
a.PatientID = p.PatientID AND 
p.PracticeID = @PracticeID
INNER JOIN dbo._import_89_46_PatientAppointments i ON 
p.VendorID = i.chartnumber AND 
a.StartDate = CAST(i.startdate AS DATETIME) AND
a.EndDate = CAST(i.enddate AS DATETIME) 
WHERE a.PracticeID = @PracticeID AND a.AppointmentConfirmationStatusCode <> 'X'