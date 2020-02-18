IF NOT EXISTS (SELECT * FROM dbo.ClearinghousePayersList AS CPL WHERE ClearinghousePayerID = 17436)
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
	VALUES  ( 17436, -- ClearinghousePayerID - int
			  3 , -- ClearinghouseID - int
			  '41205' , -- PayerNumber - varchar(32)
			  'BENEFIT ADMINISTRATION SERVICES, LTD (BAS LTD)' , -- Name - varchar(1000)
			  'created for fb 3978' , -- Notes - varchar(1000)
			  'MS' , -- StateSpecific - varchar(256)
			  0 , -- IsPaperOnly - bit
			  0, -- IsGovernment - bit
			  0, -- IsCommercial - bit
			  0, -- IsParticipating - bit
			  0, -- IsProviderIdRequired - bit
			  0 , -- IsEnrollmentRequired - bit
			  0, -- IsAuthorizationRequired - bit
			  0, -- IsTestRequired - bit
			  0 , -- ResponseLevel - int
			  0, -- IsNewPayer - bit
			  NULL , -- DateNewPayerSince - datetime
			  '2012-04-06 19:15:06' , -- CreatedDate - datetime
			  '2012-04-06 19:15:06' , -- ModifiedDate - datetime
			  NULL , -- TIMESTAMP - timestamp
			  1 , -- Active - bit
			  0 , -- IsModifiedPayer - bit
			  NULL , -- DateModifiedPayerSince - datetime
			  17436 , -- KareoClearinghousePayersListID - int
			  '2012-04-06 19:15:06' , -- KareoLastModifiedDate - datetime
			  'BENEFIT ADMINISTRATION SERVICES LTD' , -- NameTransmitted - varchar(35)
			  0 , -- SupportsPatientEligibilityRequests - bit
			  0, -- SupportsSecondaryElectronicBilling - bit
			  0, -- SupportsCoordinationOfBenefits - bit
			  NULL  -- B2BPayerID - int
			)
END