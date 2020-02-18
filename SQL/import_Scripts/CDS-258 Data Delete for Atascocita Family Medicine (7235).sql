USE superbill_7235_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

PRINT 'Deleteing from AppointmentToResource'
DELETE FROM dbo.AppointmentToResource
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '

PRINT 'Deleteing from Appointment'
DELETE FROM dbo.Appointment
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '

PRINT 'Deleteing from PatientCase'
DELETE FROM dbo.PatientCase
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '

PRINT 'Deleteing from PatientJournalNote'
DELETE FROM dbo.PatientJournalNote
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '

PRINT 'Deleteing from Patient'
DELETE FROM dbo.Patient
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '



ROLLBACK