

		CREATE TABLE #FirstASN(EncounterID INT, ClaimID INT, ClaimTransactionID INT, EncounterProcedureID INT)
		INSERT INTO #FirstASN(EncounterID, ClaimID, ClaimTransactionID, EncounterProcedureID)
		SELECT EP.EncounterID, C.ClaimID, MIN(CAA.ClaimTransactionID) ClaimTransactionID, MIN(ep.EncounterProcedureID)
		FROM Encounter E 
			INNER JOIN EncounterProcedure EP ON E.EncounterID=EP.EncounterID
			INNER JOIN Claim C ON EP.PracticeID=C.PracticeID AND EP.EncounterProcedureID=C.EncounterProcedureID
			INNER JOIN ClaimAccounting_Assignments CAA ON C.PracticeID=CAA.PracticeID AND C.ClaimID=CAA.ClaimID
			LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
		WHERE 
			InsurancePolicyID IS NOT NULL AND 
--			C.ClaimStatusCode<>'C' AND 
			VC.ClaimID IS NULL
		GROUP BY EP.EncounterID, C.ClaimID


		-- List of Approved Encounters that are in need of copay
		CREATE TABLE #MissedCoPays(EncounterID INT, EncounterProcedureID INT, CopayDue MONEY, AmountPaid MONEY default 0)
		INSERT INTO #MissedCopays(EncounterID, EncounterProcedureID, CopayDue)
		SELECT FA.EncounterID, Min(EncounterProcedureID), IP.Copay
		FROM #FirstASN FA 
			INNER JOIN ClaimAccounting_Assignments CAA ON FA.ClaimTransactionID=CAA.ClaimTransactionID
			INNER JOIN InsurancePolicy IP ON CAA.InsurancePolicyID=IP.InsurancePolicyID
			INNER JOIN InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
			INNER JOIN Encounter E ON FA.EncounterID=E.EncounterID
			LEFT JOIN PatientCase PC ON E.PatientCaseID=PC.PatientCaseID
		WHERE
			isnull(IP.Copay, 0) <> 0
		GROUP BY FA.EncounterID, IP.Copay



		INSERT INTO #MissedCopays(EncounterID, EncounterProcedureID, CopayDue)
		SELECT e.EncounterID, Min(ep.EncounterProcedureID), IP.Copay
		FROM Encounter E
			INNER JOIN PatientCase PC ON E.PatientCaseID=PC.PatientCaseID
			INNER JOIN InsurancePolicy IP ON PC.PracticeID=IP.PracticeID AND PC.PatientCaseID=IP.PatientCaseID AND IP.Precedence=dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(E.PatientCaseID,E.DateOfService,0)		
			INNER JOIN EncounterProcedure ep ON ep.PracticeID = e.PracticeID AND e.EncounterID = ep.EncounterID
			LEFT JOIN #MissedCopays mc ON mc.EncounterID = e.EncounterID
		WHERE
			mc.EncounterID IS NULL AND
			isnull(IP.Copay, 0) <> 0
		GROUP BY e.EncounterID, IP.Copay


delete ClaimTransaction
FROM ( 
		select mc.*, prc.*
		from #MissedCopays mc
			INNER JOIN Claim c ON c.EncounterProcedureID = mc.EncounterProcedureID
			INNER JOIN 
				( select practiceID, claimID, cnt = count(*), amount = sum(Amount), max(ClaimTransactionID) ClaimTransactionID
					from ClaimTransaction
					where ClaimTransactionTypeCode = 'PRC'
					GROUP BY practiceID, CLaimID ) as prc on c.PracticeID = prc.PracticeID AND c.ClaimID = prc.ClaimID
		where cnt = 2
	) as v
where ClaimTransaction.ClaimTransactionID = v.ClaimTransactionID
	AND ClaimTransactionTypeCode = 'PRC'




drop table #FirstASN, #MissedCopays