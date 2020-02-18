IF EXISTS(SELECT * FROM sys.indexes 
WHERE name='IX_PaymentPatient_PatientID')
	DROP INDEX PaymentPatient.IX_PaymentPatient_PatientID

GO

CREATE INDEX IX_PaymentPatient_PatientID
ON PaymentPatient (PatientID)

GO
IF EXISTS(SELECT * FROM sys.indexes 
WHERE name='IX_Appointment_PatientID')
	DROP INDEX Appointment.IX_Appointment_PatientID

GO

CREATE INDEX IX_Appointment_PatientID
ON Appointment (PatientID)

GO

DROP INDEX PatientJournalNote.CI_Patient_PatientID

GO

CREATE CLUSTERED INDEX CI_PatientJournalNote_PatientID_Hidden 
ON PatientJournalNote
(PatientID ASC, Hidden ASC)

GO