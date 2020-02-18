-- kprod-rs01
BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
USE KareoBizclaims;
GO

IF NOT EXISTS ( SELECT  *
                FROM    dbo.PayerStatus AS PS
                WHERE   PS.MatchingPattern = 'postal/zip code acknowledgement/rejected for invalid information'
                        AND PS.[Rank] = 150 ) 
    BEGIN
        INSERT  INTO dbo.PayerStatus
                ( MatchType ,
                  MatchingPattern ,
                  NonMatchingPattern ,
                  PayerStatusCode ,
                  [Rank]
                )
        VALUES  ( 2 , -- MatchType - int
                  'postal/zip code acknowledgement/rejected for invalid information' , -- MatchingPattern - varchar(500)
                  NULL , -- NonMatchingPattern - varchar(500)
                  'R00' , -- PayerStatusCode - varchar(150)
                  150  -- Rank - int
                );
    END
        