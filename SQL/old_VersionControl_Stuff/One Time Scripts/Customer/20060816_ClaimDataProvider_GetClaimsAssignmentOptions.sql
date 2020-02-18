IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClaimDataProvider_GetClaimsAssignmentOptions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ClaimDataProvider_GetClaimsAssignmentOptions]
GO

--===========================================================================
-- GET CLAIMS ASSIGNMENT OPTIONS
-- dbo.ClaimDataProvider_GetClaimsAssignmentOptions '<?xml version=''1.0'' ?><selections><selection ClaimID=''154550'' /><selection ClaimID=''154556'' /></selections>'
--===========================================================================
CREATE PROCEDURE [dbo].[ClaimDataProvider_GetClaimsAssignmentOptions]
	@selection_xml TEXT
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @x_doc INT
	EXEC sp_xml_preparedocument @x_doc OUTPUT, @selection_xml

	SELECT S.ClaimID 
	INTO #TClaim
	FROM OPENXML(@x_doc, 'selections/selection') WITH (ClaimID INT) S
	INNER JOIN dbo.Claim C ON C.ClaimID = S.ClaimID

	EXEC sp_xml_removedocument @x_doc
	
	CREATE UNIQUE CLUSTERED INDEX #UX_TClaim_ClaimID ON #TClaim (ClaimID)

	-- Create a temp table to store the insurance policies
	CREATE TABLE #TInsurancePolicy(
		ClaimID INT, 
		PatientCaseID INT, 
		InsurancePolicyID INT,
		InsuranceCompanyPlanID INT, 
		Precedence INT, 
		DisplayPrecedence INT
	)

	INSERT #TInsurancePolicy(
		ClaimID,
		PatientCaseID, 
		InsurancePolicyID,
		InsuranceCompanyPlanID, 
		Precedence
	)
	SELECT		C.ClaimID,
			E.PatientCaseID, 
			IP.InsurancePolicyID,
			IP.InsuranceCompanyPlanID, 
			IP.Precedence
	FROM 		CLAIM C
	INNER JOIN 	#TClaim CS 
	ON 		   CS.ClaimID = C.ClaimID
	INNER JOIN 	dbo.EncounterProcedure EP
		ON EP.PracticeID = C.PracticeID
		AND EP.EncounterProcedureID = C.EncounterProcedureID
	INNER JOIN	dbo.Encounter E
		ON E.PracticeID = EP.PracticeID
		AND E.EncounterID = EP.EncounterID
	INNER JOIN	dbo.PatientCase PC
		ON PC.PracticeID = E.PracticeID
		AND PC.PatientCaseID = E.PatientCaseID
	INNER JOIN	dbo.InsurancePolicy IP
	ON		   IP.PracticeID = PC.PracticeID
	AND		   IP.PatientCaseID = PC.PatientCaseID
	AND		   IP.Active = 1
	AND		   (IP.PolicyStartDate IS NULL OR IP.PolicyStartDate <= EP.ProcedureDateOfService)
	AND		   (IP.PolicyEndDate IS NULL OR IP.PolicyEndDate >= EP.ProcedureDateOfService)
	ORDER BY	IP.Precedence

	-- Loop through each claim and assign the display precedence for each insurance policy associated with the claim
	DECLARE @ClaimID INT
	SELECT	@ClaimID = MIN(ClaimID)	FROM #TClaim

	WHILE @ClaimID IS NOT NULL
	BEGIN
		DECLARE 	@i INT
		SET		@i = 0
		
		UPDATE		#TInsurancePolicy
		SET		DisplayPrecedence = @i,
				@i = @i + 1
		WHERE		ClaimID = @ClaimID

		SELECT @ClaimID = MIN(ClaimID) FROM #TClaim WHERE ClaimID > @ClaimID
	END


	SELECT 
		C.ClaimID,
	 	CASE WHEN CA.InsurancePolicyID IS NULL THEN 'Rebill patient'
			ELSE 'Bill patient'
		END AS ASSIGNMENTNAME,
		CASE WHEN CA.InsurancePolicyID IS NULL THEN 'R'
			ELSE CAST(-1 AS VARCHAR(2))	--'P'
		END AS ASSIGNMENTCODE,
		CAST(1 AS BIT) AS PAYMENTOPTION,
		CAST(1 AS BIT) AS ADJUSTMENTOPTION,
		CAST(0 AS BIT) AS VOIDOPTION,
		CASE WHEN CA.InsurancePolicyID IS NULL THEN CAST(0 AS BIT)
			ELSE CAST(1 AS BIT)
		END AS TRANSFEROPTION,
		CAST(0 AS BIT) AS REBILLOPTION,
		CAST(0 AS BIT) AS SETTLEOPTION,
		CAST(0 AS INT) AS SortOrder
	FROM 
		#TClaim C
		LEFT JOIN
			dbo.ClaimAccounting_Assignments CA
		ON	   CA.ClaimID = C.ClaimID
		AND	   CA.LastAssignment = 1

	UNION ALL

	SELECT 
		IP.ClaimID,
		CASE
			WHEN IP.InsurancePolicyID = CA.InsurancePolicyID THEN 'Rebill payer ' + CAST(IP.DisplayPrecedence AS VARCHAR) + ' - ' + ICP.PlanName
			ELSE 'Bill payer ' + CAST(IP.DisplayPrecedence AS VARCHAR) + ' - ' + ICP.PlanName
		END AS ASSIGNMENTNAME,
		CASE
			WHEN IP.InsurancePolicyID = CA.InsurancePolicyID THEN 'R'
			ELSE CAST(IP.InsurancePolicyID AS VARCHAR)
		END AS ASSIGNMENTCODE,
		CAST(1 AS BIT) AS PAYMENTOPTION,
		CAST(1 AS BIT) AS ADJUSTMENTOPTION,
		CAST(0 AS BIT) AS VOIDOPTION,
		CASE
			WHEN IP.InsurancePolicyID = CA.InsurancePolicyID THEN CAST(0 AS BIT)
			ELSE CAST(1 AS BIT)
		END AS TRANSFEROPTION,
		CAST(0 AS BIT) AS REBILLOPTION,
		CAST(0 AS BIT) AS SETTLEOPTION, 
		IP.Precedence AS SortOrder
	FROM 		#TInsurancePolicy IP
	LEFT JOIN	dbo.ClaimAccounting_Assignments CA
	ON	   	   CA.ClaimID = IP.ClaimID
	AND	   	   CA.LastAssignment = 1
	INNER JOIN	dbo.InsuranceCompanyPlan ICP
	ON		   ICP.InsuranceCompanyPlanID = IP.InsuranceCompanyPlanID

	UNION ALL

	SELECT 
		ClaimID,
		'Settle' AS ASSIGNMENTNAME,
		'S' AS ASSIGNMENTCODE,
		CAST(1 AS BIT) AS PAYMENTOPTION,
		CAST(1 AS BIT) AS ADJUSTMENTOPTION,
		CAST(0 AS BIT) AS VOIDOPTION,
		CAST(0 AS BIT) AS TRANSFEROPTION,
		CAST(0 AS BIT) AS REBILLOPTION,
		CAST(0 AS BIT) AS SETTLEOPTION,
		CAST(100 AS INT) AS SortOrder
	FROM 
		#TClaim

	UNION ALL

	SELECT 
		ClaimID,
		'None' AS ASSIGNMENTNAME,
		'N' AS ASSIGNMENTCODE,
		CAST(1 AS BIT) AS PAYMENTOPTION,
		CAST(1 AS BIT) AS ADJUSTMENTOPTION,
		CAST(1 AS BIT) AS VOIDOPTION,
		CAST(0 AS BIT) AS TRANSFEROPTION,
		CAST(1 AS BIT) AS REBILLOPTION,
		CAST(1 AS BIT) AS SETTLEOPTION, 
		CAST(101 AS INT) AS SortOrder
	FROM 
		#TClaim

	UNION ALL

	-- Show any of the insurance companies that can be 'auto' billed by the insurance company with the BillSecondaryInsurance set to 1
	SELECT 
		IP.ClaimID,
		'Auto-bill payer ' + CAST(IP2.DisplayPrecedence AS VARCHAR) + ' - ' + ICP2.PlanName AS ASSIGNMENTNAME,
		'A' + CAST(IP2.InsurancePolicyID AS VARCHAR) AS ASSIGNMENTCODE,
		CAST(1 AS BIT) AS PAYMENTOPTION,
		CAST(1 AS BIT) AS ADJUSTMENTOPTION,
		CAST(0 AS BIT) AS VOIDOPTION,
		CASE
			WHEN IP2.InsurancePolicyID = CA.InsurancePolicyID THEN CAST(0 AS BIT)
			ELSE CAST(1 AS BIT)
		END AS TRANSFEROPTION,
		CAST(0 AS BIT) AS REBILLOPTION,
		CAST(0 AS BIT) AS SETTLEOPTION, 
		CAST(1000 + IP2.DisplayPrecedence AS INT) AS SortOrder
	FROM 		#TInsurancePolicy IP
	LEFT JOIN	dbo.ClaimAccounting_Assignments CA
	ON	   	   CA.ClaimID = IP.ClaimID
	AND	   	   CA.LastAssignment = 1
	INNER JOIN	dbo.InsurancePolicy CurIP	-- Used to make sure the curently assigned policy is even set to autobill
	ON		   CurIP.InsurancePolicyID = CA.InsurancePolicyID
	INNER JOIN	dbo.InsuranceCompanyPlan CurICP
	ON		   CurICP.InsuranceCompanyPlanID = CurIP.InsuranceCompanyPlanID
	INNER JOIN	dbo.InsuranceCompany CurIC
	ON		   CurIC.InsuranceCompanyID = CurICP.InsuranceCompanyID
	AND		   CurIC.BillSecondaryInsurance = 1
	INNER JOIN	dbo.InsuranceCompanyPlan ICP
	ON		   ICP.InsuranceCompanyPlanID = IP.InsuranceCompanyPlanID
	INNER JOIN	dbo.InsuranceCompany IC
	ON		   IC.InsuranceCompanyID = ICP.InsuranceCompanyID
	AND		   IC.BillSecondaryInsurance = 1
	INNER JOIN	#TInsurancePolicy IP2
	ON		   IP2.PatientCaseID = IP.PatientCaseID
	AND		   IP2.InsurancePolicyID <> CA.InsurancePolicyID
	AND		   IP2.DisplayPrecedence > IP.DisplayPrecedence
	INNER JOIN	dbo.InsuranceCompanyPlan ICP2
	ON		   ICP2.InsuranceCompanyPlanID = IP2.InsuranceCompanyPlanID
	GROUP BY	IP.ClaimID,
			IP2.DisplayPrecedence,
			ICP2.PlanName,
			IP2.InsurancePolicyID,
			CA.InsurancePolicyID
	ORDER BY	SortOrder

	DROP TABLE #TClaim
	DROP TABLE #TInsurancePolicy
END
