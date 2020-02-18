/*
USE superbill_9353_dev;
GO
USE superbill_9353_prod;
GO
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET NOCOUNT ON
GO

IF OBJECT_ID('tempdb.dbo.#table_delete_false_rejections') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#table_delete_false_rejections;
    END
GO

DECLARE @is_debug AS INT ,
    @claim_id AS INT ,
    @delete_count_1 AS INT ,
    @is_hot AS BIT;

CREATE TABLE #table_delete_false_rejections
    (
      createddate DATETIME ,
      rownum INT ,
      practiceid INT ,
      claimid INT ,
      claimtransactionid INT ,
      notes VARCHAR(MAX)
    );

-- Set to 1 to *not* delete
SET @is_debug = 0;
-- _UpdateClaimAccounting_Errors runs as a nightly job
-- Set to 1 to run _UpdateClaimAccounting_Errors now!
SET @is_hot = 0;

    ;
WITH    CTE1 ( rownum, ClaimTransactionID, ClaimID, PracticeID, ClaimTransactionTypeCode, Notes, FollowUpDate, CreatedDate )
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY CT1.ClaimID ORDER BY CT1.ClaimTransactionID DESC ) AS rownum ,
                        CT1.ClaimTransactionID ,
                        CT1.ClaimID ,
                        CT1.PracticeID ,
                        CT1.ClaimTransactionTypeCode ,
                        CT1.Notes ,
                        CT1.FollowUpDate ,
                        CT1.CreatedDate
               FROM     dbo.ClaimTransaction AS CT1 WITH ( NOLOCK )
                        INNER JOIN ( SELECT  DISTINCT
                                            CT2.ClaimId
                                     FROM   dbo.ClaimTransaction AS CT2 WITH ( NOLOCK )
                                     WHERE  CT2.CreatedDate > '2/1/2012'
                                            AND CT2.Notes LIKE '%(R00) ;  Status: ACK  %'
                                            AND ( CT2.Notes LIKE '%Entity acknowledges receipt of claim/encounter. Note: This code requires us%'
                                                  OR CT2.Notes LIKE '%Primary Payer : Accepted for processing Acknowledgement/Acceptance  Billing Provider : Entity''s National Provider Identifier (NPI). Note: This code requires use of an Ent  Submitter : Accepted for processing Acknowledgement/Receipt%'
                                                  OR CT2.Notes LIKE '%Medicare entitlement information is required to determine primary coverage Pending/Patient Requested I%'
                                                  OR CT2.Notes LIKE '%ENTITY ACKNOWLEDGES RECEIPT OF CLAIM/ENCOUNTER.  ACK/RECEIPT - MISSING OR INVALID INFORMATION.  ACK/RECEIPT - ENTITY NATIONAL PROVIDER IDENTIFIER (NPI)%'
                                                )
                                            AND CT2.Notes LIKE '%Processed by GatewayEDI%'
                                            AND CT2.Notes NOT LIKE '%Error Message:%'
                                            AND CT2.Notes NOT LIKE '%CONTACT PAYER%'
                                            AND CT2.Notes NOT LIKE '%CONTACT THE PAYER%'
                                   ) AS C ON CT1.ClaimID = C.ClaimID
             ),
        CTE2 ( rownum, ClaimTransactionID1, ClaimTransactionID2, ClaimID, PracticeID, ClaimTransactionTypeCode, Notes, CreatedDate )
          AS ( SELECT   X1.rownum ,
                        X1.ClaimTransactionID ,
                        X2.ClaimTransactionID ,
                        X1.ClaimID ,
                        X1.PracticeID ,
                        X1.ClaimTransactionTypeCode ,
                        X2.Notes ,
                        X1.CreatedDate
               FROM     CTE1 AS X1
                        INNER JOIN CTE1 AS X2 ON X1.rownum = X2.rownum - 1
                                                 AND X1.ClaimID = X2.ClaimID
             )
    INSERT  INTO #table_delete_false_rejections
            ( createddate ,
              rownum ,
              practiceid ,
              claimid ,
              claimtransactionid ,
              notes              
            )
            SELECT  CreatedDate ,
                    rownum ,
                    PracticeID ,
                    ClaimID ,
                    ClaimTransactionID1 ,
                    Notes
            FROM    CTE2
            WHERE   CTE2.ClaimTransactionTypeCode = 'RJT'
                    AND CTE2.Notes LIKE '%(R00) ;  Status: ACK  %'
                    AND ( CTE2.Notes LIKE '%Entity acknowledges receipt of claim/encounter. Note: This code requires us%'
                          OR CTE2.Notes LIKE '%Primary Payer : Accepted for processing Acknowledgement/Acceptance  Billing Provider : Entity''s National Provider Identifier (NPI). Note: This code requires use of an Ent  Submitter : Accepted for processing Acknowledgement/Receipt%'
                          OR CTE2.Notes LIKE '%Medicare entitlement information is required to determine primary coverage Pending/Patient Requested I%'
                          OR CTE2.Notes LIKE '%ENTITY ACKNOWLEDGES RECEIPT OF CLAIM/ENCOUNTER.  ACK/RECEIPT - MISSING OR INVALID INFORMATION.  ACK/RECEIPT - ENTITY NATIONAL PROVIDER IDENTIFIER (NPI)%'
                        )
                    AND CTE2.Notes LIKE '%Processed by GatewayEDI%'
                    AND CTE2.Notes NOT LIKE '%Error Message:%'
                    AND CTE2.Notes NOT LIKE '%CONTACT PAYER%'
                    AND CTE2.Notes NOT LIKE '%CONTACT THE PAYER%';

IF @is_debug = 0 
    BEGIN  
        BEGIN TRANSACTION  
		
		-- Do fix...
		-- This does triggered-maintenance of dbo.ClaimAccounting_Errors
        DELETE  FROM dbo.ClaimTransaction
        WHERE   ClaimTransactionID IN ( SELECT  ClaimTransactionID
                                        FROM    #table_delete_false_rejections );
		       
        SELECT  @@ROWCOUNT AS 'DeleteCount';

        IF @is_hot = 1 
            BEGIN
                EXEC dbo.ClaimDataProvider_UpdateClaimAccounting_Errors;
            END
                
        COMMIT TRANSACTION
    END
ELSE 
    BEGIN  
        SELECT  *
        FROM    #table_delete_false_rejections
        ORDER BY claimid;
    END
GO

IF OBJECT_ID('tempdb.dbo.#table_delete_false_rejections') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#table_delete_false_rejections;
    END
GO