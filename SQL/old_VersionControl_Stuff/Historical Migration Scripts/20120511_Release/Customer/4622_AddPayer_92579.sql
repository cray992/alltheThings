DECLARE @chpid INT

IF NOT EXISTS (SELECT * FROM dbo.ClearinghousePayersList AS CPL WHERE PayerNumber = '92579' AND ClearinghouseID = 1 AND Active = 1)
BEGIN
	
	SET @chpid = (SELECT ClearinghousePayerID 
		FROM SHAREDSERVER.Superbill_Shared.dbo.ClearinghousePayersList 
		WHERE PayerNumber = '92579' AND ClearinghouseID = 1)
	
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
			  '92579' , -- PayerNumber - varchar(32)
			  'University of Miami Behavioral Hlth' , -- Name - varchar(1000)
			  'FB4622' , -- Notes - varchar(1000)
			  'FL' , -- StateSpecific - varchar(256)
			  0 , -- IsPaperOnly - bit
			  0, -- IsGovernment - bit
			  0, -- IsCommercial - bit
			  0, -- IsParticipating - bit
			  0 , -- IsProviderIdRequired - bit
			  0 , -- IsEnrollmentRequired - bit
			  1 , -- IsAuthorizationRequired - bit
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
			  'UNIVERSITY OF MIAMI BEHAVIORAL HLTH' , -- NameTransmitted - varchar(35)
			  0 , -- SupportsPatientEligibilityRequests - bit
			  0 , -- SupportsSecondaryElectronicBilling - bit
			  0 , -- SupportsCoordinationOfBenefits - bit
			  NULL  -- B2BPayerID - int
			)
END			

--SELECT *
--FROM dbo.ClearinghousePayersList AS CPL
--WHERE PayerNumber = '92579'