BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

/*
-- kprod-db33
USE superbill_1621_dev;
GO
USE superbill_1621_prod;
GO
-- kprod-db32
USE superbill_12039_dev;
GO
USE superbill_12039_prod;
GO
-- kprod-db24
USE superbill_4403_dev;
GO
USE superbill_4403_prod;
GO
-- kprod-db11
USE superbill_1905_dev;
GO
USE superbill_1905_prod;
GO
-- kprod-DB34
USE superbill_2382_dev;
GO
USE superbill_2382_prod;
GO
*/

IF OBJECT_ID('tempdb..#claim_transactions') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#claim_transactions;
    END
GO

DECLARE @is_debug AS BIT;
SET @is_debug = 0;

CREATE TABLE #claim_transactions
    (
      RowNum INT ,
      PostingDate DATETIME ,
      CreatedDate DATETIME ,
      ClaimTransactionID INT ,
      PracticeID INT ,
      PracticeName VARCHAR(128) ,
      ClaimID INT ,
      ClaimTransactionTypeCode CHAR(3) ,
      ClaimTransactionTypeName VARCHAR(50) ,
      Amount MONEY ,
      Notes TEXT
    );

WITH    CTE
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY CT.ClaimID ORDER BY CT.PostingDate DESC , CT.ClaimTransactionID DESC ) AS RowNum_DESC ,
                        ROW_NUMBER() OVER ( PARTITION BY CT.ClaimID ORDER BY CT.PostingDate ASC , CT.ClaimTransactionID ASC ) AS RowNum_ASC ,
                        CT.CreatedDate ,
                        CT.PostingDate ,
                        CT.ClaimTransactionID ,
                        CT.PracticeID ,
                        CT.ClaimID ,
                        CT.ClaimTransactionTypeCode ,
                        CTT.TypeName ,
                        CT.Amount ,
                        CT.Notes ,
                        P.Name
               FROM     dbo.ClaimTransaction AS CT
                        INNER JOIN dbo.ClaimTransactionType AS CTT ON CT.ClaimTransactionTypeCode = CTT.ClaimTransactionTypeCode
                        INNER JOIN dbo.Practice AS P ON CT.PracticeID = P.PracticeID
               WHERE    CT.ClaimID IN (
                        SELECT DISTINCT
                                CT2.ClaimID
                        FROM    dbo.ClaimTransaction AS CT2
                        WHERE   CAST(CONVERT(CHAR(8), CT2.CreatedDate, 112) AS DATETIME) BETWEEN '2013-02-11'
                                                              AND
                                                              '2013-02-12' )
             )
    INSERT  INTO #claim_transactions
            ( RowNum ,
              CreatedDate ,
              PostingDate ,
              ClaimTransactionID ,
              PracticeID ,
              PracticeName ,
              ClaimID ,
              ClaimTransactionTypeCode ,
              ClaimTransactionTypeName ,
              Amount ,
              Notes
            )
            SELECT  CTE.RowNum_DESC ,
                    CTE.CreatedDate ,
                    CTE.PostingDate ,
                    CTE.ClaimTransactionID ,
                    CTE.PracticeID ,
                    CTE.Name ,
                    CTE.ClaimID ,
                    CTE.ClaimTransactionTypeCode ,
                    CTE.TypeName ,
                    CTE.Amount ,
                    CTE.Notes
            FROM    CTE
            WHERE   CTE.RowNum_DESC = 1
                    AND CTE.RowNum_ASC = 3
                    AND CTE.ClaimTransactionTypeCode = 'BLL'
                    AND CAST(CONVERT(CHAR(8), CTE.CreatedDate, 112) AS DATETIME) BETWEEN '2013-02-11'
                                                              AND
                                                              '2013-02-12'
            ORDER BY CTE.Name ASC;

IF @is_debug = 1 
    BEGIN
        SELECT  EP.EncounterID ,
                CT.*
        FROM    #claim_transactions AS CT
                INNER JOIN dbo.Claim AS C ON CT.ClaimID = C.ClaimID
                INNER JOIN dbo.EncounterProcedure AS EP ON C.EncounterProcedureID = EP.EncounterProcedureID;
    END
ELSE 
    BEGIN
        BEGIN TRANSACTION;

        DECLARE @cursor_claim_id AS INT ,
            @xml AS XML;

        DECLARE claim_cursor CURSOR FAST_FORWARD
        FOR
            SELECT  ClaimID
            FROM    #claim_transactions;
        OPEN claim_cursor;
        FETCH NEXT FROM claim_cursor INTO @cursor_claim_id;
        WHILE @@FETCH_STATUS = 0 
            BEGIN
                SET @xml = N'<?xml version=''1.0'' ?><Claims><Claim ClaimID='''
                    + CAST(@cursor_claim_id AS VARCHAR) + ''' /></Claims>';
                EXEC ClaimDataProvider_RebillClaim @claim_id = @xml,
                    @user_id = 35088,
                    @notes = N'Rebilled by Kareo - SF797301 PT44556565';
                FETCH NEXT FROM claim_cursor INTO @cursor_claim_id;
            END;		
        CLOSE claim_cursor;
        DEALLOCATE claim_cursor;

        COMMIT;
    END

IF OBJECT_ID('tempdb..#claim_transactions') IS NOT NULL 
    BEGIN
        DROP TABLE dbo.#claim_transactions;
    END
GO
    