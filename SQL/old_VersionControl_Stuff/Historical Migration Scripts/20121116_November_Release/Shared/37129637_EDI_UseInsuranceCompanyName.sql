IF NOT EXISTS (SELECT * FROM dbo.EdiHack AS EH WHERE Name = 'UseInsuranceCompanyName')
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
	VALUES  ( N'UseInsuranceCompanyName' , -- Name - nvarchar(100)
			  N'Use the insurance company name as the payer''s transmitted name' , -- Description - nvarchar(500)
			  N'' , -- Comments - nvarchar(500)
			  0, -- EdiBillXMLV1 - bit
			  0, -- EdiBillXmlV2 - bit
			  0, -- EdiBillXmlV2i - bit
			  1, -- EdiBillXml5010 - bit
			  0, -- EdiBillXml5010i - bit
			  'NM1*PR*2*DMBA/ CHP*****PI*SX156~' , -- Example - varchar(256)
			  'PT37129637' , -- ReferencedCases - varchar(256)
			  '2010BB' , -- LoopSegment - varchar(128)
			  GETDATE() , -- LastModifiedDate - datetime
			  'wei.chen'  -- LastModifiedUser - varchar(100)
			)

	DECLARE @edihackid INT
	SET @edihackid = (SELECT EdiHackID FROM dbo.EdiHack AS EH WHERE Name = 'UseInsuranceCompanyName')

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
	VALUES  ( @edihackid , -- EdiHackID - int
	          N'SX156' , -- PayerNumber - nvarchar(64)
	          10033 , -- CustomerID - int
	          0, -- EdiBillXmlV1 - bit
	          0, -- EdiBillXmlV2 - bit
	          0, -- EdiBillXmlV2i - bit
	          1, -- EdiBillXml5010 - bit
	          0, -- EdiBillXml5010i - bit
	          GETDATE() , -- LastModifiedDate - datetime
	          'wei.chen'  -- LastModifiedUser - varchar(100)
	        )

END