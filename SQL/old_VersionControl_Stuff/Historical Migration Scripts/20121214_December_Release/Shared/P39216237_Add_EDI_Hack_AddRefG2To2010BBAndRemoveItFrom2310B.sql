BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

USE Superbill_Shared;
GO

DECLARE @hack_name AS NVARCHAR(100);
SET @hack_name = 'AddRefG2To2010BBAndRemoveItFrom2310B';

IF NOT EXISTS ( SELECT  *
                FROM    dbo.EdiHack AS EH
                WHERE   [Name] = @hack_name ) 
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
        VALUES  ( @hack_name ,
                  'If there is a REF*G2 claim-settings-override, then the system will add the REF*G2 segment to loop 2010BB and remove it from 2310B.' ,
                  '@' + @hack_name + ' = 1' ,
                  0 ,
                  0 ,
                  0 ,
                  1 ,
                  0 ,
                  'REF*G2*...~' ,
                  'P39216237' ,
                  '2010BB' ,
                  CURRENT_TIMESTAMP ,
                  'joe.somoza'
			    );
    END

DECLARE @edi_hack_id AS INT ,
    @customer_id AS INT ,
    @payer_number AS NVARCHAR(64);

SELECT TOP 1
        @edi_hack_id = EH.EdiHackID
FROM    dbo.EdiHack AS EH
WHERE   EH.NAME = @hack_name;

SET @customer_id = 12149;
SET @payer_number = 'BRICK';

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
