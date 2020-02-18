DECLARE @ClearinghouseID INT, --1: Gateway; 2: OfficeAlly; 3: Capario
		@PayerNumber VARCHAR(32),
		@SharedPayerID INT
		
SELECT @ClearinghouseID = 3,
	   @PayerNumber = '39182'

SET @SharedPayerID = (SELECT ClearinghousePayerID FROM SHAREDSERVER.Superbill_Shared.dbo.ClearinghousePayersList 
		WHERE PayerNumber = @PayerNumber AND ClearinghouseID = @ClearinghouseID AND Active = 1)
	   	   
IF NOT EXISTS (SELECT * 
				FROM dbo.ClearinghousePayersList AS CPL
				WHERE PayerNumber = @PayerNumber AND ClearinghouseID = @ClearinghouseID AND ClearinghousePayerID = @SharedPayerID)
BEGIN		
			   	   
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
	SELECT CPL.ClearinghousePayerID , -- ClearinghousePayerID - int
			  @ClearinghouseID , -- ClearinghouseID - int
			  @PayerNumber , -- PayerNumber - varchar(32)
			  CPL.Name , -- Name - varchar(1000)
			  CPL.Notes , -- Notes - varchar(1000)
			  CPL.StateSpecific , -- StateSpecific - varchar(256)
			  CPL.IsPaperOnly, -- IsPaperOnly - bit
			  CPL.IsGovernment, -- IsGovernment - bit
			  CPL.IsCommercial, -- IsCommercial - bit
			  CPL.IsParticipating, -- IsParticipating - bit
			  CPL.IsProviderIdRequired, -- IsProviderIdRequired - bit
			  CPL.IsEnrollmentRequired, -- IsEnrollmentRequired - bit
			  CPL.IsAuthorizationRequired, -- IsAuthorizationRequired - bit
			  CPL.IsTestRequired, -- IsTestRequired - bit
			  CPL.ResponseLevel, -- ResponseLevel - int
			  CPL.IsNewPayer, -- IsNewPayer - bit
			  CPL.DateNewPayerSince , -- DateNewPayerSince - datetime
			  GETDATE() , -- CreatedDate - datetime
			  GETDATE() , -- ModifiedDate - datetime
			  NULL , -- TIMESTAMP - timestamp
			  CPL.Active, -- Active - bit
			  CPL.IsModifiedPayer , -- IsModifiedPayer - bit
			  CPL.DateModifiedPayerSince , -- DateModifiedPayerSince - datetime
			  CPL.ClearinghousePayerID , -- KareoClearinghousePayersListID - int
			  NULL , -- KareoLastModifiedDate - datetime
			  CPL.NameTransmitted , -- NameTransmitted - varchar(35)
			  CPL.SupportsPatientEligibilityRequests, -- SupportsPatientEligibilityRequests - bit
			  CPL.SupportsSecondaryElectronicBilling, -- SupportsSecondaryElectronicBilling - bit
			  CPL.SupportsCoordinationOfBenefits, -- SupportsCoordinationOfBenefits - bit
			  CPL.B2BPayerID  -- B2BPayerID - int
	FROM SHAREDSERVER.Superbill_Shared.dbo.ClearinghousePayersList AS CPL
	WHERE CPL.PayerNumber = @PayerNumber AND CPL.ClearinghouseID = @ClearinghouseID AND Active = 1

END	