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
SET @is_hot = 1;

DECLARE @claim_ids AS TABLE ( ClaimID INT NOT NULL );
    
INSERT  INTO @claim_ids
        ( ClaimID
        )
        SELECT  C.ClaimID
        FROM    dbo.Encounter AS E
                INNER JOIN dbo.EncounterProcedure AS EP ON E.EncounterID = EP.EncounterID
                INNER JOIN dbo.Claim AS C ON C.EncounterProcedureID = EP.EncounterProcedureID
        WHERE   E.EncounterID IN ( 9544, 9643, 9764, 9803, 9675, 9756, 9770,
                                   9796, 9843, 9856, 9859, 9860, 9861, 9863,
                                   9865, 9867, 9868, 9869, 9871, 9877, 9878,
                                   9885, 9887, 9891, 9893, 9895, 9896, 9899,
                                   9901, 9903, 9925, 9589, 7508 );

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
               FROM     dbo.ClaimTransaction AS CT1
               WHERE    CT1.ClaimID IN ( SELECT CI.*
                                         FROM   @claim_ids AS CI )
                        AND CT1.ClaimTransactionTypeCode IN ( 'RES', 'RJT',
                                                              'DEN', 'ADJ',
                                                              'PAY', 'BLL',
                                                              'ASN', 'END',
                                                              'XXX', 'RAS' )
             ),
        CTE2 ( rownum, ClaimTransactionID, ClaimID, PracticeID, ClaimTransactionTypeCode, Notes, CreatedDate, PatientID, ClaimProviderID, PostingDate )
          AS ( SELECT   CTE1.rownum ,
                        CTE1.ClaimTransactionID ,
                        CTE1.ClaimID ,
                        CTE1.PracticeID ,
                        CTE1.ClaimTransactionTypeCode ,
                        CTE1.Notes ,
                        CTE1.CreatedDate ,
                        CTE1.PatientID ,
                        CTE1.ClaimProviderID ,
                        CTE1.PostingDate
               FROM     CTE1
               WHERE    CTE1.rownum = 1
                        AND CTE1.ClaimTransactionTypeCode <> 'END'
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
                    CTE2.ClaimTransactionID ,
                    CTE2.Notes ,
                    CTE2.ClaimTransactionTypeCode ,
                    CTE2.PatientID ,
                    CTE2.ClaimProviderID ,
                    CTE2.PostingDate
            FROM    CTE2;
        
DECLARE @excluded_claim_ids AS TABLE ( ClaimID INT NOT NULL );
        
INSERT  INTO @excluded_claim_ids
        ( ClaimID 
                
        )
        SELECT  CI.ClaimID
        FROM    @claim_ids AS CI
        EXCEPT
        SELECT  TAR.ClaimID
        FROM    #table_add_rejections AS TAR;
                
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
                SELECT  'END' , -- ClaimTransactionTypeCode - char(3)
                        TAR.claimid , -- ClaimID - int
                        NULL , -- Amount - money
                        NULL , -- Quantity - decimal
                        NULL , -- Code - varchar(50)
                        NULL , -- ReferenceID - int
                        NULL , -- ReferenceData - varchar(250)
                        '' , -- Notes - text
                        TAR.patientid , -- PatientID - int
                        TAR.practiceid , -- PracticeID - int
                        NULL , -- BatchKey - uniqueidentifier
                        NULL , -- Original_ClaimTransactionID - int
                        TAR.claimproviderid , -- Claim_ProviderID - int
                        0 , -- IsFirstBill - bit
                        CURRENT_TIMESTAMP , -- PostingDate - datetime
                        NULL , -- PaymentID - int
                        NULL , -- AdjustmentGroupID - tinyint
                        NULL , -- AdjustmentReasonCode - varchar(5)
                        NULL , -- AdjustmentCode - varchar(10)
                        0 , -- Reversible - bit
                        0 , -- overrideClosingDate - bit
                        NULL , -- FollowUpDate - datetime
                        NULL  -- ClaimResponseStatusID - int
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
        
        SELECT  ECI.ClaimID AS 'ClaimID in error'
        FROM    @excluded_claim_ids AS ECI
                INNER JOIN dbo.ClaimAccounting_Errors AS CAE ON CAE.ClaimID = ECI.ClaimID
        WHERE   CAE.ClaimTransactionTypeCode = 'RJT'
        ORDER BY ECI.ClaimID;
                
        SELECT  ECI.ClaimID AS 'ClaimID not in error'
        FROM    @excluded_claim_ids AS ECI
                LEFT OUTER JOIN dbo.ClaimAccounting_Errors AS CAE ON CAE.ClaimID = ECI.ClaimID
        WHERE   CAE.ClaimID IS NULL
        ORDER BY ECI.ClaimID;

        SELECT  TAR.*
        FROM    #table_add_rejections AS TAR
        ORDER BY TAR.ClaimID;
    END
GO

IF OBJECT_ID('tempdb..#table_add_rejections') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#table_add_rejections;
    END
GO