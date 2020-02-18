
IF NOT EXISTS (SELECT * FROM superbill_shared.dbo.EdiHack 
	WHERE Name = 'RemovePurchasedProvider')
INSERT INTO Superbill_Shared.dbo.EdiHack
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
VALUES  ( N'RemovePurchasedProvider' , -- Name - nvarchar(100)
          N'Remove Purchasing Provider from 2420B loop' , -- Description - nvarchar(500)
          N'' , -- Comments - nvarchar(500)
          0 , -- EdiBillXMLV1 - bit
          0 , -- EdiBillXmlV2 - bit
          0 , -- EdiBillXmlV2i - bit
          1 , -- EdiBillXml5010 - bit
          0 , -- EdiBillXml5010i - bit
          'NM1*QB*2******XX*1234567891~' , -- Example - varchar(256)
          'PT 35218543' , -- ReferencedCases - varchar(256)
          '2420B' , -- LoopSegment - varchar(128)
          '2012-09-17 16:34:00' , -- LastModifiedDate - datetime
          'douglas.ginther'  -- LastModifiedUser - varchar(100)
        )
  
IF NOT EXISTS(SELECT * FROM Superbill_Shared.DBO.EdiHackPayer 
	WHERE PayerNumber = 'WELM2' AND CustomerID = 4559
	 AND EdiHackId = (SELECT EdiHackId FROM EdiHack WHERE Name = 'RemovePurchasedProvider'))
INSERT INTO superbill_shared.dbo.EdiHackPayer
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
SELECT  EdiHack.EdiHackID , -- EdiHackID - int
          N'WELM2' , -- PayerNumber - nvarchar(64)
          4559 , -- CustomerID - int
          0 , -- EdiBillXmlV1 - bit
          0 , -- EdiBillXmlV2 - bit
          0 , -- EdiBillXmlV2i - bit
          1 , -- EdiBillXml5010 - bit
          0 , -- EdiBillXml5010i - bit
          '2012-09-17 16:39:42' , -- LastModifiedDate - datetime
          'douglas.ginther'  -- LastModifiedUser - varchar(100)
       FROM  Superbill_Shared.dbo.EdiHack WHERE 
		Name = 'RemovePurchasedProvider'