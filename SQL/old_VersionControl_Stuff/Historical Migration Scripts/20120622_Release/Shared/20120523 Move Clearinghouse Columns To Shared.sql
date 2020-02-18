
USE [Superbill_Shared]

GO

IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='ClearinghousePayersList' AND column_name='EclaimsSupported' )
    ALTER TABLE ClearinghousePayersList ADD EclaimsSupported BIT NOT NULL CONSTRAINT DF_ClearinghousePayersList_EclaimsSupported DEFAULT 1

GO

IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='ClearinghousePayersList' AND column_name='EraSupported' )
    ALTER TABLE ClearinghousePayersList ADD EraSupported BIT NOT NULL CONSTRAINT DF_ClearinghousePayersList_EraSupported DEFAULT 0

GO

IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='ClearinghousePayersList' AND column_name='EclaimsAgreementUrl' )
    ALTER TABLE ClearinghousePayersList ADD EclaimsAgreementUrl VARCHAR(200) NULL

GO

IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='ClearinghousePayersList' AND column_name='EraAgreementUrl' )
    ALTER TABLE ClearinghousePayersList ADD EraAgreementUrl VARCHAR(200) NULL

GO

IF NOT EXISTS ( SELECT * FROM information_schema.columns WHERE table_name='ClearinghousePayersList' AND column_name='EligibilityAgreementUrl' )
    ALTER TABLE ClearinghousePayersList ADD EligibilityAgreementUrl VARCHAR(200) NULL

GO  
	
UPDATE CPL
	SET EclaimsSupported = 1,
	    EraSupported =  CAST(
			CASE WHEN EraAgreementUrlRecord.ParamValue IS NOT NULL AND LEN(EraAgreementUrlRecord.ParamValue) > 0 THEN
				1
			WHEN EXISTS(SELECT * FROM CLEARINGHOUSEPAYERS.ClearinghousePayers.dbo.PayerExtraParams AS CPEX where CPEX.PayerID = CPP.PayerID AND CPEX.ParamName IN ('Eligibility', 'RealTimeEligibility') AND ParamValue = 'True') THEN
				1
			ELSE
				0
			END
		AS BIT),
	    EclaimsAgreementUrl =  EclaimsAgreementUrlRecord.ParamValue,
	    EraAgreementUrl =  EraAgreementUrlRecord.ParamValue,
	    EligibilityAgreementUrl =  EligibilityAgreementUrlRecord.ParamValue
	FROM dbo.ClearinghousePayersList AS CPL
	JOIN dbo.Clearinghouse CH
		  ON CH.ClearinghouseID = CPL.ClearinghouseID 
		LEFT JOIN dbo.ClearinghousePayerEDIVersion AS CPEV
		  ON CPL.PayerNumber = CPEV.PayerNumber AND CPL.ClearinghouseID = CPEV.ClearinghouseID
		INNER JOIN CLEARINGHOUSEPAYERS.ClearinghousePayers.dbo.Payer AS CPP
		  ON CPL.ClearinghouseID = CPP.PayerSourceID AND CPL.PayerNumber = CPP.PayerExternalID COLLATE Latin1_General_CI_AS AND CPL.Name = CPP.PayerName COLLATE Latin1_General_CI_AS AND CPP.Active = 1
		LEFT JOIN CLEARINGHOUSEPAYERS.ClearinghousePayers.dbo.PayerExtraParams AS EclaimsAgreementUrlRecord
		  ON EclaimsAgreementUrlRecord.PayerID = CPP.PayerID AND EclaimsAgreementUrlRecord.ParamName = 'ClaimsAgreementUrl'
		LEFT JOIN CLEARINGHOUSEPAYERS.ClearinghousePayers.dbo.PayerExtraParams AS EraAgreementUrlRecord
		  ON EraAgreementUrlRecord.PayerID = CPP.PayerID AND EraAgreementUrlRecord.ParamName = 'EraAgreementUrl'
		LEFT JOIN CLEARINGHOUSEPAYERS.ClearinghousePayers.dbo.PayerExtraParams AS EligibilityAgreementUrlRecord
		  ON EligibilityAgreementUrlRecord.PayerID = CPP.PayerID AND EligibilityAgreementUrlRecord.ParamName = 'EligibilityAgreementUrl'

GO    
