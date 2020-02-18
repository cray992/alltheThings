
IF NOT EXISTS(SELECT * FROM dbo.EdiHack AS EH WHERE [Name] = 'ForceSubscriberInfo2010BA')
BEGIN
	INSERT INTO dbo.EdiHack
	        ( Name ,
	          Description ,
	          Comments ,
	          EdiBillXmlV1 ,
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
	VALUES  ( N'ForceSubscriberInfo2010BA' , -- Name - nvarchar(100)
	          N'Force subscriber info even if the patient is the subscriber' , -- Description - nvarchar(500)
	          N'' , -- Comments - nvarchar(500)
	          0 , -- EdiBillXmlV1 - bit
	          1, -- EdiBillXmlV2 - bit
	          0, -- EdiBillXmlV2i - bit
	          1, -- EdiBillXml5010 - bit
	          0, -- EdiBillXml5010i - bit
	          'N3*1112 MELTON DR~;N4*LILBURN*GA*30047~' , -- Example - varchar(256)
	          'FB4141' , -- ReferencedCases - varchar(256)
	          '2010BA' , -- LoopSegment - varchar(128)
	          GETDATE() , -- LastModifiedDate - datetime
	          'wei.chen'  -- LastModifiedUser - varchar(100)
	        )
END

DECLARE @hackID INT
SET @hackID = (SELECT EDIHackID FROM dbo.EdiHack WHERE [Name] = 'ForceSubscriberInfo2010BA')

IF NOT EXISTS (SELECT * FROM dbo.EdiHackPayer AS EHP WHERE EdiHackID = @hackID AND PayerNumber = '21313')
BEGIN
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
	VALUES  ( @hackID , -- EdiHackID - int
	          N'21313' , -- PayerNumber - nvarchar(64)
	          NULL , -- CustomerID - int
	          0 , -- EdiBillXmlV1 - bit
	          1, -- EdiBillXmlV2 - bit
	          0, -- EdiBillXmlV2i - bit
	          1, -- EdiBillXml5010 - bit
	          0, -- EdiBillXml5010i - bit
	          GETDATE() , -- LastModifiedDate - datetime
	          'wei.chen'  -- LastModifiedUser - varchar(100)
	        )
END