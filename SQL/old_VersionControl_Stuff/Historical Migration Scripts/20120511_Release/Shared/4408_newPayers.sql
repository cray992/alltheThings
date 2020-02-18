IF NOT EXISTS(SELECT * FROM dbo.ClearinghousePayersList AS CPL WHERE PayerNumber = '0088f' AND ClearinghouseID = 3)
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
	VALUES  ( 3, -- ClearinghouseID - int
	          '0088F' , -- PayerNumber - varchar(32)
	          'Blue Cross Blue Shield NY Central - FEP Claims' , -- Name - varchar(1000)
	          '' , -- Notes - varchar(1000)
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
	          0, -- IsNewPayer - bit
	          NULL , -- DateNewPayerSince - datetime
	          GETDATE() , -- CreatedDate - datetime
	          GETDATE() , -- ModifiedDate - datetime
	          NULL , -- TIMESTAMP - timestamp
	          1 , -- Active - bit
	          0 , -- IsModifiedPayer - bit
	          NULL , -- DateModifiedPayerSince - datetime
	          'BLUE CROSS BLUE SHIELD NY CENTRAL' , -- NameTransmitted - varchar(35)
	          NULL , -- B2BPayerID - int
	          1 , -- SupportsPatientEligibilityRequests - bit
	          1 , -- SupportsSecondaryElectronicBilling - bit
	          1 , -- SupportsCoordinationOfBenefits - bit
	          NULL , -- AutoUpdateDate - datetime
	          NULL  -- IsInstitutional - bit
	        )
END


IF NOT EXISTS(SELECT * FROM dbo.ClearinghousePayersList AS CPL WHERE PayerNumber = '0089f' AND ClearinghouseID = 3)
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
	VALUES  ( 3, -- ClearinghouseID - int
	          '0089F' , -- PayerNumber - varchar(32)
	          'Blue Cross Blue Shield NY Utica - FEP Claims' , -- Name - varchar(1000)
	          '' , -- Notes - varchar(1000)
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
	          0, -- IsNewPayer - bit
	          NULL , -- DateNewPayerSince - datetime
	          GETDATE() , -- CreatedDate - datetime
	          GETDATE() , -- ModifiedDate - datetime
	          NULL , -- TIMESTAMP - timestamp
	          1 , -- Active - bit
	          0 , -- IsModifiedPayer - bit
	          NULL , -- DateModifiedPayerSince - datetime
	          'BLUE CROSS BLUE SHIELD NY UTICA' , -- NameTransmitted - varchar(35)
	          NULL , -- B2BPayerID - int
	          1 , -- SupportsPatientEligibilityRequests - bit
	          1 , -- SupportsSecondaryElectronicBilling - bit
	          1 , -- SupportsCoordinationOfBenefits - bit
	          NULL , -- AutoUpdateDate - datetime
	          NULL  -- IsInstitutional - bit
	        )
END

IF NOT EXISTS(SELECT * FROM dbo.ClearinghousePayersList AS CPL WHERE PayerNumber = '36426' AND ClearinghouseID = 3)
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
	VALUES  ( 3, -- ClearinghouseID - int
	          '36426' , -- PayerNumber - varchar(32)
	          'Sendero Health Plan', -- Name - varchar(1000)
	          '' , -- Notes - varchar(1000)
	          'TX' , -- StateSpecific - varchar(256)
	          0 , -- IsPaperOnly - bit
	          0, -- IsGovernment - bit
	          1, -- IsCommercial - bit
	          0, -- IsParticipating - bit
	          0 , -- IsProviderIdRequired - bit
	          0 , -- IsEnrollmentRequired - bit
	          0 , -- IsAuthorizationRequired - bit
	          0 , -- IsTestRequired - bit
	          0 , -- ResponseLevel - int
	          0, -- IsNewPayer - bit
	          NULL , -- DateNewPayerSince - datetime
	          GETDATE() , -- CreatedDate - datetime
	          GETDATE() , -- ModifiedDate - datetime
	          NULL , -- TIMESTAMP - timestamp
	          1 , -- Active - bit
	          0 , -- IsModifiedPayer - bit
	          NULL , -- DateModifiedPayerSince - datetime
	          'SENDERO HEALTH PLAN' , -- NameTransmitted - varchar(35)
	          NULL , -- B2BPayerID - int
	          0 , -- SupportsPatientEligibilityRequests - bit
	          1 , -- SupportsSecondaryElectronicBilling - bit
	          1 , -- SupportsCoordinationOfBenefits - bit
	          NULL , -- AutoUpdateDate - datetime
	          NULL  -- IsInstitutional - bit
	        )
END




IF NOT EXISTS(SELECT * FROM dbo.ClearinghousePayersList AS CPL WHERE PayerNumber = '36426' AND ClearinghouseID = 1)
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
	VALUES  ( 1, -- ClearinghouseID - int
	          '36426' , -- PayerNumber - varchar(32)
	          'Sendero Health', -- Name - varchar(1000)
	          '' , -- Notes - varchar(1000)
	          NULL , -- StateSpecific - varchar(256)
	          0 , -- IsPaperOnly - bit
	          0, -- IsGovernment - bit
	          1, -- IsCommercial - bit
	          0, -- IsParticipating - bit
	          0 , -- IsProviderIdRequired - bit
	          0 , -- IsEnrollmentRequired - bit
	          0 , -- IsAuthorizationRequired - bit
	          0 , -- IsTestRequired - bit
	          0 , -- ResponseLevel - int
	          0, -- IsNewPayer - bit
	          NULL , -- DateNewPayerSince - datetime
	          GETDATE() , -- CreatedDate - datetime
	          GETDATE() , -- ModifiedDate - datetime
	          NULL , -- TIMESTAMP - timestamp
	          1 , -- Active - bit
	          0 , -- IsModifiedPayer - bit
	          NULL , -- DateModifiedPayerSince - datetime
	          'SENDERO HEALTH' , -- NameTransmitted - varchar(35)
	          NULL , -- B2BPayerID - int
	          0 , -- SupportsPatientEligibilityRequests - bit
	          1 , -- SupportsSecondaryElectronicBilling - bit
	          1 , -- SupportsCoordinationOfBenefits - bit
	          NULL , -- AutoUpdateDate - datetime
	          NULL  -- IsInstitutional - bit
	        )
END
