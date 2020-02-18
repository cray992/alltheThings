--===========================================================================
-- 
-- BILL DATA PROVIDER
--
--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BillDataProvider_CreateEDIBatch'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.BillDataProvider_CreateEDIBatch
GO

-- BillDataProvider_CreateEDIBatch 1
--===========================================================================
-- CREATE EDI BATCH
--===========================================================================
CREATE PROCEDURE dbo.BillDataProvider_CreateEDIBatch
	@practice_id INT = NULL,
	@PatientID INT=NULL,
	@PayerScenarioID INT=NULL,
	@InsuranceCompanyID INT=NULL,
	@StartDate datetime=null,
	@EndDate datetime=null
AS
BEGIN

  BEGIN TRANSACTION
  BEGIN TRY

	SET @StartDate = dbo.fn_ReplaceTimeInDate(@StartDate)
	SET @EndDate = dbo.fn_ReplaceTimeInDate(@EndDate)

	DECLARE @max_diagnoses INT
	SET @max_diagnoses = 8			-- ANSI max 8 is good for all ANSI payers, see case 6795. A 4 is good for non-ansi

	DECLARE @max_claims INT
	SET @max_claims = 50

	DECLARE @payer_number VARCHAR(30)
	DECLARE @PayerResponsibilityCode CHAR(1)

	DECLARE @CustomerID INT
	SET @CustomerID = dbo.fn_GetCustomerID()
	
	--Create the main batch record.
	DECLARE @batch_id INT
	DECLARE @CurrentDate DATETIME
	SET @CurrentDate=GETDATE()

	IF COALESCE(@practice_id, 0) = 0 AND COALESCE(@PatientID, 0) <> 0
		SELECT @practice_id =  PracticeID FROM dbo.Patient AS P
		WHERE P.PatientID = @PatientID
		
	INSERT	BillBatch (PracticeID, BillBatchTypeCode, CreatedDate)
	VALUES	(@practice_id, 'E', @CurrentDate)

	SET @batch_id = SCOPE_IDENTITY()

	-- get a list of encounters where at least one claim is ready to go:
	CREATE TABLE #ReadyAssignedEncounter(EncounterID INT, InsurancePolicyID INT, SetPrecedence TINYINT, PayerNumber VARCHAR(30))

	INSERT INTO #ReadyAssignedEncounter(EncounterID, InsurancePolicyID, SetPrecedence, PayerNumber)
	SELECT E.EncounterID, IP.InsurancePolicyID, IP.Precedence, CPL.PayerNumber
	FROM	Claim C INNER JOIN ClaimAccounting_Assignments CAA
	ON C.PracticeID=CAA.PracticeID AND C.ClaimID=CAA.ClaimID AND CAA.InsurancePolicyID IS NOT NULL AND CAA.LastAssignment=1 AND CAA.Status=0
	LEFT OUTER JOIN VoidedClaims VC
	ON C.ClaimID=VC.ClaimID
	INNER JOIN EncounterProcedure EP
	ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
	INNER JOIN Encounter E
	ON EP.PracticeID=E.PracticeID AND EP.EncounterID=E.EncounterID
	INNER JOIN PatientCase PC
	ON E.PracticeID=PC.PracticeID AND E.PatientCaseID=PC.PatientCaseID
	INNER JOIN Practice Pr
	ON PC.PracticeID=Pr.PracticeID	
	INNER JOIN InsuranceCompanyPlan ICP
	ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	INNER JOIN InsuranceCompany IC
	ON ICP.InsuranceCompanyID=IC.InsuranceCompanyID
	INNER JOIN ClearingHousePayersList CPL
	ON IC.ClearingHousePayerID = CPL.ClearingHousePayerID
	LEFT JOIN PracticeToInsuranceCompany PTIC
	ON PTIC.PracticeID = PR.PracticeID AND PTIC.InsuranceCompanyID = IC.InsuranceCompanyID
	INNER JOIN InsurancePolicy IP
	ON IP.PracticeID = PC.PracticeID AND IP.InsurancePolicyID=CAA.InsurancePolicyID
				AND IP.Active = 1
				AND (IP.PolicyStartDate IS NULL OR IP.PolicyStartDate <= EP.ProcedureDateOfService)
				AND (IP.PolicyEndDate IS NULL OR IP.PolicyEndDate >= EP.ProcedureDateOfService)
	LEFT JOIN PatientCaseDate PHD
	ON PC.PracticeID=PHD.PracticeID AND PC.PatientCaseID=PHD.PatientCaseID AND PHD.PatientCaseDateTypeID=6	-- Hospitalization Related to Condition
	LEFT JOIN PatientCaseDate PAD
	ON PC.PracticeID=PAD.PracticeID AND PC.PatientCaseID=PAD.PatientCaseID AND PAD.PatientCaseDateTypeID=12	-- Accident Date (Auto and Other)
	WHERE	C.PracticeID = @practice_id
		AND VC.ClaimID IS NULL
		AND C.ClaimStatusCode = 'R'
		AND NOT (C.NonElectronicOverrideFlag = 1 OR E.DoNotSendElectronic = 1)
