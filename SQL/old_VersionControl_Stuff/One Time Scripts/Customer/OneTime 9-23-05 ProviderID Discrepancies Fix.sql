BEGIN TRAN

CREATE TABLE #E_Defs(ClaimID INT, ProviderID INT)
INSERT INTO #E_Defs(ClaimID, ProviderID)
SELECT ClaimID, DoctorID ProviderID
FROM Encounter E WITH (READUNCOMMITTED) INNER JOIN EncounterProcedure EP WITH (READUNCOMMITTED) ON E.EncounterID=EP.EncounterID
INNER JOIN Claim C WITH (READUNCOMMITTED) ON EP.EncounterProcedureID=C.EncounterProcedureID

SELECT COUNT(ClaimTransactionID) CT_Before
FROM ClaimTransaction CT WITH (READUNCOMMITTED) INNER JOIN #E_Defs E
ON CT.ClaimID=E.ClaimID
WHERE CT.Claim_ProviderID<>E.ProviderID

SELECT COUNT(ClaimTransactionID) CA_Before
FROM ClaimAccounting CA WITH (READUNCOMMITTED) INNER JOIN #E_Defs E
ON CA.ClaimID=E.ClaimID
WHERE CA.ProviderID<>E.ProviderID

ALTER TABLE ClaimTransaction DISABLE TRIGGER ALL

UPDATE CT SET Claim_ProviderID=E.ProviderID
FROM ClaimTransaction CT INNER JOIN #E_Defs E
ON CT.ClaimID=E.ClaimID
WHERE CT.Claim_ProviderID<>E.ProviderID

UPDATE CA SET ProviderID=E.ProviderID
FROM ClaimAccounting CA INNER JOIN #E_Defs E
ON CA.ClaimID=E.ClaimID
WHERE CA.ProviderID<>E.ProviderID

ALTER TABLE ClaimTransaction ENABLE TRIGGER ALL

SELECT COUNT(ClaimTransactionID) CT_After
FROM ClaimTransaction CT WITH (READUNCOMMITTED) INNER JOIN #E_Defs E
ON CT.ClaimID=E.ClaimID
WHERE CT.Claim_ProviderID<>E.ProviderID

SELECT COUNT(ClaimTransactionID) CA_After
FROM ClaimAccounting CA WITH (READUNCOMMITTED) INNER JOIN #E_Defs E
ON CA.ClaimID=E.ClaimID
WHERE CA.ProviderID<>E.ProviderID

DROP TABLE #E_Defs

COMMIT TRAN
--ROLLBACK TRAN