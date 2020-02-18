--Appointments Export for Migration
USE superbill_12509_prod
GO 

SELECT --*
a.AppointmentID,sl.Name AS slname,a.StartDate,a.EndDate,
DATEDIFF(MINUTE,a.StartDate,a.EndDate)AS apptduration,a.AppointmentType,a.AppointmentConfirmationStatusCode,
ar.Name AS appointmentreason1,a.Notes, ar.DefaultColorCode
--select *
FROM appointment a 
INNER JOIN dbo.AppointmentToAppointmentReason atar ON 
	atar.AppointmentID = a.AppointmentID
INNER JOIN dbo.AppointmentReason ar ON 
	ar.AppointmentReasonID = atar.AppointmentReasonID
INNER JOIN dbo.AppointmentToResource atr ON 
	atr.AppointmentID = a.AppointmentID
--INNER JOIN dbo.Patient p ON 
--	p.PatientID = a.PatientID
INNER JOIN dbo.ServiceLocation sl ON 
	sl.ServiceLocationID = a.ServiceLocationID
--INNER JOIN dbo.Doctor d ON 
--	d.DoctorID = atr.ResourceID
--WHERE a.StartDate>'2018-01-01 09:00:00.000'
WHERE a.PatientID IS NULL and a.StartDate>'2018-01-01 09:00:00.000'


	SELECT * from appointment a 
	INNER JOIN dbo.ServiceLocation sl ON 
	sl.ServiceLocationID = a.ServiceLocationID
	WHERE PatientID IS NULL and a.StartDate>'2018-01-01 09:00:00.000'