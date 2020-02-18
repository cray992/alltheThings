IF NOT EXISTS (SELECT * FROM dbo.EdiHack AS EH WHERE Name = 'Use2330BAdjudicationDate')
BEGIN

	INSERT INTO dbo.EdiHack
			( Name ,
			  Description ,
			  Comments ,
			  EdiBillXMLV1 ,
			  EdiBillXmlV2 ,
			  EdiBillXmlV2i ,
			  EdiBillXml5010 ,
			  EdiBillXml5010i ,
			  Example ,
			  ReferencedCases ,
			  LoopSegment ,
			  LastModifiedDate ,
			  LastModifiedUser
			)
	VALUES  ( N'Use2330BAdjudicationDate' , -- Name - nvarchar(100)
			  N'Populate adjudication date in 2330B' , -- Description - nvarchar(500)
			  N'' , -- Comments - nvarchar(500)
			  0, -- EdiBillXMLV1 - bit
			  0, -- EdiBillXmlV2 - bit
			  0, -- EdiBillXmlV2i - bit
			  1, -- EdiBillXml5010 - bit
			  0, -- EdiBillXml5010i - bit
			  'DTP*573*20120718' , -- Example - varchar(256)
			  '4820' , -- ReferencedCases - varchar(256)
			  '2330B' , -- LoopSegment - varchar(128)
			  GETDATE() , -- LastModifiedDate - datetime
			  'wei.chen'  -- LastModifiedUser - varchar(100)
			)
	        
	INSERT INTO dbo.EdiHackPayer
			( EdiHackID ,
			  PayerNumber ,
			  CustomerID ,
			  EdiBillXmlV1 ,
			  EdiBillXmlV2 ,
			  EdiBillXmlV2i ,
			  EdiBillXml5010 ,
			  EdiBillXml5010i ,
			  LastModifiedDate ,
			  LastModifiedUser
			)
	SELECT EdiHackID , -- EdiHackID - int
			  N'MR053' , -- PayerNumber - nvarchar(64)
			  10007, -- CustomerID - int
			  0 , -- EdiBillXmlV1 - bit
			  0, -- EdiBillXmlV2 - bit
			  0, -- EdiBillXmlV2i - bit
			  1, -- EdiBillXml5010 - bit
			  0, -- EdiBillXml5010i - bit
			  GETDATE() , -- LastModifiedDate - datetime
			  'wei.chen'  -- LastModifiedUser - varchar(100)
	FROM dbo.EdiHack AS EH
	WHERE Name = 'Use2330BAdjudicationDate'

--fb4877
INSERT INTO dbo.EdiHackPayer
			( EdiHackID ,
			  PayerNumber ,
			  CustomerID ,
			  EdiBillXmlV1 ,
			  EdiBillXmlV2 ,
			  EdiBillXmlV2i ,
			  EdiBillXml5010 ,
			  EdiBillXml5010i ,
			  LastModifiedDate ,
			  LastModifiedUser
			)
	SELECT EdiHackID , -- EdiHackID - int
			  N'MC059' , -- PayerNumber - nvarchar(64)
			  7083, -- CustomerID - int
			  0 , -- EdiBillXmlV1 - bit
			  0, -- EdiBillXmlV2 - bit
			  0, -- EdiBillXmlV2i - bit
			  1, -- EdiBillXml5010 - bit
			  0, -- EdiBillXml5010i - bit
			  GETDATE() , -- LastModifiedDate - datetime
			  'wei.chen'  -- LastModifiedUser - varchar(100)
	FROM dbo.EdiHack AS EH
	WHERE Name = 'Use2330BAdjudicationDate'

INSERT INTO dbo.EdiHackPayer
			( EdiHackID ,
			  PayerNumber ,
			  CustomerID ,
			  EdiBillXmlV1 ,
			  EdiBillXmlV2 ,
			  EdiBillXmlV2i ,
			  EdiBillXml5010 ,
			  EdiBillXml5010i ,
			  LastModifiedDate ,
			  LastModifiedUser
			)
	SELECT EdiHackID , -- EdiHackID - int
			  N'MC097' , -- PayerNumber - nvarchar(64)
			  6491, -- CustomerID - int
			  0 , -- EdiBillXmlV1 - bit
			  0, -- EdiBillXmlV2 - bit
			  0, -- EdiBillXmlV2i - bit
			  1, -- EdiBillXml5010 - bit
			  0, -- EdiBillXml5010i - bit
			  GETDATE() , -- LastModifiedDate - datetime
			  'wei.chen'  -- LastModifiedUser - varchar(100)
	FROM dbo.EdiHack AS EH
	WHERE Name = 'Use2330BAdjudicationDate'

	
END
