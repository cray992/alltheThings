BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

USE Superbill_Shared;
GO

DECLARE @hack_name AS VARCHAR(MAX);
SET @hack_name = 'SuppressRenderingProvider';

DECLARE @edi_hack_id AS INT ,
    @customer_id AS INT ,
    @payer_number AS NVARCHAR(64);
			
SET @customer_id = 11103;
SET @payer_number = '60054';

SELECT TOP 1
        @edi_hack_id = EH.EdiHackID
FROM    dbo.EdiHack AS EH
WHERE   EH.NAME = @hack_name;

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

/*
DECLARE @hack_name AS VARCHAR(MAX);
SET @hack_name = 'SuppressRenderingProvider';

DECLARE @edi_hack_id AS INT ,
    @customer_id AS INT ,
    @payer_number AS NVARCHAR(64);
			
SET @customer_id = 11103;
SET @payer_number = '60054';

SELECT TOP 1
        @edi_hack_id = EH.EdiHackID
FROM    dbo.EdiHack AS EH
WHERE   EH.NAME = @hack_name;

SELECT  *
FROM    dbo.EdiHackPayer AS EHP
WHERE   EHP.CustomerID = @customer_id
        AND EHP.EdiHackID = @edi_hack_id
        AND EHP.PayerNumber = @payer_number;
*/

/*
DECLARE @hack_name AS VARCHAR(MAX);
SET @hack_name = 'SuppressRenderingProvider';

DECLARE @edi_hack_id AS INT ,
    @customer_id AS INT ,
    @payer_number AS NVARCHAR(64);
			
SET @customer_id = 11103;
SET @payer_number = '60054';

SELECT TOP 1
        @edi_hack_id = EH.EdiHackID
FROM    dbo.EdiHack AS EH
WHERE   EH.NAME = @hack_name;

DELETE  FROM dbo.EdiHackPayer
WHERE   CustomerID = @customer_id
        AND EdiHackID = @edi_hack_id
        AND PayerNumber = @payer_number;
*/
