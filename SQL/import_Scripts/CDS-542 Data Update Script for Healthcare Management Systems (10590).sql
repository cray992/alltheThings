USE superbill_10590_dev
--USE superbill_10590_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT

SET @PracticeID = 30

SET NOCOUNT ON 


PRINT ''
PRINT 'Updating InsuranceCompanyPlanID...'
UPDATE dbo.InsurancePolicy 
SET InsuranceCompanyPlanID = 230
WHERE InsuranceCompanyPlanID IN (203, 2316) AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

