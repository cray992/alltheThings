USE superbill_18092_dev
GO


SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
 
SET @PracticeID = 1

PRINT 'Deleting From Billclaim...'
DELETE FROM dbo.BillClaim WHERE ClaimID IN (SELECT ClaimID FROM dbo.Claim WHERE PracticeID = @PracticeID) 
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From ClaimTransaction...'
DELETE FROM dbo.ClaimTransaction WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From Claim...'
DELETE FROM dbo.Claim WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From EncounterDiagnosis...'
DELETE FROM dbo.EncounterDiagnosis WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From EncounterProcedure...'
DELETE FROM dbo.EncounterProcedure WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From PaymentPatient...'
DELETE FROM dbo.PaymentPatient WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From PaymentEncounter...'
DELETE FROM dbo.PaymentEncounter WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From RefundtoPayments...'
DELETE FROM dbo.RefundToPayments WHERE PaymentID IN (SELECT PaymentID FROM dbo.Payment WHERE PracticeID = @PracticeID)
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From Payment...'
DELETE FROM dbo.Payment WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From Encounter...'
DELETE FROM dbo.Encounter WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From InsurancePolicyAuthorization...'
DELETE FROM dbo.InsurancePolicyAuthorization WHERE InsurancePolicyID IN (SELECT InsurancePolicyID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID)
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From InsurancePolicy...'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From InsuranceCompanyPlan...'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From PracticeToInsuranceCompany...'
DELETE FROM dbo.PracticeToInsuranceCompany WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From InsuranceCompany...'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From AppointmentToResource...'
DELETE FROM dbo.AppointmentToResource WHERE PracticeID  = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From AppointmentReasonDefaultResource...'
DELETE FROM dbo.AppointmentReasonDefaultResource WHERE AppointmentReasonID IN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE PracticeID = @PracticeID)
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From AppointmentToAppointmentReason...'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From AppointmentReason...'
DELETE FROM dbo.AppointmentReason WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From AppointmentRecurrenceException...'
DELETE FROM dbo.AppointmentRecurrenceException WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PracticeID = @PracticeID)
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From AppointmentRecurrence...'
DELETE FROM dbo.AppointmentRecurrence WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PracticeID = @PracticeID)
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From Appointment...'
DELETE FROM dbo.Appointment WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From PatientCaseDate...'
DELETE FROM dbo.PatientCaseDate WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From PatientCase...'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From Bill_StatementCassError...'
DELETE FROM dbo.Bill_StatementCassError WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From PatientAlert...'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID)
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From PatientJournalNote...'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID)
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From Patient...'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting from ProviderNumber...'
DELETE FROM dbo.ProviderNumber WHERE DoctorID IN (SELECT DoctorID FROM dbo.Doctor WHERE PracticeID = @PracticeID)
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From ClaimSettings...'
DELETE FROM dbo.ClaimSettings WHERE DoctorID IN (SELECT DoctorID FROM dbo.Doctor WHERE PracticeID = @PracticeID)
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From Doctor...'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'
PRINT 'Deleting From ServiceLocation...'
DELETE FROM dbo.ServiceLocation WHERE PracticeID = 1
PRINT '     ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'


--ROLLBACK
--COMMIT