IF NOT EXISTS (SELECT * FROM dbo.EdiHack AS EH WHERE Name = 'ChangeInsuranceProgramToMB')
BEGIN
	INSERT INTO dbo.EdiHack
			( Name ,
			  Description ,
			  Comments ,
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
	VALUES  ( N'ChangeInsuranceProgramToMB' , -- Name - nvarchar(100)
			  N'If primary payer = 88023, for ''MB'' in 2320 SBR09' , -- Description - nvarchar(500)
			  N'' , -- Comments - nvarchar(500)
			  1, -- EdiBillXmlV2 - bit
			  0, -- EdiBillXmlV2i - bit
			  1, -- EdiBillXml5010 - bit
			  0, -- EdiBillXml5010i - bit
			  '' , -- Example - varchar(256)
			  'FB4355' , -- ReferencedCases - varchar(256)
			  '2320 SBR09' , -- LoopSegment - varchar(128)
			  '2012-04-18' , -- LastModifiedDate - datetime
			  'wei.chen'  -- LastModifiedUser - varchar(100)
			)

	DECLARE @edihackid INT
	SET @edihackid = (SELECT edihackid FROM dbo.EdiHack AS EH WHERE Name = 'ChangeInsuranceProgramToMB')

	INSERT INTO dbo.EdiHackPayer
			( EdiHackID ,
			  PayerNumber ,
			  CustomerID ,
			  EdiBillXmlV2 ,
			  EdiBillXmlV2i ,
			  EdiBillXml5010 ,
			  EdiBillXml5010i ,
			  LastModifiedDate ,
			  LastModifiedUser
			)
	VALUES  ( @edihackid , -- EdiHackID - int
			  N'00266' , -- PayerNumber - nvarchar(64)
			  9352 , -- CustomerID - int
			  1, -- EdiBillXmlV2 - bit
			  0, -- EdiBillXmlV2i - bit
			  1, -- EdiBillXml5010 - bit
			  0, -- EdiBillXml5010i - bit
			  '2012-04-18' , -- LastModifiedDate - datetime
			  'wei.chen'  -- LastModifiedUser - varchar(100)
			)
END		
