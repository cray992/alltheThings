USE superbill_29621_dev
--USE superbill_29621_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

--DECLARE @PracticeID1 INT
--DECLARE @VendorImportID1 INT
--DECLARE @PracticeID2 INT
--DECLARE @VendorImportID2 INT

--SET @PracticeID1 = 1
--SET @VendorImportID1 = 3
--SET @PracticeID2 = 2
--SET @VendorImportID2 = 4


SET NOCOUNT ON 

PRINT ''
PRINT 'Deleting From Payment Patient...'
DELETE FROM dbo.PaymentPatient WHERE PaymentID IN (SELECT PaymentID FROM dbo.Payment WHERE ModifiedDate IN ('2016-01-09 02:13:59.787', '2016-01-09 02:14:00.427') AND BatchID = 'CreditFWD')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Unapplied Payments...'
DELETE FROM dbo.UnappliedPayments WHERE PaymentID IN (SELECT PaymentID FROM dbo.Payment WHERE ModifiedDate IN ('2016-01-09 02:13:59.787', '2016-01-09 02:14:00.427') AND BatchID = 'CreditFWD')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted' 

PRINT ''
PRINT 'Deleting From Payment...'
DELETE FROM dbo.Payment WHERE ModifiedDate IN ('2016-01-09 02:13:59.787', '2016-01-09 02:14:00.427') AND BatchID = 'CreditFWD'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted' 

PRINT ''
PRINT 'Deketing From Patient Journal Note...'
DELETE FROM dbo.PatientJournalNote WHERE ModifiedDate IN ('2016-01-09 02:13:59.560', '2016-01-09 02:13:59.777')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted' 


SELECT COUNT(*) FROM dbo.Payment WHERE ModifiedDate IN ('2016-01-08 11:03:10.940' , '2016-01-08 11:03:11.430') --304
SELECT COUNT(*) FROM dbo.Payment WHERE ModifiedDate IN ('2016-01-09 02:13:59.787', '2016-01-09 02:14:00.427') -- 304

SELECT * FROM dbo.Payment WHERE BatchID = 'CreditFWD' ORDER BY CreatedDate

--ROLLBACK
--COMMIT