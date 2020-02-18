DECLARE @chpid INT

IF NOT EXISTS (SELECT * FROM dbo.ClearinghousePayersList AS CPL WHERE PayerNumber = '0089F' AND ClearinghouseID = 3)
BEGIN
	
	SET @chpid = (SELECT ClearinghousePayerID 
		FROM SHAREDSERVER.Superbill_Shared.dbo.ClearinghousePayersList 
		WHERE PayerNumber = '0089F' AND ClearinghouseID = 3)
	
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
			  3 , -- ClearinghouseID - int
			  '0089F' , -- PayerNumber - varchar(32)
			  'Blue Cross and Blue Shield of New York Utica - FEP Claims' , -- Name - varchar(1000)
			  'created for fb 4408' , -- Notes - varchar(1000)
			  'NY' , -- StateSpecific - varchar(256)
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
			  'BLUE CROSS BLUE SHIELD NY UTICA' , -- NameTransmitted - varchar(35)
			  1 , -- SupportsPatientEligibilityRequests - bit
			  1 , -- SupportsSecondaryElectronicBilling - bit
			  1 , -- SupportsCoordinationOfBenefits - bit
			  NULL  -- B2BPayerID - int
			)
END			

IF NOT EXISTS (SELECT * FROM dbo.ClearinghousePayersList AS CPL WHERE PayerNumber = '0088F' AND ClearinghouseID = 3)
BEGIN
	SET @chpid = (SELECT ClearinghousePayerID 
		FROM SHAREDSERVER.Superbill_Shared.dbo.ClearinghousePayersList 
		WHERE PayerNumber = '0088F' AND ClearinghouseID = 3)
		
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
			  3 , -- ClearinghouseID - int
			  '0088F' , -- PayerNumber - varchar(32)
			  'Blue Cross and Blue Shield of New York Central - FEP Claims' , -- Name - varchar(1000)
			  'created for fb 4408' , -- Notes - varchar(1000)
			  'NY' , -- StateSpecific - varchar(256)
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
			  'BLUE CROSS BLUE SHIELD NY CENTRAL' , -- NameTransmitted - varchar(35)
			  1 , -- SupportsPatientEligibilityRequests - bit
			  1 , -- SupportsSecondaryElectronicBilling - bit
			  1 , -- SupportsCoordinationOfBenefits - bit
			  NULL  -- B2BPayerID - int
			)
END			


IF NOT EXISTS (SELECT * FROM dbo.ClearinghousePayersList AS CPL WHERE PayerNumber = '36426' AND ClearinghouseID = 3)
BEGIN
	
	SET @chpid = (SELECT ClearinghousePayerID 
		FROM SHAREDSERVER.Superbill_Shared.dbo.ClearinghousePayersList 
		WHERE PayerNumber = '36426' AND ClearinghouseID = 3)
	
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
			  3 , -- ClearinghouseID - int
			  '36426' , -- PayerNumber - varchar(32)
			  'Sendero Health Plan' , -- Name - varchar(1000)
			  'created for fb 4456' , -- Notes - varchar(1000)
			  'TX' , -- StateSpecific - varchar(256)
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
			  @chpid, -- KareoClearinghousePayersListID - int
			  GETDATE() , -- KareoLastModifiedDate - datetime
			  'SENDERO HEALTH PLAN' , -- NameTransmitted - varchar(35)
			  1 , -- SupportsPatientEligibilityRequests - bit
			  1 , -- SupportsSecondaryElectronicBilling - bit
			  1 , -- SupportsCoordinationOfBenefits - bit
			  NULL  -- B2BPayerID - int
			)
END			

IF NOT EXISTS (SELECT * FROM dbo.ClearinghousePayersList AS CPL WHERE PayerNumber = '36426' AND ClearinghouseID = 1)
BEGIN

	SET @chpid = (SELECT ClearinghousePayerID 
		FROM SHAREDSERVER.Superbill_Shared.dbo.ClearinghousePayersList 
		WHERE PayerNumber = '36426' AND ClearinghouseID = 1)
	
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
			  1 , -- ClearinghouseID - int
			  '36426' , -- PayerNumber - varchar(32)
			  'Sendero Health' , -- Name - varchar(1000)
			  'created for fb 4456' , -- Notes - varchar(1000)
			  NULL , -- StateSpecific - varchar(256)
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
			  @chpid, -- KareoClearinghousePayersListID - int
			  GETDATE() , -- KareoLastModifiedDate - datetime
			  'SENDERO HEALTH' , -- NameTransmitted - varchar(35)
			  1 , -- SupportsPatientEligibilityRequests - bit
			  1 , -- SupportsSecondaryElectronicBilling - bit
			  1 , -- SupportsCoordinationOfBenefits - bit
			  NULL  -- B2BPayerID - int
			)
END			