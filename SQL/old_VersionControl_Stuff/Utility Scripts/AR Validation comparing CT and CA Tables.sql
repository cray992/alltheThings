CREATE TABLE #Billed(PracticeID INT, ClaimID INT)
INSERT INTO #Billed(PracticeID, ClaimID)
SELECT DISTINCT PracticeID, CT.ClaimID
FROM ClaimTransaction CT LEFT JOIN VoidedClaims VC
ON CT.ClaimID=VC.ClaimID
WHERE ClaimTransactionTypeCode='BLL' AND VC.ClaimID IS NULL

CREATE TABLE #CT_AR(PracticeID INT, AR MONEY)
INSERT INTO #CT_AR(PracticeID, AR)
SELECT B.PracticeID,
SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)-SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN Amount ELSE 0 END) AR
FROM ClaimTransaction CT INNER JOIN #Billed B
ON CT.PracticeID=B.PracticeID AND CT.ClaimID=B.ClaimID
GROUP BY B.PracticeID

CREATE TABLE #CA_AR(PracticeID INT, AR MONEY)
INSERT INTO #CA_AR(PracticeID, AR)
SELECT CA.PracticeID, SUM(ARAmount) AR
FROM ClaimAccounting CA INNER JOIN #Billed B
ON CA.PracticeID=B.PracticeID AND CA.ClaimID=B.ClaimID
GROUP BY CA.PracticeID

DECLARE @PracticesToReview TABLE(PracticeID INT)
INSERT @PracticesToReview(PracticeID)
SELECT CT.PracticeID
FROM #CT_AR CT INNER JOIN #CA_AR CA
ON CT.PracticeID=CA.PracticeID
WHERE CT.AR<>CA.AR

CREATE TABLE #CA_FirstBLL(PracticeID INT, ClaimID INT, ClaimTransactionID INT)
INSERT #CA_FirstBLL(PracticeID, ClaimID, ClaimTransactionID)
SELECT CA.PracticeID, CA.ClaimID, CA.ClaimTransactionID
FROM ClaimAccounting CA INNER JOIN #Billed B
ON CA.PracticeID=B.PracticeID AND CA.ClaimID=B.ClaimID
INNER JOIN @PracticesToReview PTR ON CA.PracticeID=PTR.PracticeID
WHERE CA.ClaimTransactionTypeCode='BLL'

CREATE TABLE #CT_ToInsert(PracticeID INT, ClaimID INT, ProviderID INT, PatientID INT, 
						  ClaimTransactionID INT, ClaimTransactionTypeCode CHAR(3),
						  Status BIT, ProcedureCount INT, Amount MONEY, ARAmount MONEY, PostingDate DATETIME)
INSERT INTO #CT_ToInsert(CT.PracticeID, CT.ClaimID, CT.ClaimProviderID ProviderID, CT.PatientID, 
CT.ClaimTransactionID, CT.ClaimTransactionTypeCode, Amount, PostingDate)
SELECT CT.PracticeID, CT.ClaimID, CT.ClaimProviderID ProviderID, CT.PatientID, 
CT.ClaimTransactionID, CT.ClaimTransactionTypeCode, CT.Amount, CT.PostingDate
FROM ClaimTransaction CT LEFT JOIN ClaimAccounting CA
ON CT.PracticeID=CA.PracticeID AND CT.ClaimID=CA.ClaimID AND 
CT.ClaimTransactionID=CA.ClaimTransactionID
LEFT JOIN VoidedClaims VC
ON CT.ClaimID=VC.ClaimID
WHERE VC.ClaimID IS NULL AND CT.ClaimTransactionTypeCode IN('CST','PAY','ADJ') AND
CA.CLaimTransactionID IS NULL

SELECT CA.*
FROM ClaimAccounting CA INNER JOIN #CA_FirstBLL CAFB
ON CA.PracticeID=CAFB.PracticeID AND CA.ClaimID=CAFB.ClaimID AND CA.ClaimTransactionID>CAFB.ClaimTransactionID
WHERE CA.PracticeID=1 AND ClaimTransactionTypeCode NOT IN ('BLL','CST') AND -1*Amount<>ARAmount
ORDER BY. CA.ClaimID, CA.ClaimTransactionID

SELECT CT.PracticeID, CT.AR-CA.AR
FROM #CT_AR CT INNER JOIN #CA_AR CA
ON CT.PracticeID=CA.PracticeID
WHERE CT.AR<>CA.AR

DROP TABLE #Billed
DROP TABLE #CT_AR
DROP TABLE #CA_AR
DROP TABLE #CA_FirstBLL