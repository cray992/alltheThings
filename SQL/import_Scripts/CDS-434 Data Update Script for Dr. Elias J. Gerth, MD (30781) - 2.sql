USE superbill_30781_dev
--USE superbill_30781_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating AppointmenttoResource...'
UPDATE dbo.AppointmentToResource
	SET AppointmentResourceTypeID = 1 , 
		ResourceID = 1
FROM dbo.AppointmentToResource atr
	INNER JOIN dbo.[_import_1_1_AppointmenttoResource] i ON
		atr.AppointmentID = i.appointmentid AND
		atr.PracticeID = @PracticeID 
WHERE atr.AppointmentResourceTypeID = 2 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'



--ROLLBACK
--COMMIT

