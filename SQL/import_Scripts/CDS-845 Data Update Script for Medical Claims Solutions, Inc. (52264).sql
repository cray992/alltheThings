USE superbill_52264_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

PRINT ''
PRINT 'Updating Insurance Company Paper Settings...'
UPDATE dbo.InsuranceCompany
SET BillingFormID = 19 , SecondaryPrecedenceBillingFormID = 19
WHERE CreatedPracticeID IN (5,6,1,13) AND (ReviewCode = '' OR ReviewCode IS NULL) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT
