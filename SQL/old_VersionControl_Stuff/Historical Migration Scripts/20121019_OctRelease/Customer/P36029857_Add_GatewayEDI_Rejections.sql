BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;

/*
-- kprod-db22
USE superbill_12268_dev;
GO
USE superbill_12268_prod;
GO
*/

IF OBJECT_ID('tempdb..#table_add_rejections') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#table_add_rejections;
    END
GO

DECLARE @is_debug AS INT ,
    @delete_count_1 AS INT ,
    @is_hot AS BIT;

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

-- Set to 1 to *not* delete
SET @is_debug = 0;
-- _UpdateClaimAccounting_Errors runs as a nightly job
-- Set to 1 to run _UpdateClaimAccounting_Errors now!
SET @is_hot = 0;

    ;
WITH    CTE1 ( rownum, ClaimTransactionID, ClaimID, PracticeID, ClaimTransactionTypeCode, Notes, FollowUpDate, CreatedDate, PatientID, ClaimProviderID, PostingDate )
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY CT1.ClaimID ORDER BY CT1.PostingDate DESC , CT1.ClaimTransactionID DESC ) AS rownum ,
                        CT1.ClaimTransactionID ,
                        CT1.ClaimID ,
                        CT1.PracticeID ,
                        CT1.ClaimTransactionTypeCode ,
                        CT1.Notes ,
                        CT1.FollowUpDate ,
                        CT1.CreatedDate ,
                        CT1.PatientID ,
                        CT1.Claim_ProviderID ,
                        CT1.PostingDate
               FROM     dbo.ClaimTransaction AS CT1 WITH ( NOLOCK )
                        INNER JOIN ( SELECT  DISTINCT
                                            CT2.ClaimId
                                     FROM   dbo.ClaimTransaction AS CT2 WITH ( NOLOCK )
                                     WHERE  CT2.CreatedDate > '2/1/2012'
                                            AND CT2.Notes LIKE '%(A00) ;  Status: REJ  %'
                                            AND CT2.Notes LIKE '%Rejected by GatewayEDI%'
                                            AND CT2.Notes LIKE '%Acknowledgement/Rejected for Invalid Information  Payer%'
                                   ) AS C ON CT1.ClaimID = C.ClaimID
             ),
        CTE2 ( rownum, ClaimTransactionID1, ClaimTransactionID2, ClaimID, PracticeID, ClaimTransactionTypeCode1, ClaimTransactionTypeCode2, Notes1, Notes2, CreatedDate, PatientID, ClaimProviderID, PostingDate )
          AS ( SELECT   X1.rownum ,
                        X1.ClaimTransactionID ,
                        X2.ClaimTransactionID ,
                        X1.ClaimID ,
                        X1.PracticeID ,
                        X1.ClaimTransactionTypeCode ,
                        X2.ClaimTransactionTypeCode ,
                        X1.Notes ,
                        X2.Notes ,
                        X1.CreatedDate ,
                        X1.PatientID ,
                        X1.ClaimProviderID ,
                        X1.PostingDate
               FROM     CTE1 AS X1
                        LEFT OUTER JOIN CTE1 AS X2 ON X1.rownum = X2.rownum
                                                      + 1
                                                      AND X1.ClaimID = X2.ClaimID
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
            SELECT  CTE2.CreatedDate ,
                    CTE2.rownum ,
                    CTE2.PracticeID ,
                    CTE2.ClaimID ,
                    CTE2.ClaimTransactionID1 ,
                    CTE2.Notes1 ,
                    CTE2.ClaimTransactionTypeCode2 ,
                    CTE2.PatientID ,
                    CTE2.ClaimProviderID ,
                    CTE2.PostingDate
            FROM    CTE2
            WHERE   ( CTE2.ClaimTransactionTypeCode2 <> 'RJT'
                      OR ( CTE2.rownum = 1
                           AND CTE2.ClaimTransactionTypeCode2 IS NULL
                         )
                    )
                    AND CTE2.Notes1 LIKE '%(A00) ;  Status: REJ  %'
                    AND CTE2.Notes1 LIKE '%Rejected by GatewayEDI%'
                    AND CTE2.Notes1 LIKE '%Acknowledgement/Rejected for Invalid Information  Payer%'

IF @is_debug = 0 
    BEGIN
        BEGIN TRANSACTION  
		
		-- Do fix...
        INSERT  INTO dbo.ClaimTransaction
                ( ClaimTransactionTypeCode ,
                  ClaimID ,
                  Amount ,
                  Quantity ,
                  Code ,
                  ReferenceID ,
                  ReferenceData ,
                  Notes ,
                  PatientID ,
                  PracticeID ,
                  BatchKey ,
                  Original_ClaimTransactionID ,
                  Claim_ProviderID ,
                  IsFirstBill ,
                  PostingDate ,
                  PaymentID ,
                  AdjustmentGroupID ,
                  AdjustmentReasonCode ,
                  AdjustmentCode ,
                  Reversible ,
                  overrideClosingDate ,
                  FollowUpDate ,
                  ClaimResponseStatusID
                )
                SELECT  'RJT' , -- ClaimTransactionTypeCode - char(3)
                        TAR.claimid , -- ClaimID - int
                        NULL , -- Amount - money
                        NULL , -- Quantity - decimal
                        NULL , -- Code - varchar(50)
                        NULL , -- ReferenceID - int
                        NULL , -- ReferenceData - varchar(250)
                        NULL , -- Notes - text
                        TAR.patientid , -- PatientID - int
                        TAR.practiceid , -- PracticeID - int
                        NULL , -- BatchKey - uniqueidentifier
                        NULL , -- Original_ClaimTransactionID - int
                        TAR.claimproviderid , -- Claim_ProviderID - int
                        0 , -- IsFirstBill - bit
                        TAR.postingdate , -- PostingDate - datetime
                        NULL , -- PaymentID - int
                        NULL , -- AdjustmentGroupID - tinyint
                        NULL , -- AdjustmentReasonCode - varchar(5)
                        NULL , -- AdjustmentCode - varchar(10)
                        0 , -- Reversible - bit
                        0 , -- overrideClosingDate - bit
                        NULL , -- FollowUpDate - datetime
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
                INNER JOIN dbo.Claim AS C WITH ( NOLOCK ) ON C.ClaimID = TAR.claimid
                INNER JOIN dbo.EncounterProcedure AS EP WITH ( NOLOCK ) ON EP.EncounterProcedureID = C.EncounterProcedureID
                INNER JOIN dbo.Encounter AS E WITH ( NOLOCK ) ON E.EncounterID = EP.EncounterID;
        
        SELECT  TAR.*
        FROM    #table_add_rejections AS TAR;
    END
GO

IF OBJECT_ID('tempdb..#table_add_rejections') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#table_add_rejections;
    END
GO