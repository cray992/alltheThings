DECLARE @CTsToUpdate TABLE(ClaimTransactionID INT, PostingDate DATETIME)
INSERT @CTsToUpdate(ClaimTransactionID, PostingDate)
select ca.ClaimTransactionID, e.PostingDate
from claimAccounting ca 
INNER JOIN Claim c on c.ClaimID = ca.ClaimID
INNER JOIN EncounterProcedure ep on ep.EncounterProcedureID = c.EncounterProcedureID
INNER JOIN Encounter e on e.EncounterID = ep.EncounterID
where ClaimTransactionTypeCode = 'CST' 
and dbo.fn_DateOnly(ca.PostingDate) <> dbo.fn_DateOnly( e.PostingDate )

UPDATE CT SET PostingDate=CTU.PostingDate
FROM ClaimTransaction CT INNER JOIN @CTsToUpdate CTU
ON CT.ClaimTransactionID=CTU.ClaimTransactionID



