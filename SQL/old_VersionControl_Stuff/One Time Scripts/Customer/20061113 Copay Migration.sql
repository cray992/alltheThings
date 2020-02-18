--CASE 15539 

select ca.PracticeID, ep.EncounterID, 
	Balance = sum(case when claimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END),
	AmountPaid = cast(0 as money)
INTO #OpenAR
FROM ClaimAccounting ca (nolock)
	INNER JOIN Claim C ON c.PracticeID = ca.PracticeID AND c.ClaimID = ca.ClaimID
	INNER JOIN EncounterProcedure ep ON ep.PracticeID = c.PracticeID AND ep.EncounterProcedureID = c.EncounterProcedureID 
	INNER JOIN Encounter e ON e.PracticeID = ep.PracticeID AND e.EncounterID = ep.EncounterID
WHERE encounterStatusID = 3
group by ca.PracticeID, ep.EncounterID
having sum(case when claimTransactionTypeCode = 'CST' THEN AMOUNT ELSE -1*AMOUNT END) > 0


Update e
SET AmountPaid = e.AmountPaid + ISNULL(		(select sum(Amount) 
											from 	EncounterProcedure ep 
													Inner Join Claim c 
														on C.PracticeID = EP.PracticeID
														AND C.EncounterProcedureID = ep.EncounterProcedureID 
													Inner Join ClaimTransaction ct 
														on CT.PracticeID = C.PracticeID
														AND ct.ClaimID = c.ClaimID 
													Inner Join Payment p 
														on P.PracticeID = ct.PracticeID
														AND P.paymentID = ct.PaymentID
											WHERE	e.EncounterID = ep.EncounterID AND
													p.PaymentTypeID = 1
													)
										, 0) -- end of ISNULL
FROM	#OpenAR e 



		CREATE TABLE #FirstASN(EncounterID INT, ClaimID INT, ClaimTransactionID INT, EncounterProcedureID INT)
		INSERT INTO #FirstASN(EncounterID, ClaimID, ClaimTransactionID, EncounterProcedureID)
		SELECT EP.EncounterID, C.ClaimID, MIN(CAA.ClaimTransactionID) ClaimTransactionID, MIN(ep.EncounterProcedureID)
		FROM #OpenAR E 
			INNER JOIN EncounterProcedure EP ON E.EncounterID=EP.EncounterID
			INNER JOIN Claim C ON EP.PracticeID=C.PracticeID AND EP.EncounterProcedureID=C.EncounterProcedureID
			INNER JOIN ClaimAccounting_Assignments CAA ON C.PracticeID=CAA.PracticeID AND C.ClaimID=CAA.ClaimID
			LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
		WHERE 
			InsurancePolicyID IS NOT NULL AND 
			C.ClaimStatusCode<>'C' AND 
			VC.ClaimID IS NULL
		GROUP BY EP.EncounterID, C.ClaimID



		CREATE TABLE #MissedCoPays(EncounterID INT, PlanName VARCHAR(128), Copay MONEY)
		INSERT INTO #MissedCopays(EncounterID, PlanName, Copay)
		SELECT DISTINCT FA.EncounterID, PlanName, IP.Copay
		FROM #FirstASN FA 
			INNER JOIN ClaimAccounting_Assignments CAA ON FA.ClaimTransactionID=CAA.ClaimTransactionID
			INNER JOIN InsurancePolicy IP ON CAA.InsurancePolicyID=IP.InsurancePolicyID
			INNER JOIN InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
			INNER JOIN Encounter E ON FA.EncounterID=E.EncounterID
			LEFT JOIN PatientCase PC ON E.PatientCaseID=PC.PatientCaseID
		WHERE
			isnull(IP.Copay, 0) - isnull(E.AmountPaid, 0) > 0



INSERT INTO [ClaimTransaction] 
	(
           [CreatedDate]
           ,[ModifiedDate]
           ,[CreatedUserID]
           ,[PostingDate]

			,[ClaimTransactionTypeCode]
           ,[ClaimID]
           ,[Amount]

           ,[PracticeID]
           ,[PatientID]
           ,[Claim_ProviderID]

           ,[Notes]

	)

    
select  
		getdate()
       ,getdate()
       ,ca.[CreatedUserID]
       ,caa.[PostingDate]

		,'PRC'
		,c.ClaimID	
		,mp.Copay

		,c.PracticeID
		,ca.PatientID
		,ca.ProviderID
		,'Migration of copay'
From #MissedCoPays mp
	INNER JOIN ( select EncounterID, EncounterProcedureID=min(EncounterProcedureID) from #FirstASN GROUP BY encounterID) fa
		ON fa.EncounterID = mp.EncounterID
	INNER JOIN Claim c ON c.EncounterProcedureID = fa.EncounterProcedureID
	INNER JOIN (SELECT PracticeID, ClaimID, min(PostingDate) as PostingDate FROM ClaimAccounting_Assignments GROUP BY PracticeID, ClaimID ) caa ON caa.PracticeID = c.PracticeID AND  caa.ClaimID = c.ClaimID 
	INNER JOIN ClaimAccounting ca ON ca.PracticeID = c.PracticeID AND  ca.ClaimID = c.ClaimID AND ca.ClaimTransactionTypeCode = 'CST'

GO