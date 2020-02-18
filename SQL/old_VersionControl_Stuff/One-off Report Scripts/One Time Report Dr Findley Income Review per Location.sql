SELECT SL.Name, DATEPART(MM,P.PostingDate) Mo, SUM(Amount) Receipts
FROM Payment P INNER JOIN PaymentClaimTransaction PCT
ON P.PracticeID=PCT.PracticeID AND P.PaymentID=PCT.PaymentID
INNER JOIN ClaimAccounting CA
ON PCT.PracticeID=CA.PracticeID AND PCT.ClaimID=CA.ClaimID AND PCT.ClaimTransactionID=CA.ClaimTransactionID
INNER JOIN Claim C
ON CA.PracticeID=C.PracticeID AND CA.ClaimID=C.ClaimID
INNER JOIN EncounterProcedure EP
ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
INNER JOIN Encounter E
ON EP.PracticeID=E.PracticeID AND EP.EncounterID=E.EncounterID
INNER JOIN ServiceLocation SL
ON E.LocationID=SL.ServiceLocationID
WHERE P.PracticeID=41 AND P.PostingDate BETWEEN '1-1-05' AND '12-31-05' AND CA.ClaimTransactionTypeCode='PAY'
GROUP BY SL.Name, DATEPART(MM, P.PostingDate)

