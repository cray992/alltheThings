DECLARE @Batches TABLE(BillBatchID INT, PracticeID INT, CreatedDate DATETIME, Items INT)
INSERT @Batches(BillBatchID, PracticeID, CreatedDate, Items)
SELECT BB.BillBatchID, BB.PracticeID, CreatedDate, COUNT(BillID) Items
FROM BillBatch BB INNER JOIN Bill_Statement BS
ON BB.BillBatchID=BS.BillBatchID
WHERE BillBatchTypeCode='S' AND CreatedDate>='1-6-07' AND ConfirmedDate IS NOT NULL
GROUP BY BB.BillBatchID, BB.PracticeID, CreatedDate
ORDER BY CreatedDate DESC

DECLARE @RepeatedClaimBills TABLE(PatientID INT, ClaimID INT)
INSERT @RepeatedClaimBills(PatientID, ClaimID)
SELECT BS.PatientID, BC.ClaimID
FROM @Batches B INNER JOIN Bill_Statement BS
ON B.BillBatchID=BS.BillBatchID
INNER JOIN BillClaim BC
ON BS.BillID=BC.BillID AND BC.BillBatchTypeCode='S'
GROUP BY BS.PatientID, BC.ClaimID
HAVING COUNT(BC.BillID)>1

CREATE TABLE #BLLToPopulate(CreatedDate DATETIME, PracticeID INT, BillID INT, ClaimID INT)
INSERT INTO #BLLToPopulate(CreatedDate, PracticeID, BillID, ClaimID)
SELECT B.CreatedDate, B.PracticeID, BC.BillID, BC.ClaimID
FROM @Batches B INNER JOIN Bill_Statement BS
ON B.BillBatchID=BS.BillBatchID
INNER JOIN BillClaim BC
ON BS.BillID=BC.BillID AND BC.BillBatchTypeCode='S'
LEFT JOIN ClaimTransaction CT
ON BC.ClaimID=CT.ClaimID AND BC.BillID=CT.ReferenceID
WHERE CT.ClaimID IS NULL AND BC.IsCopay=1

--Create Statement transaction for claim.
DECLARE @notes VARCHAR(200)
SET @notes = 'STATEMENT GENERATED WITH BATCH '

--Create the bill transaction.
INSERT INTO CLAIMTRANSACTION (ClaimTransactionTypeCode, ClaimID, PostingDate, Code, ReferenceID,
						  Notes, PracticeID, PatientID, Claim_ProviderID)
SELECT 'BLL', BTP.ClaimID, CAST(CONVERT(CHAR(10),BTP.CreatedDate,110) AS DATETIME), 'S', BTP.BillID, @notes+CAST(BTP.BillID AS VARCHAR), BTP.PracticeID, CA.PatientID, CA.ProviderID
FROM #BLLToPopulate BTP INNER JOIN ClaimAccounting CA
ON BTP.PracticeID=CA.PracticeID AND BTP.ClaimID=CA.ClaimID AND CA.ClaimTransactionTypeCode='CST'

DROP TABLE #BLLToPopulate
