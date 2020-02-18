USE superbill_37984_dev
--USE superbill_37984_prod
GO


SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT ''
PRINT 'Updating Appointment to Resource...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = CASE ip.legacyprovidercode
						WHEN 'CRCI' THEN 3
						WHEN 'CRCE' THEN 3
						WHEN 'CRC' THEN 3
						WHEN 'JPL' THEN 12
						WHEN 'JPLI' THEN 12
						WHEN 'JPLE' THEN 12
						WHEN 'MMW2' THEN 12
						WHEN 'LTW' THEN 23
						WHEN 'DPB 3' THEN 23
					END ,
		ModifiedDate = GETDATE() 
FROM dbo.AppointmentToResource atr
INNER JOIN dbo.Appointment a ON  atr.AppointmentID = a.AppointmentID
INNER JOIN dbo.[_import_1_1_importappt] i ON a.[Subject] = i.legacyappointmentid 
INNER JOIN dbo.[_import_1_1_importprovider] ip ON  i.drorroomorequip = ip.legacyprovidercode
WHERE ip.legacyprovidercode IN ('CRCI' , 'CRCE' , 'CRC' , 'JPL' , 'JPLI' , 'JPLE' , 'MMW2' , 'LTW' , 'DPB 3' )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Appointment...'
UPDATE dbo.Appointment 
	SET ModifiedDate = GETDATE()
FROM dbo.Appointment a
INNER JOIN dbo.AppointmentToResource atr ON a.AppointmentID = atr.AppointmentID
INNER JOIN dbo.[_import_1_1_importappt] i ON a.[Subject] = i.legacyappointmentid 
INNER JOIN dbo.[_import_1_1_importprovider] ip ON  i.drorroomorequip = ip.legacyprovidercode
WHERE ip.legacyprovidercode IN ('CRCI' , 'CRCE' , 'CRC' , 'JPL' , 'JPLI' , 'JPLE' , 'MMW2' , 'LTW' , 'DPB 3' )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT

