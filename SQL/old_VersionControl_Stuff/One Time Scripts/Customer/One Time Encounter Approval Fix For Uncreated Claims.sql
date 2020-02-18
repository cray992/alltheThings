--BEGIN TRAN

DECLARE @AffectedEncounters TABLE(EncounterID INT, DoctorID INT, EPs INT, Claims INT)
INSERT @AffectedEncounters(EncounterID, DoctorID, EPs, Claims)
SELECT E.EncounterID, E.DoctorID, COUNT(EP.EncounterProcedureID) EPs, COUNT(ClaimID) Claims
FROM Encounter E INNER JOIN EncounterProcedure EP
ON E.EncounterID=EP.EncounterID
LEFT JOIN Claim C
ON EP.EncounterProcedureID=C.EncounterProcedureID
WHERE C.CreatedDate IS NULL OR C.CreatedDate>='1-11-06 00:00'
GROUP BY E.EncounterID, E.DoctorID
HAVING COUNT(ClaimID)>0 AND COUNT(EP.EncounterProcedureID)<>COUNT(ClaimID) AND COUNT(ClaimID)=1

DECLARE @ClaimInfo TABLE(EncounterID INT, ClaimID INT, EncounterProcedureID INT, PracticeID INT, PatientID INT, AssignmentOfBenefitsFlag BIT, ReleaseSignatureSourceCode CHAR(1), 
			 ReferringProviderIDNumber VARCHAR(32), CreatedDate DATETIME, ModifiedDate DATETIME, DoctorID INT, InsurancePolicyID INT)
INSERT @ClaimInfo(EncounterID, ClaimID, EncounterProcedureID, PracticeID, PatientID, AssignmentOfBenefitsFlag, ReleaseSignatureSourceCode, ReferringProviderIDNumber, CreatedDate, ModifiedDate, DoctorID)
SELECT AE.EncounterID, C.ClaimID, EP.EncounterProcedureID, C.PracticeID, C.PatientID, C.AssignmentOfBenefitsFlag, C.ReleaseSignatureSourceCode, C.ReferringProviderIDNumber, C.CreatedDate, C.ModifiedDate, AE.DoctorID
FROM @AffectedEncounters AE INNER JOIN EncounterProcedure EP
ON AE.EncounterID=EP.EncounterID
INNER JOIN Claim C
ON EP.EncounterProcedureID=C.EncounterProcedureID

UPDATE CI SET InsurancePolicyID=CAA.InsurancePolicyID
FROM @ClaimInfo CI INNER JOIN ClaimAccounting_Assignments CAA
ON CI.ClaimID=CAA.ClaimID

DECLARE @ClaimEPs TABLE(EncounterID INT, PracticeID INT, EncounterProcedureID INT)
INSERT @ClaimEPs(EncounterID, PracticeID, EncounterProcedureID)
SELECT CI.EncounterID, CI.PracticeID, EP.EncounterProcedureID
FROM EncounterProcedure EP INNER JOIN @ClaimInfo CI
ON EP.EncounterID=CI.EncounterID
WHERE EP.EncounterProcedureID<>CI.EncounterProcedureID

INSERT INTO Claim(PracticeID, ClaimStatusCode, PatientID, AssignmentOfBenefitsFlag, ReleaseSignatureSourceCode, EncounterProcedureID, CreatedDate, ModifiedDate, ReferringProviderIDNumber)
SELECT CI.PracticeID, 'R' ClaimStatusCode, CI.PatientID, CI.AssignmentOfBenefitsFlag, CI.ReleaseSignatureSourceCode, EP.EncounterProcedureID, CI.CreatedDate, CI.ModifiedDate, CI.ReferringProviderIDNumber
FROM EncounterProcedure EP INNER JOIN @ClaimInfo CI
ON EP.EncounterID=CI.EncounterID
WHERE EP.EncounterProcedureID<>CI.EncounterProcedureID

INSERT INTO ClaimTransaction(ClaimTransactionTypeCode, ClaimID, PostingDate, ReferenceID, Notes, PracticeID, PatientID, Claim_ProviderID)
SELECT 'ASN' ClaimTransactionTypeCode, C.ClaimID, CAST(CONVERT(CHAR(10),CI.ModifiedDate,110) AS DATETIME) PostingDate, CI.InsurancePolicyID, 
'AUTOMATICALLY ASSIGNED ON CREATION' Notes, CI.PracticeID, CI.PatientID, CI.DoctorID Claim_ProviderID
FROM Claim C INNER JOIN @ClaimEPs CE
ON C.PracticeID=CE.PracticeID AND C.EncounterProcedureID=CE.EncounterProcedureID
INNER JOIN @ClaimInfo CI
ON CE.EncounterID=CI.EncounterID

--ROLLBACK