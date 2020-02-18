
-- CAPARIO FOR KAREO
IF EXISTS (SELECT * FROM dbo.EligibilityTransport AS et WHERE et.TransportType = 1 AND et.PartnerID = 1 AND ClearinghouseID = 1)
BEGIN	
	DELETE FROM dbo.EligibilityTransport WHERE TransportType = 1 AND PartnerID = 1 AND ClearinghouseID = 1
END
 
INSERT dbo.EligibilityTransport
        ( TransportName ,
          TransportType ,
          Active ,
          ParametersXml ,
          Notes ,
          EligibilityTransportID ,
          ClearinghouseID ,
          PartnerID
        )
VALUES  ( 'MedAvant HTTP' , -- TransportName - varchar(128)
          1 , -- TransportType - varchar(32)
          1 , -- Active - bit
          '<Parameters>    <Http>      <Url>https://b2b.capario.net/b2b/X12Transaction</Url>   <Login>kirvin6</Login>   <Password>pitkirvin6</Password>    </Http>    <AnsiX12>   <SubmitterName>KAREO</SubmitterName>   <SubmitterEtin>00739220</SubmitterEtin>   <SubmitterContactName>Kareo Inc Eligibility</SubmitterContactName>   <SubmitterContactPhone>1-888-775-2736</SubmitterContactPhone>   <SubmitterContactEmail>sergei@kareo.com</SubmitterContactEmail>   <SubmitterContactFax>949-209-3473</SubmitterContactFax>   <ReceiverName>MEDAVANT</ReceiverName>   <ReceiverEtin>770545613</ReceiverEtin>    </AnsiX12>  </Parameters>' , -- ParametersXml - ntext
          NULL, -- Notes - ntext
          1 , -- EligibilityTransportID - int
          1 , -- ClearinghouseID - int
          1  -- PartnerID - int
        )

--CAPARIO FOR RCM
IF EXISTS (SELECT * FROM dbo.EligibilityTransport AS et WHERE et.TransportType = 1 AND et.PartnerID = 2 AND ClearinghouseID = 1)
BEGIN	
	DELETE FROM dbo.EligibilityTransport WHERE TransportType = 1 AND PartnerID = 2 AND ClearinghouseID = 1
END
 
INSERT dbo.EligibilityTransport
        ( TransportName ,
          TransportType ,
          Active ,
          ParametersXml ,
          Notes ,
          EligibilityTransportID ,
          ClearinghouseID ,
          PartnerID
        )
VALUES  ( 'MedAvant HTTP' , -- TransportName - varchar(128)
          1 , -- TransportType - varchar(32)
          1 , -- Active - bit
          '<Parameters>    <Http>      <Url>https://b2b.capario.net/b2b/X12Transaction</Url>   <Login>kacadem9</Login>   <Password>kareocap89</Password>    </Http>    <AnsiX12>   <SubmitterName>KAREO</SubmitterName>   <SubmitterEtin>00739220</SubmitterEtin>   <SubmitterContactName>Kareo Inc Eligibility</SubmitterContactName>   <SubmitterContactPhone>1-888-775-2736</SubmitterContactPhone>   <SubmitterContactEmail>sergei@kareo.com</SubmitterContactEmail>   <SubmitterContactFax>949-209-3473</SubmitterContactFax>   <ReceiverName>MEDAVANT</ReceiverName>   <ReceiverEtin>770545613</ReceiverEtin>    </AnsiX12>  </Parameters>' , -- ParametersXml - ntext
          'RCM', -- Notes - ntext
          2 , -- EligibilityTransportID - int
          1 , -- ClearinghouseID - int
          9  -- PartnerID - int
        )

--GATEWAY FOR KAREO
IF EXISTS (SELECT * FROM dbo.EligibilityTransport AS et WHERE et.TransportType = 1 AND et.PartnerID = 1 AND ClearinghouseID = 3)
BEGIN	
	DELETE FROM dbo.EligibilityTransport WHERE TransportType = 1 AND PartnerID = 1 AND ClearinghouseID = 3
END
 

INSERT dbo.EligibilityTransport
        ( TransportName ,
          TransportType ,
          Active ,
          ParametersXml ,
          Notes ,
          EligibilityTransportID ,
          ClearinghouseID ,
          PartnerID
        )
