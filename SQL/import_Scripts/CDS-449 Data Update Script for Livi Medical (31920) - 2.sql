USE superbill_31920_dev
--USE superbill_XXX_prod
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

UPDATE dbo.Appointment
SET AppointmentType = 'O' , [Subject] = 'Missing Patient Name'
WHERE PatientID IS NULL AND AppointmentType <> 'O'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Updated'

--ROLLBACK
--COMMIT



