USE superbill_57115_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT
SET @PracticeID = 1

UPDATE dbo.Patient 
	SET PrimaryProviderID = CASE WHEN PrimaryProviderID IS NULL THEN 1 ELSE PrimaryProviderID END ,
		DefaultServiceLocationID = CASE WHEN DefaultServiceLocationID IS NULL THEN 1 ELSE DefaultServiceLocationID END 
WHERE PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient records updated'


--ROLLBACK
--COMMIT