VALUES  ( 'Gateway EDI Web Service' , -- TransportName - varchar(128)
          1 , -- TransportType - varchar(32)
          1 , -- Active - bit
          '<Parameters>    <Http>      <Url>https://services.gatewayedi.com/Eligibility/Service.asmx</Url>   <Login>11QZ</Login>   <Password>ym8r4lyb</Password>    </Http>    <AnsiX12>   <SubmitterName>KAREO</SubmitterName>   <SubmitterEtin>00739220</SubmitterEtin>   <SubmitterContactName>Kareo Inc Eligibility</SubmitterContactName>   <SubmitterContactPhone>1-888-775-2736</SubmitterContactPhone>   <SubmitterContactEmail>support@kareo.com</SubmitterContactEmail>   <SubmitterContactFax>949-209-3473</SubmitterContactFax>   <ReceiverName>GATEWAYEDI</ReceiverName>   <ReceiverEtin>770545613</ReceiverEtin>    </AnsiX12>  </Parameters>' , -- ParametersXml - ntext
          null, -- Notes - ntext
          3 , -- EligibilityTransportID - int
          3 , -- ClearinghouseID - int
          1  -- PartnerID - int
        )
        
        
--GATEWAY FOR RCM
IF EXISTS (SELECT * FROM dbo.EligibilityTransport AS et WHERE et.TransportType = 1 AND et.PartnerID = 2 AND ClearinghouseID = 3)
BEGIN	
	DELETE FROM dbo.EligibilityTransport WHERE TransportType = 1 AND PartnerID = 2 AND ClearinghouseID = 3
END
 

INSERT dbo.EligibilityTransport
        ( TransportName ,
          TransportType ,
          Active ,
          ParametersXml ,
          Notes ,
          EligibilityTransportID ,
          ClearinghouseID ,
          PartnerID
        )
VALUES  ( 'Gateway EDI Web Service' , -- TransportName - varchar(128)
          1 , -- TransportType - varchar(32)
          1 , -- Active - bit
          '<Parameters>    <Http>      <Url>https://services.gatewayedi.com/Eligibility/Service.asmx</Url>   <Login>2EM5</Login>   <Password>ym8r4lyb</Password>    </Http>    <AnsiX12>   <SubmitterName>KAREO</SubmitterName>   <SubmitterEtin>00739220</SubmitterEtin>   <SubmitterContactName>Kareo Inc Eligibility</SubmitterContactName>   <SubmitterContactPhone>1-888-775-2736</SubmitterContactPhone>   <SubmitterContactEmail>support@kareo.com</SubmitterContactEmail>   <SubmitterContactFax>949-209-3473</SubmitterContactFax>   <ReceiverName>GATEWAYEDI</ReceiverName>   <ReceiverEtin>770545613</ReceiverEtin>    </AnsiX12>  </Parameters>' , -- ParametersXml - ntext
          'RCM', -- Notes - ntext
          4 , -- EligibilityTransportID - int
          3 , -- ClearinghouseID - int
          9  -- PartnerID - int
        )

IF EXISTS (SELECT * FROM dbo.EligibilityTransport AS et WHERE et.TransportType = 2 AND et.PartnerID = 1)
BEGIN	
	DELETE FROM dbo.EligibilityTransport WHERE TransportType = 2 AND PartnerID = 1
END
INSERT dbo.EligibilityTransport
        ( TransportName ,
          TransportType ,
          Active ,
          ParametersXml ,
          Notes ,
          EligibilityTransportID ,
          ClearinghouseID ,
          PartnerID
        )
VALUES  ( 'Eligible API' , -- TransportName - varchar(128)
          2 , -- TransportType - varchar(32)
          1 , -- Active - bit
          '<Parameters>    <Url>https://json1.eligibleapi.net/search.asp?</Url>   <Key>26e2b12f-4176-b05e-f4ec-ca58aff2f6f0</Key>  </Parameters>' , -- ParametersXml - ntext
          NULL, -- Notes - ntext
          5 , -- EligibilityTransportID - int
          0 , -- ClearinghouseID - int
          1  -- PartnerID - int
        )


IF EXISTS (SELECT * FROM dbo.EligibilityTransport AS et WHERE et.TransportType = 2 AND et.PartnerID = 2)
BEGIN	
	DELETE FROM dbo.EligibilityTransport WHERE TransportType = 2 AND PartnerID = 2
END
    
INSERT dbo.EligibilityTransport
        ( TransportName ,
          TransportType ,
          Active ,
          ParametersXml ,
          Notes ,
          EligibilityTransportID ,
          ClearinghouseID ,
          PartnerID
        )
VALUES  ( 'Eligible API' , -- TransportName - varchar(128)
          2 , -- TransportType - varchar(32)
          1 , -- Active - bit
          '<Parameters>    <Url>https://json1.eligibleapi.net/search.asp?</Url>   <Key>2b3f43c8-a082-4309-93f0-f44a11beb522</Key>  </Parameters>' , -- ParametersXml - ntext
          'RCM', -- Notes - ntext
          6 , -- EligibilityTransportID - int
          0 , -- ClearinghouseID - int
          9  -- PartnerID - int
        )

--SELECT * FROM dbo.EligibilityTransport AS et