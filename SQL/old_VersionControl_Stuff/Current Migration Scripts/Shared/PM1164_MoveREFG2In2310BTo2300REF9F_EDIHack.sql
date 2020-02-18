BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @hack_name AS NVARCHAR(100);
SET @hack_name = 'RemoveREFG2In2310BAndPlaceIn2300AsREF9F'

IF NOT EXISTS (	SELECT * 
				FROM dbo.EdiHack AS EH
				WHERE EH.Name = @hack_name)
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
		          'Removes REF*G2 In 2310B And Places In 2300 As REF*9F - Medicaid Provider Number' , -- Description - nvarchar(500)
		          'Adding Line, Deleting Line' , -- Comments - nvarchar(500)
		          0 , -- EdiBillXMLV1 - bit
		          0 , -- EdiBillXmlV2 - bit
		          0 , -- EdiBillXmlV2i - bit
		          1 , -- EdiBillXml5010 - bit
		          0 , -- EdiBillXml5010i - bit
		          'REF*9F*9900124 in 2300, REF*G2*9900124 Eliminated from 2310B' , -- Example - varchar(256)
		          'PM-1164' , -- ReferencedCases - varchar(256)
		          '2300' , -- LoopSegment - varchar(128)
		          GETDATE() , -- LastModifiedDate - datetime
		          'jonathen.kwok'  -- LastModifiedUser - varchar(100)
		        );
	END

DECLARE @ediHackID AS INT ,
		@customer_id AS INT ,
		@payer_number AS NVARCHAR(64);

SELECT	TOP 1 @ediHackID = EH.EdiHackID
		FROM dbo.EdiHack AS EH
		WHERE name = @hack_name

SET @customer_id = 14897
SET @payer_number = 'MC033'

IF NOT EXISTS ( SELECT * 
				FROM dbo.EdiHackPayer AS EHP
				WHERE EHP.CustomerID = @customer_id
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
		          0 , -- EdiBillXmlV1 - bit
		          0 , -- EdiBillXmlV2 - bit
		          0 , -- EdiBillXmlV2i - bit
		          1 , -- EdiBillXml5010 - bit
		          0 , -- EdiBillXml5010i - bit
		          GETDATE() , -- LastModifiedDate - datetime
		          'jonathen.kwok' , -- LastModifiedUser - varchar(100)
		          1  -- PracticeID - int
		        )  
	END    

