USE superbill_27002_dev
--USE superbill_27002_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

PRINT ''
PRINT 'Deleting from Encounter Procedure...'
DELETE FROM dbo.EncounterProcedure
WHERE PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@Rowcount AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Encounter Diagnosis...'
DELETE FROM dbo.EncounterDiagnosis
WHERE PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Encounter...'
DELETE FROM dbo.Encounter
WHERE PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@rowcount AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Appointment To Resource...'
DELETE FROM dbo.AppointmentToResource
WHERE PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Appointment To Appointment Reason...'
DELETE FROM dbo.AppointmentToAppointmentReason
WHERE PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Appointment Recurrence...'
DELETE FROM dbo.AppointmentRecurrence
WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PracticeID IN (14,21,23,27,5,33,40))
PRINT CAST(@@rowcount AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Appointment Recurrence Exception...'
DELETE FROM dbo.AppointmentRecurrenceException
WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PracticeID IN (14,21,23,27,5,33,40))
PRINT CAST(@@rowcount AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Appointment...'
DELETE FROM dbo.Appointment
WHERE PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@rowcount AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Insurance Policy...'
DELETE FROM dbo.InsurancePolicy
WHERE PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Insurance Company Plan...'
DELETE FROM dbo.InsuranceCompanyPlan
WHERE CreatedPracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@rowcount AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Practice to Insurance Company...'
DELETE FROM dbo.PracticeToInsuranceCompany
WHERE PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@rowcount AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Delete from Enrollment Doctor...'
DELETE FROM dbo.EnrollmentDoctor
WHERE EnrollmentPayerID IN (SELECT EnrollmentPayerID FROM dbo.EnrollmentPayer WHERE PracticeID IN (14,21,23,27,5,33,40))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Enrollment Payer...'
DELETE FROM dbo.EnrollmentPayer
WHERE PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Insurance Company...'
DELETE FROM dbo.InsuranceCompany
WHERE CreatedPracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@rowcount AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Doctor...'
DELETE FROM dbo.Doctor WHERE [External] = 1 AND PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@rowcount AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Patient Journal Note...'
DELETE FROM dbo.PatientJournalNote
WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID IN (14,21,23,27,5,33,40))
PRINT CAST(@@rowcount AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Patient Case Date...'
DELETE FROM dbo.PatientCaseDate
WHERE PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@rowcount AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Patient Case...'
DELETE FROM dbo.PatientCase
WHERE PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting from Patient...'
DELETE FROM dbo.Patient
WHERE PracticeID IN (14,21,23,27,5,33,40)
PRINT CAST(@@rowcount AS VARCHAR) + ' records deleted'




--ROLLBACK
--COMMIT