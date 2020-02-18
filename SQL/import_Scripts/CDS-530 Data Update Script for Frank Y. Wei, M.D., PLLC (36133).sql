USE superbill_36133_dev
--USE superbill_36133_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON


PRINT ''
PRINT 'Update Appointment to Resource 1 of 3...'
UPDATE dbo.AppointmentToResource
	SET ResourceID = 1
WHERE ResourceID = 4
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Update Appointment to Resource 2 of 3...'
UPDATE dbo.AppointmentToResource
	SET ResourceID = 2
FROM dbo.AppointmentToResource atr
INNER JOIN dbo.Appointment a ON
atr.AppointmentID = a.AppointmentID AND
atr.PracticeID = 1
INNER JOIN dbo.[_import_4_1_Appointments] i ON
a.[Subject] = i.id AND
i.provider = '4'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Update Appointment to Resource 3 of 3...'
UPDATE dbo.AppointmentToResource
	SET ResourceID = 2
FROM dbo.AppointmentToResource atr
INNER JOIN dbo.Appointment a ON
atr.AppointmentID = a.AppointmentID AND 
atr.PracticeID = 1
INNER JOIN dbo.[_import_4_1_Appointments] i ON
a.[Subject] = i.NAME + ' - ' + i.ID AND
i.provider = '4'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT
