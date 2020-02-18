BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- kprod-db33
/*
USE superbill_1012_dev;
GO
USE superbill_1012_prod;
GO
*/

IF OBJECT_ID('tempdb..#claim_ids') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#claim_ids;
    END
GO

CREATE TABLE #claim_ids ( claimid INT );

INSERT  INTO #claim_ids
        ( claimid 
        )
        SELECT  DISTINCT
                CT.ClaimId
        FROM    dbo.ClaimTransaction AS CT
        WHERE   CT.CreatedDate > '11/1/2012'
                --AND CT.Notes LIKE '%(A00) ;  Status: REJ  %'
                --AND CT.Notes LIKE '%Rejected by GatewayEDI%'
                --AND CT.Notes LIKE '%Patient eligibility not found with entity%';
				AND CT.Notes LIKE '%AZBlue%'
				AND  CT.Notes LIKE '%claim failed pre-membership validation%';

IF OBJECT_ID('tempdb..#table_add_rejections') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#table_add_rejections;
    END
GO

CREATE TABLE #table_add_rejections
    (
      createddate DATETIME ,
      rownum INT ,
      practiceid INT ,
      patientid INT ,
      claimid INT ,
      claimtransactionid INT ,
      notes VARCHAR(MAX) ,
      claimtransactiontypecode CHAR(3) ,
      claimproviderid INT ,
      postingdate DATETIME ,
      encounterid INT
    );

    ;
WITH    CTE
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY CT.ClaimID ORDER BY CT.PostingDate DESC , CT.ClaimTransactionID DESC ) AS rownum ,
                        CT.ClaimTransactionID ,
                        CT.ClaimID ,
                        CT.PracticeID ,
                        CT.ClaimTransactionTypeCode ,
                        CT.Notes ,
                        CT.FollowUpDate ,
                        CT.CreatedDate ,
                        CT.PatientID ,
                        CT.Claim_ProviderID ,
                        CT.PostingDate
               FROM     dbo.ClaimTransaction AS CT
                        INNER JOIN #claim_ids AS C ON CT.ClaimID = C.ClaimID
             )
    INSERT  INTO #table_add_rejections
            ( createddate ,
              rownum ,
              practiceid ,
              claimid ,
              claimtransactionid ,
              notes ,
              claimtransactiontypecode ,
              patientid ,
              claimproviderid ,
              postingdate                
            )
            SELECT  CTE_A.CreatedDate ,
                    CTE_A.rownum ,
                    CTE_A.PracticeID ,
                    CTE_A.ClaimID ,
                    CTE_A.ClaimTransactionID ,
                    CTE_A.Notes ,
                    CTE_B.ClaimTransactionTypeCode ,
                    CTE_A.PatientID ,
                    CTE_A.Claim_ProviderID ,
                    CTE_A.PostingDate
            FROM    CTE AS CTE_A /* Please note: We are doing a LEFT OUTER JOIN */
                    LEFT OUTER JOIN CTE AS CTE_B ON CTE_A.rownum = CTE_B.rownum
                                                    + 1
                                                    AND CTE_A.ClaimID = CTE_B.ClaimID
            WHERE   ( CTE_B.ClaimTransactionTypeCode <> 'RJT'
                      OR ( CTE_A.rownum = 1 /* Last row because sort DESC */
                           AND CTE_B.ClaimTransactionTypeCode IS NULL /* From LEFT OUTER JOIN */
                         )
                    )
                    --AND CTE_A.Notes LIKE '%(A00) ;  Status: REJ  %'
                    --AND CTE_A.Notes LIKE '%Rejected by GatewayEDI%'
                    --AND CTE_A.Notes LIKE '%Patient eligibility not found with entity%';
                    AND CTE_A.Notes LIKE '%AZBlue%'
                    AND CTE_A.Notes LIKE '%claim failed pre-membership validation%';

DECLARE @is_debug AS INT ,
    @is_hot AS BIT;	
-- Set to 1 to *not* delete
SET @is_debug = 1;
-- _UpdateClaimAccounting_Errors runs as a nightly job
-- Set to 1 to run _UpdateClaimAccounting_Errors now!
SET @is_hot = 0;

IF @is_debug = 0 
    BEGIN
        BEGIN TRANSACTION  
		
		-- Do fix...
		-- Not idempotent if there are two EDI claim-transactions next to each 
		-- other with the same PostDate and Note.
        INSERT  INTO dbo.ClaimTransaction
                ( ClaimTransactionTypeCode ,
                  ClaimID ,
                  PatientID ,
                  PracticeID ,
                  Claim_ProviderID ,
                  IsFirstBill ,
                  PostingDate ,
                  Reversible ,
                  overrideClosingDate ,
                  ClaimResponseStatusID
                )
                SELECT  'RJT' , -- ClaimTransactionTypeCode - char(3)
                        TAR.claimid , -- ClaimID - int
                        TAR.patientid , -- PatientID - int
                        TAR.practiceid , -- PracticeID - int
                        TAR.claimproviderid , -- Claim_ProviderID - int
                        0 , -- IsFirstBill - bit
                        TAR.postingdate , -- PostingDate - datetime
                        0 , -- Reversible - bit
                        0 , -- overrideClosingDate - bit
                        5  -- ClaimResponseStatusID - int
                FROM    #table_add_rejections AS TAR;
		       
        SELECT  @@ROWCOUNT AS 'InsertCount';

        IF @is_hot = 1 
            BEGIN
                EXEC dbo.ClaimDataProvider_UpdateClaimAccounting_Errors;
            END
                
        COMMIT TRANSACTION
    END
ELSE 
    BEGIN  
        UPDATE  TAR
        SET     TAR.encounterid = E.EncounterID
        FROM    #table_add_rejections AS TAR
                INNER JOIN dbo.Claim AS C ON C.ClaimID = TAR.claimid
                INNER JOIN dbo.EncounterProcedure AS EP ON EP.EncounterProcedureID = C.EncounterProcedureID
                INNER JOIN dbo.Encounter AS E ON E.EncounterID = EP.EncounterID;
        
        SELECT  TAR.* ,
                P.Name
        FROM    #table_add_rejections AS TAR
                INNER JOIN dbo.Practice AS P ON TAR.practiceid = P.PracticeID;
    END
GO

IF OBJECT_ID('tempdb..#claim_ids') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#claim_ids;
    END
GO

IF OBJECT_ID('tempdb..#table_add_rejections') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#table_add_rejections;
    END
GO
