UPDATE CT SET CT.PostingDate=CAST(CONVERT(CHAR(10),E.PostingDate,110) AS DATETIME)
FROM Encounter E INNER JOIN EncounterProcedure EP
ON E.EncounterID=EP.EncounterID
INNER JOIN Claim C
ON EP.EncounterProcedureID=C.EncounterProcedureID
INNER JOIN ClaimTransaction CT
ON C.ClaimID=CT.ClaimID
WHERE E.CreatedDate>='12-21-05' AND CT.ClaimTransactionTypeCode='CST'

UPDATE CA SET CA.PostingDate=CAST(CONVERT(CHAR(10),E.PostingDate,110) AS DATETIME)
FROM Encounter E INNER JOIN EncounterProcedure EP
ON E.EncounterID=EP.EncounterID
INNER JOIN Claim C
ON EP.EncounterProcedureID=C.EncounterProcedureID
INNER JOIN ClaimTransaction CT
ON C.ClaimID=CT.ClaimID
INNER JOIN ClaimAccounting CA
ON CT.ClaimTransactionID=CA.ClaimTransactionID
WHERE E.CreatedDate>='12-21-05' AND CT.ClaimTransactionTypeCode='CST'