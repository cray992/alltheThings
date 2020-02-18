USE superbill_31776_dev
--USE superbill_31776_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1

PRINT ''
PRINT 'Updating AppointmenttoResource...'
UPDATE dbo.AppointmentToResource
SET ResourceID = CASE ResourceID WHEN 1 THEN 1959
								 WHEN 2 THEN 1961
								 WHEN 3 THEN 1960
								 WHEN 4 THEN 1958
								 WHEN 5 THEN 1962 
				 END , 
	AppointmentResourceTypeID = 1 , 
	ModifiedDate = GETDATE() 
WHERE AppointmentResourceTypeID = 2 AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT
