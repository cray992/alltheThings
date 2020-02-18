-- Use IS NULL and IS NOT NULL.
SET ANSI_NULLS ON
GO
-- Identifiers double quote. Strings single quote.
SET QUOTED_IDENTIFIER ON
GO
-- Prevent DONE_IN_PROC messages for each statement 
SET NOCOUNT ON
GO

DECLARE @is_debug AS INT ,
    @claim_id AS INT ,
    @delete_count_1 AS INT;

DECLARE @table_fix_3948 AS TABLE
    (
      rownum INT ,
      practiceid INT ,
      claimid INT ,
      claimtransactionid INT ,
      notes VARCHAR(MAX)
    );

-- Set to 1 to *not* delete
SET @is_debug = 0;
  
-- Set to NULL to fix for all.
SET @delete_count_1 = 0;

    ;
WITH    CTE1 ( rownum, ClaimTransactionID, ClaimID, PracticeID, ClaimTransactionTypeCode, Notes, FollowUpDate, PostingDate )
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY CT1.ClaimID ORDER BY CT1.PostingDate DESC , CT1.ClaimTransactionID DESC ) AS rownum ,
                        CT1.ClaimTransactionID ,
                        CT1.ClaimID ,
                        CT1.PracticeID ,
                        CT1.ClaimTransactionTypeCode ,
                        CT1.Notes ,
                        CT1.FollowUpDate ,
                        CT1.PostingDate
               FROM     dbo.ClaimTransaction AS CT1 WITH ( NOLOCK )
               WHERE    CT1.ClaimID IN (
                        SELECT  DISTINCT CT2.ClaimId
                        FROM    dbo.ClaimTransaction AS CT2 WITH ( NOLOCK )
                        WHERE   CT2.ClaimTransactionTypeCode = 'EDI'
                                AND ( CT2.Notes LIKE '%Acknowledgement/Receipt Entity acknowledges receipt of claim/encounter. Note: This code requires use o%'
                                      OR CT2.Notes LIKE '%(R00) ;  Status: ACK  Acknowledgement/Acceptance Entity acknowledges receipt of claim/encounter. Note: This code requires us  Acknowledgement/Receipt Entity acknowledges receipt of claim/encounter.'
                                      OR CT2.Notes LIKE '%(R00) ;  Status: ACK  Acknowledgement/Acceptance Entity acknowledges receipt of claim/encounter. Note: This code requires us (Chk # %'
                                    )
                                AND CT2.Notes NOT LIKE '%Error Message:%'
                                AND CT2.CreatedDate > '2/1/2012' )
             ),
        CTE2 ( rownum, ClaimTransactionID1, ClaimTransactionID2, ClaimID, PracticeID, ClaimTransactionTypeCode, Notes )
          AS ( SELECT   X1.rownum ,
                        X1.ClaimTransactionID ,
                        X2.ClaimTransactionID ,
                        X1.ClaimID ,
                        X1.PracticeID ,
                        X1.ClaimTransactionTypeCode ,
                        X2.Notes
               FROM     CTE1 AS X1
                        INNER JOIN CTE1 AS X2 ON X1.rownum = X2.rownum - 1
                                                 AND X1.ClaimID = X2.ClaimID
             )
    INSERT  INTO @table_fix_3948
            ( rownum ,
              PracticeID ,
              ClaimID ,
              ClaimTransactionID ,
              Notes                    
            )
            SELECT  rownum ,
                    PracticeID ,
                    ClaimID ,
                    ClaimTransactionID1 ,
                    Notes
            FROM    CTE2
            WHERE   CTE2.ClaimTransactionTypeCode = 'RJT'
                    AND ( CTE2.Notes LIKE '%Acknowledgement/Receipt Entity acknowledges receipt of claim/encounter. Note: This code requires use o%'
                          OR CTE2.Notes LIKE '%(R00) ;  Status: ACK  Acknowledgement/Acceptance Entity acknowledges receipt of claim/encounter. Note: This code requires us  Acknowledgement/Receipt Entity acknowledges receipt of claim/encounter.'
                          OR CTE2.Notes LIKE '%(R00) ;  Status: ACK  Acknowledgement/Acceptance Entity acknowledges receipt of claim/encounter. Note: This code requires us (Chk # %'
                        )
                    AND CTE2.Notes NOT LIKE '%Error Message:%';

    
IF @is_debug = 0 
    BEGIN  
        BEGIN TRANSACTION  
		
		-- Do fix...
		-- This does triggered-maintenance of dbo.ClaimAccounting_Errors
        DELETE  FROM dbo.ClaimTransaction
        WHERE   ClaimTransactionID IN ( SELECT  ClaimTransactionID
                                        FROM    @table_fix_3948 );
		
        SET @delete_count_1 = @@ROWCOUNT;        
        SELECT  @delete_count_1 AS '@delete_count_1';
                
        COMMIT TRANSACTION
    END
 
SELECT  *
FROM    @table_fix_3948;

GO