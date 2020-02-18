
DECLARE @hack_name AS NVARCHAR(100);
SET @hack_name = 'AllowEITo2310B';

IF NOT EXISTS ( SELECT *
				FROM dbo.EdiHack AS eh
				WHERE eh.Name = @hack_name)
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
		VALUES  ( @hack_name , -- Name - nvarchar(100)
				  'Hack to allow EI in 2310B' , -- Description - nvarchar(500)
				  N'' , -- Comments - nvarchar(500)
				  0 , -- EdiBillXMLV1 - bit
				  0 , -- EdiBillXmlV2 - bit
				  0 , -- EdiBillXmlV2i - bit
				  1	   , -- EdiBillXml5010 - bit
				  0 , -- EdiBillXml5010i - bit
				  ' REF*EI*[EIN]~' , -- Example - varchar(256)
				  'Pivotal: 45729777' , -- ReferencedCases - varchar(256)
				  '2310B' , -- LoopSegment - varchar(128)
				  GETDATE() , -- LastModifiedDate - datetime
				  'charles.black'  -- LastModifiedUser - varchar(100)
				);
	END

		
DECLARE @ediHackID AS INT,
		@customer_id AS INT,
		@payer_number AS NVARCHAR(64);

SELECT TOP 1 @ediHackID = ediHackID
	FROM dbo.EdiHack
	WHERE name = @hack_name;

SET @customer_id = 122;
SET @payer_number = 'CSMED'


IF NOT EXISTS ( SELECT  *
                FROM    dbo.EdiHackPayer AS EHP
                WHERE   EHP.CustomerID = @customer_id
                        AND EHP.EdiHackID = @ediHackID
                        AND EHP.PayerNumber = @payer_number ) 
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
		VALUES  ( @ediHackID , -- EdiHackID - int
				  @payer_number , -- PayerNumber - nvarchar(64)
				  @customer_id , -- CustomerID - int
				  0, -- EdiBillXmlV1 - bit
				  0, -- EdiBillXmlV2 - bit
				  0, -- EdiBillXmlV2i - bit
				  1 , -- EdiBillXml5010 - bit
				  0, -- EdiBillXml5010i - bit
				  GETDATE() , -- LastModifiedDate - datetime
				  'charles.black' , -- LastModifiedUser - varchar(100)
				  NULL  -- PracticeID - int
				);
	END
