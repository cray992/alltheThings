-- Server: kprod-rs01

USE KareoBizclaims;
GO

-- Use IS NULL and IS NOT NULL.
SET ANSI_NULLS ON
GO
-- Identifiers double quote. Strings single quote.
SET QUOTED_IDENTIFIER ON
GO
-- Prevent DONE_IN_PROC messages for each statement 
SET NOCOUNT ON
GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

;
WITH    CTE ( CustomerID, BillID, ClaimID, EncounterID, PracticeID, RoutingPaytoTaxId )
          AS ( SELECT   CustomerID ,
                        BillID ,
                        ClaimID ,
                        EncounterID ,
                        PracticeID ,
                        RoutingPaytoTaxId
               FROM     dbo.ExportMap AS EM WITH ( NOLOCK )
             )
    UPDATE  dbo.ClaimMessage
    SET     RoutingPaytoTaxId = Map.RoutingPaytoTaxId
    FROM    dbo.ClaimMessage AS CM
            INNER JOIN CTE AS Map ON CM.DataOriginalCustomerId = Map.CustomerID
                                     AND CM.DataOriginalPracticeId = Map.PracticeID
                                     AND CM.DataOriginalClaimId = Map.ClaimID
    WHERE   CM.RoutingPaytoTaxId IS NULL;
    
--SELECT  *
--FROM    dbo.ClaimMessage AS CM WITH ( NOLOCK )
--WHERE   CM.RoutingPaytoTaxId IS NULL;