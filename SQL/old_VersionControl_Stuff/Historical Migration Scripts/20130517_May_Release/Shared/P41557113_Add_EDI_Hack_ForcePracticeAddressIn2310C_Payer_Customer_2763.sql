BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

USE [Superbill_Shared]
GO

IF NOT EXISTS ( SELECT  *
                FROM    dbo.EdiHackPayer AS EHP
                WHERE   EHP.EdiHackID = 82
                        AND EHP.PayerNumber = '09102'
                        AND EHP.CustomerID = 2763 ) 
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
                  [LastModifiedUser] ,
                  [PracticeID]
                )
        VALUES  ( 82 ,
                  '09102' ,
                  2763 ,
                  0 ,
                  0 ,
                  0 ,
                  1 ,
                  0 ,
                  CURRENT_TIMESTAMP ,
                  'joe.somoza@kareo.com' ,
                  NULL
                );
    END
GO

/*
SELECT  *
FROM    dbo.EdiHackPayer AS EHP
WHERE   EHP.EdiHackID = 82
        AND EHP.PayerNumber = '09102'
        AND EHP.CustomerID = 2763;
*/

/*
DELETE  FROM dbo.EdiHackPayer
WHERE   EdiHackID = 82
        AND PayerNumber = '09102'
        AND CustomerID = 2763;
*/

/*
SELECT  *
FROM    dbo.EdiHack AS EH
WHERE   EH.EdiHackID = 82
*/