--		-- keep in mind that "all states" in the Auto Accident State dropdown corresponds to two spaces:
--		AND (PC.AutoAccidentRelatedFlag = 0
--			 OR (PAD.StartDate IS NOT NULL AND PC.AutoAccidentRelatedState IS NOT NULL AND LEN(REPLACE(PC.AutoAccidentRelatedState,' ','')) > 0))
--		AND (PC.OtherAccidentRelatedFlag = 0 OR PAD.StartDate IS NOT NULL)
-- per FB 22680 no longer check this here ... works OK
--		AND PC.EmploymentRelatedFlag = 0
-- per FB 22394 no longer check this here ... find it in validation
--		AND NOT (PHD.StartDate IS NULL 
--					AND E.HospitalizationStartDT IS NULL
--					AND E.PlaceOfServiceCode IN (21,51))
		AND PR.EClaimsEnrollmentStatusID > 1
		AND IC.EClaimsAccepts = 1 AND (PTIC.EClaimsDisable IS NULL OR PTIC.EClaimsDisable = 0)
		AND CPL.PayerNumber IS NOT NULL
		AND (CPL.IsEnrollmentRequired = 0 OR PTIC.EClaimsEnrollmentStatusID > 1) 
		AND (@PatientID IS NULL OR C.PatientID=@PatientID) 
		AND (@PayerScenarioID IS NULL OR PC.PayerScenarioID=@PayerScenarioID)
		AND (@InsuranceCompanyID IS NULL OR IC.InsuranceCompanyID=@InsuranceCompanyID)
		AND (@StartDate IS NULL OR EP.ProcedureDateOfService >= @StartDate)
		AND (@EndDate IS NULL OR EP.ProcedureDateOfService <= @EndDate)
	GROUP BY E.EncounterID, IP.InsurancePolicyID, IP.Precedence, CPL.PayerNumber

	-- exclude encounters that are assigned to more than one active insurance with ready claims in every insurance.
	-- if there are non-ready claims to be pulled in, those will be billed to insurance indicated by the ready claims set.
	DELETE #ReadyAssignedEncounter
	--SELECT *
	FROM #ReadyAssignedEncounter RAE
		LEFT JOIN
		(SELECT EncounterID, count(EncounterID) CNT FROM #ReadyAssignedEncounter GROUP BY EncounterID) FilteredRAE
		ON FilteredRAE.EncounterID = RAE.EncounterID
	WHERE FilteredRAE.CNT > 1

	-- get all claims related to selected encounters, independently of their last assignment (they can be settled):	
	CREATE TABLE #ReadyAssignedClaim(ClaimID INT, ClaimStatusCode char(1), PracticeID INT, EncounterID INT, EncounterProcedureID INT, PatientCaseID INT, PayerNumber VARCHAR(30),SetPrecedence TINYINT, 
								SupportsSecondary BIT, DOS DATETIME, InsurancePolicyID INT, ActiveInsurancePolicyID INT)

	INSERT INTO #ReadyAssignedClaim(ClaimID, ClaimStatusCode, PracticeID, EncounterID, EncounterProcedureID, PatientCaseID, PayerNumber,
										 SetPrecedence, SupportsSecondary, DOS, InsurancePolicyID, ActiveInsurancePolicyID)
	SELECT	DISTINCT C.ClaimID, C.ClaimStatusCode, C.PracticeID, E.EncounterID, EP.EncounterProcedureID, E.PatientCaseID, TE.PayerNumber, TE.SetPrecedence SetPrecedence,
	CASE WHEN (ISNULL(PTIC.UseSecondaryElectronicBilling, 0) = 1 AND ISNULL(CPL.SupportsSecondaryElectronicBilling, 0) = 1) THEN 1 ELSE 0 END SupportsSecondary,
	EP.ProcedureDateOfService DOS, TE.InsurancePolicyID, IP.InsurancePolicyID		
	FROM	Claim C INNER JOIN ClaimAccounting_Assignments CAA
		ON C.ClaimID=CAA.ClaimID AND CAA.InsurancePolicyID IS NOT NULL AND CAA.LastAssignment=1 AND CAA.Status=0
	LEFT OUTER JOIN VoidedClaims VC
		ON C.ClaimID=VC.ClaimID
	INNER JOIN EncounterProcedure EP
		ON C.EncounterProcedureID=EP.EncounterProcedureID
	INNER JOIN Encounter E
		ON EP.PracticeID=E.PracticeID AND EP.EncounterID=E.EncounterID
	INNER JOIN #ReadyAssignedEncounter TE
		ON TE.EncounterID=E.EncounterID
	INNER JOIN PatientCase PC
		ON E.PracticeID=PC.PracticeID AND E.PatientCaseID=PC.PatientCaseID
	INNER JOIN Practice Pr
		ON PC.PracticeID=Pr.PracticeID	
	INNER JOIN InsuranceCompanyPlan ICP
		ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	INNER JOIN InsuranceCompany IC
		ON ICP.InsuranceCompanyID=IC.InsuranceCompanyID
	INNER JOIN ClearingHousePayersList CPL
		ON IC.ClearingHousePayerID = CPL.ClearingHousePayerID
	LEFT JOIN PracticeToInsuranceCompany PTIC
		ON PTIC.PracticeID = PR.PracticeID AND PTIC.InsuranceCompanyID = IC.InsuranceCompanyID
	LEFT OUTER JOIN InsurancePolicy IP
		ON IP.PracticeID = PC.PracticeID AND IP.InsurancePolicyID=CAA.InsurancePolicyID
				AND IP.Active = 1
				AND (IP.PolicyStartDate IS NULL OR IP.PolicyStartDate <= EP.ProcedureDateOfService)
				AND (IP.PolicyEndDate IS NULL OR IP.PolicyEndDate >= EP.ProcedureDateOfService)
	LEFT JOIN PatientCaseDate PHD
		ON PC.PracticeID=PHD.PracticeID AND PC.PatientCaseID=PHD.PatientCaseID AND PHD.PatientCaseDateTypeID=6	-- Hospitalization Related to Condition
	LEFT JOIN PatientCaseDate PAD
		ON PC.PracticeID=PAD.PracticeID AND PC.PatientCaseID=PAD.PatientCaseID AND PAD.PatientCaseDateTypeID=12	-- Accident Date (Auto and Other)
	WHERE VC.ClaimID IS NULL AND C.NonElectronicOverrideFlag = 0 AND C.ClaimStatusCode = 'R'

	-- ok, we've got the claims - collect more info related to their policies precedence in a separate table:
	CREATE TABLE #PatientCasePrimaryPolicy(PatientCaseID INT, DOS DateTime, FirstPolicyPrecedence TINYINT, FirstPolicyInsurancePolicyID INT, PayerNumber VARCHAR(30), SecondaryPolicyPrecedence TINYINT, 
										   LastPolicyPrecedence TINYINT, ActivePolicyCount TINYINT)
	INSERT INTO #PatientCasePrimaryPolicy(PatientCaseID, DOS, FirstPolicyInsurancePolicyID, PayerNumber)
	SELECT DISTINCT RA.PatientCaseID, RA.DOS, RA.InsurancePolicyID, RA.PayerNumber
	FROM #ReadyAssignedClaim RA
	WHERE RA.ClaimStatusCode = 'R'	AND RA.ActiveInsurancePolicyID IS NOT NULL -- consider only ready claims with valid IP for purpose of insurance assignment

	-- compute precedence data based on each case
	CREATE TABLE #PatientCasePrimaryPolicy2(PatientCaseID INT, DOS DateTime, FirstPolicyPrecedence TINYINT, SecondaryPolicyPrecedence TINYINT, 
										   LastPolicyPrecedence TINYINT, ActivePolicyCount TINYINT)
	INSERT INTO #PatientCasePrimaryPolicy2(PatientCaseID, DOS, FirstPolicyPrecedence, SecondaryPolicyPrecedence, LastPolicyPrecedence, ActivePolicyCount)
	SELECT RA.PatientCaseID, RA.DOS, MIN(IP.Precedence) FirstPolicyPrecedence, 
	CASE WHEN MIN(IP.Precedence)=MIN(RA.SetPrecedence) THEN MIN(CASE WHEN IP.Precedence>RA.SetPrecedence THEN IP.Precedence ELSE NULL END)
		 WHEN MIN(IP.Precedence)<>MIN(RA.SetPrecedence) THEN MAX(CASE WHEN IP.Precedence<RA.SetPrecedence THEN IP.Precedence ELSE NULL END)
	ELSE NULL END SecondaryPolicyPrecedence, MAX(IP.Precedence), COUNT(DISTINCT IP.InsurancePolicyID)
	FROM #ReadyAssignedClaim RA
	INNER JOIN InsurancePolicy IP
	ON RA.PracticeID=IP.PracticeID AND RA.PatientCaseID=IP.PatientCaseID
		WHERE IP.Active = 1
		AND (IP.PolicyStartDate IS NULL OR IP.PolicyStartDate <= RA.DOS)
		AND (IP.PolicyEndDate IS NULL OR IP.PolicyEndDate >= RA.DOS)
	GROUP BY RA.PatientCaseID, RA.DOS

	-- fill precedence data
	UPDATE #PatientCasePrimaryPolicy
	SET FirstPolicyPrecedence = P2.FirstPolicyPrecedence, SecondaryPolicyPrecedence=P2.SecondaryPolicyPrecedence,
		 LastPolicyPrecedence=P2.LastPolicyPrecedence, ActivePolicyCount=P2.ActivePolicyCount
	FROM #PatientCasePrimaryPolicy P
	JOIN #PatientCasePrimaryPolicy2 P2 ON P2.PatientCaseID = P.PatientCaseID AND P2.DOS = P.DOS


	--now we can compile final list of claims:
	CREATE TABLE #ClaimBatch(ClaimID INT, EncounterID INT, PayerNumber VARCHAR(30), PayerInsurancePolicyID INT, OtherInsurancePolicyID INT)

	INSERT INTO #ClaimBatch(ClaimID, EncounterID, PayerNumber, PayerInsurancePolicyID, OtherInsurancePolicyID)
	SELECT RA.ClaimID, RA.EncounterID, PPP.PayerNumber, PPP.FirstPolicyInsurancePolicyID AS PayerInsurancePolicyID, IPS.InsurancePolicyID AS OtherInsurancePolicyID
	FROM #ReadyAssignedClaim RA INNER JOIN #PatientCasePrimaryPolicy PPP
	ON RA.PatientCaseID=PPP.PatientCaseID AND RA.DOS = PPP.DOS
	LEFT JOIN InsurancePolicy IPS
	ON PPP.PatientCaseID=IPS.PatientCaseID AND PPP.SecondaryPolicyPrecedence=IPS.Precedence
	WHERE RA.SetPrecedence IS NULL	-- include claims that were pulled in by association with encounter, and were not related to active policy
		 OR RA.SetPrecedence=PPP.FirstPolicyPrecedence
		 OR RA.SetPrecedence<>PPP.FirstPolicyPrecedence  AND RA.SupportsSecondary=1
	ORDER BY EncounterID, EncounterProcedureID


	--Fetch claims' diagnoses into temp table
	SELECT
		CB.ClaimID, DiagnosisCode
	INTO 
		#ClaimBatchDiagnoses
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID1=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID

	UNION

	SELECT
		CB.ClaimID, DiagnosisCode
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID2=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID3=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID4=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID5=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID6=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID7=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID8=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID

	--Process the selected claims.
	DECLARE @claim_id INT
	DECLARE @payerInsurancePolicyID INT
	DECLARE @otherInsurancePolicyID INT

	DECLARE @doSecondary BIT
	DECLARE @PayerSupportsSecondaryElectronicBilling BIT
	--DECLARE @PayerSupportsCoordinationOfBenefits BIT
	DECLARE @PracticeInsuranceUseSecondaryElectronicBilling BIT
	--DECLARE @PracticeInsuranceUseCoordinationOfBenefits BIT
	DECLARE @EncounterAllowsUseSecondaryElectronicBilling BIT
	
	DECLARE @BillIDs TABLE(BillID int)

	DECLARE claim_cursor CURSOR READ_ONLY
	FOR
		SELECT	ClaimID,
			PayerInsurancePolicyID,
			OtherInsurancePolicyID,
			PayerNumber
		FROM	#ClaimBatch

	OPEN claim_cursor

	FETCH NEXT FROM claim_cursor
	INTO	@claim_id,
		@payerInsurancePolicyID,
		@otherInsurancePolicyID,
		@payer_number

	WHILE (@@FETCH_STATUS = 0)
	BEGIN

		-- see case 6795 - some payers do not accept more than 4 diagnoses, especially when claims are passed through PAPER:
		IF (@payer_number IN ('BS085','MC053','41147','60054') AND NOT (@CustomerID = 2978 AND @payer_number='60054'))
		BEGIN
			SET @max_diagnoses = 4
		END
		ELSE
		BEGIN
			SET @max_diagnoses = 8
		END

		--Check for existing bill to add this to.
		DECLARE @bill_id INT
		SET @bill_id = (
			SELECT 	TOP 1 B.BillID
			FROM	Bill_EDI B
				INNER JOIN Claim C
				ON C.ClaimID = B.RepresentativeClaimID
				INNER JOIN EncounterProcedure EP 
				ON C.EncounterProcedureID=EP.EncounterProcedureID
				INNER JOIN Encounter E
				ON EP.EncounterID=E.EncounterID
				INNER JOIN Claim CC
				ON CC.ClaimID = @claim_id
				INNER JOIN EncounterProcedure EP2 
				ON CC.EncounterProcedureID=EP2.EncounterProcedureID
				INNER JOIN Encounter E2
				ON EP2.EncounterID=E2.EncounterID
			WHERE	B.BillBatchID = @batch_id
			AND	B.PayerInsurancePolicyID = @payerInsurancePolicyID
			AND	ISNULL(B.OtherPayerInsurancePolicyID,-1) = ISNULL(@otherInsurancePolicyID,-1)
			AND	E2.EncounterID = E.EncounterID		-- case 12553: require claims to be batched by Encounter
			AND	ISNULL(CC.LocalUseData,'') =
				ISNULL(C.LocalUseData,'')
			AND	@max_claims > (
					SELECT	COUNT(*)
					FROM	BillClaim BC
					WHERE	BC.BillID = B.BillID
					AND	BC.BillBatchTypeCode = 'E')
			AND	@max_diagnoses >= (
					SELECT	COUNT(DISTINCT CBD.DiagnosisCode)
					FROM	BillClaim BC
						INNER JOIN #ClaimBatchDiagnoses CBD
						ON	CBD.ClaimID = BC.ClaimID 
							OR CBD.ClaimID = @claim_id
					WHERE	BC.BillID = B.BillID
					AND	BC.BillBatchTypeCode = 'E' )
		)


		IF (@bill_id IS NULL)
		BEGIN
			-- no suitable bill in this batch, create a new one:

			-- see also PatientDataProvider_GetInsurancePoliciesForPatientCase -- it may be better way to deliver the same list as below

			CREATE TABLE #t_realPrecedence (RealPrecedence int identity(1,1), InsurancePolicyID int, StatedPrecedence int)

			INSERT #t_realPrecedence (InsurancePolicyID, StatedPrecedence)
			SELECT PI.InsurancePolicyID, PI.Precedence
			FROM Claim RC
				INNER JOIN dbo.EncounterProcedure EP
					ON EP.EncounterProcedureID = RC.EncounterProcedureID
				INNER JOIN dbo.Encounter E
					ON E.EncounterID = EP.EncounterID
				INNER JOIN PatientCase PC
					ON PC.PatientCaseID = E.PatientCaseID
				LEFT OUTER JOIN InsurancePolicy PI
					INNER JOIN InsuranceCompanyPlan IP
						ON IP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
				ON PI.PatientCaseID = PC.PatientCaseID AND PI.Active = 1
					 AND (PI.PolicyStartDate IS NULL OR PI.PolicyStartDate <= EP.ProcedureDateOfService)
					 AND (PI.PolicyEndDate IS NULL OR PI.PolicyEndDate >= EP.ProcedureDateOfService)
			WHERE RC.ClaimID = @claim_id
			ORDER BY PI.Precedence

			SELECT @EncounterAllowsUseSecondaryElectronicBilling = CASE WHEN isnull(E.DoNotSendElectronicSecondary,0) = 1 THEN 0 ELSE 1 END
			FROM Claim RC
				INNER JOIN dbo.EncounterProcedure EP
					ON EP.EncounterProcedureID = RC.EncounterProcedureID
				INNER JOIN dbo.Encounter E
					ON E.EncounterID = EP.EncounterID
			WHERE RC.ClaimID = @claim_id

			DECLARE @realPrecedence INT

			SELECT TOP 1 @realPrecedence = RPI.RealPrecedence
			FROM #t_realPrecedence RPI
			WHERE RPI.InsurancePolicyID = @payerInsurancePolicyID

			-- SELECT * from #t_realPrecedence

			DROP TABLE #t_realPrecedence

			-- PRINT '@realPrecedence=' + CAST(@realPrecedence AS varchar)

			SELECT
				@PayerSupportsSecondaryElectronicBilling = ISNULL(CPL.SupportsSecondaryElectronicBilling, 0),
				--@PayerSupportsCoordinationOfBenefits = ISNULL(CPL.SupportsCoordinationOfBenefits, 0),
				@PracticeInsuranceUseSecondaryElectronicBilling = ISNULL(PTIC.UseSecondaryElectronicBilling, 0)
				--@PracticeInsuranceUseCoordinationOfBenefits = ISNULL(PTIC.UseCoordinationOfBenefits, 0)
			FROM	
				InsurancePolicy PI
				INNER JOIN InsuranceCompanyPlan ICP
				ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
				INNER JOIN InsuranceCompany IC 
				ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
				INNER JOIN PatientCase PC
				ON PC.PatientCaseID = PI.PatientCaseID
				INNER JOIN Patient P
				ON P.PatientID = PC.PatientID
				LEFT OUTER JOIN ClearinghousePayersList CPL
				ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID
				LEFT OUTER JOIN PracticeToInsuranceCompany PTIC
				ON PTIC.PracticeID = P.PracticeID AND PTIC.InsuranceCompanyID = IC.InsuranceCompanyID
			WHERE PI.InsurancePolicyID = @payerInsurancePolicyID

			SET @doSecondary = CASE WHEN
				@PayerSupportsSecondaryElectronicBilling=1
		--		AND @PayerSupportsCoordinationOfBenefits=1
				AND @PracticeInsuranceUseSecondaryElectronicBilling=1
		--		AND @PracticeInsuranceUseCoordinationOfBenefits=1
				AND @EncounterAllowsUseSecondaryElectronicBilling=1
			THEN 1 ELSE 0 END

			-- if secondaries are not allowed, skip the bill creation
			IF (@realPrecedence = 1 OR @doSecondary = 1)
			BEGIN 
				-- see case 6269 - EClaims: add ability to handle Coordination of Benefits (COB):   
				-- CASE WHEN @otherInsurancePolicyID IS NULL THEN 'P' ELSE 'S' END
				-- CASE RPI.RealPrecedence WHEN 1 THEN 'P' WHEN 2 THEN 'S' WHEN 3 THEN 'T' WHEN 4 THEN 'A' WHEN 5 THEN 'B' WHEN 6 THEN 'C' WHEN 7 THEN 'D' ELSE 'E' END
				--SET @PayerResponsibilityCode = 'P'
				SET @PayerResponsibilityCode = CASE WHEN @doSecondary=1 THEN (CASE @realPrecedence WHEN 1 THEN 'P' WHEN 2 THEN 'S' WHEN 3 THEN 'T' ELSE 'T' END) ELSE 'P' END

				-- PRINT '@PayerResponsibilityCode=' + CAST(@PayerResponsibilityCode AS varchar)

				INSERT	Bill_EDI (
					BillBatchID,
					RepresentativeClaimID,
					PayerInsurancePolicyID,
					OtherPayerInsurancePolicyID,
					PayerResponsibilityCode)
				VALUES	(
					@batch_id,
					@claim_id,
					@payerInsurancePolicyID,
					@otherInsurancePolicyID,
					@PayerResponsibilityCode
					)
				
				SET @bill_id = SCOPE_IDENTITY()
			
				INSERT @BillIDs(BillID)
				VALUES (@bill_id)	

			END
		END

		IF (@bill_id IS NOT NULL)		-- can be still NULL if secondaries are not allowed
		BEGIN
			--Add the claim to the bill.
			INSERT	BillClaim (BillID, BillBatchTypeCode, ClaimID)
			VALUES	(@bill_id, 'E', @claim_id)
			
		END

		FETCH NEXT FROM claim_cursor
		INTO	@claim_id,
			@payerInsurancePolicyID,
			@otherInsurancePolicyID,
			@payer_number
	END
	
	CLOSE claim_cursor
	DEALLOCATE claim_cursor
	
	-- SELECT * FROM #ReadyAssignedEncounter
	DROP TABLE #ReadyAssignedEncounter

	-- SELECT * FROM #ReadyAssignedClaim
	DROP TABLE #ReadyAssignedClaim

	DROP TABLE #PatientCasePrimaryPolicy
	DROP TABLE #PatientCasePrimaryPolicy2
	DROP TABLE #ClaimBatch
	DROP TABLE #ClaimBatchDiagnoses

	COMMIT
	
	-- Have to submit these outside of the transaction scope otherwise we run into issues with the LINKED SERVER ('Transaction Context in use by another session')
	INSERT [SharedServer].[superbill_Shared].[dbo].[BizClaimsEDIBill] (
					CustomerID,
					BillID)
	SELECT @CustomerID, BillID
	FROM @BillIDs

	RETURN @batch_id

  END TRY

  BEGIN CATCH

	print 'Error: catch in BillDataProvider_CreateEDIBatch -- rolling back'
	print ERROR_MESSAGE()
	ROLLBACK TRANSACTION

  END CATCH

END
GO

