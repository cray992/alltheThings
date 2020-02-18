BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- kprod-rs01
USE KareoBizclaims;
GO

BEGIN TRANSACTION;

IF NOT EXISTS ( SELECT  *
                FROM    dbo.PayerStatus AS PS
                WHERE   PS.MatchingPattern LIKE '%patient eligibility not found with entity%'
                        OR PS.NonMatchingPattern LIKE '%patient eligibility not found with entity%' ) 
    BEGIN
        UPDATE  dbo.PayerStatus
        SET     NonMatchingPattern = NonMatchingPattern
                + ',patient eligibility not found with entity'
        WHERE   MatchingPattern = 'entity acknowledges receipt of claim/encounter';

        INSERT  INTO dbo.PayerStatus
                ( MatchType ,
                  MatchingPattern ,
                  PayerStatusCode ,
                  Rank
                )
        VALUES  ( 2 , -- MatchType - int - Match anywhere
                  'patient eligibility not found with entity' , -- MatchingPattern - varchar(500)
                  'R00' , -- PayerStatusCode - varchar(150)
                  400  -- Rank - int
                );
    END
  
IF NOT EXISTS ( SELECT  *
                FROM    dbo.PayerStatus AS PS
                WHERE   PS.MatchingPattern LIKE '%claim failed pre-membership validation%'
                        OR PS.NonMatchingPattern LIKE '%claim failed pre-membership validation%' ) 
    BEGIN      
        INSERT  INTO dbo.PayerStatus
                ( MatchType ,
                  MatchingPattern ,
                  PayerStatusCode ,
                  Rank
                )
        VALUES  ( 2 , -- MatchType - int - Match anywhere
                  'claim failed pre-membership validation' , -- MatchingPattern - varchar(500)
                  'R00' , -- PayerStatusCode - varchar(150)
                  400  -- Rank - int
                );
    END
        
COMMIT;
