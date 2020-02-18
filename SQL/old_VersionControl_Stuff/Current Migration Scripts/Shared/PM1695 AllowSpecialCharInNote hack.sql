IF NOT EXISTS (SELECT 1 FROM dbo.EdiHack WHERE [Name] = 'AllowSpecialCharInNote')
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
	VALUES  ( N'AllowSpecialCharInNote' , -- Name - nvarchar(100)
			  N'Allow + and / characters in the notes segment' , -- Description - nvarchar(500)
			  N'' , -- Comments - nvarchar(500)
			  0, -- EdiBillXMLV1 - bit
			  0, -- EdiBillXmlV2 - bit
			  0, -- EdiBillXmlV2i - bit
			  1, -- EdiBillXml5010 - bit
			  0, -- EdiBillXml5010i - bit
			  'NTE*ADD*+DX123/456' , -- Example - varchar(256)
			  'PM-1695' , -- ReferencedCases - varchar(256)
			  '' , -- LoopSegment - varchar(128)
			  GETDATE() , -- LastModifiedDate - datetime
			  'wei.chen'  -- LastModifiedUser - varchar(100)
			)
END
		
DECLARE @id INT
SET @id = (SELECT EdiHackID From dbo.EdiHack WHERE [Name] = 'AllowSpecialCharInNote') 		

IF NOT EXISTS (SELECT 1 FROM dbo.EdiHackPayer WHERE EdiHackID = @id AND PayerNumber = 'NMG01' AND CustomerID = 10954)
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
			  LastModifiedUser ,
			  PracticeID
			)
	VALUES  ( @id , -- EdiHackID - int
			  N'NMG01' , -- PayerNumber - nvarchar(64)
			  10954 , -- CustomerID - int
			  0 , -- EdiBillXmlV1 - bit
			  0, -- EdiBillXmlV2 - bit
			  0, -- EdiBillXmlV2i - bit
			  1, -- EdiBillXml5010 - bit
			  0, -- EdiBillXml5010i - bit
			  GETDATE() , -- LastModifiedDate - datetime
			  'wei.chen' , -- LastModifiedUser - varchar(100)
			  null  -- PracticeID - int
			)
END			