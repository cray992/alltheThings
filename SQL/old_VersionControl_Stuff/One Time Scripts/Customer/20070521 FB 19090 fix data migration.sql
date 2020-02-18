CREATE TABLE #END_CTs(ClaimTransactionID INT, CorrectCode CHAR(3))
INSERT INTO #END_CTs(ClaimTransactionID, CorrectCode)
SELECT CT.ClaimTransactionID, CA.ClaimTransactionTypeCode CorrectCode
FROM ClaimTransaction CT INNER JOIN ClaimAccounting CA
ON CT.PracticeID=CA.PracticeID AND CT.ClaimTransactionID=CA.ClaimTransactionID
AND CT.ClaimTransactionTypeCode<>CA.ClaimTransactionTypeCode
WHERE CT.ClaimTransactionTypeCode='END'
UNION
SELECT CT.ClaimTransactionID, 'ASN' CorrectCode
FROM ClaimTransaction CT INNER JOIN ClaimAccounting_Assignments CA
ON CT.PracticeID=CA.PracticeID AND CT.ClaimTransactionID=CA.ClaimTransactionID
WHERE CT.ClaimTransactionTypeCode='END'
UNION
SELECT CT.ClaimTransactionID, 'BLL' CorrectCode
FROM ClaimTransaction CT INNER JOIN ClaimAccounting_Billings CA
ON CT.PracticeID=CA.PracticeID AND CT.ClaimTransactionID=CA.ClaimTransactionID
WHERE CT.ClaimTransactionTypeCode='END'

ALTER TABLE ClaimTransaction DISABLE TRIGGER ALL

UPDATE CT SET ClaimTransactionTypeCode=CorrectCode
FROM ClaimTransaction CT INNER JOIN #END_CTs ECT
ON CT.ClaimTransactionID=ECT.ClaimTransactionID

ALTER TABLE ClaimTransaction ENABLE TRIGGER ALL

DROP TABLE #END_CTs
