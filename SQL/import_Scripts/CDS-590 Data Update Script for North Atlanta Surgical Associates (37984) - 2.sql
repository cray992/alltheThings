USE superbill_37984_dev
--USE superbill_39969_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

PRINT ''
PRINT 'Updating Appointment...'
UPDATE dbo.Appointment
	SET ServiceLocationID = 1 , 
		ModifiedDate = GETDATE()
WHERE ServiceLocationID IS NULL
PRINT CAST (@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Appointment to Resource...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = 20 ,
		ModifiedDate = GETDATE() 
FROM dbo.AppointmentToResource atr
INNER JOIN dbo.Appointment a ON  atr.AppointmentID = a.AppointmentID
INNER JOIN dbo.[_import_1_1_importappt] i ON a.[Subject] = i.legacyappointmentid 
INNER JOIN dbo.[_import_1_1_importprovider] ip ON  i.drorroomorequip = ip.legacyprovidercode
WHERE ip.legacyprovidercode IN ('AKB1' , 'JGT')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Appointment...'
UPDATE dbo.Appointment 
	SET ModifiedDate = GETDATE()
FROM dbo.Appointment a
INNER JOIN dbo.AppointmentToResource atr ON a.AppointmentID = atr.AppointmentID
INNER JOIN dbo.[_import_1_1_importappt] i ON a.[Subject] = i.legacyappointmentid 
INNER JOIN dbo.[_import_1_1_importprovider] ip ON  i.drorroomorequip = ip.legacyprovidercode
WHERE ip.legacyprovidercode IN ('AKB1' , 'JGT')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT
