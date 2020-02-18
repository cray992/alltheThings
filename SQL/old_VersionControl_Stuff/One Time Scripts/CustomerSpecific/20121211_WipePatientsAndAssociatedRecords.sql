BEGIN TRAN

DELETE FROM dbo.PaymentPatient
DBCC CHECKIDENT('PaymentPatient', RESEED, 0)
PRINT 'dbo.PaymentPatient'

DELETE FROM dbo.ClaimTransaction
DBCC CHECKIDENT('ClaimTransaction', RESEED, 0)
PRINT 'dbo.ClaimTransaction'

DELETE FROM dbo.PaymentEncounter
DBCC CHECKIDENT('PaymentEncounter', RESEED, 0)
PRINT 'dbo.PaymentEncounter'

DELETE FROM dbo.Payment
DBCC CHECKIDENT('Payment', RESEED, 0)
PRINT 'dbo.Payment'

DELETE FROM dbo.EncounterDiagnosis
DBCC CHECKIDENT('EncounterDiagnosis', RESEED, 0)
PRINT 'dbo.EncounterDiagnosis'

DELETE FROM dbo.BillClaim
PRINT 'dbo.BillClaim'

DELETE FROM dbo.Claim
DBCC CHECKIDENT('Claim', RESEED, 0)
PRINT 'dbo.Claim'

DELETE FROM dbo.EncounterProcedure
DBCC CHECKIDENT('EncounterProcedure', RESEED, 0)
PRINT 'dbo.EncounterProcedure'

DELETE FROM dbo.Encounter
DBCC CHECKIDENT('Encounter', RESEED, 0)
PRINT 'dbo.Encounter'

DELETE FROM dbo.AppointmentRecurrenceException
DBCC CHECKIDENT('AppointmentRecurrenceException', RESEED, 0)
PRINT 'dbo.AppointmentRecurrenceException'

DELETE FROM dbo.AppointmentRecurrence
PRINT 'dbo.AppointmentRecurrence'

DELETE FROM dbo.AppointmentToResource
DBCC CHECKIDENT('AppointmentToResource', RESEED, 0)
PRINT 'dbo.AppointmentToResource'

DELETE FROM dbo.AppointmentToAppointmentReason
DBCC CHECKIDENT('AppointmentToAppointmentReason', RESEED, 0)
PRINT 'dbo.AppointmentToAppointmentReason'

DELETE FROM dbo.Appointment
DBCC CHECKIDENT('Appointment', RESEED, 0)
PRINT 'dbo.Appointment'

DELETE FROM dbo.Bill_EDI
DBCC CHECKIDENT('Bill_EDI', RESEED, 0)
PRINT 'dbo.Bill_EDI'

DELETE FROM dbo.EligibilityHistory
DBCC CHECKIDENT('EligibilityHistory', RESEED, 0)
PRINT 'dbo.EligibilityHistory'

DELETE FROM dbo.InsurancePolicy
DBCC CHECKIDENT('InsurancePolicy', RESEED, 0)
PRINT 'dbo.InsurancePolicy'

DELETE FROM dbo.PatientCase
DBCC CHECKIDENT('PatientCase', RESEED, 0)
PRINT 'dbo.PatientCase'

DELETE FROM dbo.PatientAlert
DBCC CHECKIDENT('PatientAlert', RESEED, 0)
PRINT 'dbo.PatientAlert'

DELETE FROM dbo.PatientJournalNote
DBCC CHECKIDENT('PatientJournalNote', RESEED, 0)
PRINT 'dbo.PatientJournalNote'

DELETE FROM dbo.Patient
DBCC CHECKIDENT('Patient', RESEED, 0)
PRINT 'dbo.Patient'

ROLLBACK TRAN