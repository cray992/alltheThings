CREATE TABLE #Claims(PracticeID INT, ClaimID INT, claimtransactionid int)
INSERT INTO #Claims(PracticeID, ClaimID, claimtransactionid)
SELECT PracticeID, ClaimID, claimtransactionid
FROM ClaimAccounting
WHERE ClaimTransactionTypeCode='BLL' AND ARAmount=0

CREATE TABLE #CSTs(PracticeID INT, ClaimID INT, Amount MONEY)
INSERT INTO #CSTs(PracticeID, ClaimID, Amount)
SELECT CA.PracticeID, CA.ClaimID, Amount
FROM ClaimAccounting CA INNER JOIN #Claims C
ON CA.PracticeID=C.PracticeID AND CA.ClaimID=C.ClaimID
WHERE CA.ClaimTransactionTypeCode='CST' AND Amount<>0

UPDATE CA SET ARAmount=CSTs.Amount
FROM ClaimAccounting CA INNER JOIN #Claims C
ON CA.PracticeID=C.PracticeID AND CA.ClaimTransactionID=C.ClaimTransactionID
INNER JOIN #CSTs CSTs
ON C.PracticeID=CSTs.PracticeID AND C.ClaimID=CSTs.ClaimID

DROP TABLE #Claims
DROP TABLE #CSTs