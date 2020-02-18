SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



-- EXEC BillDataProvider_CreateHCFABatch_Test @Practice_ID = 86

--===========================================================================
-- ALTER  HCFA BATCH
--===========================================================================
ALTER  PROCEDURE dbo.BillDataProvider_CreateHCFABatch
	@practice_id INT,
	@PatientID INT=NULL,
	@PayerScenarioID INT=NULL,
	@InsuranceCompanyID INT=NULL,
	@ClaimID INT=NULL
AS
BEGIN
	--Create the main batch record.
	
	--@UniqueSeed will be used to enforce uniqueness of temp batch IDs in the calculated batches
	--this procedure creates
	DECLARE @UniqueSeed INT
	SET @UniqueSeed=10000

	DECLARE @DocumentBatchID INT
	DECLARE @CurrentDate DATETIME
	SET @CurrentDate=GETDATE()

	DECLARE @SpecificClaimStatus CHAR(1)

	IF @ClaimID IS NOT NULL
	BEGIN
		SELECT @SpecificClaimStatus=ClaimStatusCode
		FROM Claim
		WHERE ClaimID=@ClaimID
	END

	INSERT	DocumentBatch (PracticeID, BusinessRuleProcessingTypeID, CreatedDate)
	VALUES	(@practice_id, 1, @CurrentDate)

	SET @DocumentBatchID= SCOPE_IDENTITY()

	--get those claims that are currently open and are assigned to insurance
	CREATE TABLE #CurrentAssignedToInsurance(ClaimID INT, InsurancePolicyID INT)
	INSERT INTO #CurrentAssignedToInsurance(ClaimID, InsurancePolicyID)
	SELECT ClaimID, InsurancePolicyID
	FROM ClaimAccounting_Assignments 
	WHERE PracticeID=@practice_id AND Status=0 AND InsurancePolicyID IS NOT NULL AND LastAssignment=1

	--get those claims that are currently open and assigned to patient
	CREATE TABLE #CurrentAssignedToPatient(ClaimID INT)
	INSERT INTO #CurrentAssignedToPatient(ClaimID)
	SELECT ClaimID
	FROM ClaimAccounting_Assignments
	WHERE PracticeID=@practice_id AND Status=0 AND InsurancePolicyID IS NULL AND LastAssignment=1

	DECLARE @PatientAssignedPrevToIns TABLE(ClaimID INT)
	INSERT @PatientAssignedPrevToIns(ClaimID)
	SELECT DISTINCT CAA.ClaimID
	FROM ClaimAccounting_Assignments CAA INNER JOIN #CurrentAssignedToPatient CATP
	ON CAA.ClaimID=CATP.ClaimID
	WHERE CAA.InsurancePolicyID IS NOT NULL

	DELETE CATP
	FROM #CurrentAssignedToPatient CATP INNER JOIN @PatientAssignedPrevToIns PAPTI
	ON CATP.ClaimID=PAPTI.ClaimID
	
	--Get relevant info for batching claims into bill and further refine to only process those
	--claims assigned to insurance and in a ready state
	--This code also gets the currently assigned insurance and determines the Secondary insurance to 
	--to list on HCFA form based on the following criteria
	--IF currently assigned insurance precedence is 1 then secondary insurance should have the next
	--greater precedence, otherwise seconday insurance is actually a reference to the previously billed
	--insurance if it is not the current primary
	CREATE TABLE #AssessAndBatch(ClaimID INT, EncounterID INT, EncounterProcedureID INT, PatientCaseID INT, LocalUseData VARCHAR(40), PrimaryInsuranceID INT,
				    SecondaryPrecedence INT, PayerScenarioID INT, ReferringPhysicianID INT, PatientID INT, ProcedureCodeDictionaryID INT,
				    LocationID INT, DoctorID INT, InsurancePolicyAuthorizationID INT, BillingFormID INT, ProcedureModifier1 VARCHAR(16),
				    ProcedureModifier2 VARCHAR(16), ProcedureModifier3 VARCHAR(16), ProcedureModifier4 VARCHAR(16), AssignedInsurance INT)

	IF @SpecificClaimStatus='P'
	BEGIN
		INSERT INTO #AssessAndBatch(ClaimID, EncounterID, EncounterProcedureID, PatientCaseID, LocalUseData, PrimaryInsuranceID, SecondaryPrecedence,
					   PayerScenarioID, ReferringPhysicianID, PatientID, ProcedureCodeDictionaryID, LocationID, DoctorID, InsurancePolicyAuthorizationID, BillingFormID,
					   ProcedureModifier1, ProcedureModifier2, ProcedureModifier3, ProcedureModifier4, AssignedInsurance)
		SELECT C.ClaimID, E.EncounterID, EP.EncounterProcedureID, E.PatientCaseID, COALESCE(E.Box19, '0') LocalUseData, CATI.InsurancePolicyID PrimaryInsuranceID,
		CASE WHEN IP.Precedence=1 
			THEN dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(E.PatientCaseID,EP.ProcedureDateOfService,IP.Precedence)
			ELSE dbo.fn_InsuranceDataProvider_GetPrevInsurancePolicyPrecedence(E.PatientCaseID, EP.ProcedureDateOfService, IP.Precedence) END SecondaryPrecedence,
		PC.PayerScenarioID, E.ReferringPhysicianID, PC.PatientID, EP.ProcedureCodeDictionaryID, ISNULL(E.LocationID,0) LocationID, ISNULL(E.DoctorID,0) DoctorID,
		ISNULL(E.InsurancePolicyAuthorizationID,0) InsurancePolicyAuthorizationID, IC.BillingFormID,
		ProcedureModifier1, ProcedureModifier2, ProcedureModifier3, ProcedureModifier4, IC.InsuranceCompanyID AssignedInsurance
		FROM Claim C INNER JOIN #CurrentAssignedToInsurance CATI ON C.ClaimID=CATI.ClaimID
		INNER JOIN EncounterProcedure EP ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN Encounter E ON EP.PracticeID=E.PracticeID AND EP.EncounterID=E.EncounterID
		INNER JOIN InsurancePolicy IP ON @practice_id=IP.PracticeID AND CATI.InsurancePolicyID=IP.InsurancePolicyID
		INNER JOIN InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
		INNER JOIN InsuranceCompany IC ON ICP.InsuranceCompanyID=IC.InsuranceCompanyID
		INNER JOIN PatientCase PC ON E.PatientCaseID=PC.PatientCaseID
		WHERE C.PracticeID=@practice_id AND C.ClaimID=@ClaimID AND ClaimStatusCode='P'
	END
	ELSE
	BEGIN

		INSERT INTO #AssessAndBatch(ClaimID, EncounterID, EncounterProcedureID, PatientCaseID, LocalUseData, PrimaryInsuranceID, SecondaryPrecedence,
					   PayerScenarioID, ReferringPhysicianID, PatientID, ProcedureCodeDictionaryID, LocationID, DoctorID, InsurancePolicyAuthorizationID, BillingFormID,
					   ProcedureModifier1, ProcedureModifier2, ProcedureModifier3, ProcedureModifier4, AssignedInsurance)
		SELECT C.ClaimID, E.EncounterID, EP.EncounterProcedureID, E.PatientCaseID, COALESCE(E.Box19, '0') LocalUseData, CATI.InsurancePolicyID PrimaryInsuranceID,
		CASE WHEN IP.Precedence=1 
			THEN dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(E.PatientCaseID,EP.ProcedureDateOfService,IP.Precedence)
			ELSE dbo.fn_InsuranceDataProvider_GetPrevInsurancePolicyPrecedence(E.PatientCaseID, EP.ProcedureDateOfService, IP.Precedence) END SecondaryPrecedence,
		PC.PayerScenarioID, E.ReferringPhysicianID, PC.PatientID, EP.ProcedureCodeDictionaryID, ISNULL(E.LocationID,0) LocationID, ISNULL(E.DoctorID,0) DoctorID,
		ISNULL(E.InsurancePolicyAuthorizationID,0) InsurancePolicyAuthorizationID, 
		CASE WHEN IP.Precedence=1 THEN IC.BillingFormID ELSE IC.SecondaryPrecedenceBillingFormID END,
		ProcedureModifier1, ProcedureModifier2, ProcedureModifier3, ProcedureModifier4, IC.InsuranceCompanyID AssignedInsurance
		FROM Claim C INNER JOIN #CurrentAssignedToInsurance CATI ON C.ClaimID=CATI.ClaimID
		INNER JOIN EncounterProcedure EP ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN Encounter E ON EP.PracticeID=E.PracticeID AND EP.EncounterID=E.EncounterID
		INNER JOIN InsurancePolicy IP ON @practice_id=IP.PracticeID AND CATI.InsurancePolicyID=IP.InsurancePolicyID
		INNER JOIN InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
		INNER JOIN InsuranceCompany IC ON ICP.InsuranceCompanyID=IC.InsuranceCompanyID
		INNER JOIN PatientCase PC ON E.PatientCaseID=PC.PatientCaseID
		WHERE C.PracticeID=@practice_id AND ClaimStatusCode='R' 
		AND (@ClaimID IS NULL OR C.CLaimID=@ClaimID)
		AND (@PatientID IS NULL OR C.PatientID=@PatientID) 
		AND (@PayerScenarioID IS NULL OR PC.PayerScenarioID=@PayerScenarioID)
		AND (@InsuranceCompanyID IS NULL OR IC.InsuranceCompanyID=@InsuranceCompanyID)

		--The following inserts are for claims whose PatientCase has no assigned insurance
		INSERT INTO #AssessAndBatch(ClaimID, EncounterID, EncounterProcedureID, PatientCaseID, LocalUseData, PrimaryInsuranceID, SecondaryPrecedence,
					   PayerScenarioID, ReferringPhysicianID, PatientID, ProcedureCodeDictionaryID, LocationID, DoctorID, InsurancePolicyAuthorizationID, BillingFormID,
					   ProcedureModifier1, ProcedureModifier2, ProcedureModifier3, ProcedureModifier4, AssignedInsurance)
		SELECT C.ClaimID, E.EncounterID, EP.EncounterProcedureID, E.PatientCaseID, COALESCE(E.Box19, '0') LocalUseData, -1 PrimaryInsuranceID, -1 SecondaryPrecedence,
                PC.PayerScenarioID, E.ReferringPhysicianID, PC.PatientID, EP.ProcedureCodeDictionaryID, ISNULL(E.LocationID,0) LocationID, ISNULL(E.DoctorID,0) DoctorID,
		ISNULL(E.InsurancePolicyAuthorizationID,0) InsurancePolicyAuthorizationID, 1, --Hard Coded Default so these claims get processed as standard HCFA for grouping purposes
		ProcedureModifier1, ProcedureModifier2, ProcedureModifier3, ProcedureModifier4, -1 AssignedInsurance
		FROM Claim C INNER JOIN #CurrentAssignedToPatient CATP ON C.ClaimID=CATP.ClaimID
		INNER JOIN EncounterProcedure EP ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN Encounter E ON EP.PracticeID=E.PracticeID AND EP.EncounterID=E.EncounterID
		INNER JOIN PatientCase PC ON E.PatientCaseID=PC.PatientCaseID
		WHERE C.PracticeID=@practice_id AND ClaimStatusCode='R'		
		AND (@ClaimID IS NULL OR C.CLaimID=@ClaimID)
		AND (@PatientID IS NULL OR C.PatientID=@PatientID) 
		AND (@PayerScenarioID IS NULL OR PC.PayerScenarioID=@PayerScenarioID)
		
	END
	
	--The final data set that will be used to calculate the bills to create for the batch
	CREATE TABLE #ClaimBatch(ClaimID INT, PatientID INT, PatientCaseID INT, EncounterID INT, LocalUseData VARCHAR(40), PrimaryInsuranceID INT, SecondaryInsuranceID INT, LocationID INT, DoctorID INT, InsurancePolicyAuthorizationID INT,
				 BillingFormID INT)
	INSERT INTO #ClaimBatch(ClaimID, PatientID, PatientCaseID, EncounterID, LocalUseData, PrimaryInsuranceID, SecondaryInsuranceID, LocationID, DoctorID, InsurancePolicyAuthorizationID, BillingFormID)
	SELECT ClaimID, AAB.PatientID, AAB.PatientCaseID, EncounterID, LocalUseData, PrimaryInsuranceID, ISNULL(IP.InsurancePolicyID, SecondaryPrecedence) SecondaryInsuranceID, LocationID, DoctorID, InsurancePolicyAuthorizationID, BillingFormID
	FROM #AssessAndBatch AAB LEFT JOIN InsurancePolicy IP ON @practice_id=IP.PracticeID AND AAB.PatientCaseID=IP.PatientCaseiD
	AND AAB.SecondaryPrecedence=IP.Precedence
	ORDER BY EncounterID, EncounterProcedureID

	CREATE TABLE #DefaultPrintForms(BusinessRuleID INT IDENTITY(1,1), BillingFormID INT, PrintingFormID INT, MaxProcedures INT, MaxDiagnosis INT)
	INSERT INTO #DefaultPrintForms(BillingFormID, PrintingFormID, MaxProcedures, MaxDiagnosis)
	SELECT DISTINCT CB.BillingFormID, PrintingFormID, MaxProcedures, MaxDiagnosis
	FROM #ClaimBatch CB INNER JOIN BillingForm BF
	ON CB.BillingFormID=BF.BillingFormID
	
	--Fetch claims' diagnoses into temp tample
	SELECT
		CB.ClaimID, DiagnosisCode
	INTO 
		#ClaimBatchDiagnoses
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.PracticeID=ED.PracticeID AND EP.EncounterDiagnosisID1=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID
		WHERE C.PracticeID=@practice_id

	UNION

	SELECT
		CB.ClaimID, DiagnosisCode
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.PracticeID=ED.PracticeID AND EP.EncounterDiagnosisID2=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID
		WHERE C.PracticeID=@practice_id

	UNION

	SELECT
		CB.ClaimID, DiagnosisCode
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.PracticeID=ED.PracticeID AND EP.EncounterDiagnosisID3=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID
		WHERE C.PracticeID=@practice_id


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.PracticeID=ED.PracticeID AND EP.EncounterDiagnosisID4=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID
		WHERE C.PracticeID=@practice_id
	ORDER BY CB.ClaimID

	--Create tables for use in applying business rules
	CREATE TABLE #CompareInfo(ClaimID INT, PayerScenarioID INT, ProcedureCode VARCHAR(16), ReferringPhysicianID INT, State VARCHAR(2), 
				  ProcedureModifier1 VARCHAR(16), ProcedureModifier2 VARCHAR(16), ProcedureModifier3 VARCHAR(16), ProcedureModifier4 VARCHAR(16), AssignedInsurance INT)
	CREATE TABLE #t_ruleresults(ID INT, BusinessRuleID INT)
	CREATE TABLE #t_idandforms(TID INT IDENTITY(1,1), ID INT, PrintingFormID INT, PrintingFormRecipientID INT, Type VARCHAR(50), BusinessRuleID INT)

	INSERT INTO #CompareInfo(ClaimID, PayerScenarioID, ProcedureCode, ReferringPhysicianID, State, ProcedureModifier1, ProcedureModifier2, ProcedureModifier3, ProcedureModifier4, AssignedInsurance)
	SELECT ClaimID, PayerScenarioID, PCD.ProcedureCode, AAB.ReferringPhysicianID, P.State, AAB.ProcedureModifier1, AAB.ProcedureModifier2, AAB.ProcedureModifier3, AAB.ProcedureModifier4, AAB.AssignedInsurance
	FROM #AssessAndBatch AAB INNER JOIN ProcedureCodeDictionary PCD
	ON AAB.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
	INNER JOIN Patient P
	ON AAB.PatientID=P.PatientID

	EXEC BusinessRuleEngine_DetermineClaimBusinessRulesAndActions @practice_id

	--Delete any claims which did not meet any rules (not even the defaults)
	DELETE CB
	FROM #ClaimBatch CB LEFT JOIN #t_ruleresults t
	ON CB.ClaimID=t.ID
	WHERE t.ID IS NULL

	CREATE TABLE #FormOrder(FID INT IDENTITY(1,1), BusinessRuleID INT, PrintingFormID INT, Type VARCHAR(50), MTID INT)
	INSERT INTO #FormOrder(BusinessRuleID, PrintingFormID, Type, MTID)
	SELECT BusinessRuleID, PrintingFormID, ISNULL(Type,'') Type, MIN(TID)
	FROM #t_idandforms
	GROUP BY BusinessRuleID, PrintingFormID, ISNULL(Type,'')

	CREATE TABLE #RecipientOrder(RID INT IDENTITY(1,1), BusinessRuleID INT, PrintingFormRecipientID INT, MTID INT)
	INSERT INTO #RecipientOrder(BusinessRuleID, PrintingFormRecipientID, MTID)
	SELECT BusinessRuleID, PrintingFormRecipientID, MIN(TID)
	FROM #t_idandforms
	GROUP BY BusinessRuleID, PrintingFormRecipientID

	CREATE TABLE #DistinctActions(BusinessRuleID INT, PrintingFormRecipientID INT, PrintingFormID INT, Type VARCHAR(50))
	INSERT INTO #DistinctActions(BusinessRuleID, PrintingFormRecipientID, PrintingFormID, Type)
	SELECT DISTINCT  BusinessRuleID, PrintingFormRecipientID, PrintingFormID, Type
	FROM #t_idandforms

	CREATE TABLE #DistinctActionsOrdered(OID INT IDENTITY(1,1),BusinessRuleID INT, PrintingFormRecipientID INT, PrintingFormID INT, Type VARCHAR(50))
	INSERT INTO #DistinctActionsOrdered(BusinessRuleID, PrintingFormRecipientID, PrintingFormID, Type)
	SELECT DA.BusinessRuleID, DA.PrintingFormRecipientID, DA.PrintingFormID, DA.Type
	FROM #DistinctActions DA INNER JOIN #FormOrder FO
	ON DA.BusinessRuleID=FO.BusinessRuleID AND DA.PrintingFormID=FO.PrintingFormID
	AND DA.Type=FO.Type
	INNER JOIN #RecipientOrder RO
	ON DA.BusinessRuleID=RO.BusinessRuleID AND DA.PrintingFormRecipientID=RO.PrintingFormRecipientID
	LEFT JOIN BusinessRule BR
	ON DA.BusinessRuleID=BR.BusinessRuleID
	ORDER BY ISNULL(BR.SortOrder,0), DA.BusinessRuleID, RO.MTID, FO.MTID

	DECLARE @DefaultBusinessRuleID INT
	DECLARE @DefaultBRPrintingFormRecipientID INT
	DECLARE @DefaultBRType VARCHAR(50)
	DECLARE @DefaultBRRuleSort INT

	SELECT @DefaultBusinessRuleID=BusinessRuleID, @DefaultBRPrintingFormRecipientID=PrintingFormRecipientID,
	@DefaultBRType=Type, @DefaultBRRuleSort=OID
	FROM #DistinctActionsOrdered
	WHERE PrintingFormID=99999

	INSERT INTO DocumentBatch_RuleActions(DocumentBatchID, BusinessRuleID, PrintingFormRecipientID, PrintingFormID, Type, RuleSort)	
	SELECT @DocumentBatchID, BusinessRuleID*-1, @DefaultBRPrintingFormRecipientID, PrintingFormID,
	@DefaultBRType, @DefaultBRRuleSort
	FROM #DefaultPrintForms
	WHERE @DefaultBusinessRuleID > 0

	--Update IDs to match generated default businessrules
	UPDATE t SET BusinessRuleID=DPF.BusinessRuleID*-1
	FROM #t_ruleresults t INNER JOIN #ClaimBatch CB
	ON t.ID=CB.ClaimID
	INNER JOIN #DefaultPrintForms DPF
	ON CB.BillingFormID=DPF.BillingFormID
	WHERE t.BusinessRuleID=@DefaultBusinessRuleID
	

	--Associate specific business rule actions to Document Batch
	INSERT INTO DocumentBatch_RuleActions(DocumentBatchID, BusinessRuleID, PrintingFormRecipientID, PrintingFormID, Type, RuleSort)
	SELECT @DocumentBatchID, DA.BusinessRuleID, DA.PrintingFormRecipientID, DA.PrintingFormID, DA.Type, DA.OID
	FROM #DistinctActionsOrdered DA
	WHERE DA.PrintingFormID<>99999
	ORDER BY OID

	--Get all the relevant data upon which claims are determined to be related for billing
	CREATE TABLE #BillData(ClaimID INT, PrimaryInsuranceID INT, SecondaryInsuranceID INT, PatientID INT, LocationID INT,
			       DoctorID INT, InsurancePolicyAuthorizationID INT, LocalUseData VARCHAR(40), PatientCaseID INT, DPFGrouping INT, EncounterID INT)
	INSERT INTO #BillData(ClaimID, PrimaryInsuranceID, SecondaryInsuranceID, PatientID, LocationID, DoctorID, InsurancePolicyAuthorizationID, LocalUseData, PatientCaseID, DPFGrouping, EncounterID)
	SELECT ClaimID, PrimaryInsuranceID, ISNULL(SecondaryInsuranceID,0) SecondaryInsuranceID, PatientID, LocationID, DoctorID, InsurancePolicyAuthorizationID, LocalUseData, PatientCaseID, DPF.BusinessRuleID, -- default for BGroupID
	EncounterID
	FROM #ClaimBatch CB INNER JOIN #DefaultPrintForms DPF
	ON CB.BillingFormID=DPF.BillingFormID

	--Group all values except for the ClaimID for each patient to determine the grouping of individual
	--claims into bills that can be performed
	CREATE TABLE #DocumentTemplates(DocumentTemplateID INT IDENTITY(1,1), PrimaryInsuranceID INT, SecondaryInsuranceID INT, PatientID INT, LocationID INT,
			       DoctorID INT, PatientCaseID INT, InsurancePolicyAuthorizationID INT, LocalUseData VARCHAR(40), EncounterID INT, MatchingItems INT, DocumentID INT)
	INSERT INTO #DocumentTemplates(PrimaryInsuranceID, SecondaryInsuranceID, PatientID, LocationID, DoctorID, PatientCaseID,
			      InsurancePolicyAuthorizationID, LocalUseData, EncounterID, MatchingItems)
	SELECT PrimaryInsuranceID, SecondaryInsuranceID, PatientID, LocationID, DoctorID, PatientCaseID, 
			      InsurancePolicyAuthorizationID, LocalUseData, EncounterID, COUNT(ClaimID) MatchingItems
	FROM #BillData
	GROUP BY PrimaryInsuranceID, SecondaryInsuranceID, PatientID, LocationID, DoctorID, PatientCaseID, 
			      InsurancePolicyAuthorizationID, LocalUseData, EncounterID

	--Insert new DocumentBatch Documents
	INSERT INTO Document(PatientID, DocumentBatchID, PracticeID, InternalDocumentTemplateID)
	SELECT DISTINCT PatientID, @DocumentBatchID, @practice_id, DocumentTemplateID
	FROM #DocumentTemplates

	--Match the new temporary bill IDs (BillTemplateID) with each ClaimID
	--This list will be used to determine how many claims will be in a bill
	CREATE TABLE #BillClaims(BillTemplateID INT, ClaimID INT, DPFGrouping INT)
	INSERT INTO #BillClaims(BillTemplateID, ClaimID, DPFGrouping)
	SELECT DocumentTemplateID, ClaimID, DPFGrouping
	FROM #DocumentTemplates BT INNER JOIN #BillData BD 
	ON BT.PrimaryInsuranceID=BD.PrimaryInsuranceID AND BT.SecondaryInsuranceID=BD.SecondaryInsuranceID AND BT.PatientID=BD.PatientID AND BT.LocationID=BD.LocationID
	AND BT.DoctorID=BD.DoctorID AND BT.PatientCaseID=BD.PatientCaseID AND BT.InsurancePolicyAuthorizationID=BD.InsurancePolicyAuthorizationID
	AND BT.LocalUseData=BD.LocalUseData AND BT.EncounterID=BD.EncounterID

	--This table will be used to later rematch bills and Documents
	CREATE TABLE #DocumentClaims(DocumentTemplateID INT, ClaimID INT, DPFGrouping INT)
	INSERT INTO #DocumentClaims(DocumentTemplateID, ClaimID, DPFGrouping)
	SELECT BillTemplateID, ClaimID, DPFGrouping
	FROM #BillClaims

	--Match the new temporary bill IDs (BillTemplateID) with each Claims DiagnosisCode
	--This list will be used to determine how many claims will be in a bill
	CREATE TABLE #BillTemplateDiagnoses(BillTemplateID INT, ClaimID INT, DiagnosisCode VARCHAR(16), DPFGrouping INT)
	INSERT INTO #BillTemplateDiagnoses(BillTemplateID, ClaimID, DiagnosisCode, DPFGrouping)
	SELECT BillTemplateID, BC.ClaimID, DiagnosisCode, DPFGrouping
	FROM #BillClaims BC LEFT JOIN #ClaimBatchDiagnoses CBD 
	ON BC.ClaimID=CBD.ClaimID
	ORDER BY BillTemplateID, BC.ClaimID

	--@Rows will hold the count of claims that still need to be assigned to a bill
	--@RowsDiagnoses will hold the count of diagnoses yet to be assigned
	DECLARE @Rows INT
	DECLARE @RowsDiagnoses INT

	--@CycleCount will be used as a multiplier in spawning new temporary Bill IDs
	DECLARE @CycleCount INT
	SET @CycleCount=0

	CREATE TABLE #BillSets(BillTemplateID INT, ClaimID INT, BillID INT)

	DECLARE @FormsLoop INT
	DECLARE @FormsCount INT
	DECLARE @MaxProcedures INT
	DECLARE @MaxDiagnosis INT

	SELECT @FormsLoop=COUNT(BusinessRuleID)
	FROM #DefaultPrintForms
	
	SET @FormsCount=0

	WHILE @FormsCount<@FormsLoop
	BEGIN
		SET @FormsCount=@FormsCount+1		

		SELECT @MaxProcedures=MaxProcedures, @MaxDiagnosis=MaxDiagnosis
		FROM #DefaultPrintForms
		WHERE BusinessRuleID=@FormsCount

		--Adds a bill item count to all outstanding claims not yet assigned to a temporary bill
		CREATE TABLE #BillItems(BillTemplateID INT, ClaimID INT, ItemCount INT)
		INSERT INTO #BillItems(BillTemplateID, ClaimID, ItemCount)
		SELECT BC2.BillTemplateID, BC2.ClaimID, CASE WHEN COUNT(BC.ClaimID)>@MaxProcedures THEN 0 ELSE COUNT(BC.ClaimID) END ItemCount
		FROM #BillClaims BC INNER JOIN #BillClaims BC2
		ON BC.BillTemplateID=BC2.BillTemplateID AND BC.ClaimID<=BC2.ClaimID
		WHERE BC2.DPFGrouping=@FormsCount
		GROUP BY BC2.BillTemplateID, BC2.ClaimID
		ORDER BY BC2.BillTemplateID, BC2.ClaimID
	
		SET @Rows=@@ROWCOUNT
	
		CREATE TABLE #BillItemsDiagnosisCount(BillTemplateID INT, ClaimID INT, DiagnosisCount INT)
		INSERT INTO #BillItemsDiagnosisCount(BillTemplateID, ClaimID, DiagnosisCount)
		SELECT BTD2.BillTemplateID, BTD2.ClaimID, COUNT(DISTINCT BTD.DiagnosisCode) DiagnosisCount
		FROM #BillTemplateDiagnoses BTD INNER JOIN #BillTemplateDiagnoses BTD2
		ON BTD.BillTemplateID=BTD2.BillTemplateID AND BTD.ClaimID<=BTD2.ClaimID
		WHERE BTD2.DPFGrouping=@FormsCount
		GROUP BY BTD2.BillTemplateID, BTD2.ClaimID
		ORDER BY BTD2.BillTemplateID, BTD2.ClaimID
		
		SET @RowsDiagnoses=@@ROWCOUNT		
	
		WHILE @Rows>0 AND @RowsDiagnoses>=0
		BEGIN			
	
			DELETE #BillItems WHERE ItemCount=0
	
			INSERT INTO #BillSets(BillTemplateID, ClaimID)
			SELECT BI.BillTemplateID+(@UniqueSeed*@CycleCount) BillTemplateID, BI.ClaimID
			FROM #BillItems BI INNER JOIN #BillItemsDiagnosisCount BIDC ON BI.BillTemplateID=BIDC.BillTemplateID
			AND BI.ClaimID=BIDC.ClaimID
			WHERE ItemCount<=@MaxProcedures AND DiagnosisCount<=@MaxDiagnosis
	
			DELETE BC
			FROM #BillClaims BC INNER JOIN #BillSets BS ON BC.ClaimID=BS.ClaimID
	
			DELETE BTC
			FROM #BillTemplateDiagnoses BTC INNER JOIN #BillSets BS ON BTC.ClaimID=BS.ClaimID
	
			DELETE #BillItems
			
			DELETE #BillItemsDiagnosisCount
	
			INSERT INTO #BillItems(BillTemplateID, ClaimID, ItemCount)
			SELECT BC2.BillTemplateID, BC2.ClaimID, CASE WHEN COUNT(BC.ClaimID)>@MaxProcedures THEN 0 ELSE COUNT(BC.ClaimID) END ItemCount
			FROM #BillClaims BC INNER JOIN #BillClaims BC2
			ON BC.BillTemplateID=BC2.BillTemplateID AND BC.ClaimID<=BC2.ClaimID
			WHERE BC2.DPFGrouping=@FormsCount
			GROUP BY BC2.BillTemplateID, BC2.ClaimID
			ORDER BY BC2.BillTemplateID, BC2.ClaimID
		
			SET @Rows=@@ROWCOUNT
	
			INSERT INTO #BillItemsDiagnosisCount(BillTemplateID, ClaimID, DiagnosisCount)
			SELECT BTD2.BillTemplateID, BTD2.ClaimID, COUNT(DISTINCT BTD.DiagnosisCode) DiagnosisCount
			FROM #BillTemplateDiagnoses BTD INNER JOIN #BillTemplateDiagnoses BTD2
			ON BTD.BillTemplateID=BTD2.BillTemplateID AND BTD.ClaimID<=BTD2.ClaimID
			WHERE BTD2.DPFGrouping=@FormsCount
			GROUP BY BTD2.BillTemplateID, BTD2.ClaimID
			ORDER BY BTD2.BillTemplateID, BTD2.ClaimID
	
			SET @RowsDiagnoses=@@ROWCOUNT
	
			SET @CycleCount=@CycleCount+1
			
		END
	
		DROP TABLE #BillItems
		DROP TABLE #BillItemsDiagnosisCount
	END

	CREATE TABLE #Bills(BillTemplateID INT, ClaimID INT, DocumentID INT, PayerInsurancePolicyID INT, OtherPayerInsurancePolicyID INT, BillID INT)
	INSERT INTO #Bills(BillTemplateID, ClaimID)
	SELECT BillTemplateID, MIN(ClaimID) ClaimID
	FROM #BillSets
	GROUP BY BillTemplateID

	UPDATE B SET PayerInsurancePolicyID=PrimaryInsuranceID, OtherPayerInsurancePolicyID=CASE WHEN SecondaryInsuranceID=0 THEN NULL ELSE SecondaryInsuranceID END
	FROM #Bills B INNER JOIN #ClaimBatch CB ON B.ClaimID=CB.ClaimID

	--Update the DocumentID with the InternalDocumentTemplateID 1st then the recently inserted
	--Document table DocumentID's
	UPDATE B SET DocumentID=DC.DocumentTemplateID
	FROM #Bills B INNER JOIN #DocumentClaims DC
	ON B.ClaimID=DC.ClaimID

	--now update to actual Document DocumentID's
	UPDATE B SET DocumentID=D.DocumentID
	FROM #Bills B INNER JOIN Document D
	ON B.DocumentID=D.InternalDocumentTemplateID
	WHERE DocumentBatchID=@DocumentBatchID

	INSERT INTO Document_HCFA(PracticeID, DocumentID, RepresentativeClaimID, PayerInsurancePolicyID, OtherPayerInsurancePolicyID)
	SELECT @practice_id, DocumentID, ClaimID RepresentativeClaimID, PayerInsurancePolicyID, OtherPayerInsurancePolicyID
	FROM #Bills

	UPDATE B SET BillID=DH.Document_HCFAID
	FROM #Bills B INNER JOIN Document_HCFA DH ON B.ClaimID=DH.RepresentativeClaimID
	AND B.DocumentID=DH.DocumentID

	UPDATE BS SET BillID=B.BillID
	FROM #BillSets BS INNER JOIN #Bills B ON BS.BillTemplateID=B.BillTemplateID

	INSERT INTO Document_HCFAClaim(PracticeID, Document_HCFAID, ClaimID)
	SELECT @practice_id, BillID, ClaimID
	FROM #BillSets

	INSERT INTO Document_BusinessRules(DocumentID, DocumentBatchID, BusinessRuleID)
	SELECT DISTINCT D.DocumentID, D.DocumentBatchID, ISNULL(BusinessRuleID,DPFGrouping*-1)
	FROM Document D INNER JOIN Document_HCFA DH
	ON D.DocumentID=DH.DocumentID
	INNER JOIN Document_HCFAClaim DHC
	ON DH.Document_HCFAID=DHC.Document_HCFAID
	LEFT JOIN #t_ruleresults t
	ON DHC.ClaimID=t.ID
	LEFT JOIN #DocumentClaims DC
	ON DHC.ClaimID=DC.ClaimID
	WHERE DocumentBatchID=@DocumentBatchID

	DROP TABLE #CurrentAssignedToInsurance
	DROP TABLE #CurrentAssignedToPatient
	DROP TABLE #AssessAndBatch
	DROP TABLE #ClaimBatch
	DROP TABLE #ClaimBatchDiagnoses
	DROP TABLE #BillData
	DROP TABLE #DocumentTemplates
	DROP TABLE #BillClaims
	DROP TABLE #BillTemplateDiagnoses
	DROP TABLE #BillSets
	DROP TABLE #Bills
	DROP TABLE #CompareInfo
	DROP TABLE #t_ruleresults
	DROP TABLE #t_idandforms
	DROP TABLE #DocumentClaims
	DROP TABLE #FormOrder
	DROP TABLE #RecipientOrder
	DROP TABLE #DistinctActions
	DROP TABLE #DistinctActionsOrdered
	DROP TABLE #DefaultPrintForms

	RETURN @DocumentBatchID
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

