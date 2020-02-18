DECLARE @ClearinghouseID INT, --1: Capario; 2: OfficeAlly; 3: Gateway
		@PayerNumber VARCHAR(32),
		@Name VARCHAR(1000),
		@NameTransmitted VARCHAR(35),
		@Notes VARCHAR(1000)
		
SELECT @ClearinghouseID = 3,
	   @PayerNumber = '39182',
	   @Name = 'Insurance TPA',
	   @NameTransmitted = 'INSURANCE TPA',
	   @Notes = 'FB 4760'

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
	VALUES ( @ClearinghouseID , -- ClearinghouseID - int
			  @PayerNumber , -- PayerNumber - varchar(32)
			  @Name , -- Name - varchar(1000)
			  @Notes , -- Notes - varchar(1000)
			  NULL , -- StateSpecific - varchar(256)
			  0, -- IsPaperOnly - bit
			  0, -- IsGovernment - bit
			  1, -- IsCommercial - bit
			  0, -- IsParticipating - bit
			  0, -- IsProviderIdRequired - bit
			  0, -- IsEnrollmentRequired - bit
			  0, -- IsAuthorizationRequired - bit
			  0, -- IsTestRequired - bit
			  0, -- ResponseLevel - int
			  0, -- IsNewPayer - bit
			  NULL , -- DateNewPayerSince - datetime
			  GETDATE() , -- CreatedDate - datetime
			  GETDATE() , -- ModifiedDate - datetime
			  NULL , -- TIMESTAMP - timestamp
			  1, -- Active - bit
			  0, -- IsModifiedPayer - bit
			  NULL , -- DateModifiedPayerSince - datetime
			  @NameTransmitted , -- NameTransmitted - varchar(35)
			  NULL, -- B2BPayerID - int
			  0, -- SupportsPatientEligibilityRequests - bit
			  0, -- SupportsSecondaryElectronicBilling - bit
			  0, -- SupportsCoordinationOfBenefits - bit
			  NULL, -- AutoUpdateDate - datetime
			  0 -- IsInstitutional - bit
			  )
	
	IF NOT EXISTS(SELECT * FROM dbo.ClearinghousePayerEDIVersion AS CPEV WHERE PayerNumber = @PayerNumber)
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
	WHERE PayerNumber = @PayerNumber AND ClearinghouseID = @ClearinghouseID

	UPDATE dbo.ClearinghousePayerEDIVersion
	SET ClaimEDIVersionID = 2, RemitEDIVersionID = 2, EligibilityEDIVersionID = 2
	WHERE PayerNumber = @PayerNumber AND ClearinghouseID = @ClearinghouseID
END	