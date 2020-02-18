UPDATE	Claim
SET	ServiceChargeAmount = 0
WHERE	ServiceChargeAmount IS NULL

UPDATE	EncounterProcedure
SET	ServiceChargeAmount = 0
WHERE	ServiceChargeAmount IS NULL
