USE superbill_13229_dev
GO

DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN
(SELECT AppointmentID FROM dbo.Appointment WHERE PracticeID = 4)

DELETE FROM dbo.Appointment WHERE PracticeID = 4


DELETE FROM dbo.InsurancePolicy WHERE PatientCaseID IN 
(SELECT PatientCaseID FROM dbo.PatientCase WHERE PatientID IN
(SELECT PatientID FROM dbo.Patient WHERE PracticeID = 4))


DELETE FROM dbo.PatientCase WHERE PatientID IN 
(SELECT PatientID FROM dbo.Patient WHERE PracticeID = 4) 

DELETE FROM dbo.Patient WHERE PracticeID = 4