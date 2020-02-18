
CREATE TABLE #IDsToKeep(ClaimID INT, IDToKeep INT, Items INT)
INSERT INTO #IDsToKeep(ClaimID, IDToKeep, Items)
SELECT ClaimID, MIN(ClaimTransactionID) IDToKeep, COUNT(ClaimTransactionID) Items
FROM ClaimAccounting
WHERE ClaimTransactionTypeCode='BLL'
GROUP BY ClaimID
HAVING COUNT(ClaimTransactionID)>1

DELETE CA
FROM ClaimAccounting CA INNER JOIN #IDsToKeep IK
ON CA.ClaimID=IK.ClaimID AND CA.ClaimTransactionID<>IK.IDToKeep
WHERE CA.ClaimTransactionTypeCode='BLL'

DROP TABLE #IDsToKeep