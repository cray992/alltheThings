USE superbill_38843_dev
--USE superbill_38843_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT ''
PRINT 'Deleting Standard Fee Schedule Link...'
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink 
WHERE LocationID IN (257,258,260,264,266,267,268, 269)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'


--ROLLBACK
--COMMIT

