USE superbill_29298_dev
-- superbill_29298_prod
GO


SET XACT_ABORT ON
 
BEGIN TRAN

SET NOCOUNT ON

DELETE FROM dbo.InsurancePolicy 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.PracticeToInsuranceCompany
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Practice to Insurance Company records deleted'
DELETE FROM dbo.EnrollmentDoctor 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Enrollment Doctor records deleted'
DELETE FROM dbo.EnrollmentPayer
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Enrollment Payer records deleted'
DELETE FROM dbo.ClaimSettings
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Enrollment Payer records deleted'
DELETE FROM dbo.InsuranceCompany 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.AppointmentToResource 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'
DELETE FROM dbo.PatientCaseDate 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case Date records deleted'
DELETE FROM dbo.PatientCase 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


--ROLLBACK
--COMMIT