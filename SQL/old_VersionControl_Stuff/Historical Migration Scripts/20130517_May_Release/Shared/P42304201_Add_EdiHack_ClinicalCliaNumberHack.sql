BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

USE Superbill_Shared;
GO

DECLARE @hack_name AS VARCHAR(MAX);
SET @hack_name = 'ClinicalCliaNumberHack';

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
                  'If there is a clia-number and TOS is 5, then add the REF*X4 segment to loop 2400.' ,
                  NULL ,
                  0 ,
                  0 ,
                  0 ,
                  1 ,
                  0 ,
                  'REF*X4' ,
                  'P42304201' ,
                  '2400' ,
                  CURRENT_TIMESTAMP ,
                  'joe.somoza'
			    );
    END
	
DECLARE @edi_hack_id AS INT ,
    @customer_id AS INT ,
    @payer_number AS NVARCHAR(64);
			
SET @customer_id = 9351;
SET @payer_number = '04412';

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
SET @hack_name = 'ClinicalCliaNumberHack';

SELECT  *
FROM    dbo.EdiHack AS EH
WHERE   EH.Name = @hack_name;

SELECT  *
FROM    dbo.EdiHackPayer AS EHP
WHERE   EHP.EdiHackID IN ( SELECT TOP 1
                                    EH.EdiHackID
                           FROM     dbo.EdiHack AS EH
                           WHERE    EH.NAME = @hack_name );
*/

/*
DECLARE @hack_name AS VARCHAR(MAX);
SET @hack_name = 'ClinicalCliaNumberHack';

DELETE  FROM dbo.EdiHackPayer
WHERE   EdiHackID IN ( SELECT TOP 1
                                EH.EdiHackID
                       FROM     dbo.EdiHack AS EH
                       WHERE    EH.NAME = @hack_name );

DELETE  FROM dbo.EdiHack
WHERE   Name = @hack_name;
*/
