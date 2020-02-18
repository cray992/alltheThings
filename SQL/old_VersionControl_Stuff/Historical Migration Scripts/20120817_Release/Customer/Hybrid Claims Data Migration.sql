

DISABLE TRIGGER tr_Encounter_MaintainPaymentsOnEncounterApproved ON Encounter
GO



UPDATE Encounter
SET SecondaryClaimTypeID = ClaimTypeID
WHERE SecondaryClaimTypeID IS NULL
AND PatientCaseID IN
(
	SELECT ip.PatientCaseID
	FROM InsurancePolicy ip
	GROUP BY ip.PatientCaseID
	HAVING COUNT(ip.InsurancePolicyID) >= 2
)
--Rollback
--COMMIT 

UPDATE Encounter
SET SubmitReasonIDCMS1500 = SubmitReasonID
WHERE SubmitReasonID IS NOT NULL
AND ClaimTypeID = 0

UPDATE Encounter
SET DocumentControlNumberCMS1500 = DocumentControlNumber
WHERE DocumentControlNumber IS NOT NULL
AND ClaimTypeID = 0

UPDATE Encounter
SET EDIClaimNoteReferenceCodeCMS1500 = EDIClaimNoteReferenceCode
WHERE EDIClaimNoteReferenceCode IS NOT NULL
AND ClaimTypeID = 0

UPDATE Encounter
SET EDIClaimNoteCMS1500 = EDIClaimNote
WHERE EDIClaimNote IS NOT NULL
AND ClaimTypeID = 0

UPDATE Encounter
SET SubmitReasonIDUB04 = SubmitReasonID
WHERE SubmitReasonID IS NOT NULL
AND ClaimTypeID = 1

UPDATE Encounter
SET DocumentControlNumberUB04 = DocumentControlNumber
WHERE DocumentControlNumber IS NOT NULL
AND ClaimTypeID = 1

UPDATE Encounter
SET EDIClaimNoteReferenceCodeUB04 = EDIClaimNoteReferenceCode
WHERE EDIClaimNoteReferenceCode IS NOT NULL
AND ClaimTypeID = 1

UPDATE Encounter
SET EDIClaimNoteUB04 = EDIClaimNote
WHERE EDIClaimNote IS NOT NULL
AND ClaimTypeID = 1

GO
ENABLE TRIGGER tr_Encounter_MaintainPaymentsOnEncounterApproved ON Encounter