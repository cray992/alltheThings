use superbill_0280_prod

select 
	PracticeID,
	PatientID, 
	ClaimID,	
	Payment = SUM(case when claimTransactionTypeCode = 'PAY' THEN amount else 0 END),
	PaymentID
INTO #CA
FROM ClaimAccounting ca
GROUP BY 	PracticeID,
	PatientID, 
	ClaimID,
	PaymentID



select 
	--prac.Name,
	pat.PatientID,
	PatientName = ISNULL(pat.LastName, '') +', ' +  ISNULL(pat.FirstName, ''),
	Charge = ep.ServiceChargeAmount * ep.ServiceUnitCount, 
	ResponsibleParty = ISNULL(iPayer.PlanName, isnull(pPayer.LastName, '') + ', ' + ISNULL(pPayer.FirstName, '') ),
	ca.Payment,
	PaymentMethod = pt.Description,
	DateOfService,
	ca.ClaimID,
	ca.PaymentID,
	IsNull(rp.LastName, '')+ ', '+IsNull(rp.FirstName, '') Rendering,
	case when sp.DoctorID is null then IsNull(rp.LastName, '')+ ', '+IsNull(rp.FirstName, '') else IsNull(sp.LastName, '')+ ', '+IsNull(sp.FirstName, '') end Scheduling
FROM #CA ca
	INNER JOIN Claim c ON c.practiceID = ca.PracticeID AND c.claimID = ca.ClaimID
	INNER JOIN EncounterProcedure ep ON ep.PracticeID = c.PracticeID AND ep.EncounterProcedureID = c.EncounterProcedureID
	INNER JOIN Encounter e ON e.PracticeID = ep.PracticeID AND e.EncounterID = ep.EncounterID
	INNER JOIN patient pat ON pat.PatientID = ca.PatientID
	INNER JOIN Payment p on p.PaymentID = ca.PaymentID AND ca.PracticeID = p.PracticeID
	INNER JOIN Practice prac on prac.PracticeID = ca.PracticeID
	LEFT JOIN Patient pPayer on pPayer.PatientID = p.PayerID and p.PayerTypeCode = 'P'
	LEFT JOIN InsuranceCompanyPlan iPayer on iPayer.InsuranceCompanyPlanID = p.PayerID and p.PayerTypeCode = 'I'
	LEFT JOIN PaymentMethodCode pt on pt.PaymentMethodCode = p.PaymentMethodCode
	INNER JOIN Doctor rp on rp.DoctorID=e.DoctorID
	LEFT JOIN Doctor sp on sp.DoctorID=e.SchedulingProviderID
WHERE ca.PRACTICEID=14 AND DateOfService between '2007-03-01' and '2007-03-31'
ORDER BY Scheduling, DateOfService

drop table #CA
