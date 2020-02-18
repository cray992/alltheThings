BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

USE Superbill_Shared;
GO

DECLARE @edi_hack_id AS INT ,
    @customer_id AS INT ,
    @payer_number AS NVARCHAR(64);

SELECT TOP 1
        @edi_hack_id = EH.EdiHackID
FROM    [Superbill_Shared].dbo.EdiHack AS EH
WHERE   EH.NAME = 'Allow4010RefG2InLoop2010AA';

SET @customer_id = 11309;
SET @payer_number = '07202';

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

