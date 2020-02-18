BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

USE [Superbill_Shared];
GO

BEGIN TRANSACTION;

IF NOT EXISTS ( SELECT  *
                FROM    dbo.EdiHack AS EH
                WHERE   [Name] = 'ForcePracticeAddressIn2310C' ) 
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
        VALUES  ( 'ForcePracticeAddressIn2310C' ,
                  'Populate practice''s address in service facility location (2310C) if POS = 12 (Home)' ,
                  '@ForcePracticeAddressIn2310C = 1' ,
                  0 ,
                  0 ,
                  0 ,
                  1 ,
                  0 ,
                  'NM1*77' ,
                  'P38506507' ,
                  '2310C' ,
                  CURRENT_TIMESTAMP ,
                  'joe.somoza'
			    );
    END
    
DECLARE @edi_hack_id AS INT ,
    @customer_id AS INT;

SELECT TOP 1
        @edi_hack_id = EH.EdiHackID
FROM    [Superbill_Shared].dbo.EdiHack AS EH
WHERE   EH.NAME = 'ForcePracticeAddressIn2310C';

SET @customer_id = 5667;

IF NOT EXISTS ( SELECT  *
                FROM    dbo.EdiHackPayer AS EHP
                WHERE   EHP.CustomerID = @customer_id
                        AND EHP.EdiHackID = @edi_hack_id
                        AND EHP.PayerNumber = 'MR002' ) 
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
                  'MR002' /* PayerNumber */ ,
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

IF NOT EXISTS ( SELECT  *
                FROM    dbo.EdiHackPayer AS EHP
                WHERE   EHP.CustomerID = @customer_id
                        AND EHP.EdiHackID = @edi_hack_id
                        AND EHP.PayerNumber = '13079' ) 
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
                  '13079' /* PayerNumber */ ,
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

IF NOT EXISTS ( SELECT  *
                FROM    dbo.EdiHackPayer AS EHP
                WHERE   EHP.CustomerID = @customer_id
                        AND EHP.EdiHackID = @edi_hack_id
                        AND EHP.PayerNumber = 'MR061' ) 
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
                  'MR061' /* PayerNumber */ ,
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
	
IF NOT EXISTS ( SELECT  *
                FROM    dbo.EdiHackPayer AS EHP
                WHERE   EHP.CustomerID = @customer_id
                        AND EHP.EdiHackID = @edi_hack_id
                        AND EHP.PayerNumber = 'MR023' ) 
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
                  'MR023' /* PayerNumber */ ,
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

IF NOT EXISTS ( SELECT  *
                FROM    dbo.EdiHackPayer AS EHP
                WHERE   EHP.CustomerID = @customer_id
                        AND EHP.EdiHackID = @edi_hack_id
                        AND EHP.PayerNumber = '95266' ) 
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
                  '95266' /* PayerNumber */ ,
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
