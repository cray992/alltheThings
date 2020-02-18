--USE superbill_49117_dev
USE superbill_49117_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT

SET @PracticeID = 1

SET NOCOUNT ON 

PRINT ''
PRINT 'Delete PaymentPatient...'
DELETE FROM dbo.PaymentPatient WHERE PaymentID IN (SELECT PaymentID FROM dbo.Payment WHERE [Description] = 'Online patient payment' AND PracticeID = @PracticeID AND CreatedDate <= '2016-04-24 00:00:00.000')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Delete from Unapplied Payments...'
DELETE FROM dbo.UnappliedPayments WHERE PaymentID IN (SELECT PaymentID FROM dbo.Payment WHERE [Description] = 'Online patient payment' AND PracticeID = @PracticeID AND CreatedDate <= '2016-04-24 00:00:00.000')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Delete from Payment'
DELETE FROM dbo.Payment WHERE [Description] = 'Online patient payment' AND PracticeID = @PracticeID AND CreatedDate <= '2016-04-24 00:00:00.000'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

--ROLLBACK
--COMMIT

