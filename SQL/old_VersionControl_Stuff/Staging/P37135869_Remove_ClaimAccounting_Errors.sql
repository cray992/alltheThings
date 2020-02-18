BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

/*
-- kprod-db20
USE superbill_5684_dev;
GO
USE superbill_5684_prod;
GO
*/

IF OBJECT_ID('tempdb..#last_claim_transaction') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#last_claim_transaction;
    END
GO

DECLARE @is_debug AS BIT ,
    @is_hot AS BIT;
SET @is_debug = 0;
-- _UpdateClaimAccounting_Errors runs as a nightly job
-- Set to 1 to run _UpdateClaimAccounting_Errors now!
SET @is_hot = 1;

CREATE TABLE #last_claim_transaction
    (
      PracticeID INT ,
      ClaimID INT ,
      ClaimTransactionTypeCode CHAR(3)
    );
;
WITH    CTE1 ( rownum, ClaimTransactionID, ClaimID, PracticeID, ClaimTransactionTypeCode, Notes, FollowUpDate, CreatedDate )
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY CT1.ClaimID ORDER BY CT1.PostingDate DESC , CT1.ClaimTransactionID DESC ) AS rownum ,
                        CT1.ClaimTransactionID ,
                        CT1.ClaimID ,
                        CT1.PracticeID ,
                        CT1.ClaimTransactionTypeCode ,
                        CT1.Notes ,
                        CT1.FollowUpDate ,
                        CT1.CreatedDate
               FROM     dbo.ClaimTransaction AS CT1 WITH ( NOLOCK )
               WHERE    CT1.ClaimID IN (
                        SELECT  DISTINCT
                                CT2.ClaimId
                        FROM    dbo.ClaimTransaction AS CT2 WITH ( NOLOCK )
                        WHERE   CT2.CreatedDate > '2/1/2012' )
                        AND CT1.ClaimTransactionTypeCode IN ( 'RES', 'RJT',
                                                              'DEN', 'ADJ',
                                                              'PAY', 'BLL',
                                                              'ASN', 'END',
                                                              'XXX', 'RAS' )
             )
    INSERT  INTO #last_claim_transaction
            ( PracticeID ,
              ClaimID ,
              ClaimTransactionTypeCode
            )
            SELECT  CTE1.PracticeID ,
                    CTE1.ClaimID ,
                    CTE1.ClaimTransactionTypeCode
            FROM    CTE1
            WHERE   CTE1.rownum = 1;

IF @is_debug = 0 
    BEGIN
        DELETE  FROM CAE
        FROM    ClaimAccounting_Errors AS CAE WITH ( NOLOCK )
                INNER JOIN #last_claim_transaction AS LT ON LT.PracticeID = CAE.PracticeID
                                                            AND LT.ClaimID = CAE.ClaimID
        WHERE   CAE.ClaimTransactionTypeCode = 'RJT'
                AND LT.ClaimTransactionTypeCode <> 'RJT'
        
        SELECT  @@ROWCOUNT AS 'Deleted';
        
        IF @is_hot = 1 
            BEGIN
                EXEC dbo.ClaimDataProvider_UpdateClaimAccounting_Errors;
            END                        
    END
ELSE 
    BEGIN
        SELECT  COUNT(*) AS '#last_claim_transaction Count'
        FROM    #last_claim_transaction AS LT

        SELECT  DISTINCT
                LT.ClaimTransactionTypeCode ,
                CTT.TypeName
        FROM    ClaimAccounting_Errors AS CAE WITH ( NOLOCK )
                INNER JOIN #last_claim_transaction AS LT ON LT.PracticeID = CAE.PracticeID
                                                            AND LT.ClaimID = CAE.ClaimID
                INNER JOIN dbo.ClaimTransactionType AS CTT ON CTT.ClaimTransactionTypeCode = LT.ClaimTransactionTypeCode
        WHERE   LT.ClaimTransactionTypeCode NOT IN ( 'RJT', 'DEN' );

        SELECT  CAE.* ,
                LT.ClaimTransactionTypeCode AS 'Last ClaimTransactionTypeCode'
        FROM    ClaimAccounting_Errors AS CAE WITH ( NOLOCK )
                INNER JOIN #last_claim_transaction AS LT ON LT.PracticeID = CAE.PracticeID
                                                            AND LT.ClaimID = CAE.ClaimID
        WHERE   CAE.ClaimTransactionTypeCode = 'RJT'
                AND LT.ClaimTransactionTypeCode <> 'RJT'
        ORDER BY CAE.ClaimID;
    END

IF OBJECT_ID('tempdb..#last_claim_transaction') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#last_claim_transaction;
    END
GO
