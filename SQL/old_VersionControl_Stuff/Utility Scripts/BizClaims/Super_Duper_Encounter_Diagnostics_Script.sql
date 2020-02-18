BEGIN TRANSACTION;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
COMMIT;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Run this on the customer's development (or production) database...
/*
USE superbill_<customer-id>_dev;
GO
USE superbill_<customer-id>_prod;
GO
*/

DECLARE @encounter_id AS INT ,
    @claim_id AS INT ,
    @clearinghouse_file_name AS VARCHAR(128) ,
    @clearinghouse_file_receive_date AS DATETIME;
DECLARE @encounter_info AS TABLE
    (
      EncounterID INT NOT NULL ,
      ClaimID INT NOT NULL ,
      PracticeID INT NOT NULL ,
      PatientID INT NOT NULL ,
      PracticeName VARCHAR(128) NOT NULL
    );
DECLARE @claim_transactions AS TABLE
    (
      RowNum INT ,
      PostingDate DATETIME ,
      CreatedDate DATETIME ,
      ClaimTransactionID INT ,
      PracticeID INT ,
      ClaimID INT ,
      ClaimTransactionTypeCode CHAR(3) ,
      ClaimTransactionTypeName VARCHAR(50) ,
      Amount MONEY ,
      PaymentID INT ,
      Notes TEXT
    );
    
-- Change the Encounter ID    
SET @encounter_id = 1;
SET @claim_id = NULL;
-- You may not have @clearinghouse_file_name at first.
-- Change from NULL to find by Clearinghouse Response (Required: @clearinghouse_file_receive_date)...
-- Notes: 1. The Clearinghouse file-name is the prefetcher file-name.
--        2. The ERA number is a ClearinghouseID.
--        3. Example of a Clearinghouse file-name is '040212_5541.csr.pgp'.
SET @clearinghouse_file_name = NULL;
-- You can grab the file received date minimum from the claim-message-transactions.
SET @clearinghouse_file_receive_date = NULL;

/*
-- Get the practices...
SELECT  PracticeID ,
        Name ,
        Active
FROM    dbo.Practice AS P;

-- Checkout the patients to see if they were migrated...
SELECT TOP 10
        *
FROM    dbo.Patient AS P
ORDER BY P.PatientID;
*/

-- Get the most important information related to an Encounter...
INSERT  INTO @encounter_info
        ( EncounterID ,
          ClaimID ,
          PracticeID ,
          PatientID ,
          PracticeName
        )
        ( SELECT  DISTINCT
                    E.EncounterID ,
                    C.ClaimID ,
                    P.PracticeID ,
                    E.PatientID ,
                    P.NAME
          FROM      dbo.Encounter AS E
                    INNER JOIN dbo.EncounterProcedure AS EP ON EP.EncounterID = E.EncounterID
                    INNER JOIN dbo.Claim AS C ON C.EncounterProcedureID = EP.EncounterProcedureID
                    INNER JOIN dbo.Practice AS P ON P.PracticeID = C.PracticeID
          WHERE     E.EncounterID IN ( @encounter_id )
                    AND ( @claim_id IS NULL
                          OR C.ClaimID = @claim_id
                        )
        ); 

SELECT  *
FROM    @encounter_info;

-- Get Claim Transactions...
-- You can get the batch ID from the claim-transaction.
INSERT  INTO @claim_transactions
        ( RowNum ,
          CreatedDate ,
          PostingDate ,
          ClaimTransactionID ,
          PracticeID ,
          ClaimID ,
          ClaimTransactionTypeCode ,
          ClaimTransactionTypeName ,
          Amount ,
          PaymentID ,
          Notes
        )
        SELECT  ROW_NUMBER() OVER ( PARTITION BY CT.ClaimID ORDER BY CT.PostingDate ASC , CT.ClaimTransactionID ASC ) AS RowNum ,
                CT.CreatedDate ,
                CT.PostingDate ,
                CT.ClaimTransactionID ,
                CT.PracticeID ,
                CT.ClaimID ,
                CT.ClaimTransactionTypeCode ,
                CTT.TypeName ,
                CT.Amount ,
                CT.PaymentID ,
                CT.Notes
        FROM    dbo.ClaimTransaction AS CT
                INNER JOIN @encounter_info AS EI ON EI.ClaimID = CT.ClaimID
                INNER JOIN dbo.ClaimTransactionType AS CTT ON CT.ClaimTransactionTypeCode = CTT.ClaimTransactionTypeCode;
                
SELECT  *
FROM    @claim_transactions;

SELECT  *
FROM    @claim_transactions AS CT
WHERE   CT.ClaimTransactionTypeCode IN ( 'RES', 'RJT', 'DEN', 'ADJ', 'PAY',
                                         'BLL', 'ASN', 'END', 'XXX', 'RAS' );

IF @clearinghouse_file_name IS NOT NULL
    AND @clearinghouse_file_receive_date IS NOT NULL 
    BEGIN
        SELECT TOP 10
                CAST(FileContents AS XML) AS [FileContents] ,
                *
        FROM    dbo.ClearinghouseResponse AS CR
        WHERE   CR.FileReceiveDate >= @clearinghouse_file_receive_date
                AND CR.FileName = @clearinghouse_file_name;
    END


SELECT TOP 1000
        *
FROM    dbo.Bill_EDI AS BE
WHERE   BE.RepresentativeClaimID IN ( SELECT DISTINCT
                                                EI.ClaimID
                                      FROM      @encounter_info AS EI );

SELECT  'CT_Deletions' AS 'CT_Deletions' ,
        CD.* ,
        U1.FirstName AS CreatedFirstName ,
        U1.LastName AS CreatedLastName ,
        U2.FirstName AS ModifiedFirstName ,
        U2.LastName AS ModifiedLastName
FROM    dbo.CT_Deletions AS CD
        INNER JOIN Superbill_Shared.dbo.Users AS U1 ON CD.CreatedUserID = U1.UserID
        INNER JOIN Superbill_Shared.dbo.Users AS U2 ON CD.ModifiedUserID = U2.UserID
WHERE   CD.ClaimID IN ( SELECT DISTINCT
                                EI.ClaimID
                        FROM    @encounter_info AS EI );

GO
