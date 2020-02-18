DECLARE @payernumber VARCHAR(32),
		@clearinghouseid INT,
		@name VARCHAR(1000),
		@notes VARCHAR(1000),
		@state VARCHAR(256),
		@nametransmitted VARCHAR(35)
		
SELECT 	@payernumber = '92579',
		@clearinghouseid = 1,
		@name = 'University of Miami Behavioral Hlth',
		@notes = 'FB4622',
		@state = 'FL',
		@nametransmitted = 'UNIVERSITY OF MIAMI BEHAVIORAL HLTH'	

IF EXISTS (SELECT * 
				FROM dbo.ClearinghousePayersList AS CPL 
				WHERE PayerNumber = @payernumber 
					AND ClearinghouseID = @clearinghouseid)
BEGIN

	DELETE FROM dbo.ClearinghousePayersList
	WHERE PayerNumber = @payernumber
		AND ClearinghouseID = @clearinghouseid

END

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
VALUES  ( @clearinghouseid , -- ClearinghouseID - int
		  @payernumber , -- PayerNumber - varchar(32)
		  @name , -- Name - varchar(1000)
		  @notes , -- Notes - varchar(1000)
		  @state , -- StateSpecific - varchar(256)
		  0 , -- IsPaperOnly - bit
		  0, -- IsGovernment - bit
		  0, -- IsCommercial - bit
		  0 , -- IsParticipating - bit
		  0 , -- IsProviderIdRequired - bit
		  0 , -- IsEnrollmentRequired - bit
		  1 , -- IsAuthorizationRequired - bit
		  0 , -- IsTestRequired - bit
		  0 , -- ResponseLevel - int
		  0 , -- IsNewPayer - bit
		  NULL , -- DateNewPayerSince - datetime
		  GETDATE() , -- CreatedDate - datetime
		  GETDATE() , -- ModifiedDate - datetime
		  NULL , -- TIMESTAMP - timestamp
		  1 , -- Active - bit
		  0, -- IsModifiedPayer - bit
		  NULL , -- DateModifiedPayerSince - datetime
		  @nametransmitted , -- NameTransmitted - varchar(35)
		  NULL , -- B2BPayerID - int
		  0 , -- SupportsPatientEligibilityRequests - bit
		  0, -- SupportsSecondaryElectronicBilling - bit
		  0, -- SupportsCoordinationOfBenefits - bit
		  NULL , -- AutoUpdateDate - datetime
		  0  -- IsInstitutional - bit
		)