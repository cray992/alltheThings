select p.PracticeID, p.Name, C.ClaimStatusCode,  e.EncounterID, c.ClaimID, e.PatientID as NewPatientID, ca.PatientID as OrgPatientID
INTO #Claims
from 
	dbo.Practice P
	INNER JOIN dbo.ClaimAccounting ca ON ca.PracticeID = p.PracticeID
	INNER JOIN dbo.Claim c ON ca.PracticeID = c.PracticeID AND ca.ClaimID = c.CLaimID
	INNER JOIN dbo.EncounterProcedure ep ON ep.PracticeID = c.PracticeID AND ep.EncounterProcedureID = c.EncounterProcedureID
	INNER JOIN dbo.Encounter E on E.PracticeID = ep.PracticeID AND e.EncounterID = ep.EncounterID 
where ca.ClaimTransactionTypeCode = 'CST'
	AND ca.PatientID <> e.PatientID
	AND c.ClaimStatusCode <> 'C'


select c.PracticeID, PaymentID, c.EncounterID, c.ClaimID, OrgPatientID, NewPatientID 
INTO #PaymentClaim
from #Claims c
	INNER JOIN ClaimAccounting ca ON c.PracticeID = ca.PracticeID AND c.ClaimID = ca.ClaimID
WHERE ca.PatientID <> c.NewPatientID
	AND ca.PaymentID IS NOT NULL



Update pc
SET PatientID = NewPatientID
FROM PaymentClaim pc
	INNER JOIN #PaymentClaim n ON n.PracticeID = pc.PracticeID AND n.PaymentID = pc.PaymentID 
		AND pc.ClaimID = n.CLaimID AND pc.EncounterID = n.EncounterID
		AND PatientID = orgPatientID


Update pe
SET PatientID = NewPatientID
FROM PaymentEncounter pe 
	INNER JOIN #PaymentClaim n ON n.PracticeID = pe.PracticeID 
		and n.PaymentID = pe.PaymentID AND n.EncounterID = pe.EncounterID
		AND pe.PatientID = n.orgPatientID



Update pp
SET PatientID = newPatientID
FROM PaymentPatient pp
	INNER JOIN #PaymentClaim n ON n.PracticeID = pp.PracticeID AND n.PaymentID = pp.PaymentID 
		AND n.OrgPatientID = pp.PatientID


drop table #PaymentClaim
drop table #Claims