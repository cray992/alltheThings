IF NOT EXISTS (SELECT * FROM dbo.EdiHack AS EH WHERE Name = 'Force2400SV105Return')
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
	VALUES  ('Force2400SV105Return',
	 'Populate POS in 2400 SV105 loop for MR001',
	 '',
	 0,
	 0,
	 1,
	 0,
	 '',
	 'FB4509',
	 '2400 SV105',
	 getdate(),
	 'douglas.ginther'
	 )
	 
DECLARE @edihackid INT

SET @edihackid = (SELECT EdiHackId FROM dbo.EdiHack AS EH WHERE name = 'Force2400SV105Return')


INSERT INTO dbo.EdiHackPayer
			 (EdiHackID ,
			  PayerNumber ,
			  CustomerID ,
			  EdiBillXmlV2 ,
			  EdiBillXmlV2i ,
			  EdiBillXml5010 ,
			  EdiBillXml5010i ,
			  LastModifiedDate ,
			  LastModifiedUser
			)
	VALUES (@edihackid,
			'MR001',
			7632,
			0,
			0,
			1,
			0,
			getDate(),
			'douglas.ginther'
			)
			
INSERT INTO dbo.EdiHackPayer
			 (EdiHackID ,
			  PayerNumber ,
			  CustomerID ,
			  EdiBillXmlV2 ,
			  EdiBillXmlV2i ,
			  EdiBillXml5010 ,
			  EdiBillXml5010i ,
			  LastModifiedDate ,
			  LastModifiedUser
			)
	VALUES (@edihackid,
			'MR001',
			6467,
			0,
			0,
			1,
			0,
			getDate(),
			'douglas.ginther'
			)	


END
		