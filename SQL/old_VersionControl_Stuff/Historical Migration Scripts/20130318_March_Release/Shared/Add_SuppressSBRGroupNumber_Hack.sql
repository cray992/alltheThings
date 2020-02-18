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
VALUES  ( N'SuppressSBRGroupNumber' , -- Name - nvarchar(100)
          N'Suppress subscriber policy number in 2000B SBR03' , -- Description - nvarchar(500)
          N'' , -- Comments - nvarchar(500)
          0, -- EdiBillXMLV1 - bit
          0, -- EdiBillXmlV2 - bit
          0, -- EdiBillXmlV2i - bit
          1, -- EdiBillXml5010 - bit
          0, -- EdiBillXml5010i - bit
          'SBR*P*18*******MB~' , -- Example - varchar(256)
          'PT39875035' , -- ReferencedCases - varchar(256)
          '2000B SBR03' , -- LoopSegment - varchar(128)
          GETDATE() , -- LastModifiedDate - datetime
          'wei.chen'  -- LastModifiedUser - varchar(100)
        )

DECLARE @EdiHackID INT
SET @EdiHackID = (SELECT EdiHackID FROM dbo.EdiHack WHERE Name = 'SuppressSBRGroupNumber')

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
VALUES  ( @EdiHackID , -- EdiHackID - int
          N'MR036' , -- PayerNumber - nvarchar(64)
          4444 , -- CustomerID - int
          0 , -- EdiBillXmlV1 - bit
          0, -- EdiBillXmlV2 - bit
          0, -- EdiBillXmlV2i - bit
          1, -- EdiBillXml5010 - bit
          0, -- EdiBillXml5010i - bit
          GETDATE() , -- LastModifiedDate - datetime
          'wei.chen' , -- LastModifiedUser - varchar(100)
          NULL  -- PracticeID - int
        )
        