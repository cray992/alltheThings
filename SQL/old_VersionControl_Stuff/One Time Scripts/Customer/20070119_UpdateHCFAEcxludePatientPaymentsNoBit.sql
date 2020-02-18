--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_HCFABillTotalPatientPaidAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_HCFABillTotalPatientPaidAmount
GO

--===========================================================================
-- HCFA BILL TOTAL PATIENT PAID Amount
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_HCFABillTotalPatientPaidAmount (@bill_id INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @paid_amount MONEY
	SET @paid_amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimPatientReceiptAmount(ClaimID))
		FROM	Document_HCFAClaim
		WHERE	Document_HCFAID = @bill_id)

	RETURN COALESCE(@paid_amount, 0)
END
GO

--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_ClaimPatientReceiptAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_ClaimPatientReceiptAmount
GO

--===============================================================================
-- CLAIM PATIENT RECEIPT Amount
--===============================================================================
-- The total patient Amount of payments made against the charges for given claim.
--===============================================================================
CREATE FUNCTION dbo.BusinessRule_ClaimPatientReceiptAmount (@claim_id INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @patient_amount MONEY

	SET @patient_amount = (
		SELECT	SUM(COALESCE(CT.Amount,0))
		FROM	CLAIM C
			INNER JOIN CLAIMTRANSACTION CT
			ON CT.ClaimID = C.ClaimID AND CT.ClaimTransactionTypeCode = 'PAY'
			INNER JOIN Payment P
			ON CT.PaymentID = P.PaymentID AND P.PayerTypeCode = 'P'
		WHERE	C.ClaimID = @claim_id)

	RETURN COALESCE(@patient_amount, 0)
END
GO

--===========================================================================

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BillDataProvider_GetHCFAFormXml'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.BillDataProvider_GetHCFAFormXml
GO

--===========================================================================
-- GET HCFA FORM XML
-- BillDataProvider_GetHCFAFormXml 13, 179063,1,1
--===========================================================================
CREATE PROCEDURE [dbo].[BillDataProvider_GetHCFAFormXml]
	@PracticeID INT, 
	@document_hcfaid INT,
	@PrintingFormRecipientID INT,
	@RecordID INT

AS
BEGIN

	DECLARE @form_name varchar(32)
	SET	@form_name = 'CMS1500'

	DECLARE @result_id INT

	DECLARE @PatientCaseID INT
	DECLARE @DOS DATETIME
	DECLARE @RecipientInsurancePolicyID INT
	DECLARE @RecipientOtherInsurancePolicyID INT
	DECLARE @RecipientInsurancePrecedence INT
	DECLARE @InsuranceCompanyPlanID INT
	DECLARE @LocationID INT
	DECLARE @ProviderID INT

	SELECT	@PatientCaseID = E.PatientCaseID, 
			@DOS = E.DateOfService,
			@LocationID = E.LocationID,
			@ProviderID = E.DoctorID
	FROM	Document_HCFA DH 
			INNER JOIN Claim C
				ON DH.RepresentativeClaimID = C.ClaimID
			INNER JOIN EncounterProcedure EP
				ON C.EncounterProcedureID = EP.EncounterProcedureID
			INNER JOIN Encounter E
				ON EP.EncounterID = E.EncounterID
	WHERE	DH.Document_HCFAID = @Document_hcfaid

	DECLARE @FirstPrecedence INT
	DECLARE @NextPrecedence INT

	IF @PrintingFormRecipientID=2 OR @PrintingFormRecipientID=8
	OR @PrintingFormRecipientID=4 AND 
	EXISTS(SELECT * FROM PatientCaseToAttorney WHERE AttorneyID=@RecordID AND PatientCaseID=@PatientCaseID AND InsurancePolicyID IS NOT NULL)
	BEGIN

		IF @PrintingFormRecipientID=8 OR @PrintingFormRecipientID=2
		BEGIN
			SELECT @RecipientInsurancePolicyID=InsurancePolicyID
			FROM InsurancePolicy
			WHERE PatientCaseID=@PatientCaseID AND InsuranceCompanyPlanID=@RecordID
		END
		ELSE
		BEGIN
			SELECT @RecipientInsurancePolicyID=InsurancePolicyID
			FROM PatientCaseToAttorney
			WHERE PatientCaseID=@PatientCaseID AND AttorneyID=@RecordID
		END

		SELECT	@RecipientInsurancePrecedence = IP.Precedence,
				@InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
		FROM	InsurancePolicy IP
				INNER JOIN InsuranceCompanyPlan ICP
					ON ICP.InsuranceCompanyPlanID = IP.InsuranceCompanyPlanID
		WHERE	IP.InsurancePolicyID = @RecipientInsurancePolicyID

		SELECT @FirstPrecedence=dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(@PatientCaseID,@DOS,0)		
		SELECT @NextPrecedence=dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(@PatientCaseID,@DOS,@FirstPrecedence)		

		IF @RecipientInsurancePrecedence=@FirstPrecedence
		BEGIN
			SELECT @RecipientOtherInsurancePolicyID=InsurancePolicyID
			FROM InsurancePolicy
			WHERE PatientCaseID=@PatientCaseID 
			AND Precedence=@NextPrecedence
		END
		ELSE
		BEGIN
			SELECT @RecipientOtherInsurancePolicyID=InsurancePolicyID
			FROM InsurancePolicy
			WHERE PatientCaseID=@PatientCaseID 
			AND Precedence=@FirstPrecedence
		END
	END
	ELSE
	BEGIN
			SELECT @FirstPrecedence=dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(@PatientCaseID,@DOS,0)		
			SELECT @NextPrecedence=dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(@PatientCaseID,@DOS,@FirstPrecedence)	

			SELECT	@RecipientInsurancePolicyID = IP.InsurancePolicyID,
					@InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
			FROM	InsurancePolicy IP
					INNER JOIN InsuranceCompanyPlan ICP
						ON ICP.InsuranceCompanyPlanID = IP.InsuranceCompanyPlanID
			WHERE	IP.PatientCaseID = @PatientCaseID 
					AND IP.Precedence = @FirstPrecedence

			SELECT @RecipientOtherInsurancePolicyID=InsurancePolicyID
			FROM InsurancePolicy
			WHERE PatientCaseID=@PatientCaseID 
			AND Precedence=@NextPrecedence
	END

	----------------------------------------------------------------------------------------------
	-- Handle Box 25
	DECLARE @FederalTaxID varchar(32)
	DECLARE @FederalTaxIDType varchar(10)

	SELECT	@FederalTaxID = FederalTaxID,
			@FederalTaxIDType = FederalTaxIDType 
	FROM	dbo.fn_BillDataProvider_GetFederalTaxIDForHCFA(@PracticeID, 
															@ProviderID, 
															@InsuranceCompanyPlanID, 
															@LocationID)
	----------------------------------------------------------------------------------------------

	CREATE TABLE #t_hcfa_header(
			Document_HCFAID int,
			HCFASameAsInsuredFormatCode char(1),
			CurrentDate varchar(50),
			TotalChargeAmount money,
			TotalPaidAmount money,
			TotalBalanceAmount money,

			DiagnosisCode1 varchar(30),
			DiagnosisCode2 varchar(30),
			DiagnosisCode3 varchar(30),
			DiagnosisCode4 varchar(30),
			CurrentIllnessDate varchar(50),
			SimilarIllnessDate varchar(50),
			DisabilityBeginDate varchar(50),
			DisabilityEndDate varchar(50),
			HospitalizationBeginDate varchar(50),
			HospitalizationEndDate varchar(50),
			EmploymentRelatedFlag bit,
			AutoAccidentRelatedFlag bit,
			OtherAccidentRelatedFlag bit,
			AutoAccidentRelatedState char(2),

			PracticeName varchar(128),
			PracticeEIN varchar(9),
			PracticeStreet1 varchar(256),
			PracticeStreet2 varchar(256),
			PracticeCity varchar(128), 
			PracticeState varchar(2),
			PracticeZip varchar(9),
			PracticePhone varchar(10),

			PatientID int,
			PatientAccountNumber varchar(11),
			PatientFirstName varchar(64),
			PatientMiddleName varchar(64),
			PatientLastName varchar(64),
			PatientSuffix varchar(16),
			PatientStreet1 varchar(256),
			PatientStreet2 varchar(256),
			PatientCity varchar(128),
			PatientState varchar(2),
			PatientZip varchar(9),
			PatientPhone varchar(10),
			PatientBirthDate varchar(50),
			PatientGender varchar(1),
			PatientMaritalStatus varchar(1),
			PatientEmploymentStatus char(1),
			FacilityName varchar(128),
			FacilityStreet1 varchar(256),
			FacilityStreet2 varchar(256),
			FacilityCity varchar(128),
			FacilityState varchar(2),
			FacilityZip varchar(9),
			FacilityInfo varchar(50),
			AddOns bigint,
			PickUp varchar(max),
			DropOff varchar(max),
			FacilityCLIANumber varchar(30),
			RenderingProviderFirstName varchar(64),
			RenderingProviderMiddleName varchar(64),
			RenderingProviderLastName varchar(64),
			RenderingProviderSuffix varchar(16),
			RenderingProviderDegree varchar(8),
			RenderingProviderIndividualNumber varchar(50),
			PracticeNPI varchar(10),
			RenderingProviderGroupNumber varchar(50),
			RenderingProviderSignatureOnFileFlag bit,

			FacilityNPI varchar(10),
			FacilityOtherID varchar(52),
			PlaceOfService char(2),

			RenderingProviderQualifier char(2),
			RenderingProviderUPIN varchar(32),
			RenderingProviderNPI varchar(32),
			NewRenderingProviderNPI varchar(10),
			
			GroupNumber varchar(100),
			PolicyNumber varchar(100),
			DependentPolicyNumber varchar(100),
			PayerPrecedence int,
			PayerName varchar(128),
			PayerStreet1 varchar(256),
			PayerStreet2 varchar(256),
			PayerCity varchar(128),
			PayerState varchar(2),
			PayerZip varchar(9),
			PayerInsuranceProgramCode varchar(2),

			SubscriberDifferentFlag bit,
			PatientRelationshipToSubscriber varchar(1),
			SubscriberFirstName varchar(64),
			SubscriberMiddleName varchar(64),
			SubscriberLastName varchar(64),
			SubscriberSuffix varchar(16),
			SubscriberStreet1 varchar(256),
			SubscriberStreet2 varchar(256),
			SubscriberCity varchar(128),
			SubscriberState varchar(2),
			SubscriberZip varchar(9),
			SubscriberPhone varchar(10),
			SubscriberBirthDate varchar(50),
			SubscriberGender char(1),
			SubscriberEmployerName varchar(128),

			OtherPayerFlag bit,
			OtherGroupNumber varchar(100),
			OtherPolicyNumber varchar(100),
			OtherPayerName varchar(128),
			OtherSubscriberDifferentFlag bit,
			OtherSubscriberFirstName varchar(64),
			OtherSubscriberMiddleName varchar(64),
			OtherSubscriberLastName varchar(64),
			OtherSubscriberSuffix varchar(16),
			OtherSubscriberBirthDate varchar(50),
			OtherSubscriberGender char(1),
			OtherSubscriberEmployerName varchar(128),
			
			ReferringProviderPrefix varchar(16),
			ReferringProviderFirstName varchar(64),
			ReferringProviderMiddleName varchar(64),
			ReferringProviderLastName varchar(64),
			ReferringProviderSuffix varchar(16),
			ReferringProviderDegree varchar(8),
			
			ReferringProviderUPIN varchar(32),
			ReferringProviderOtherID varchar(32),
			ReferringProviderNPI varchar(32),
			NewReferringProviderNPI varchar(10),
			
			AuthorizationNumber varchar(65),
			LocalUseData varchar(100),
			ReferringProviderQualifier char(2),
			ReferringProviderIDNumber varchar(32),

			IsWorkersComp bit,
			PatientSSN varchar(50),
			WorkersCompCaseNumber varchar(128),
			AdjusterPrefix varchar(16),
			AdjusterFirstName varchar(64),
			AdjusterMiddleName varchar(64),
			AdjusterLastName varchar(64),
			AdjusterSuffix varchar(16),
			HolderThroughEmployer bit,
			HasSupervisingProvider bit,
			SupervisingProviderFirstName varchar(64),
			SupervisingProviderMiddleName varchar(64),
			SupervisingProviderLastName varchar(64),
			SupervisingProviderSuffix varchar(16),
			SupervisingProviderDegree varchar(8),

			FederalTaxID varchar(20),
			FederalTaxIDType varchar(10),

			AcceptAssignment bit
	)

	CREATE TABLE #DiagnosisList (
		DiagnosisIndex INT IDENTITY(1,1) NOT NULL,
		DiagnosisCode VARCHAR(30) NOT NULL
	)

	--DiagnosisPointer1
	INSERT	#DiagnosisList (DiagnosisCode)
	SELECT DiagnosisCode
	FROM
		(SELECT	DISTINCT DiagnosisCode
		FROM	Document_HCFAClaim BC
			INNER JOIN Claim C
			ON	C.ClaimID = BC.ClaimID
			INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
			INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID1=ED.EncounterDiagnosisID
			INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID
		WHERE	BC.PracticeID = @PracticeID AND BC.Document_HCFAID = @document_hcfaid) as T
	WHERE T.DiagnosisCode NOT IN(SELECT DiagnosisCode FROM #DiagnosisList)

	--DiagnosisPointer2
	INSERT	#DiagnosisList (DiagnosisCode)
	SELECT DiagnosisCode
	FROM
		(SELECT	DISTINCT DiagnosisCode
		FROM	Document_HCFAClaim BC
			INNER JOIN Claim C
			ON	C.ClaimID = BC.ClaimID
			INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
			INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID2=ED.EncounterDiagnosisID
			INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID
		WHERE	BC.PracticeID = @PracticeID AND BC.Document_HCFAID = @document_hcfaid) as T
	WHERE T.DiagnosisCode NOT IN(SELECT DiagnosisCode FROM #DiagnosisList)

	--DiagnosisPointer3
	INSERT	#DiagnosisList (DiagnosisCode)
	SELECT DiagnosisCode
	FROM
		(SELECT	DISTINCT DiagnosisCode
		FROM	Document_HCFAClaim BC
			INNER JOIN Claim C
			ON	C.ClaimID = BC.ClaimID
			INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
			INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID3=ED.EncounterDiagnosisID
			INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID
		WHERE	BC.PracticeID = @PracticeID AND BC.Document_HCFAID = @document_hcfaid) as T
	WHERE T.DiagnosisCode NOT IN(SELECT DiagnosisCode FROM #DiagnosisList)
		
	--DiagnosisPointer4
	INSERT	#DiagnosisList (DiagnosisCode)
	SELECT DiagnosisCode
	FROM
		(SELECT	DISTINCT DiagnosisCode
		FROM	Document_HCFAClaim BC
			INNER JOIN Claim C
			ON	C.ClaimID = BC.ClaimID
			INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
			INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID4=ED.EncounterDiagnosisID
			INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID
		WHERE	BC.PracticeID = @PracticeID AND BC.Document_HCFAID = @document_hcfaid) as T
	WHERE T.DiagnosisCode NOT IN(SELECT DiagnosisCode FROM #DiagnosisList)

	CREATE TABLE #DiagnosisData(
		Document_HCFAID INT,
		DiagnosisCode1 VARCHAR(30),
		DiagnosisCode2 VARCHAR(30),
		DiagnosisCode3 VARCHAR(30),
		DiagnosisCode4 VARCHAR(30)
	)

	INSERT	#DiagnosisData
	SELECT	@document_hcfaid AS Document_HCFAID,
		(
			SELECT	DiagnosisCode
			FROM	#DiagnosisList DL
			WHERE	DL.DiagnosisIndex = 1) AS DiagnosisCode1,
		(
			SELECT	DiagnosisCode
			FROM	#DiagnosisList DL
			WHERE	DL.DiagnosisIndex = 2) AS DiagnosisCode2,
		(
			SELECT	DiagnosisCode
			FROM	#DiagnosisList DL
			WHERE	DL.DiagnosisIndex = 3) AS DiagnosisCode3,
		(
			SELECT	DiagnosisCode
			FROM	#DiagnosisList DL
			WHERE	DL.DiagnosisIndex = 4) AS DiagnosisCode4

	DECLARE @CustomerID INT

	SELECT	@CustomerID = CustomerID
	FROM	Superbill_Shared.dbo.Customer
	WHERE	DatabaseName = DB_NAME()

	--Retrieve the results.
	INSERT INTO #t_hcfa_header
	SELECT	TOP 1
		DH.Document_HCFAID,
		IC.HCFASameAsInsuredFormatCode,
		dbo.fn_FormatDate(GETDATE()) AS CurrentDate,
		dbo.BusinessRule_HCFABillTotalOriginalChargeAmount(DH.Document_HCFAID) AS TotalChargeAmount,
		dbo.BusinessRule_HCFABillTotalPaidAmount(DH.Document_HCFAID) - dbo.BusinessRule_HCFABillTotalPatientPaidAmount(DH.Document_HCFAID) AS TotalPaidAmount,
		dbo.BusinessRule_HCFABillTotalBalanceAmount(DH.Document_HCFAID) + dbo.BusinessRule_HCFABillTotalPatientPaidAmount(DH.Document_HCFAID) AS TotalBalanceAmount,

		DD.DiagnosisCode1,
		DD.DiagnosisCode2,
		DD.DiagnosisCode3,
		DD.DiagnosisCode4,
		CASE WHEN PC.PregnancyRelatedFlag = 0 AND LIStartDate IS NOT NULL THEN 
		dbo.fn_FormatDate(DATEADD(hour, 5, PCDTDateOfInjury.LIStartDate))
		WHEN PC.PregnancyRelatedFlag <> 0 AND LMPStartDate IS NOT NULL THEN 
		dbo.fn_FormatDate(DATEADD(hour, 5, PCDTDateOfInjury.LMPStartDate))
		ELSE
		dbo.fn_FormatDate(DATEADD(hour, 5, PCDTDateOfInjury.ITRStartDate /*LIStartDate*/)) END AS CurrentIllnessDate,
		dbo.fn_FormatDate(DATEADD(hour, 5, PCDTSimilar.StartDate)) AS SimilarIllnessDate,
		dbo.fn_FormatDate(DATEADD(hour, 5, PCDTDisability.StartDate)) AS DisabilityBeginDate,
		dbo.fn_FormatDate(DATEADD(hour, 5, PCDTDisability.EndDate)) AS DisabilityEndDate,
		dbo.fn_FormatDate(DATEADD(hour, 5, COALESCE(E.HospitalizationStartDT, PCDTHospitalization.StartDate))) AS HospitalizationBeginDate,
		dbo.fn_FormatDate(DATEADD(hour, 5, COALESCE(E.HospitalizationEndDT, PCDTHospitalization.EndDate))) AS HospitalizationEndDate,
		PC.EmploymentRelatedFlag,
		PC.AutoAccidentRelatedFlag,
		PC.OtherAccidentRelatedFlag,
		PC.AutoAccidentRelatedState,

		UPPER(PR.Name) AS PracticeName,
		PR.EIN AS PracticeEIN,
		UPPER(PR.AddressLine1) AS PracticeStreet1,
		UPPER(PR.AddressLine2) AS PracticeStreet2,
		UPPER(PR.City) AS PracticeCity,
		UPPER(PR.State) AS PracticeState,
		UPPER(PR.ZipCode) AS PracticeZip,
		PR.Phone AS PracticePhone,

		P.PatientID,
		RTRIM(LTRIM(STR(E.EncounterID))) + 'Z' + RTRIM(LTRIM(STR(@CustomerID))) AS PatientAccountNumber,
		UPPER(P.FirstName) AS PatientFirstName,
		UPPER(P.MiddleName) AS PatientMiddleName,
		UPPER(P.LastName) AS PatientLastName,
		UPPER(P.Suffix) AS PatientSuffix,
		UPPER(P.AddressLine1) AS PatientStreet1,
		UPPER(P.AddressLine2) AS PatientStreet2,
		UPPER(P.City) AS PatientCity,
		UPPER(P.State) AS PatientState,
		UPPER(P.ZipCode) AS PatientZip,
		P.HomePhone AS PatientPhone,
		dbo.fn_FormatDate(DATEADD(hour, 5, P.DOB)) AS PatientBirthDate,
		P.Gender AS PatientGender,
		P.MaritalStatus AS PatientMaritalStatus,
		P.EmploymentStatus AS PatientEmploymentStatus,
		UPPER(L.BillingName) AS FacilityName,
		UPPER(L.AddressLine1) AS FacilityStreet1,
		UPPER(L.AddressLine2) AS FacilityStreet2,
		UPPER(L.City) AS FacilityCity,
		UPPER(L.State) AS FacilityState,
		L.ZipCode AS FacilityZip,
		UPPER(L.HCFABox32FacilityID) AS FacilityInfo,
		E.AddOns & 4 AS AddOns,
		UPPER(ACI.PickUp) AS PickUp,
		UPPER(ACI.DropOff) AS DropOff,
		UPPER(L.CLIANumber) AS FacilityCLIANumber,
		UPPER(D.FirstName) AS RenderingProviderFirstName,
		UPPER(D.MiddleName) AS RenderingProviderMiddleName,
		UPPER(D.LastName) AS RenderingProviderLastName,
		UPPER(D.Suffix) AS RenderingProviderSuffix,
		UPPER(D.Degree) AS RenderingProviderDegree,
		(
		SELECT TOP 1
				PN.ProviderNumber
			FROM
				ProviderNumber PN
			WHERE
				PN.DoctorID = D.DoctorID
				AND PN.ProviderNumberTypeID = IC.ProviderNumberTypeID
				AND PN.AttachConditionsTypeID IN (1, 2)
				AND (PN.InsuranceCompanyPlanID IS NULL OR PN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
				AND (PN.LocationID IS NULL OR PN.LocationID = E.LocationID)
			ORDER BY
				CASE WHEN PN.LocationID IS NULL THEN 0 ELSE 1 END + CASE WHEN PN.InsuranceCompanyPlanID IS NULL THEN 0 ELSE 2 END DESC
		)
			AS RenderingProviderIndividualNumber,
		PR.NPI AS PracticeNPI,
		(
			SELECT TOP 1
				PIGN.GroupNumber
			FROM
				PracticeInsuranceGroupNumber PIGN
			WHERE
				PIGN.PracticeID = PR.PracticeID
				AND PIGN.GroupNumberTypeID = IC.GroupNumberTypeID
				AND PIGN.AttachConditionsTypeID IN (1, 2)
				AND (PIGN.InsuranceCompanyPlanID IS NULL OR PIGN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
				AND (PIGN.LocationID IS NULL OR PIGN.LocationID = E.LocationID)
			ORDER BY
				CASE WHEN PIGN.LocationID IS NULL THEN 0 ELSE 1 END + CASE WHEN PIGN.InsuranceCompanyPlanID IS NULL THEN 0 ELSE 2 END DESC
		)
			AS RenderingProviderGroupNumber,
 
		1	AS RenderingProviderSignatureOnFileFlag,

		L.NPI AS FacilityNPI,
		GNT.ANSIReferenceIdentificationQualifier + UPPER(L.HCFABox32FacilityID) AS FacilityOtherID,
		E.PlaceOfServiceCode AS PlaceOfService,

		UPINQ2.ANSIReferenceIdentificationQualifier AS RenderingProviderQualifier,
		RP_UPIN2.ProviderNumber AS RenderingProviderUPIN,
		NPI2.ProviderNumber AS RenderingProviderNPI,
		D.NPI AS NewRenderingProviderNPI,

		UPPER(IP.GroupNumber) AS GroupNumber,
		UPPER(IP.PolicyNumber) AS PolicyNumber,
		UPPER(IP.DependentPolicyNumber) AS DependentPolicyNumber,
		IP.Precedence AS PayerPrecedence,
		UPPER(ICP.PlanName) AS PayerName,
		UPPER(ICP.AddressLine1) AS PayerStreet1,
		UPPER(ICP.AddressLine2) AS PayerStreet2,
		UPPER(ICP.City) AS PayerCity,
		UPPER(ICP.State) AS PayerState,
		UPPER(ICP.ZipCode) AS PayerZip,
		IC.InsuranceProgramCode AS PayerInsuranceProgramCode,

		CASE WHEN IP.PatientRelationshipToInsured = 'S' THEN 0 ELSE 1 END AS SubscriberDifferentFlag,
		IP.PatientRelationshipToInsured 
			AS PatientRelationshipToSubscriber,
		UPPER(IP.HolderFirstName) AS SubscriberFirstName,
		UPPER(IP.HolderMiddleName) AS SubscriberMiddleName,
		UPPER(IP.HolderLastName) AS SubscriberLastName,
		UPPER(IP.HolderSuffix) AS SubscriberSuffix,
		UPPER(IP.HolderAddressLine1) AS SubscriberStreet1,
		UPPER(IP.HolderAddressLine2) AS SubscriberStreet2,
		UPPER(IP.HolderCity) AS SubscriberCity,
		UPPER(IP.HolderState) AS SubscriberState,
		UPPER(IP.HolderZipCode) AS SubscriberZip,
		IP.HolderPhone AS SubscriberPhone,
		dbo.fn_FormatDate(DATEADD(hour, 5, IP.HolderDOB)) AS SubscriberBirthDate,
		IP.HolderGender AS SubscriberGender,
		UPPER(IP.HolderEmployerName) AS SubscriberEmployerName,
		
		CASE WHEN IP2.InsurancePolicyID IS NULL THEN 0 ELSE 1 END AS OtherPayerFlag,
		UPPER(IP2.GroupNumber) AS OtherGroupNumber,
		UPPER(IP2.PolicyNumber) AS OtherPolicyNumber,
		UPPER(ICP2.PlanName) AS OtherPayerName,
		CASE WHEN IP2.PatientRelationshipToInsured = 'S' THEN 0 ELSE 1 END AS OtherSubscriberDifferentFlag,
		UPPER(IP2.HolderFirstName) AS OtherSubscriberFirstName,
		UPPER(IP2.HolderMiddleName) AS OtherSubscriberMiddleName,
		UPPER(IP2.HolderLastName) AS OtherSubscriberLastName,
		UPPER(IP2.HolderSuffix) AS OtherSubscriberSuffix,
		dbo.fn_FormatDate(DATEADD(hour, 5, IP2.HolderDOB)) AS OtherSubscriberBirthDate,
		IP2.HolderGender AS OtherSubscriberGender,
		UPPER(IP2.HolderEmployerName) AS OtherSubscriberEmployerName,

		UPPER(RP.Prefix) AS ReferringProviderPrefix,
		UPPER(RP.FirstName) AS ReferringProviderFirstName,
		UPPER(RP.MiddleName) AS ReferringProviderMiddleName,
		UPPER(RP.LastName) AS ReferringProviderLastName,
		UPPER(RP.Suffix) AS ReferringProviderSuffix,
		UPPER(RP.Degree) AS ReferringProviderDegree,
		
		(
			SELECT TOP 1
				PN.ProviderNumber
			FROM
				ProviderNumber PN
			WHERE
				PN.DoctorID = RP.DoctorID
				AND PN.ProviderNumberTypeID = IC.ProviderNumberTypeID
				AND PN.AttachConditionsTypeID IN (1, 2)
				AND (PN.InsuranceCompanyPlanID IS NULL OR PN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
				AND (PN.LocationID IS NULL OR PN.LocationID = E.LocationID)
			ORDER BY
				CASE WHEN PN.LocationID IS NULL THEN 0 ELSE 1 END + CASE WHEN PN.InsuranceCompanyPlanID IS NULL THEN 0 ELSE 2 END DESC
		)   AS ReferringProviderUPIN,

		MCD.ProviderNumber AS ReferringProviderOtherID,
		NPI.ProviderNumber AS ReferringProviderNPI,
		RP.NPI AS NewReferringProviderNPI,

		IPA.AuthorizationNumber,
		ISNULL(E.Box19, ' ') AS LocalUseData,
		CASE
			WHEN C.ReferringProviderIDNumber IS NULL THEN UPINQ.ANSIReferenceIdentificationQualifier
			WHEN C.ReferringProviderIDNumber = '' THEN UPINQ.ANSIReferenceIdentificationQualifier
			WHEN (		
					SELECT TOP 1 CASE WHEN ProviderNumber IS NULL THEN 0 ELSE 1 END
					FROM ProviderNumber PN
					WHERE PN.DoctorID = RP.DoctorID
						AND PN.ProviderNumberTypeID = IC.ProviderNumberTypeID
						AND PN.AttachConditionsTypeID IN (1, 2)
						AND (PN.InsuranceCompanyPlanID IS NULL OR PN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
						AND (PN.LocationID IS NULL OR PN.LocationID = E.LocationID)
					ORDER BY ProviderNumberID
				 ) = 0 THEN UPINQ3.ANSIReferenceIdentificationQualifier
		END AS 'ReferringProviderQualifier',


		coalesce( dbo.fn_ZeroLengthStringToNull( C.ReferringProviderIDNumber), 
					
				--	UPIN.ProviderNumber,

				( -- Referring Provider ProviderID
					SELECT TOP 1 ProviderNumber
					FROM ProviderNumber UPIN
					WHERE UPIN.DoctorID = RP.DoctorID 
						AND UPIN.ProviderNumberTypeID = IC.ReferringProviderNumberTypeID 
						AND (UPIN.LocationID IS NULL OR UPIN.LocationID = E.LocationID)
						AND UPIN.AttachConditionsTypeID IN (1, 2)
						AND (UPIN.InsuranceCompanyPlanID IS NULL OR UPIN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
					ORDER BY
						CASE WHEN UPIN.LocationID IS NULL THEN 0 ELSE 1 END + CASE WHEN UPIN.InsuranceCompanyPlanID IS NULL THEN 0 ELSE 2 END DESC
					),
			 
					( -- Referring Provider UPIN
						SELECT TOP 1
							PN.ProviderNumber
						FROM
							ProviderNumber PN
						WHERE
							PN.DoctorID = RP.DoctorID
							AND PN.ProviderNumberTypeID = 25
							AND PN.AttachConditionsTypeID IN (1, 2)
							AND (PN.InsuranceCompanyPlanID IS NULL OR PN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
							AND (PN.LocationID IS NULL OR PN.LocationID = E.LocationID)
						ORDER BY
							CASE WHEN PN.LocationID IS NULL THEN 0 ELSE 1 END + CASE WHEN PN.InsuranceCompanyPlanID IS NULL THEN 0 ELSE 2 END DESC
					)  
				) AS 'ReferringProviderIDNumber',

		CASE WHEN PC.PayerScenarioID IN (13, 15, 16) THEN 1 ELSE 0 END AS IsWorkersComp,
		dbo.fn_FormatSSN(P.SSN),
		PC.CaseNumber,
		UPPER(IP.AdjusterPrefix),
		UPPER(IP.AdjusterFirstName),
		UPPER(IP.AdjusterMiddleName),
		UPPER(IP.AdjusterLastName),
		UPPER(IP.AdjusterSuffix),
		IP.HolderThroughEmployer, 
		CASE WHEN D2.DoctorID IS NULL THEN 0 ELSE 1 END as HasSupervisingProvider,
		UPPER(D2.FirstName) AS SupervisingProviderFirstName,
		UPPER(D2.MiddleName) AS SupervisingProviderMiddleName,
		UPPER(D2.LastName) AS SupervisingProviderLastName,
		UPPER(D2.Suffix) AS SupervisingProviderSuffix,
		UPPER(D2.Degree) AS SupervisingProviderDegree,
		COALESCE(@FederalTaxID, PR.EIN) AS FederalTaxID,
		@FederalTaxIDType AS FederalTaxIDType,
		COALESCE(PTIC.AcceptAssignment, 1) as AcceptAssignment
	FROM	Document_HCFA DH
		INNER JOIN Claim C
		ON DH.PracticeID=C.PracticeID AND DH.RepresentativeClaimID=C.ClaimID
		INNER JOIN EncounterProcedure EP 
		ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN Encounter E 
		ON EP.PracticeID=E.PracticeID AND EP.EncounterID=E.EncounterID
		LEFT JOIN AmbulanceTransportInformation ACI
		ON E.EncounterID = ACI.EncounterID
		INNER JOIN PatientCase PC 
		ON E.PracticeID=PC.PracticeID AND E.PatientCaseID=PC.PatientCaseID
		INNER JOIN Practice PR
		ON PC.PracticeID = PR.PracticeID
		INNER JOIN Patient P
		ON PC.PracticeID=P.PracticeID AND PC.PatientID = P.PatientID
		INNER JOIN Doctor D
		ON E.DoctorID = D.DoctorID
		INNER JOIN ServiceLocation L
		ON E.LocationID = L.ServiceLocationID
		LEFT JOIN GroupNumberType GNT
		ON L.FacilityIDType = GNT.GroupNumberTypeID
		AND GNT.GroupNumberTypeID = 28
		INNER JOIN InsurancePolicy IP
		ON IP.InsurancePolicyID = @RecipientInsurancePolicyID
		LEFT JOIN InsurancePolicyAuthorization IPA
		ON E.InsurancePolicyAuthorizationID=IPA.InsurancePolicyAuthorizationID
		INNER JOIN InsuranceCompanyPlan ICP
		ON ICP.InsuranceCompanyPlanID = IP.InsuranceCompanyPlanID
		INNER JOIN InsuranceCompany IC
		ON ICP.InsuranceCompanyID=IC.InsuranceCompanyID
		LEFT OUTER JOIN Doctor RP
		ON E.ReferringPhysicianID = RP.DoctorID
		LEFT OUTER JOIN ProviderNumber UPIN
			ON UPIN.DoctorID = RP.DoctorID
			AND UPIN.ProviderNumberTypeID = IC.ProviderNumberTypeID
			AND (UPIN.LocationID IS NULL OR UPIN.LocationID = E.LocationID)
			AND UPIN.AttachConditionsTypeID IN (1, 2)
			AND (UPIN.InsuranceCompanyPlanID IS NULL OR UPIN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
		LEFT OUTER JOIN ProviderNumberType UPINQ
			ON UPINQ.ProviderNumberTypeID = UPIN.ProviderNumberTypeID
		LEFT OUTER JOIN ProviderNumber MCD
			ON MCD.DoctorID = RP.DoctorID
			AND MCD.ProviderNumberTypeID = 24
			AND MCD.AttachConditionsTypeID IN (1, 2)
			AND (MCD.LocationID IS NULL OR MCD.LocationID = E.LocationID)
			AND (MCD.InsuranceCompanyPlanID IS NULL OR MCD.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
		LEFT OUTER JOIN ProviderNumber NPI
			ON NPI.DoctorID = RP.DoctorID
			AND NPI.ProviderNumberTypeID = 8
			AND NPI.AttachConditionsTypeID IN (1, 2)
			AND (NPI.LocationID IS NULL OR NPI.LocationID = E.LocationID)
			AND (NPI.InsuranceCompanyPlanID IS NULL OR NPI.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
		LEFT OUTER JOIN ProviderNumber RP_UPIN2
			ON RP_UPIN2.DoctorID = D.DoctorID
			AND RP_UPIN2.ProviderNumberTypeID = IC.ProviderNumberTypeID
			AND RP_UPIN2.AttachConditionsTypeID IN (1, 2)
			AND (RP_UPIN2.LocationID IS NULL OR RP_UPIN2.LocationID = E.LocationID)
			AND (RP_UPIN2.InsuranceCompanyPlanID IS NULL OR RP_UPIN2.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
		LEFT OUTER JOIN ProviderNumberType UPINQ2
			ON UPINQ2.ProviderNumberTypeID = RP_UPIN2.ProviderNumberTypeID
		LEFT OUTER JOIN ProviderNumber NPI2
			ON NPI2.DoctorID = D.DoctorID
			AND NPI2.ProviderNumberTypeID = 8
			AND NPI2.AttachConditionsTypeID IN (1, 2)
			AND (NPI2.LocationID IS NULL OR NPI2.LocationID = E.LocationID)
			AND (NPI2.InsuranceCompanyPlanID IS NULL OR NPI2.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
		LEFT OUTER JOIN ProviderNumberType UPINQ3
			ON UPINQ3.ProviderNumberTypeID = IC.ReferringProviderNumberTypeID
		LEFT OUTER JOIN InsurancePolicy IP2
		ON IP2.InsurancePolicyID = @RecipientOtherInsurancePolicyID
		LEFT JOIN InsuranceCompanyPlan ICP2
		ON ICP2.InsuranceCompanyPlanID = IP2.InsuranceCompanyPlanID
		LEFT OUTER JOIN #DiagnosisData DD
		ON	DD.Document_HCFAID = DH.Document_HCFAID 
-------------------------------------------------------------------------------------------
		LEFT OUTER JOIN (
		SELECT PatientCaseID, 
		MIN(CASE WHEN PatientCaseDateTypeID=7 THEN StartDate ELSE NULL END) LMPStartDate,
		MIN(CASE WHEN PatientCaseDateTypeID=2 THEN StartDate ELSE NULL END) LIStartDate,
		MIN(CASE WHEN PatientCaseDateTypeID=1 THEN StartDate ELSE NULL END) ITRStartDate

		FROM PatientCaseDate 
		WHERE PatientCaseID=@PatientCaseID
		GROUP BY PatientCaseID) PCDTDateOfInjury
		ON PC.PatientCaseID=PCDTDateOfInjury.PatientCaseID
------------------------------------------------------------------------------------------------
		LEFT OUTER JOIN PatientCaseDate PCDTSimilar
		ON	PCDTSimilar.PatientCaseID = PC.PatientCaseID
		AND	PCDTSimilar.PatientCaseDateTypeID = 3		--SimilarIllnessDate
		LEFT OUTER JOIN PatientCaseDate PCDTDisability
		ON	PCDTDisability.PatientCaseID = PC.PatientCaseID
		AND	PCDTDisability.PatientCaseDateTypeID = 5	--DisabilityDate
		LEFT OUTER JOIN PatientCaseDate PCDTHospitalization
		ON	PCDTHospitalization.PatientCaseID = PC.PatientCaseID
		AND	PCDTHospitalization.PatientCaseDateTypeID = 6	--HospitalizationDate
		LEFT OUTER JOIN Doctor D2
		ON	D2.DoctorID = E.SupervisingProviderID
------------------------------------------------------------------------------------------------
		LEFT OUTER JOIN PracticeToInsuranceCompany PTIC
		ON	PTIC.InsuranceCompanyID = IC.InsuranceCompanyID
		AND	PTIC.PracticeID = @PracticeID
	WHERE	DH.PracticeID=@PracticeID AND DH.Document_HCFAID = @document_hcfaid

	-- Start the XML
	EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_hcfa_header', @DestinationName='#t_result', @FormID=@form_name, @ADDRoot=1, @CloseRoot=0
	SET @result_id = @@identity


	SELECT	C.ClaimID,
		IC.HCFADiagnosisReferenceFormatCode,
		IC.HCFASameAsInsuredFormatCode,
		dbo.fn_FormatDate(DATEADD(Hour, 5, EP.ProcedureDateOfService)) AS ServiceBeginDate,
		dbo.fn_FormatDate(DATEADD(Hour, 5, ISNULL(EP.ServiceEndDate, EP.ProcedureDateOfService))) AS ServiceEndDate,
		E.PlaceOfServiceCode,
		dbo.BusinessRule_ClaimOriginalChargeAmount(C.ClaimID) AS ChargeAmount,
		CAST(EP.ServiceUnitCount AS REAL) AS ServiceUnitCount,
		ISNULL(PCD.BillableCode,PCD.ProcedureCode) ProcedureCode,
		'NDC: '+PCD.NDC NDC,
		CASE WHEN NDC IS NULL THEN 0 ELSE IC.NDCFormat END NDCFormat,
		COALESCE(EP.TypeOfServiceCode, PCD.TypeOfServiceCode) AS TypeOfServiceCode,
		EP.AnesthesiaTime AS AnesthesiaMinutes,
		PCD.NDC AS NDCNumber,
		PCD.DrugName,
		EP.ProcedureModifier1,
		EP.ProcedureModifier2,
		EP.ProcedureModifier3,
		EP.ProcedureModifier4,
		CASE WHEN DCD.DiagnosisCode IS NOT NULL THEN DL.DiagnosisIndex ELSE NULL END DiagnosisPointer1,
		DCD.DiagnosisCode DiagnosisPointer1Code,
		CASE WHEN DCD2.DiagnosisCode IS NOT NULL THEN DL2.DiagnosisIndex ELSE NULL END DiagnosisPointer2,
		DCD2.DiagnosisCode DiagnosisPointer2Code,
		CASE WHEN DCD3.DiagnosisCode IS NOT NULL THEN DL3.DiagnosisIndex ELSE NULL END DiagnosisPointer3,
		DCD3.DiagnosisCode DiagnosisPointer3Code,
		CASE WHEN DCD4.DiagnosisCode IS NOT NULL THEN DL4.DiagnosisIndex ELSE NULL END DiagnosisPointer4,
		DCD4.DiagnosisCode DiagnosisPointer4Code,
		CASE WHEN C.LocalUseData IS NOT NULL AND LEN(C.LocalUseData) > 0 THEN C.LocalUseData ELSE 
		(
			SELECT TOP 1
				PN.ProviderNumber
			FROM
				ProviderNumber PN
			WHERE
				PN.DoctorID = E.DoctorID
				AND PN.AttachConditionsTypeID IN (1, 2)
				AND PN.ProviderNumberTypeID = IC.LocalUseProviderNumberTypeID
				AND (PN.InsuranceCompanyPlanID IS NULL OR PN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
				AND (PN.LocationID IS NULL OR PN.LocationID = E.LocationID)
			ORDER BY
				CASE WHEN PN.LocationID IS NULL THEN 0 ELSE 1 END + CASE WHEN PN.InsuranceCompanyPlanID IS NULL THEN 0 ELSE 2 END DESC
		) END AS RenderingProviderLocalIdentifier,
		CASE WHEN C.LocalUseData IS NOT NULL AND LEN(C.LocalUseData) > 0 THEN C.LocalUseData ELSE 
		(
			SELECT TOP 1
				PN.ProviderNumber
			FROM
				ProviderNumber PN
			WHERE
				PN.DoctorID = E.SupervisingProviderID
				AND PN.AttachConditionsTypeID IN (1, 2)
				AND PN.ProviderNumberTypeID = IC.LocalUseProviderNumberTypeID
				AND (PN.InsuranceCompanyPlanID IS NULL OR PN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
				AND (PN.LocationID IS NULL OR PN.LocationID = E.LocationID)
			ORDER BY
				CASE WHEN PN.LocationID IS NULL THEN 0 ELSE 1 END + CASE WHEN PN.InsuranceCompanyPlanID IS NULL THEN 0 ELSE 2 END DESC
		) END AS SupervisingProviderLocalIdentifier,

		-- primary paid 
		(SELECT replace (cast (SUM(Amount) as varchar(50)), '.', '' )
			FROM ClaimTransaction CT INNER JOIN Payment P
			ON CT.ReferenceID=P.PaymentID
			INNER JOIN Claim C
			ON CT.PracticeID=C.PracticeID AND CT.ClaimID=C.ClaimID
			INNER JOIN EncounterProcedure EP
			ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
			INNER JOIN Encounter E
			ON EP.PracticeID=E.PracticeID AND EP.EncounterID=E.EncounterID
			INNER JOIN InsurancePolicy IP
			ON E.PatientCaseID=IP.PatientCaseID AND IP.InsuranceCompanyPlanID=P.PayerID
			AND IP.Precedence=dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(IP.PatientCaseID,EP.ProcedureDateOfService,0)
			WHERE CT.ClaimID=BC.ClaimID AND CT.ClaimTransactionTypeCode='PAY' AND P.PayerTypeCode='I'
		) AS PrimaryPaid
	INTO	#t_hcfa_procedures
	FROM	Document_HCFA B INNER JOIN Document_HCFAClaim BC
		ON BC.Document_HCFAID = B.Document_HCFAID
		INNER JOIN Claim C
		ON C.ClaimID = BC.ClaimID
		INNER JOIN EncounterProcedure EP 
		ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN Encounter E 
		ON EP.EncounterID=E.EncounterID
		INNER JOIN InsurancePolicy IP
		ON IP.InsurancePolicyID = @RecipientInsurancePolicyID
		INNER JOIN InsuranceCompanyPlan ICP
		ON IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
		INNER JOIN InsuranceCompany IC 
		ON ICP.InsuranceCompanyID=IC.InsuranceCompanyID
		INNER JOIN ProcedureCodeDictionary PCD
		ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID

		LEFT JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID1=ED.EncounterDiagnosisID
		LEFT JOIN DiagnosisCodeDictionary DCD
		ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID
		LEFT JOIN #DiagnosisList DL ON DL.DiagnosisCode = DCD.DiagnosisCode

		LEFT JOIN EncounterDiagnosis ED2 ON EP.EncounterDiagnosisID2=ED2.EncounterDiagnosisID
		LEFT JOIN DiagnosisCodeDictionary DCD2
		ON ED2.DiagnosisCodeDictionaryID=DCD2.DiagnosisCodeDictionaryID
		LEFT JOIN #DiagnosisList DL2 ON DL2.DiagnosisCode = DCD2.DiagnosisCode

		LEFT JOIN EncounterDiagnosis ED3 ON EP.EncounterDiagnosisID3=ED3.EncounterDiagnosisID
		LEFT JOIN DiagnosisCodeDictionary DCD3
		ON ED3.DiagnosisCodeDictionaryID=DCD3.DiagnosisCodeDictionaryID
		LEFT JOIN #DiagnosisList DL3 ON DL3.DiagnosisCode = DCD3.DiagnosisCode

		LEFT JOIN EncounterDiagnosis ED4 ON EP.EncounterDiagnosisID4=ED4.EncounterDiagnosisID
		LEFT JOIN DiagnosisCodeDictionary DCD4
		ON ED4.DiagnosisCodeDictionaryID=DCD4.DiagnosisCodeDictionaryID	
		LEFT JOIN #DiagnosisList DL4 ON DL4.DiagnosisCode = DCD4.DiagnosisCode

	WHERE	B.Document_HCFAID = @document_hcfaid

	-- Finish the xml
	EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_hcfa_procedures', @DestinationName='#t_result', @FormID=@form_name, @ADDRoot=0, @CloseRoot=1, @DestinationID=@result_id

	IF @RecipientInsurancePrecedence=@FirstPrecedence
	BEGIN
		UPDATE t SET Transform=BF.Transform
		FROM 	#t_result t
		INNER JOIN InsurancePolicy IP
		ON 	IP.InsurancePolicyID = @RecipientInsurancePolicyID
		INNER JOIN InsuranceCompanyPlan ICP
		ON 	IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
		INNER JOIN InsuranceCompany IC
		ON 	ICP.InsuranceCompanyID=IC.InsuranceCompanyID
		INNER JOIN BillingForm BF ON BF.BillingFormID = IC.BillingFormID
		WHERE t.TID=@result_id
	END
	ELSE
	BEGIN
		UPDATE t SET Transform=BF.Transform
		FROM 	#t_result t
		INNER JOIN InsurancePolicy IP
		ON 	IP.InsurancePolicyID = @RecipientInsurancePolicyID
		INNER JOIN InsuranceCompanyPlan ICP
		ON 	IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
		INNER JOIN InsuranceCompany IC
		ON 	ICP.InsuranceCompanyID=IC.InsuranceCompanyID
		INNER JOIN BillingForm BF ON BF.BillingFormID = IC.SecondaryPrecedenceBillingFormID
		WHERE t.TID=@result_id
	END

	
--	SELECT * FROM #t_hcfa_header
--	SELECT * FROM #t_hcfa_procedures
 
	DROP TABLE #DiagnosisList
	DROP TABLE #DiagnosisData
	DROP TABLE #t_hcfa_header
	DROP TABLE #t_hcfa_procedures

END