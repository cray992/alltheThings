USE superbill_30202_dev
--USE superbill_30202_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON


PRINT ''
PRINT 'Updating Appoinments Time...'
UPDATE dbo.Appointment 
SET StartDate = i.startdate ,
	EndDate = i.enddate ,
	StartTm = i.starttm ,
	EndTm = i.endtm
FROM dbo.Appointment a
	INNER JOIN dbo.[_import_4_1_Appointment] i ON
		i.appointmentuid = a.[Subject] AND
		a.PracticeID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Updating Appointment ServiceLocation ID...'
UPDATE dbo.Appointment
SET ServiceLocationID = 1 
FROM dbo.Appointment a 
	INNER JOIN dbo.[_import_4_1_Appointment] i ON
		i.appointmentuid = a.[Subject] AND
		a.PracticeID = 1
WHERE i.facilityfid = 1 AND a.ServiceLocationID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Updating Appointment Notes...'
UPDATE dbo.Appointment
SET Notes = i.notes
FROM dbo.Appointment a
	INNER JOIN dbo.[_import_4_1_Appointment] i ON
		i.appointmentuid = a.[Subject] AND
		a.PracticeID = 1
WHERE i.notes <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT

