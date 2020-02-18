USE superbill_57372_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

UPDATE dbo.AppointmentToResource
SET ResourceID = 4 , 
	ModifiedDate = GETDATE()
WHERE ResourceID = 2 AND AppointmentResourceTypeID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' AppointmentToResource Records Updated...'

UPDATE dbo.Patient 
SET PrimaryProviderID = 4
WHERE PrimaryProviderID = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient PrimaryProvider Records Updated...'

--ROLLBACK
--COMMIT


