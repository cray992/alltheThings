USE superbill_11990_dev 
--USE superbill_11990_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT

SET @PracticeID = 5

UPDATE 
	dbo.Patient
SET
	DOB = CAST(dbo._import_8_5_Sheet1.dob AS DATETIME)
FROM
	dbo._import_8_5_Sheet1
WHERE
	dbo.Patient.VendorImportID = 2 AND
	dbo.Patient.PracticeID = @PracticeID AND
	dbo.Patient.VendorID = dbo._import_8_5_Sheet1.pat_id
	

	
PRINT cast(@@rowcount as varchar)

COMMIT TRAN	