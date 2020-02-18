USE superbill_11306_dev
--USE superbill_11306_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

PRINT ''
PRINT 'Updating Appointment to Resource...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = CASE iatr.ResourceID 
						WHEN 7 THEN 44 
						WHEN 4 THEN 43
						WHEN 2 THEN 39
						WHEN 6 THEN 41
						WHEN 3 THEN 45
						WHEN 5 THEN 42
						WHEN 8 THEN 1 END ,
		AppointmentResourceTypeID = CASE iatr.ResourceID WHEN 8 THEN 2 ELSE atr.AppointmentResourceTypeID END
FROM dbo.AppointmentToResource atr
INNER JOIN dbo.Appointment a ON 
atr.AppointmentID = a.AppointmentID
INNER JOIN dbo.[_import_1_1_AppointmentToResource] iatr ON
a.[subject] = CAST(iatr.AppointmentID AS VARCHAR)
INNER JOIN dbo.[_import_1_1_Appointment] ia ON 
iatr.AppointmentID = ia.AppointmentID
WHERE atr.ModifiedDate = '2015-06-23 12:25:35.130'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT


