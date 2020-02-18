--USE superbill_49359_dev
USE superbill_49359_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 6
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


CREATE TABLE #temppol (InsurancePolicyID INT , HolderFirstName VARCHAR(125), HolderLastName VARCHAR(125))
INSERT INTO #temppol
        ( InsurancePolicyID ,
          HolderFirstName ,
          HolderLastName
        )
SELECT DISTINCT
		  InsurancePolicyID , -- InsurancePolicyID - int
          HolderFirstName , -- HolderFirstName - varchar(125)
          HolderLastName  -- HolderLastName - varchar(125)
FROM dbo.InsurancePolicy
WHERE PracticeID = @PracticeID AND 
	  VendorImportID = @VendorImportID AND
	  ModifiedUserID = 0 AND 
      Precedence = 2

PRINT ''
PRINT 'Updating Insurance Policy - Holder Names...'
UPDATE dbo.InsurancePolicy
	SET HolderFirstName = temp.HolderLastName , 
		HolderLastName = temp.HolderFirstName
FROM dbo.InsurancePolicy ip
INNER JOIN #temppol temp ON 
	ip.InsurancePolicyID = temp.InsurancePolicyID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #temppol

--ROLLBACK
--COMMIT

