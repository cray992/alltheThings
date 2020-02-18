IF NOT EXISTS (SELECT EDIHackID FROM dbo.EdiHack WHERE Name = 'GetUnitsFromLineNote')
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
	VALUES  ( N'GetUnitsFromLineNote' , -- Name - nvarchar(100)
			  N'Pull CTP04 units from procedure line note where reference code is "ADD"' , -- Description - nvarchar(500)
			  N'' , -- Comments - nvarchar(500)
			  0, -- EdiBillXMLV1 - bit
			  0, -- EdiBillXmlV2 - bit
			  0, -- EdiBillXmlV2i - bit
			  1, -- EdiBillXml5010 - bit
			  0, -- EdiBillXml5010i - bit
			  'CTP****10* ML~' , -- Example - varchar(256)
			  'PT36475015' , -- ReferencedCases - varchar(256)
			  'CTP04' , -- LoopSegment - varchar(128)
			  GETDATE() , -- LastModifiedDate - datetime
			  'wei.chen'  -- LastModifiedUser - varchar(100)
			)

	DECLARE @EdiHackID INT
	SET @EdiHackID = (SELECT EDIHackID FROM dbo.EdiHack WHERE Name = 'GetUnitsFromLineNote')

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
	VALUES  ( @EdiHackID , -- EdiHackID - int
			  N'00266' , -- PayerNumber - nvarchar(64)
			  9352 , -- CustomerID - int
			  0 , -- EdiBillXmlV1 - bit
			  0, -- EdiBillXmlV2 - bit
			  0, -- EdiBillXmlV2i - bit
			  1, -- EdiBillXml5010 - bit
			  0, -- EdiBillXml5010i - bit
			  GETDATE() , -- LastModifiedDate - datetime
			  'wei.chen'  -- LastModifiedUser - varchar(100)
			)

END