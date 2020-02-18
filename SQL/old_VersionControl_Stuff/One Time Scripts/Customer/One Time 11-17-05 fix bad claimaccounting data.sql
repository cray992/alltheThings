
CREATE TABLE #ProblemClaims(ClaimID INT)
INSERT INTO #ProblemClaims(ClaimID)
SELECT DISTINCT C.ClaimID
FROM Claim C INNER JOIN ClaimAccounting CA
ON C.ClaimID=CA.ClaimID
WHERE ClaimStatusCode='R' AND CA.Status=1

CREATE TABLE #HasEnd(ClaimID INT, Items INT)
INSERT INTO #HasEnd(ClaimID, Items)
SELECT CA.ClaimID, COUNT(ClaimTransactionID) Items
FROM ClaimAccounting CA INNER JOIN #ProblemClaims PC
ON CA.ClaimID=PC.ClaimID
WHERE ClaimTransactionTypeCode='END'
GROUP BY CA.ClaimID
HAVING COUNT(ClaimTransactionID)>=1

DELETE PC
FROM #ProblemClaims PC INNER JOIN #HasEnd HE
ON PC.ClaimID=HE.ClaimID

UPDATE CA SET Status=0
FROM ClaimAccounting CA INNER JOIN #ProblemClaims PC
ON CA.ClaimID=PC.ClaimID

UPDATE CAA SET Status=0
FROM ClaimAccounting_Assignments CAA INNER JOIN #ProblemClaims PC
ON CAA.ClaimID=PC.ClaimID

UPDATE CAB SET Status=0
FROM ClaimAccounting_Billings CAB INNER JOIN #ProblemClaims PC
ON CAB.ClaimID=PC.ClaimID

DROP TABLE #ProblemClaims
DROP TABLE #HasEnd