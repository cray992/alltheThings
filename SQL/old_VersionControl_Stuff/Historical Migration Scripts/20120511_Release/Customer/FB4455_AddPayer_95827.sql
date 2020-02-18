DECLARE @chpid INT
DECLARE @ClearinghouseID INT, 
		@PayerNumber VARCHAR(32),
		@Name VARCHAR(1000),
		@Notes VARCHAR(1000),
		@State VARCHAR(256),
		@NameTransmitted VARCHAR(35)
		
SELECT @ClearinghouseID = 1,
		@PayerNumber = '95827',
		@Name = 'Healthy Palm Beach',
		@Notes = 'Created for FB 4455',
		@State = 'FL',
		@NameTransmitted = 'HEALTHY PALM BEACH'
		
SET @chpid = (SELECT ClearinghousePayerID 
FROM SHAREDSERVER.Superbill_Shared.dbo.ClearinghousePayersList 
WHERE PayerNumber = @PayerNumber 
	AND ClearinghouseID = @ClearinghouseID
	AND Active = 1)
	
IF EXISTS (SELECT * FROM dbo.ClearinghousePayersList AS CPL WHERE ClearinghousePayerID = @chpid)
BEGIN
	DELETE FROM dbo.ClearinghousePayersList
	WHERE ClearinghousePayerID = @chpid
END
	
INSERT INTO dbo.ClearinghousePayersList
		( ClearinghousePayerID ,
		  ClearinghouseID ,
		  PayerNumber ,
		  Name ,
		  Notes ,
		  StateSpecific ,
		  IsPaperOnly ,
		  IsGovernment ,
		  IsCommercial ,
		  IsParticipating ,
		  IsProviderIdRequired ,
		  IsEnrollmentRequired ,
		  IsAuthorizationRequired ,
		  IsTestRequired ,
		  ResponseLevel ,
		  IsNewPayer ,
		  DateNewPayerSince ,
		  CreatedDate ,
		  ModifiedDate ,
		  TIMESTAMP ,
		  Active ,
		  IsModifiedPayer ,
		  DateModifiedPayerSince ,
		  KareoClearinghousePayersListID ,
		  KareoLastModifiedDate ,
		  NameTransmitted ,
		  SupportsPatientEligibilityRequests ,
		  SupportsSecondaryElectronicBilling ,
		  SupportsCoordinationOfBenefits ,
		  B2BPayerID
		)
VALUES  ( @chpid , -- ClearinghousePayerID - int
		  @ClearinghouseID , -- ClearinghouseID - int
		  @PayerNumber , -- PayerNumber - varchar(32)
		  @Name , -- Name - varchar(1000)
		  @Notes , -- Notes - varchar(1000)
		  @State , -- StateSpecific - varchar(256)
		  0 , -- IsPaperOnly - bit
		  0, -- IsGovernment - bit
		  0, -- IsCommercial - bit
		  0, -- IsParticipating - bit
		  0 , -- IsProviderIdRequired - bit
		  0 , -- IsEnrollmentRequired - bit
		  0 , -- IsAuthorizationRequired - bit
		  0 , -- IsTestRequired - bit
		  1 , -- ResponseLevel - int
		  0 , -- IsNewPayer - bit
		  NULL , -- DateNewPayerSince - datetime
		  GETDATE() , -- CreatedDate - datetime
		  GETDATE() , -- ModifiedDate - datetime
		  NULL , -- TIMESTAMP - timestamp
		  1 , -- Active - bit
		  0 , -- IsModifiedPayer - bit
		  NULL , -- DateModifiedPayerSince - datetime
		  @chpid , -- KareoClearinghousePayersListID - int
		  GETDATE() , -- KareoLastModifiedDate - datetime
		  @NameTransmitted , -- NameTransmitted - varchar(35)
		  1 , -- SupportsPatientEligibilityRequests - bit
		  1 , -- SupportsSecondaryElectronicBilling - bit
		  1 , -- SupportsCoordinationOfBenefits - bit
		  NULL  -- B2BPayerID - int
		)
