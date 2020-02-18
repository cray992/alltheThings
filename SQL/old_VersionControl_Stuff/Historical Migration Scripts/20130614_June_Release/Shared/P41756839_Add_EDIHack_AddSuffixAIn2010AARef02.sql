BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

USE Superbill_Shared;
GO

BEGIN TRANSACTION;

DECLARE @hack_name AS VARCHAR(MAX);
SET @hack_name = 'Add_Suffix_A_To_2010AA_REF02';

IF NOT EXISTS ( SELECT  *
				FROM    dbo.EdiHack AS EH
				WHERE   [Name] = @hack_name ) 
	BEGIN
		INSERT  INTO dbo.EdiHack
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
		VALUES  ( @hack_name , -- Name - nvarchar(100)
				  N'Add suffix ''A'' to loop 2010AA and element REF02' , -- Description - nvarchar(500)
				  N'' , -- Comments - nvarchar(500)
				  0 , -- EdiBillXmlV1 - bit
				  0 , -- EdiBillXmlV2 - bit
				  0 , -- EdiBillXmlV2i - bit
				  1 , -- EdiBillXml5010 - bit
				  0 , -- EdiBillXml5010i - bit
				  'REF*EI*123456789A~' , -- Example - varchar(256)
				  'PT41756839' , -- ReferencedCases - varchar(256)
				  '2010AA-REF02' , -- LoopSegment - varchar(128)
				  CURRENT_TIMESTAMP , -- LastModifiedDate - datetime
				  'joe.somoza'  -- LastModifiedUser - varchar(100)
				);
	END

DECLARE @edi_hack_ID AS INT ,
	@payer_number AS VARCHAR(MAX) ,
	@customer_ID AS INT;

SELECT  @edi_hack_ID = EDIHackID
FROM    dbo.EdiHack
WHERE   [Name] = @hack_name;

SET @payer_number = 'BS031';
SET @customer_ID = 7280;

IF NOT EXISTS ( SELECT  *
				FROM    dbo.EdiHackPayer AS EHP
				WHERE   EHP.CustomerID = @customer_id
						AND EHP.EdiHackID = @edi_hack_id
						AND EHP.PayerNumber = @payer_number ) 
	BEGIN
		INSERT  INTO [dbo].[EdiHackPayer]
				( [EdiHackID] ,
				  [PayerNumber] ,
				  [CustomerID] ,
				  [EdiBillXmlV1] ,
				  [EdiBillXmlV2] ,
				  [EdiBillXmlV2i] ,
				  [EdiBillXml5010] ,
				  [EdiBillXml5010i] ,
				  [LastModifiedDate] ,
				  [LastModifiedUser]
				)
		VALUES  ( @edi_hack_id /* EdiHackID */ ,
				  @payer_number /* PayerNumber */ ,
				  @customer_id /* CustomerID */ ,
				  0 /* EdiBillXmlV1 */ ,
				  0 /* EdiBillXmlV2 */ ,
				  0 /* EdiBillXmlV2i */ ,
				  1 /* EdiBillXml5010 */ ,
				  0 /* EdiBillXml5010i */ ,
				  CURRENT_TIMESTAMP /* LastModifiedDate */ ,
				  'joe.somoza' /* LastModifiedUser */
				);
	END

COMMIT;
GO

/*
SELECT  *
FROM    dbo.EdiHackPayer AS EHP
WHERE   EHP.CustomerID = 7280
		AND EHP.PayerNumber = 'BS031'
*/

/*
DELETE  FROM dbo.EdiHackPayer
WHERE   CustomerID = 7280
		AND PayerNumber = 'BS031';
*/
