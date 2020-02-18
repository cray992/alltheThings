BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET NOCOUNT ON;
SET	QUOTED_IDENTIFIER ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
COMMIT;
/*
USE superbill_3129_dev;
GO
*/
IF OBJECT_ID('tempdb.dbo.#payment_table') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#payment_table;
    END
GO

DECLARE @is_debug AS BIT;
SET @is_debug = 0;
             
CREATE TABLE #payment_table
    (
      PracticeID INT ,
      PaymentID INT ,
      IsInsert BIT
    );
INSERT  INTO #payment_table
        ( PracticeID ,
          PaymentID ,
          IsInsert              
        )
        SELECT  P.PracticeID ,
                P.PaymentID ,
                CASE WHEN dbo.BusinessRule_PaymentUnappliedAmount(P.PaymentID) > 0
                     THEN 1
                     ELSE 0
                END AS IsInsert
        FROM    dbo.Payment AS P WITH ( NOLOCK )
        WHERE   P.PayerTypeCode = 'P';

DELETE  FROM #payment_table
FROM    #payment_table AS PT
        INNER JOIN dbo.UnappliedPayments AS UP WITH ( NOLOCK ) ON UP.PracticeID = PT.PracticeID
                                                              AND UP.PaymentID = PT.PaymentID
WHERE   PT.IsInsert = 1;
                
BEGIN TRANSACTION;
-- Insert
IF EXISTS ( SELECT  *
            FROM    #payment_table AS PT
            WHERE   PT.IsInsert = 1 ) 
    BEGIN
        IF @is_debug = 0 
            BEGIN
                INSERT  INTO dbo.UnappliedPayments
                        ( PracticeID ,
                          PaymentID
                        )
                        SELECT  PT.PracticeID ,
                                PT.PaymentID
                        FROM    #payment_table AS PT
                        WHERE   PT.IsInsert = 1;
            END
        ELSE 
            BEGIN
                SELECT  PT.*
                FROM    #payment_table AS PT
                WHERE   PT.IsInsert = 1;
            END
    END;

-- Delete
IF EXISTS ( SELECT  *
            FROM    #payment_table AS PT
            WHERE   PT.IsInsert = 0 ) 
    BEGIN
        IF @is_debug = 0 
            BEGIN
                DELETE  FROM dbo.UnappliedPayments
                FROM    dbo.UnappliedPayments AS UP
                        INNER JOIN #payment_table AS PT ON PT.PracticeID = UP.PracticeID
                                                           AND PT.PaymentID = UP.PaymentID
                WHERE   PT.IsInsert = 0;
            END
        ELSE 
            BEGIN
                SELECT  PT.*
                FROM    dbo.UnappliedPayments AS UP
                        INNER JOIN #payment_table AS PT ON PT.PracticeID = UP.PracticeID
                                                           AND PT.PaymentID = UP.PaymentID
                WHERE   PT.IsInsert = 0;
            END
    END;
COMMIT;
GO
IF OBJECT_ID('tempdb.dbo.#payment_table') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#payment_table;
    END
GO   