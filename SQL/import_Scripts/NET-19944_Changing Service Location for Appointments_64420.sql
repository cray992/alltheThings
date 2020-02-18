USE superbill_64420_prod
GO

SELECT a.ServiceLocationID,ipa.* FROM dbo.Appointment a
INNER  JOIN dbo.[Patient_Appointments$] ipa 
ON ipa.Appointment_ID=a.AppointmentID 

BEGIN TRAN
UPDATE a SET
a.ServiceLocationID=2
FROM dbo.Appointment a
INNER  JOIN dbo.[Patient_Appointments$] ipa 
ON ipa.Appointment_ID=a.AppointmentID 

SELECT a.ServiceLocationID,ipa.* FROM dbo.Appointment a
INNER  JOIN dbo.[Patient_Appointments$] ipa 
ON ipa.Appointment_ID=a.AppointmentID 

rollback

--SELECT * FROM dbo.[Patient_Appointments$] ipa 

--SELECT * FROM dbo.ServiceLocation




