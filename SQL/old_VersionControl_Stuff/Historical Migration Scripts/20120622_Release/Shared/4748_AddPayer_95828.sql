DECLARE @ClearinghouseID INT, --1: Gateway; 2: OfficeAlly; 3: Capario
		@PayerNumber VARCHAR(32),
		@Notes VARCHAR(1000),
		@ClearinghousePayerID INT,
		@Name VARCHAR(1000)
		
SELECT @ClearinghouseID = 1,
	   @PayerNumber = '95828',
	   @Notes = 'FB 4748',
	   @ClearinghousePayerID = 9847,
	   @Name = 'HCare District Palm Beach Cnty'

IF NOT EXISTS (SELECT * 
				FROM dbo.ClearinghousePayersList AS CPL 
				WHERE PayerNumber = @PayerNumber AND ClearinghouseID = @ClearinghouseID)
BEGIN				
	INSERT INTO dbo.ClearinghousePayersList
			( ClearinghouseID ,
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
			  NameTransmitted ,
			  B2BPayerID ,
			  SupportsPatientEligibilityRequests ,
			  SupportsSecondaryElectronicBilling ,
			  SupportsCoordinationOfBenefits ,
			  AutoUpdateDate ,
			  IsInstitutional
			)
	SELECT @ClearinghouseID , -- ClearinghouseID - int
			  @PayerNumber , -- PayerNumber - varchar(32)
			  @Name , -- Name - varchar(1000)
			  @Notes , -- Notes - varchar(1000)
			  StateSpecific , -- StateSpecific - varchar(256)
			  IsPaperOnly, -- IsPaperOnly - bit
			  IsGovernment, -- IsGovernment - bit
			  IsCommercial, -- IsCommercial - bit
			  IsParticipating, -- IsParticipating - bit
			  IsProviderIdRequired, -- IsProviderIdRequired - bit
			  IsEnrollmentRequired, -- IsEnrollmentRequired - bit
			  IsAuthorizationRequired, -- IsAuthorizationRequired - bit
			  IsTestRequired, -- IsTestRequired - bit
			  ResponseLevel, -- ResponseLevel - int
			  IsNewPayer, -- IsNewPayer - bit
			  DateNewPayerSince , -- DateNewPayerSince - datetime
			  GETDATE() , -- CreatedDate - datetime
			  GETDATE() , -- ModifiedDate - datetime
			  NULL , -- TIMESTAMP - timestamp
			  1, -- Active - bit
			  IsModifiedPayer, -- IsModifiedPayer - bit
			  NULL , -- DateModifiedPayerSince - datetime
			  UPPER(@Name) , -- NameTransmitted - varchar(35)
			  B2BPayerID, -- B2BPayerID - int
			  SupportsPatientEligibilityRequests, -- SupportsPatientEligibilityRequests - bit
			  SupportsSecondaryElectronicBilling , -- SupportsSecondaryElectronicBilling - bit
			  SupportsCoordinationOfBenefits , -- SupportsCoordinationOfBenefits - bit
			  AutoUpdateDate, -- AutoUpdateDate - datetime
			  IsInstitutional-- IsInstitutional - bit
	FROM dbo.ClearinghousePayersList AS CPL
	WHERE ClearinghousePayerID = @ClearinghousePayerID
	
	IF NOT EXISTS(SELECT * FROM dbo.ClearinghousePayerEDIVersion WHERE PayerNumber = @PayerNumber AND ClearinghouseID = @ClearinghouseID)
	BEGIN
		INSERT INTO dbo.ClearinghousePayerEDIVersion
				( PayerNumber ,
				  ClearinghouseID ,
				  ClaimEDIVersionID ,
				  RemitEDIVersionID ,
				  EligibilityEDIVersionID
				)
		VALUES  ( @PayerNumber , -- PayerNumber - varchar(50)
				  @ClearinghouseID , -- ClearinghouseID - int
				  2 , -- ClaimEDIVersionID - int
				  2 , -- RemitEDIVersionID - int
				  2  -- EligibilityEDIVersionID - int
				)
	END
END
ELSE
BEGIN
	UPDATE dbo.ClearinghousePayersList
	SET Active = 1
	WHERE ClearinghousePayerID = @ClearinghousePayerID

	UPDATE dbo.ClearinghousePayerEDIVersion
	SET ClaimEDIVersionID = 2, RemitEDIVersionID = 2, EligibilityEDIVersionID = 2
	WHERE PayerNumber = @PayerNumber AND ClearinghouseID = @ClearinghouseID
END	