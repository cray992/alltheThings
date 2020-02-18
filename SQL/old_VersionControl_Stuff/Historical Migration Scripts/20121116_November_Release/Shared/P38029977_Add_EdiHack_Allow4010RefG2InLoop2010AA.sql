BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

USE Superbill_Shared;
GO

IF NOT EXISTS ( SELECT  *
                FROM    dbo.EdiHack AS EH
                WHERE   [Name] = 'Allow4010RefG2InLoop2010AA' ) 
    BEGIN
        INSERT  INTO [Superbill_Shared].[dbo].[EdiHack]
                ( [Name] ,
                  [Description] ,
                  [Comments] ,
                  [EdiBillXmlV1] ,
                  [EdiBillXmlV2] ,
                  [EdiBillXmlV2i] ,
                  [EdiBillXml5010] ,
                  [EdiBillXml5010i] ,
                  [Example] ,
                  [ReferencedCases] ,
                  [LoopSegment] ,
                  [LastModifiedDate] ,
                  [LastModifiedUser]
			    )
        VALUES  ( 'Allow4010RefG2InLoop2010AA' ,
                  'If there is a REF*G2 claim-settings-override, then let the system add the REF*G2 segment to loop 2010AA even though REF*G2 is 4010 837P' ,
                  '@Allow4010RefG2InLoop2010AA = 1' ,
                  0 ,
                  0 ,
                  0 ,
                  1 ,
                  0 ,
                  'REF*G2*...~' ,
                  'P38029977' ,
                  '2010AA' ,
                  CURRENT_TIMESTAMP ,
                  'joe.somoza'
			    );
    END

DECLARE @edi_hack_id AS INT ,
    @customer_id AS INT ,
    @payer_number AS NVARCHAR(64);

SELECT TOP 1
        @edi_hack_id = EH.EdiHackID
FROM    [Superbill_Shared].dbo.EdiHack AS EH
WHERE   EH.NAME = 'Allow4010RefG2InLoop2010AA';

SET @customer_id = 10124;
SET @payer_number = '31147';

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
