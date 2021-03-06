--===========================================================================
-- 
-- BILL DATA PROVIDER - EDI/XML portion
-- feeds BizClaims with XML representation of a single Big Claim (defined by bill_id)
--
--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BillDataProvider_GetEDIBillXML_5010'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.BillDataProvider_GetEDIBillXML_5010
GO


--===========================================================================
-- GET EDI BILL XML
-- dbo.BillDataProvider_GetEDIBillXML_5010 0, 157
-- dbo.BillDataProvider_GetEDIBillXML_5010 0, 1
--===========================================================================
CREATE PROCEDURE dbo.BillDataProvider_GetEDIBillXML_5010
	@batch_id INT,
	@bill_id INT

-- WITH RECOMPILE
AS
BEGIN

	SET NOCOUNT ON
	
-- =========== Declaration Section (DML) To prevent recompiling of sproc mid-stream ===============----
	--Temp Tables for Available Edi Hacks
	Declare @PayerHacks table ([Name] nvarchar(30) NOT NULL)
	Declare @CustomerHacks table ([Name] nvarchar(30) NOT NULL)
	
	DECLARE @loop2010BB2U varchar(30)	-- case 5492

	-- get values that go into the header from shared DB:
	DECLARE @customer_id INT

	DECLARE @ClearinghouseConnectionId INT
	DECLARE @ProductionFlag INT
	DECLARE @SubmitterName VARCHAR(100)
	DECLARE @SubmitterEtin VARCHAR(100)
	DECLARE @SubmitterContactName VARCHAR(60)
	DECLARE @SubmitterContactPhone VARCHAR(80)
	DECLARE @SubmitterContactEmail VARCHAR(80)
	DECLARE @SubmitterContactFax VARCHAR(80)
	DECLARE @ReceiverName VARCHAR(100)
	DECLARE @ReceiverEtin VARCHAR(100)

	DECLARE @PracticeID INT
	DECLARE @GroupTaxonomyCode VARCHAR(10)
	DECLARE @SptSBROrdering BIT					-- SF 192306 - Secondary, Primary, Tertiary
	DECLARE @RenderingProviderID INT
	DECLARE @RenderingProviderNPI VARCHAR(32)
	DECLARE @RenderingProviderTaxonomyCode VARCHAR(10)
	DECLARE @SuppressRenderingTaxonomyCode BIT
	DECLARE @PatientID INT
	DECLARE @EncounterID INT
	DECLARE @PatientCaseID INT
	DECLARE @RepresentativeClaimID INT
	DECLARE @LocationID INT
	DECLARE @PlaceOfServiceCode CHAR(2)		-- from table PlaceOfService -- for example '31' = Skilled Nursing Facility
	DECLARE @InsuranceCompanyPlanID INT
	DECLARE @InsuranceCompanyID INT
	DECLARE @PayerResponsibilityCode CHAR(1)
	DECLARE @PayerInsurancePolicyID INT
	DECLARE @OtherPayerInsurancePolicyID INT
	DECLARE @PlanName VARCHAR(256)			-- something like 'Medicare Part B of Arizona' from ICP
	DECLARE @ClearinghouseID INT
	DECLARE @PayerName VARCHAR(256)			-- something like 'MEDICARE ARIZONA' - NameTransmitted from CPL
	DECLARE @PayerNumber VARCHAR(30)		-- something like 'MR049'
	DECLARE @InsuranceProgramCode CHAR(2)		-- something like 'CI' for SBR09, or 'MB' for Medicare
	DECLARE @hide_patient_paid_amount BIT		-- case 8396
	DECLARE @RoutingPreference VARCHAR(500)
	DECLARE @SupervisingProviderID INT					-- doctor ID
	DECLARE @ReferringProviderID INT					-- doctor ID
	DECLARE @ServiceFacilityIdQualifier CHAR(2)
	DECLARE @ServiceFacilityId VARCHAR(50)
	DECLARE @ServiceFacilityMammographyCertificationNumber VARCHAR(50)
	DECLARE @TransactionType CHAR(2)		-- 'CH' or 'RP'
	DECLARE @PayerSupportsSecondaryElectronicBilling BIT
	DECLARE @PayerSupportsCoordinationOfBenefits BIT
	DECLARE @PracticeInsuranceUseSecondaryElectronicBilling BIT
	DECLARE @PracticeInsuranceUseCoordinationOfBenefits BIT

	DECLARE @t_realPrecedence Table(RealPrecedence int identity(1,1), InsurancePolicyID int, StatedPrecedence int)

	DECLARE @t_PatientCaseDate Table(PatientCaseID int, StartDate DateTime, EndDate DateTime, PatientCaseDateTypeID int)

	DECLARE @InitialTreatmentDate		DateTime
	DECLARE @DateOfInjury				DateTime
	DECLARE @AccidentDate				DateTime
	DECLARE @DateOfSimilarInjury		DateTime
	DECLARE @UnableToWorkStartDate		DateTime
	DECLARE @UnableToWorkEndDate		DateTime
	DECLARE @DisabilityStartDate		DateTime
	DECLARE @DisabilityEndDate			DateTime
	DECLARE @HospitalizationStartDate	DateTime
	DECLARE @HospitalizationEndDate		DateTime
	DECLARE @LastMenstrualDate			DateTime
	DECLARE @LastSeenDate				DateTime
	DECLARE @ReferralDate				DateTime
	DECLARE @AcuteManifestationDate		DateTime
	DECLARE @LastXrayDate				DateTime


	DECLARE @OPFirstName  VARCHAR(256)
	DECLARE @OPMiddleName  VARCHAR(256)
	DECLARE @OPLastName  VARCHAR(256)
	DECLARE @OPSuffix  VARCHAR(256)
	DECLARE @OPSSNQualifier  CHAR(2)
	DECLARE @OPSSN  VARCHAR(32)
	DECLARE @OPNPI  VARCHAR(32)
	DECLARE @OPUPIN  VARCHAR(32)
	DECLARE @OPAddressLine1  VARCHAR(256)
	DECLARE @OPAddressLine2  VARCHAR(256)
	DECLARE @OPCity  VARCHAR(256)
	DECLARE @OPState  VARCHAR(256)
	DECLARE @OPZipCode  VARCHAR(32)
	DECLARE @OPPhone  VARCHAR(32)

	DECLARE @t_ambulancecertification Table(TID int identity(1,1), AmbulanceCertificationCode char(2))

	DECLARE @t_groupnumbers table
	(
		TID int identity(1,1),
		ANSIReferenceIdentificationQualifier varchar(10),
		GroupNumber varchar(50)
	)

	DECLARE @t_providernumbers table
	(
		TID int identity(1,1),
		ANSIReferenceIdentificationQualifier varchar(10),
		ProviderNumber varchar(50)
	)

	DECLARE @t_refprovidernumbers table
	(
		TID int identity(1,1),
		ANSIReferenceIdentificationQualifier varchar(10),
		ProviderNumber varchar(50)
	)

	DECLARE @IndividualBilling BIT		-- 1 = Individual, 0 = Group
	DECLARE @BillerType VARCHAR(1)		-- biller type for loop  2010AA, 1(indiv) or 2(group)
	DECLARE @BillerIdent VARCHAR(32)	-- actual value for NM109  "ein"

	DECLARE @PaytoNPI VARCHAR(32)

	DECLARE @groupNumbersCount INT

	DECLARE @DiagnosisCode1 VARCHAR(32)
	DECLARE @DiagnosisCode2 VARCHAR(32)
	DECLARE @DiagnosisCode3 VARCHAR(32)
	DECLARE @DiagnosisCode4 VARCHAR(32)
	DECLARE @DiagnosisCode5 VARCHAR(32)
	DECLARE @DiagnosisCode6 VARCHAR(32)
	DECLARE @DiagnosisCode7 VARCHAR(32)
	DECLARE @DiagnosisCode8 VARCHAR(32)
	DECLARE @DiagnosisCode9 VARCHAR(32)
	DECLARE @DiagnosisCode10 VARCHAR(32)
	DECLARE @DiagnosisCode11 VARCHAR(32)
	DECLARE @DiagnosisCode12 VARCHAR(32)

	DECLARE @doCOB BIT

	DECLARE @t_cob_othersubscriber Table(TID int identity(1,1),
		InsurancePolicyID int,
		[insured-different-than-patient-flag] bit,
		[subscriber-first-name] varchar(128),
		[subscriber-middle-name] varchar(128),
		[subscriber-last-name] varchar(128),
		[subscriber-suffix] varchar(128),
		[subscriber-street-1] varchar(128),
		[subscriber-street-2] varchar(128),
		[subscriber-city] varchar(128),
		[subscriber-state] varchar(32),
		[subscriber-zip] varchar(32),
		[subscriber-country] varchar(128),
		[subscriber-birth-date] DATETIME,
		[subscriber-gender] varchar(128),
		[subscriber-assignment-of-benefits-flag] bit,
		[subscriber-release-of-information-code] char(1),
		[relation-to-insured-code] char(2),
		[payer-responsibility-code] char(1),
		[payer-responsibility-code-order] INT,
		[claim-filing-indicator-code] char(2),
		[plan-name] varchar(128),
		[insurance-type-code] varchar(8),
		[group-number] varchar(128),
		[policy-number] varchar(128),
		[payer-name] varchar(128),
		[payer-identifier-qualifier] char(2),		-- 'PI' for clearinghouse ID or 'XV' for NPI
		[payer-identifier] varchar(128),
		[payer-street-1] varchar(128),
		[payer-street-2] varchar(128),
		[payer-city] varchar(128),
		[payer-state] varchar(32),
		[payer-zip] varchar(32),
		[payer-country] varchar(128),
		[payer-secondary-id] varchar(128),
		[payer-contact-name] varchar(128),
		[payer-contact-phone] varchar(128),
		[payer-paid-flag] bit,
		[payer-paid-amount] money,
		[payer-allowed-amount] money,
		[patient-responsibility-amount] money
		)

	DECLARE @t_cob_svcadjudication Table (
		TID int identity(1,1),
		[othersubscriberTID] int,					-- joins with @t_cob_othersubscriber.TID
			-- this is computed to fill loop 2420 SVD segment:
		[adjudication-date] datetime,
		[comp-procedure-code] varchar(128),
		[date-of-service] datetime,
		[procedure-modifiers] varchar(128),	-- concatenation of all modifiers
		[paid-amount] money,
		[allowed-amount] money,
		[approved-amount] money,	-- SF 65891, FB 24028
		[paid-quantity] decimal,
		[assigned-number] int,						-- for bundled lines only
			-- the following comes from PaymentClaim table:
		[PaymentClaimID] [int] NOT NULL,
		[PaymentID] [int] NOT NULL,					-- Kareo RT system Payment ID needed for diagnostics
		[PracticeID] [int] NOT NULL,
		[PatientID] [int] NOT NULL,
		[EncounterID] [int] NOT NULL,
		[ClaimID] [int] NOT NULL,
		[EOBXml] [xml] NULL,
		[Notes] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
		)

	-- loop 2430 CAS - service line adjustments information
	DECLARE @t_cob_svcadjustment Table (
		TID int identity(1,1),
		[svcadjudicationTID] int,					-- joins with @t_cob_svcadjudication.TID
			-- this is computed to fill loop 2430 CAS segment:
		[adjustment-type] varchar(128),
		[adjustment-amount] money,
		[adjustment-quantity] decimal,
		[adjustment-category] varchar(128),
		[adjustment-description] varchar(256)
		)

	DECLARE @t_cob_svcadjustment_bg Table (			-- before-grouping
		TID int identity(1,1),
		[svcadjudicationTID] int,					-- joins with @t_cob_svcadjudication.TID
			-- this is computed to fill loop 2430 CAS segment:
		[adjustment-type] varchar(128),
		[adjustment-amount] money,
		[adjustment-quantity] decimal,
		[adjustment-category] varchar(128),
		[adjustment-description] varchar(256)
		)

	DECLARE @t_cob_svcadjustment_w Table (
		TID int identity(1,1),
		[svcadjudicationTID] int,					-- joins with @t_cob_svcadjudication.TID
			-- the following goes into CAS segment, grouped by group-code:
		[adjustment-group-code] varchar(128),
		[adjustment-reason-1] varchar(128),
		[adjustment-amount-1] varchar(128),
		[adjustment-quantity-1] varchar(128),
		[adjustment-reason-2] varchar(128),
		[adjustment-amount-2] varchar(128),
		[adjustment-quantity-2] varchar(128),
		[adjustment-reason-3] varchar(128),
		[adjustment-amount-3] varchar(128),
		[adjustment-quantity-3] varchar(128),
		[adjustment-reason-4] varchar(128),
		[adjustment-amount-4] varchar(128),
		[adjustment-quantity-4] varchar(128),
		[adjustment-reason-5] varchar(128),
		[adjustment-amount-5] varchar(128),
		[adjustment-quantity-5] varchar(128),
		[adjustment-reason-6] varchar(128),
		[adjustment-amount-6] varchar(128),
		[adjustment-quantity-6] varchar(128)
		)

	DECLARE @cob_othersubscriberTID int 
	DECLARE @cob_insurancePolicyID int 

	DECLARE cob_cursor CURSOR READ_ONLY
	FOR
		SELECT COSS.TID, COSS.InsurancePolicyID
		FROM @t_cob_othersubscriber COSS

	DECLARE @CliaNumber VARCHAR(100)
	DECLARE @ExecutionCount INT, @RecompileInterval INT

	CREATE TABLE #ClaimBatch( ClaimID INT)
	CREATE TABLE #ClaimBatchDiagnosesPointers (ClaimID INT, DiagnosisCode varchar(16), Pointer INT)
	
	CREATE CLUSTERED INDEX t_IX_ClaimBatch ON #ClaimBatch (ClaimID)
	CREATE CLUSTERED INDEX t_IX_ClaimBatchDiagnosesPointers ON #ClaimBatchDiagnosesPointers(ClaimID, DiagnosisCode)

------------- End of DDL -----------------------



	IF (@bill_id < 1)
	BEGIN
		SELECT TOP 1 @bill_id = BillID FROM Bill_EDI BE ORDER BY BillID DESC
		PRINT 'bill_id=' + CAST(@bill_id AS varchar)
	END

	IF (@batch_id < 1)
	BEGIN
		SELECT @batch_id = BillBatchID FROM Bill_EDI BE WHERE BillID = @bill_id
		PRINT  'batch_id=' + CAST(@batch_id AS varchar)
	END


	SET @customer_id = dbo.fn_GetCustomerID()

	-- per FB 22324 ... hard-code these for now
	SELECT  @ClearinghouseConnectionID = 0,
		@ProductionFlag = 1


	-- BizClaims will take over some values, we need to mark them here (case 9927).
	-- unless overridden, they will be replaced by values from ClearinghouseConnection after routing:
	SET @SubmitterName = 'XXXXXX'
	SET @SubmitterEtin = 'XXXXXX'
	SET @SubmitterContactName = 'XXXXXX'
	SET @SubmitterContactPhone = 'XXXXXX'
	SET @SubmitterContactEmail = 'XXXXXX'
	SET @SubmitterContactFax = 'XXXXXX'
	SET @ReceiverName = 'XXXXXX'
	SET @ReceiverEtin = 'XXXXXX'

	-- to have Loop 2000A filled with Group Numbers, we need RC.LocationID and ICP.InsuranceCompanyPlanID.
	-- also, get some other parameters into variables:

	-- SET @RoutingPreference = 'PROXYMED'

	---------------------------------------------------------------------------------------------------------------------
	-- get all Big Claim info

	-- fetch "snapshot" bill parameters, including InsurancePolicies, stored in the bill at the time of its creation:

	SELECT
		@RepresentativeClaimID = B.RepresentativeClaimID,
		@PayerResponsibilityCode = B.PayerResponsibilityCode,			-- 'P', 'S' or 'T'
		@PayerInsurancePolicyID = B.PayerInsurancePolicyID,
		@OtherPayerInsurancePolicyID = B.OtherPayerInsurancePolicyID
	FROM	Bill_EDI B
	WHERE	B.BillID = @bill_id

	-- fetch all big claim parameters at encounter level - based on Representative Claim:
	SELECT TOP 1 
		@PracticeID = PR.PracticeID,
		@RenderingProviderID = RD.DoctorID,
		@RenderingProviderTaxonomyCode = RD.TaxonomyCode, 
		@SupervisingProviderID = SD.DoctorID,
		@ReferringProviderID = E.ReferringPhysicianID, 
		@PatientID = P.PatientID,
		@EncounterID = E.EncounterID,
		@LocationID = E.LocationID,
		@ServiceFacilityIdQualifier = LNT.ANSIReferenceIdentificationQualifier,
		@ServiceFacilityId = SL.HCFABox32FacilityID,
		@PlaceOfServiceCode = E.PlaceOfServiceCode,
		@SubmitterContactName = CASE WHEN AdministrativeContactLastName <> '' THEN 
										dbo.fn_FormatFirstMiddleLast(AdministrativeContactFirstName, AdministrativeContactMiddleName, AdministrativeContactLastName)
									WHEN BillingContactLastName <> '' THEN 
										dbo.fn_FormatFirstMiddleLast(BillingContactFirstName, BillingContactMiddleName, BillingContactLastName)
									ELSE 
										@SubmitterContactName 
								END,
		@SubmitterContactPhone = COALESCE(NULLIF(PR.Phone,''), 
											NULLIF(AdministrativeContactPhone,''), 
											NULLIF(BillingPhone,''),
											@SubmitterContactPhone),
		@SubmitterContactEmail = COALESCE(NULLIF(PR.EmailAddress,''), 
											NULLIF(AdministrativeContactEmailAddress,''), 
											NULLIF(BillingEmailAddress,''),
											@SubmitterContactEmail),
		@SubmitterContactFax = COALESCE(NULLIF(PR.Fax,''), 
											NULLIF(AdministrativeContactFax,''), 
											NULLIF(BillingFax,''),
											@SubmitterContactFax)
	FROM	Claim RC
		INNER JOIN dbo.EncounterProcedure EP
			ON EP.EncounterProcedureID = RC.EncounterProcedureID
		INNER JOIN dbo.Encounter E
			ON E.EncounterID = EP.EncounterID
		INNER JOIN Practice PR
			ON PR.PracticeID = E.PracticeID
		INNER JOIN Patient P
		ON P.PatientID = RC.PatientID
		LEFT JOIN Doctor RD
			ON RD.DoctorID = E.DoctorID
		LEFT JOIN Doctor SD
			ON SD.DoctorID = E.SupervisingProviderID
		LEFT JOIN ServiceLocation SL
			ON SL.ServiceLocationID = E.LocationID
		LEFT JOIN GroupNumberType LNT
			ON LNT.GroupNumberTypeID = SL.FacilityIDType
	WHERE	RC.ClaimID = @RepresentativeClaimID

	-- based on the basics and the insurance policy, fetch insurance related info - hopefully for the time when bill was created.
	-- keep in mind that assignment might have changed since, so we need to rely on linkage provided by that old insurance policy.

	SELECT TOP 1 
		@PatientCaseID = PI.PatientCaseID,
		@InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID,
		@InsuranceCompanyID = ICP.InsuranceCompanyID,
		@InsuranceProgramCode = IC.InsuranceProgramCode,
		@PlanName = ICP.PlanName,
		@hide_patient_paid_amount = CASE WHEN PTIC.ExcludePatientPayment IS NULL OR PTIC.ExcludePatientPayment = 0 THEN 0 ELSE 1 END,
		@ClearinghouseID = CPL.ClearinghouseID,
		@PayerName = CPL.NameTransmitted,
		@PayerNumber = CPL.PayerNumber,
		@RoutingPreference = CH.RoutingName,
		@TransactionType = CASE WHEN ISNULL(CONT.Capitated, 0) = 0 THEN 'CH' ELSE 'RP' END,
		@PayerSupportsSecondaryElectronicBilling = ISNULL(CPL.SupportsSecondaryElectronicBilling, 0),
		@PayerSupportsCoordinationOfBenefits = ISNULL(CPL.SupportsCoordinationOfBenefits, 0),
		@PracticeInsuranceUseSecondaryElectronicBilling = ISNULL(PTIC.UseSecondaryElectronicBilling, 0),
		@PracticeInsuranceUseCoordinationOfBenefits = ISNULL(PTIC.UseCoordinationOfBenefits, 0)
	FROM	
		InsurancePolicy PI
		INNER JOIN InsuranceCompanyPlan ICP
			INNER JOIN InsuranceCompany IC 
			ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
			LEFT OUTER JOIN ClearinghousePayersList CPL
			ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID
		ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
		INNER JOIN SharedServer.superbill_shared.dbo.Clearinghouse CH
		ON CH.ClearinghouseID = CPL.ClearinghouseID
		LEFT OUTER JOIN PracticeToInsuranceCompany PTIC
		ON PTIC.PracticeID = @PracticeID AND PTIC.InsuranceCompanyID = IC.InsuranceCompanyID
		LEFT OUTER JOIN ContractToInsurancePlan CTIP 
			INNER JOIN [Contract] CONT ON CONT.ContractID = CTIP.ContractID
		ON ICP.InsuranceCompanyPlanID = CTIP.PlanID
	WHERE	PI.InsurancePolicyID = @PayerInsurancePolicyID

	
	--Temp Table for Available Payer Hacks
	INSERT INTO @PayerHacks
	SELECT [Name]
	FROM
		 SharedServer.superbill_shared.dbo.EdiHackPayer EHP
			INNER JOIN  SharedServer.superbill_shared.dbo.EdiHack EH
			ON EH.EdiHackID = EHP.EdiHackID
		WHERE	([CustomerID] = @customer_id or [CustomerID] IS NULL )
				AND [PayerNumber] = @PayerNumber
				AND EH.[EdiBillXml5010] = 1
				AND EHP.[EdiBillXml5010] = 1

	INSERT INTO @CustomerHacks
	SELECT Name
	FROM SHAREDSERVER.superbill_shared.dbo.EdiHackCustomer EHC
		INNER JOIN SHAREDSERVER.superbill_shared.dbo.EdiHack EH ON EHC.EdiHackID = EH.EdiHackID
	WHERE EdiBillXml5010 = 1 AND CustomerID = @customer_id
	 
	--SF 00232838
	DECLARE @HospiceEmployeeIndicator CHAR(1)

	SELECT @HospiceEmployeeIndicator = 
	CASE WHEN EXISTS (SELECT * from @PayerHacks where [Name] = 'HospiceEmployeeIndicatorYes') THEN 'Y'
	WHEN EXISTS (SELECT * from @PayerHacks where [Name] = 'HospiceEmployeeIndicatorNo') THEN 'N'
	ELSE NULL END


	IF EXISTS (SELECT * from @PayerHacks where [Name] = 'SptSBROrdering')
	BEGIN
		SET @SptSBROrdering = 1
	END

	-- Service Location hacks	
	IF @ServiceFacilityIdQualifier = 'EI'
	BEGIN
		-- Payer specific hack.  All Capario payers require 'TJ' instead of 'EI' for @ServiceFacilityIdQualifier
		IF @ClearinghouseID = 1
		BEGIN
			SET @ServiceFacilityIdQualifier = 'TJ'
		END
	END

	-- Set the @ServiceFacilityMammographyCertificationNumber to the @ServiceFacilityId when the @ServiceFacilityIdQualifier is EW
	IF @ServiceFacilityIdQualifier = 'EW'  
	BEGIN
		SET @ServiceFacilityMammographyCertificationNumber = @ServiceFacilityId
	END

	-- If either the @ServiceFacilityIdQualifier or @ServiceFacilityId is null empty both values out since we only want to use it
	-- if both are set
	IF @ServiceFacilityIdQualifier IS NULL or @ServiceFacilityId IS NULL
	BEGIN
		SET @ServiceFacilityIdQualifier = null
		SET @ServiceFacilityId = null
	END

	IF EXISTS ( SELECT * FROM @PayerHacks WHERE [Name] = 'SuppressRenderingTaxonomyCode')
		SET @SuppressRenderingTaxonomyCode = 1
		
		
	DECLARE @ReferringCliaNumberHack BIT
	IF EXISTS ( SELECT * from @PayerHacks where [Name] = 'ReferringCliaNumber')
		SET @ReferringCliaNumberHack = 1
	
	--EDIHACKS
	DECLARE @SuppressRenderingProviderForASC BIT
	IF EXISTS (SELECT * FROM @PayerHacks WHERE [Name] = 'SuppressRenderingProviderForASC') AND @PlaceOfServiceCode = '24'
		SET @SuppressRenderingProviderForASC = 1
		
	DECLARE @ForcePatientAddressIn2310C BIT
	IF EXISTS (SELECT * FROM @PayerHacks WHERE [Name] = 'ForcePatientAddressIn2310C') AND @PlaceOfServiceCode = '12'
		SET @ForcePatientAddressIn2310C = 1
		
	DECLARE @PopulatePSsegment BIT
	IF EXISTS (SELECT * FROM @PayerHacks WHERE [Name] = 'PopulatePSsegment')
		SET @PopulatePSsegment = 1
		
	--DECLARE @ BIT
	--IF EXISTS (SELECT * FROM @PayerHacks WHERE [Name] = '') 
	--	SET @ = 1

	-- SF case 00007862, FB case 14025   TBD
	-- see if we need to supress NPI sending for those payers who haven't prepared to accept them:

	-- compile a temp table with all related insurance policies, for Precedence (case 18781):

	INSERT @t_realPrecedence (InsurancePolicyID, StatedPrecedence)
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
	WHERE RC.ClaimID = @RepresentativeClaimID
	ORDER BY PI.Precedence
	
	--SF 00216411
	--Customer 1849
	--WHERE:Secondary claim billed to payer = 00029 & Primary payer = 00880 
	--Do:Secondary payer needs to go out as 620, instead of 00029 as the payer ID (PI*) 
	DECLARE @MedicaidSecondaryPayerMask BIT
	
	SELECT @MedicaidSecondaryPayerMask =1 FROM
	@t_realPrecedence RPI
	INNER JOIN InsurancePolicy PI
	ON RPI.InsurancePolicyID = PI.InsurancePolicyID
		INNER JOIN InsuranceCompanyPlan ICP
			INNER JOIN InsuranceCompany IC 
			ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
			LEFT OUTER JOIN ClearinghousePayersList CPL
			ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID
		ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
	WHERE ((CPL.PayerNumber = '00029' AND RPI.StatedPrecedence = 2 AND PI.InsurancePolicyID = @PayerInsurancePolicyID) 
	OR ( CPL.PayerNumber = '00880' AND rpi.StatedPrecedence = 1))
	AND @customer_id = 1849
	HAVING COUNT(1) = 2

--select '@t_realPrecedence' as [@t_realPrecedence], * from @t_realPrecedence
--select @PayerResponsibilityCode as [@PayerResponsibilityCode], @PayerInsurancePolicyID as [@PayerInsurancePolicyID]


	---------------------------------------------------------------------------------------------------------------------
	-- Get Claim Settings for Rendering Provider
	DECLARE	@RenderingProviderNumberType1 varchar(2)
	DECLARE	@RenderingProviderNumberType2 varchar(2)
	DECLARE	@RenderingProviderNumberType3 varchar(2)
	DECLARE	@RenderingProviderNumberType4 varchar(2)
	DECLARE	@RenderingProviderNumber1 varchar(50)
	DECLARE	@RenderingProviderNumber2 varchar(50)
	DECLARE	@RenderingProviderNumber3 varchar(50)
	DECLARE	@RenderingProviderNumber4 varchar(50)
	DECLARE	@RenderingGroupNumberType1 varchar(2)
	DECLARE	@RenderingGroupNumberType2 varchar(2)
	DECLARE	@RenderingGroupNumberType3 varchar(2)
	DECLARE	@RenderingGroupNumberType4 varchar(2)
	DECLARE	@RenderingGroupNumber1 varchar(50)
	DECLARE	@RenderingGroupNumber2 varchar(50)
	DECLARE	@RenderingGroupNumber3 varchar(50)
	DECLARE	@RenderingGroupNumber4 varchar(50)
	DECLARE @RenderingTaxIDTypeID int
	DECLARE @RenderingTaxIDQualifier varchar(2)
	DECLARE	@RenderingTaxID varchar(50)
	DECLARE	@RenderingNPI varchar(50)
	DECLARE @RenderingSubmitterNumber varchar(10)

	DECLARE @OverridePracticeNameFlag BIT
	DECLARE @OverridePracticeAddressFlag BIT
	DECLARE @OverridePracticeName varchar(256)
	DECLARE @OverridePracticeAddressLine1 varchar(256)
	DECLARE @OverridePracticeAddressLine2 varchar(256)
	DECLARE @OverridePracticeCity varchar(128)
	DECLARE @OverridePracticeState varchar(2)
	DECLARE @OverridePracticeZipCode varchar(9)
	DECLARE @OverridePracticeCountry varchar(32)

	DECLARE @EnablePayToAddressFlag BIT
	DECLARE @EnablePayToName varchar(128)
	DECLARE @EnablePayToAddressLine1 varchar(256)
	DECLARE @EnablePayToAddressLine2 varchar(256)
	DECLARE @EnablePayToCity varchar(128)
	DECLARE @EnablePayToState varchar(2)
	DECLARE @EnablePayToZipCode varchar(9)
	DECLARE @EnablePayToCountry varchar(32)
	
	DECLARE @EnableGlobalPayToAddressFlag BIT
	DECLARE @EnableGlobalPayToName varchar(128)
	DECLARE @EnableGlobalPayToAddressLine1 varchar(256)
	DECLARE @EnableGlobalPayToAddressLine2 varchar(256)
	DECLARE @EnableGlobalPayToCity varchar(128)
	DECLARE @EnableGlobalPayToState varchar(2)
	DECLARE @EnableGlobalPayToZipCode varchar(9)
	DECLARE @EnableGlobalPayToCountry varchar(32)
	
	--print 'SELECT * FROM dbo.fn_BillDataProvider_GetClaimSetting(' +
	--		cast(@PracticeID as varchar) + ', ' + cast(@RenderingProviderID as varchar) + 
	--		', ' + cast(@InsuranceCompanyID as varchar) + ', ' + cast(@LocationID as varchar) + ')'

	SELECT	@RenderingProviderNumberType1 = ProviderNumberType1,
			@RenderingProviderNumberType2 = ProviderNumberType2,
			@RenderingProviderNumberType3 = ProviderNumberType3,
			@RenderingProviderNumberType4 = ProviderNumberType4,
			@RenderingProviderNumber1 = ProviderNumber1,
			@RenderingProviderNumber2 = ProviderNumber2,
			@RenderingProviderNumber3 = ProviderNumber3,
			@RenderingProviderNumber4 = ProviderNumber4,
			@RenderingGroupNumberType1 = GroupNumberType1,
			@RenderingGroupNumberType2 = GroupNumberType2,
			@RenderingGroupNumberType3 = GroupNumberType3,
			@RenderingGroupNumberType4 = GroupNumberType4,
			@RenderingGroupNumber1 = GroupNumber1,
			@RenderingGroupNumber2 = GroupNumber2,
			@RenderingGroupNumber3 = GroupNumber3,
			@RenderingGroupNumber4 = GroupNumber4,
			@RenderingTaxIDTypeID = ClaimSettingsTaxIDTypeID, 
			@RenderingTaxIDQualifier = TaxIDQualifier, 
			@RenderingTaxID = TaxID,
			@RenderingNPI = NPI,
			@RenderingProviderNPI = IndividualNPI, 
			@RenderingSubmitterNumber = SubmitterNumber,
			
			@OverridePracticeAddressFlag = OverridePracticeAddressFlag,
			@GroupTaxonomyCode = GroupTaxonomyCode,
			@OverridePracticeName = OverridePracticeName,

			@OverridePracticeAddressLine1 = OverridePracticeAddressLine1,
			@OverridePracticeAddressLine2 = OverridePracticeAddressLine2,
			@OverridePracticeCity = OverridePracticeCity,
			@OverridePracticeState = OverridePracticeState,
			@OverridePracticeZipCode = OverridePracticeZipCode,
			@OverridePracticeCountry = OverridePracticeCountry,
			@EnablePayToAddressFlag = EnablePayToAddressFlag,
			@EnablePayToName = EnablePayToName,
			@EnablePayToAddressLine1 = EnablePayToAddressLine1,
			@EnablePayToAddressLine2 = EnablePayToAddressLine2,
			@EnablePayToCity = EnablePayToCity,
			@EnablePayToState = EnablePayToState,
			@EnablePayToZipCode = EnablePayToZipCode,
			@EnablePayToCountry = EnablePayToCountry,
			
			@EnableGlobalPayToAddressFlag = EnableGlobalPayToAddressFlag,
			@EnableGlobalPayToName = EnableGlobalPayToName,
			@EnableGlobalPayToAddressLine1 = EnableGlobalPayToAddressLine1,
			@EnableGlobalPayToAddressLine2 = EnableGlobalPayToAddressLine2,
			@EnableGlobalPayToCity = EnableGlobalPayToCity,
			@EnableGlobalPayToState = EnableGlobalPayToState,
			@EnableGlobalPayToZipCode = EnableGlobalPayToZipCode,
			@EnableGlobalPayToCountry = EnableGlobalPayToCountry,

			-- Determine if this is Individual or Group billing based ClaimSettingsNPITypeID (1 is group, 2 is individual)
			@IndividualBilling = CASE WHEN ClaimSettingsNPITypeID = 2 THEN 1 ELSE 0 END
	FROM dbo.fn_BillDataProvider_GetClaimSetting(@PracticeID, @RenderingProviderID, @InsuranceCompanyID, @LocationID)

	DECLARE @OverridePayToAddress INT
	SET @OverridePayToAddress = CASE @EnablePayToAddressFlag
									WHEN 1 THEN 0
									ELSE CASE @EnableGlobalPayToAddressFlag
										WHEN 1 THEN 1
										ELSE 2 END
									END
									
	-- When NPI is used we need the TaxIDQualifier (EI or SY) to be here with the value, add this as it is required as
	-- a REF in addition to the provider numbers
	INSERT INTO @t_providernumbers(ANSIReferenceIdentificationQualifier, ProviderNumber)
	VALUES(@RenderingTaxIDQualifier, @RenderingTaxID)

	-- Save the provider numbers in the flat structure from Claim Settings into a temp table
	IF @RenderingProviderNumberType1 IS NOT NULL AND @RenderingProviderNumberType1 <> ''
	AND @RenderingProviderNumber1 IS NOT NULL AND @RenderingProviderNumber1 <> ''
	BEGIN
		INSERT INTO @t_providernumbers(ANSIReferenceIdentificationQualifier, ProviderNumber)
		VALUES(@RenderingProviderNumberType1, @RenderingProviderNumber1)
	END

	IF @RenderingProviderNumberType2 IS NOT NULL AND @RenderingProviderNumberType2 <> ''
	AND @RenderingProviderNumber2 IS NOT NULL AND @RenderingProviderNumber2 <> ''
	BEGIN
		INSERT INTO @t_providernumbers(ANSIReferenceIdentificationQualifier, ProviderNumber)
		VALUES(@RenderingProviderNumberType2, @RenderingProviderNumber2)
	END

	IF @RenderingProviderNumberType3 IS NOT NULL AND @RenderingProviderNumberType3 <> ''
	AND @RenderingProviderNumber3 IS NOT NULL AND @RenderingProviderNumber3 <> ''
	BEGIN
		INSERT INTO @t_providernumbers(ANSIReferenceIdentificationQualifier, ProviderNumber)
		VALUES(@RenderingProviderNumberType3, @RenderingProviderNumber3)
	END

	IF @RenderingProviderNumberType4 IS NOT NULL AND @RenderingProviderNumberType4 <> ''
	AND @RenderingProviderNumber4 IS NOT NULL AND @RenderingProviderNumber4 <> ''
	BEGIN
		INSERT INTO @t_providernumbers(ANSIReferenceIdentificationQualifier, ProviderNumber)
		VALUES(@RenderingProviderNumberType4, @RenderingProviderNumber4)
	END

	-- Group Numbers table contains the Provider Numbers if individual billing, otherwise it contains group numbers
	-- This is most likely due to the Group Numbers being used to populate 2010AA loop which contains different information
	-- depending on billing as an individual or group
	IF @IndividualBilling = 1
	BEGIN
		-- Copy the provider numbers into group numbers if we are billing individually
		INSERT @t_groupnumbers(ANSIReferenceIdentificationQualifier, GroupNumber) 
		SELECT ANSIReferenceIdentificationQualifier, ProviderNumber
		FROM @t_providernumbers
	END
	ELSE
	BEGIN
		-- We only need to load in group numbers if we are billing as a group

		-- When NPI is used we need the TaxIDQualifier (EI or SY) to be here with the value, add this as it is required as
		-- a REF in addition to the provider numbers
		INSERT INTO @t_groupnumbers(ANSIReferenceIdentificationQualifier, GroupNumber)
		VALUES(@RenderingTaxIDQualifier, @RenderingTaxID)
		
		-- Save the group numbers in the flat structure from Claim Settings into a temp table
		IF @RenderingGroupNumberType1 IS NOT NULL AND @RenderingGroupNumberType1 <> ''
		AND @RenderingGroupNumber1 IS NOT NULL AND @RenderingGroupNumber1 <> ''
		BEGIN
			INSERT INTO @t_groupnumbers(ANSIReferenceIdentificationQualifier, GroupNumber) 
			VALUES(@RenderingGroupNumberType1, @RenderingGroupNumber1)
		END

		IF @RenderingGroupNumberType2 IS NOT NULL AND @RenderingGroupNumberType2 <> ''
		AND @RenderingGroupNumber2 IS NOT NULL AND @RenderingGroupNumber2 <> ''
		BEGIN
			INSERT INTO @t_groupnumbers(ANSIReferenceIdentificationQualifier, GroupNumber) 
			VALUES(@RenderingGroupNumberType2, @RenderingGroupNumber2)
		END

		IF @RenderingGroupNumberType3 IS NOT NULL AND @RenderingGroupNumberType3 <> ''
		AND @RenderingGroupNumber3 IS NOT NULL AND @RenderingGroupNumber3 <> ''
		BEGIN
			INSERT INTO @t_groupnumbers(ANSIReferenceIdentificationQualifier, GroupNumber) 
			VALUES(@RenderingGroupNumberType3, @RenderingGroupNumber3)
		END

		IF @RenderingGroupNumberType4 IS NOT NULL AND @RenderingGroupNumberType4 <> ''
		AND @RenderingGroupNumber4 IS NOT NULL AND @RenderingGroupNumber4 <> ''
		BEGIN
			INSERT INTO @t_groupnumbers(ANSIReferenceIdentificationQualifier, GroupNumber) 
			VALUES(@RenderingGroupNumberType4, @RenderingGroupNumber4)
		END
	END

	-- Get Claim Settings for Supervising Provider
	DECLARE @SupervisingProviderNPI varchar(50)
	DECLARE	@SupervisingProviderNumberType1 varchar(2)
	DECLARE	@SupervisingProviderNumber1 varchar(50)

	SELECT	@SupervisingProviderNPI = IndividualNPI, 
			@SupervisingProviderNumberType1 = ProviderNumberType1,
			@SupervisingProviderNumber1 = ProviderNumber1
	FROM	dbo.fn_BillDataProvider_GetClaimSetting(@PracticeID, @SupervisingProviderID, @InsuranceCompanyID, @LocationID)

	-- Get Claim Settings for Referring Provider
	DECLARE @ReferringProviderNPI varchar(50)
	DECLARE	@ReferringProviderNumberType1 varchar(2)
	DECLARE	@ReferringProviderNumberType2 varchar(2)
	DECLARE	@ReferringProviderNumberType3 varchar(2)
	DECLARE	@ReferringProviderNumberType4 varchar(2)
	DECLARE	@ReferringProviderNumber1 varchar(50)
	DECLARE	@ReferringProviderNumber2 varchar(50)
	DECLARE	@ReferringProviderNumber3 varchar(50)
	DECLARE	@ReferringProviderNumber4 varchar(50)
	DECLARE @ReferringTaxIDQualifier varchar(2)
	DECLARE	@ReferringTaxID varchar(50)

	SELECT	@ReferringProviderNPI = IndividualNPI,
			@ReferringProviderNumberType1 = ProviderNumberType1,
			@ReferringProviderNumberType2 = ProviderNumberType2,
			@ReferringProviderNumberType3 = ProviderNumberType3,
			@ReferringProviderNumberType4 = ProviderNumberType4,
			@ReferringProviderNumber1 = ProviderNumber1,
			@ReferringProviderNumber2 = ProviderNumber2,
			@ReferringProviderNumber3 = ProviderNumber3,
			@ReferringProviderNumber4 = ProviderNumber4,
			@ReferringTaxIDQualifier = TaxIDQualifier, 
			@ReferringTaxID = TaxID
	FROM	dbo.fn_BillDataProvider_GetClaimSetting(@PracticeID, @ReferringProviderID, @InsuranceCompanyID, @LocationID)

	-- Save the provider numbers for the referring provider in the flat structure from Claim Settings into a temp table
	IF @ReferringProviderNumberType1 IS NOT NULL AND @ReferringProviderNumberType1 <> '' 
	AND @ReferringProviderNumber1 IS NOT NULL AND @ReferringProviderNumber1 <> ''
	BEGIN
		INSERT INTO @t_refprovidernumbers(ANSIReferenceIdentificationQualifier, ProviderNumber)
		VALUES(@ReferringProviderNumberType1, @ReferringProviderNumber1)
	END

	IF @ReferringProviderNumberType2 IS NOT NULL AND @ReferringProviderNumberType2 <> '' 
	AND @ReferringProviderNumber2 IS NOT NULL AND @ReferringProviderNumber2 <> ''
	BEGIN
		INSERT INTO @t_refprovidernumbers(ANSIReferenceIdentificationQualifier, ProviderNumber)
		VALUES(@ReferringProviderNumberType2, @ReferringProviderNumber2)
	END

	IF @ReferringProviderNumberType3 IS NOT NULL AND @ReferringProviderNumberType3 <> '' 
	AND @ReferringProviderNumber3 IS NOT NULL AND @ReferringProviderNumber3 <> ''
	BEGIN
		INSERT INTO @t_refprovidernumbers(ANSIReferenceIdentificationQualifier, ProviderNumber)
		VALUES(@ReferringProviderNumberType3, @ReferringProviderNumber3)
	END

	IF @ReferringProviderNumberType4 IS NOT NULL AND @ReferringProviderNumberType4 <> '' 
	AND @ReferringProviderNumber4 IS NOT NULL AND @ReferringProviderNumber4 <> ''
	BEGIN
		INSERT INTO @t_refprovidernumbers(ANSIReferenceIdentificationQualifier, ProviderNumber)
		VALUES(@ReferringProviderNumberType4, @ReferringProviderNumber4)
	END

	-- ok, we know enough about big claim and insurances involved in this billing act
	---------------------------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------------
	-- individual billers supply PRV in loop 2000A and do not have Loop 2310B:

	IF @IndividualBilling = 1
		SET @BillerType = '1'	-- Individual
	ELSE
		SET @BillerType = '2'	-- Group

	SET @BillerIdent = @RenderingNPI
	SET @PaytoNPI = @RenderingNPI

	-- case 14717: prepare all dates:


	INSERT @t_PatientCaseDate (PatientCaseID, StartDate, EndDate, PatientCaseDateTypeID)
	SELECT PCD.PatientCaseID, PCD.StartDate, PCD.EndDate, PCD.PatientCaseDateTypeID
	FROM PatientCaseDate PCD
	WHERE PCD.PracticeID = @PracticeID AND PCD.PatientCaseID = @PatientCaseID
	ORDER BY PatientCaseDateID DESC

	-- SF 35016, FB 23158 - use AccidentDate for accident-related claims
	SELECT TOP 1 
		@InitialTreatmentDate = InitialTreatmentDate.StartDate,
		@DateOfInjury = DateOfInjury.StartDate,
		@AccidentDate = AccidentDate.StartDate,
		@DateOfSimilarInjury = DateOfSimilarInjury.StartDate,
		@UnableToWorkStartDate = UnableToWorkDate.StartDate,
		@UnableToWorkEndDate = UnableToWorkDate.EndDate,
		@DisabilityStartDate = DisabilityDate.StartDate,
		@DisabilityEndDate = DisabilityDate.EndDate,
		@HospitalizationStartDate = HospitalizationDate.StartDate,
		@HospitalizationEndDate = HospitalizationDate.EndDate,
		@LastMenstrualDate = LastMenstrualDate.StartDate,
		@LastSeenDate = LastSeenDate.StartDate,
		@ReferralDate = ReferralDate.StartDate,
		@AcuteManifestationDate = AcuteManifestationDate.StartDate,
		@LastXrayDate = LastXrayDate.StartDate
	FROM PatientCase PC
		LEFT JOIN @t_PatientCaseDate AS InitialTreatmentDate
			ON InitialTreatmentDate.PatientCaseDateTypeID = 1
		LEFT JOIN @t_PatientCaseDate AS DateOfInjury
			ON DateOfInjury.PatientCaseDateTypeID = 2
		LEFT JOIN @t_PatientCaseDate AS DateOfSimilarInjury
			ON DateOfSimilarInjury.PatientCaseDateTypeID = 3
		LEFT JOIN @t_PatientCaseDate AS UnableToWorkDate
			ON UnableToWorkDate.PatientCaseDateTypeID = 4
		LEFT JOIN @t_PatientCaseDate AS DisabilityDate
			ON DisabilityDate.PatientCaseDateTypeID = 5
		LEFT JOIN @t_PatientCaseDate AS HospitalizationDate
			ON HospitalizationDate.PatientCaseDateTypeID = 6
		LEFT JOIN @t_PatientCaseDate AS LastMenstrualDate
			ON LastMenstrualDate.PatientCaseDateTypeID = 7
		LEFT JOIN @t_PatientCaseDate AS LastSeenDate
			ON LastSeenDate.PatientCaseDateTypeID = 8
		LEFT JOIN @t_PatientCaseDate AS ReferralDate
			ON ReferralDate.PatientCaseDateTypeID = 9
		LEFT JOIN @t_PatientCaseDate AS AcuteManifestationDate
			ON AcuteManifestationDate.PatientCaseDateTypeID = 10
		LEFT JOIN @t_PatientCaseDate AS LastXrayDate
			ON LastXrayDate.PatientCaseDateTypeID = 11
		LEFT JOIN @t_PatientCaseDate AS AccidentDate
			ON AccidentDate.PatientCaseDateTypeID = 12
	WHERE	PC.PatientCaseID = @PatientCaseID

	DELETE @t_PatientCaseDate

	-- case 8805: prepare Ordering Provider info for DME bills, if any:

	SELECT TOP 1 
		@OPFirstName = UPPER(OP.FirstName),
		@OPMiddleName = UPPER(OP.MiddleName),
		@OPLastName = UPPER(OP.LastName),
		@OPSuffix = UPPER(OP.Suffix),
		-- XSLT currently translates 24 to EI and 34 to SY so we need to map the qualifier back to these numbers for backward compatibility with v1 sproc
		@OPSSNQualifier = CASE @ReferringTaxIDQualifier
							WHEN 'EI' THEN '24' 
							WHEN 'SY' THEN '34' 
							ELSE '24' END,
		@OPSSN = CASE WHEN LEN(@ReferringTaxID) > 0 THEN @ReferringTaxID ELSE '' END,
		@OPUPIN = '',	-- obsolete so set this to empty string
		@OPNPI = @ReferringProviderNPI,
		@OPAddressLine1 = UPPER(OP.AddressLine1),
		@OPAddressLine2 = UPPER(OP.AddressLine2),
		@OPCity = UPPER(OP.City),
		@OPState = UPPER(OP.State),
		@OPZipCode = OP.ZipCode,
		@OPPhone = OP.WorkPhone
	FROM dbo.Encounter E
		LEFT OUTER JOIN Doctor OP
			ON OP.DoctorID = E.ReferringPhysicianID
	WHERE	E.EncounterID = @EncounterID



	-- case 8560 - get Ambulance Certification codes for the encounter:
	INSERT INTO @t_ambulancecertification
	SELECT TOP 5
		ACI.AmbulanceCertificationCode
	FROM AmbulanceCertificationInformation ACI
	WHERE ACI.EncounterID = @EncounterID
	AND aci.AmbulanceCertificationCode NOT IN ('02','03','60')
	ORDER BY ACI.AmbulanceCertificationCode


	------------------------------------------------------------------------------------------------------
	-- do whatever is needed to accommodate payer-specific requirements for this envelope:

	-- case 5492:
	IF (@PlanName LIKE 'BC/BS OF SOUTH CAROLINA-%')
	BEGIN
		SET @loop2010BB2U=SUBSTRING(@PlanName,CHARINDEX('-',@PlanName)+1,3)
	END
	ELSE IF @PayerNumber = 'BS028'
	BEGIN
		SELECT @loop2010BB2U  = SUBSTRING(UPPER(PI.PolicyNumber),1,3)
		FROM InsurancePolicy PI
		WHERE PI.InsurancePolicyID = @PayerInsurancePolicyID
	 END

	-- case 8396:
	--Hide Patient Paid Amount Payer Hack                                           
	IF EXISTS ( SELECT * from @PayerHacks where [Name] = 'Hide Patient Paid Amount')
 	    SET @hide_patient_paid_amount = 1

	------------------------------------------------------------------------------------------------------
	-- SF 12226 and SF 28487
	-- SF 67196, FB 24452/24028
	-- SF 71982 - bs031 for 122
	-- SF 71738 - 00511 for 801
	DECLARE @SumContractAdjustments bit
	SELECT @SumContractAdjustments = 0
	-- case 10711:
	--SumContractAdjustments Payer Hack                                           
	IF EXISTS ( SELECT * from @PayerHacks where [Name] = 'SumContractAdjustments')
	BEGIN
		SET @SumContractAdjustments = 1
	END

	------------------------------------------------------------------------------------------------------
	-- SF 31959, FB 23110
	-- SF 63750, FB 24028 ... expand this to other payers and customers

	-- This appears to be to set the AMT*AAE in the 2320 loop

	DECLARE @SumAllowedAmount bit
	DECLARE @IncludeZeroAllowedAmount bit
	DECLARE @SumPatientResponsibility bit
	DECLARE @IncludeZeroPatientResponsibilityAmount bit
	DECLARE @SumContractOtaf bit
	DECLARE @SumCobContractOtaf bit
	DECLARE @SumCobAllowedAmount bit
	DECLARE @IncludeZeroCobAllowedAmount bit
	DECLARE @IncludeZeroServiceLineApprovedAmount bit
	SET @SumAllowedAmount = 0
	SET @IncludeZeroAllowedAmount = 0
	SET @SumPatientResponsibility = 0
	SET @IncludeZeroPatientResponsibilityAmount = 0
	SET @SumCobAllowedAmount = 0
	SET @SumCobContractOtaf = 0
	SET @SumContractOtaf = 0
	SET @IncludeZeroCobAllowedAmount = 0
	SET @IncludeZeroServiceLineApprovedAmount = 0
	
	-- case 10711:
	--SumAllowedAmount Payer Hack                                           
	IF EXISTS ( SELECT * from @PayerHacks where [Name] = 'SumAllowedAmount')
	BEGIN
		SET @SumAllowedAmount = 1
	END

	-- CN1 for 71738 only for secondary claims
	IF @PayerResponsibilityCode = 'S' 
		AND ((@PayerNumber IN ('00511') AND @customer_id = 801)		-- SF 71738
			OR EXISTS(SELECT * FROM @PayerHacks WHERE [Name] = 'CN1ForSecondary'))
	BEGIN
		SET @SumContractOtaf = 1
	END
	
	-- pjh: 5-5-2008: we only do this now for MR017 for cust 203 and, for them, they need AMT*B6 instead of AMT*AAE in the 2320 loop
	-- SF case 68502 - cust 1227, payer BS031 needs AMT*B6 as well...
	--AMT*B6 Payer Hack                                           
	IF EXISTS ( SELECT * from @PayerHacks where [Name] = 'AMT*B6')
	BEGIN
		SET @SumCobAllowedAmount = 1
	END

	-- Patient Responsibility AMT*F2 in the 2320 loop
	--SumPatientResponsibility Payer Hack                                           
	IF EXISTS ( SELECT * from @PayerHacks where [Name] = 'SumPatientResponsibility')
	BEGIN
		SET @SumPatientResponsibility = 1
	END

	-- CN1 for 71738 only for secondary claims
	IF @PayerResponsibilityCode = 'S' 
		AND
		( 
			(@PayerNumber IN ('00511') AND @customer_id = 801)		-- SF 71738
			OR EXISTS(SELECT * FROM @PayerHacks WHERE [Name] = 'CN1ForSecondary')
	   )
	BEGIN
		SET @SumCobContractOtaf = 1
	END

	-- Some payers want 0 values to show up for the 2320 B6 and 2400 AAE
	-- SF 96881-- SF 100660-- SF 114957
	--Include Zero For B6 and AAE Payer Hack	                                                                                                                      
	IF @PayerResponsibilityCode = 'S' AND EXISTS ( SELECT * from @PayerHacks where [Name] = 'Include Zero For B6 and AAE')
	BEGIN
		SET @IncludeZeroCobAllowedAmount = 1
		SET @IncludeZeroServiceLineApprovedAmount = 1
	END
	------------------------------------------------------------------------------------------------------

	-- list all claims in the bill:
	INSERT INTO #ClaimBatch (ClaimID)
	SELECT C.ClaimID
	FROM	Bill_EDI B	
		INNER JOIN Claim RC
			ON RC.ClaimID = B.RepresentativeClaimID
		INNER JOIN BillClaim BC
			ON BC.BillID = B.BillID
				AND BC.BillBatchTypeCode = 'E'
		INNER JOIN Claim C
			ON C.ClaimID = BC.ClaimID
	WHERE	B.BillID = @bill_id
	
	
	;with cteDiagnosisList as
	(
		select *, RANK() over (partition by [SortOrder] order by EncounterProcedureID asc) as [NonUniqueSortOrder]
		from
		(
			select c.ClaimID,EP.EncounterProcedureID, DiagnosisCodeDictionaryID as DiagnosisCodeDictionaryID, 1 as [SortOrder]
			from #ClaimBatch AS CB
				INNER JOIN Claim C ON CB.ClaimID = C.ClaimID
				INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
				INNER JOIN dbo.EncounterDiagnosis ED ON ep.EncounterDiagnosisID1 = ed.EncounterDiagnosisID
				where EncounterDiagnosisID1 is not NULL
			union all
			select c.ClaimID,EP.EncounterProcedureID, DiagnosisCodeDictionaryID as DiagnosisCodeDictionaryID, 2 as [SortOrder]
			from #ClaimBatch AS CB
				INNER JOIN Claim C ON CB.ClaimID = C.ClaimID
				INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
				INNER JOIN dbo.EncounterDiagnosis ED ON ep.EncounterDiagnosisID2 = ed.EncounterDiagnosisID
			WHERE EncounterDiagnosisID2 is not null
			union all
			select c.ClaimID,EP.EncounterProcedureID, DiagnosisCodeDictionaryID as DiagnosisCodeDictionaryID, 3 as [SortOrder]
			from #ClaimBatch AS CB
				INNER JOIN Claim C ON CB.ClaimID = C.ClaimID
				INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
				INNER JOIN dbo.EncounterDiagnosis ED ON ep.EncounterDiagnosisID3 = ed.EncounterDiagnosisID
				where EncounterDiagnosisID3 is not null
			union all
			select c.ClaimID,EP.EncounterProcedureID, DiagnosisCodeDictionaryID as DiagnosisCodeDictionaryID, 4 as [SortOrder]
			from #ClaimBatch AS CB
				INNER JOIN Claim C ON CB.ClaimID = C.ClaimID
				INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
				INNER JOIN dbo.EncounterDiagnosis ED ON ep.EncounterDiagnosisID4 = ed.EncounterDiagnosisID
				where EncounterDiagnosisID4 is not NULL
	    ) as temp
	)

	INSERT INTO #ClaimBatchDiagnosesPointers (ClaimID, DiagnosisCode, Pointer )
	select claimid, Diagnosiscode, MIN(OrderedDiagnosis.DiagnosisIndex)
	FROM
	(
		select
		DiagnosisCodeDictionaryID,
		ROW_NUMBER() OVER (ORDER BY min(sortedOrder)) AS DiagnosisIndex
		FROM
		( SELECT claimid,DiagnosisCodeDictionaryID, ((([NonUniqueSortOrder] - 1) * 4) + [SortOrder]) sortedOrder
		from cteDiagnosisList
		) AS tmp
		GROUP BY tmp.DiagnosisCodeDictionaryID
	) AS OrderedDiagnosis
	INNER JOIN cteDiagnosisList ON OrderedDiagnosis.DiagnosisCodeDictionaryID = cteDiagnosisList.DiagnosisCodeDictionaryID
	INNER JOIN DiagnosisCodeDictionary DCD ON OrderedDiagnosis.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID
	GROUP BY claimid, Diagnosiscode
	
	SELECT @DiagnosisCode1 = [1],@DiagnosisCode2 = [2],@DiagnosisCode3 = [3],@DiagnosisCode4 = [4],@DiagnosisCode5 = [5],@DiagnosisCode6 = [6],@DiagnosisCode7 = [7],@DiagnosisCode8 = [8], @DiagnosisCode9 = [9], @DiagnosisCode10 = [10], @DiagnosisCode11 = [11], @DiagnosisCode12 = [12]
	FROM
	(	
		select Diagnosiscode, Pointer
		FROM #ClaimBatchDiagnosesPointers cbdp
		GROUP BY Diagnosiscode, Pointer
	
	) AS diagnosises
	PIVOT
	(
	MAX(DiagnosisCode)
	FOR Pointer IN ( [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
	) AS pivotDiagnosis

	------------------------------------------------------------------------------------------------------
	-- case 14089 - COB related variables

	SET @doCOB = CASE WHEN
--		@PayerSupportsSecondaryElectronicBilling=1 AND
		@PayerSupportsCoordinationOfBenefits=1 AND
--		@PracticeInsuranceUseSecondaryElectronicBilling=1 AND
		@PracticeInsuranceUseCoordinationOfBenefits=1
	THEN 1 ELSE 0 END

--	print '@PayerSupportsCoordinationOfBenefits=' + CAST(@PayerSupportsCoordinationOfBenefits AS varchar)
--	print '@PracticeInsuranceUseCoordinationOfBenefits=' + CAST(@PracticeInsuranceUseCoordinationOfBenefits AS varchar)
--	print '@doCOB=' + CAST(@doCOB AS varchar)

	-- loop 2320 - other subscriber information
	IF (@doCOB = 1)
	BEGIN
		-- get all Other Payers from the case into the "secondary" XML node
		INSERT INTO @t_cob_othersubscriber (
			InsurancePolicyID,
			[insured-different-than-patient-flag],
			[subscriber-first-name],
			[subscriber-middle-name],
			[subscriber-last-name],
			[subscriber-suffix],
			[subscriber-street-1],
			[subscriber-street-2],
			[subscriber-city],
			[subscriber-state],
			[subscriber-zip],
			[subscriber-country],
			[subscriber-birth-date],
			[subscriber-gender],
			[subscriber-assignment-of-benefits-flag],
			[subscriber-release-of-information-code],
			[relation-to-insured-code],
			[payer-responsibility-code],
			[payer-responsibility-code-order],
			[claim-filing-indicator-code],
			[plan-name],
			[insurance-type-code],
			[group-number],
			[policy-number],
			[payer-name],
			[payer-identifier-qualifier],			-- 'PI' for clearinghouse ID or 'XV' for NPI
			[payer-identifier],
			[payer-street-1],
			[payer-street-2],
			[payer-city],
			[payer-state],
			[payer-zip],
			[payer-country],
			[payer-secondary-id],
			[payer-contact-name],
			[payer-contact-phone],
			[payer-paid-flag],
			[payer-paid-amount]
		)
		SELECT PI.InsurancePolicyID,
			(CASE PI.PatientRelationshipToInsured WHEN 'S' THEN 0 ELSE 1 END)
				AS [insured-different-than-patient-flag],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.FirstName
				ELSE PI.HolderFirstName END)
				AS [subscriber-first-name],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.MiddleName
				ELSE PI.HolderMiddleName END)
				AS [subscriber-middle-name],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.Lastname
				ELSE PI.HolderLastName END)
				AS [subscriber-last-name],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.Suffix
				ELSE PI.HolderSuffix END)
				AS [subscriber-suffix],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.AddressLine1
				ELSE COALESCE(PI.HolderAddressLine1, P.ResponsibleAddressLine1) END)
				AS [subscriber-street-1],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.AddressLine2
				ELSE COALESCE(PI.HolderAddressLine2, P.ResponsibleAddressLine2) END)
				AS [subscriber-street-2],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.City
				ELSE COALESCE(PI.HolderCity, P.ResponsibleCity) END)
				AS [subscriber-city],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.State
				ELSE COALESCE(PI.HolderState, P.ResponsibleState) END)
				AS [subscriber-state],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.ZipCode
				ELSE COALESCE(PI.HolderZipCode, P.ResponsibleZipCode) END)
				AS [subscriber-zip],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN (CASE WHEN P.Country LIKE 'CA%' THEN 'CA' ELSE NULL END)
				ELSE (CASE WHEN COALESCE(PI.HolderCountry, P.ResponsibleCountry) LIKE 'CA%' THEN 'CA' ELSE NULL END) END)
				AS [subscriber-country],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.DOB
				ELSE PI.HolderDOB END)
				AS [subscriber-birth-date],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.Gender
				ELSE PI.HolderGender END)
				AS [subscriber-gender],
			PTIC.AcceptAssignment   AS [subscriber-assignment-of-benefits-flag],
			E.ReleaseOfInformationCode AS [subscriber-release-of-information-code],
			-- CASE PI.PatientRelationshipToInsured WHEN 'S' THEN '18' WHEN 'U' THEN '01' WHEN 'C' THEN '19' ELSE 'G8' END
			RS.IndividualRelationshipCode
				AS [relation-to-insured-code],
	--		CASE RPI.RealPrecedence WHEN 1 THEN 'P' WHEN 2 THEN 'S' WHEN 3 THEN 'T' WHEN 4 THEN 'A' WHEN 5 THEN 'B' WHEN 6 THEN 'C' WHEN 7 THEN 'D' ELSE 'E' END
			CASE RPI.RealPrecedence WHEN 1 THEN 'P' WHEN 2 THEN 'S' WHEN 3 THEN 'T' ELSE 'T' END 
				AS [payer-responsibility-code],
			CASE @SptSBROrdering WHEN 1 THEN
					CASE RPI.RealPrecedence WHEN 1 THEN 2 WHEN 2 THEN 1 WHEN 3 THEN 3 ELSE 3 END -- SBR segment order -> Primary = 2, Secondary = 1, Tertiary = 3
				ELSE
					PI.InsurancePolicyID
				END
				AS [payer-responsibility-code-order],
			IC.InsuranceProgramCode
				AS [claim-filing-indicator-code],
			UPPER(SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ICP.PlanName,'+',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' '),':',''),1,35)) AS [plan-name],
			case when IC.InsuranceProgramCode='MB' THEN IPT.InsuranceProgramTypeCode else '' end AS [insurance-type-code], --story 15 - if MB then insurancetypecode will be from the table. FB 3438, needs TO be EMPTY if NOT MB IN 5010 [SF 00274440 wanted C1 in 4010]
			UPPER(PI.GroupNumber) AS [group-number],
			UPPER(PI.PolicyNumber) AS [policy-number],
			CASE WHEN CPL.NameTransmitted IS NULL THEN UPPER(SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(IC.InsuranceCompanyName,'+',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' '),1,35)) ELSE UPPER(CPL.NameTransmitted) END AS [payer-name],
	--		CASE WHEN CPL.PayerNumber IS NULL THEN 'XV' ELSE 'PI' END AS [payer-identifier-qualifier],					-- 'PI' for clearinghouse ID or 'XV' for NPI
			CASE WHEN CPL.PayerNumber IS NULL THEN 'PI' ELSE 'PI' END AS [payer-identifier-qualifier],					-- 'PI' for clearinghouse ID or 'XV' for NPI
			ISNULL(CPL.PayerNumber,'999999999') AS [payer-identifier],

			UPPER(ICP.AddressLine1) AS [payer-street-1],
			UPPER(ICP.AddressLine2) AS [payer-street-2],
			UPPER(ICP.City) AS [payer-city],
			UPPER(ICP.State) AS [payer-state],
			ICP.ZipCode AS [payer-zip],
			CASE WHEN ICP.Country LIKE 'CA%' THEN 'CA' ELSE NULL END AS [payer-country],
			NULL AS [payer-secondary-id],

			UPPER(COALESCE(ICP.ContactFirstName + ' ', '')
				+ COALESCE(ICP.ContactMiddleName + ' ', '')
				+ COALESCE(ICP.ContactLastName, ''))
				AS [payer-contact-name],
			ICP.Phone AS [payer-contact-phone],
			dbo.BusinessRule_EDIBillPayerPaid(
				@bill_id, 
				ICP.InsuranceCompanyPlanID) 
				AS [payer-paid-flag],
			dbo.BusinessRule_EDIBillPayerPaidAmount(
				@bill_id,
				ICP.InsuranceCompanyPlanID)
				AS [payer-paid-amount]

		-- SELECT EP.ProcedureDateOfService, PI.*
		FROM Claim RC
			INNER JOIN Patient P
			ON P.PatientID = RC.PatientID
			INNER JOIN dbo.EncounterProcedure EP
			ON EP.EncounterProcedureID = RC.EncounterProcedureID
			INNER JOIN dbo.Encounter E
				ON E.EncounterID = EP.EncounterID
			INNER JOIN PatientCase PC 
			ON PC.PatientCaseID = E.PatientCaseID

			LEFT OUTER JOIN InsurancePolicy PI
			ON PI.PatientCaseID = PC.PatientCaseID AND PI.Active = 1
				 AND (PI.PolicyStartDate IS NULL OR PI.PolicyStartDate <= EP.ProcedureDateOfService)
				 AND (PI.PolicyEndDate IS NULL OR PI.PolicyEndDate >= EP.ProcedureDateOfService)
			LEFT JOIN dbo.InsuranceProgramType AS IPT
			ON ipt.InsuranceProgramTypeID = PI.InsuranceProgramTypeID
			INNER JOIN @t_realPrecedence RPI
			ON RPI.InsurancePolicyID = PI.InsurancePolicyID
			INNER JOIN Relationship RS
				ON RS.Relationship = PI.PatientRelationshipToInsured
			INNER JOIN InsuranceCompanyPlan ICP
				INNER JOIN InsuranceCompany IC 
				ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
				LEFT OUTER JOIN ClearinghousePayersList CPL
				ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID
 				LEFT OUTER JOIN PracticeToInsuranceCompany PTIC
 					ON PTIC.PracticeID = @PracticeID AND PTIC.InsuranceCompanyID = IC.InsuranceCompanyID
			ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID AND PI.InsurancePolicyID <> @PayerInsurancePolicyID
		WHERE	RC.ClaimID = @RepresentativeClaimID
		ORDER BY RPI.RealPrecedence

		-- clean-up the records that produce un-formattable loops.
		-- [payer-identifier] is NULL when an Insurance Company doesn't have a Payer Connection or is not enabled for e-claims
		DELETE @t_cob_othersubscriber WHERE [payer-identifier] IS NULL
	END

	-- some useful queries to consider when debugging:
	--   PatientDataProvider_GetInsurancePoliciesForPatientCase 14608
	--   PatientDataProvider_GetCaseDetailsForPatient 172464
	--   PatientDataProvider_GetInsurancePoliciesMostRecent 172464

	-- loop 2430 - service line adjudication information

	IF (@doCOB = 1)
	BEGIN
		OPEN cob_cursor

		FETCH NEXT FROM cob_cursor INTO @cob_othersubscriberTID, @cob_insurancePolicyID

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN

				INSERT INTO @t_cob_svcadjudication (
						othersubscriberTID,
						[adjudication-date],
						[comp-procedure-code],
						[date-of-service],
						[procedure-modifiers],
						[paid-amount],
						[paid-quantity],
						[assigned-number],
						PaymentID, PaymentClaimID, PracticeID, PatientID, EncounterID, ClaimID, EOBXml, Notes
				)
				SELECT
						@cob_othersubscriberTID AS othersubscriberTID,
						PMT.AdjudicationDate AS [adjudication-date],
						UPPER(ISNULL(CASE WHEN LEN(PCD.BillableCode)=0 THEN NULL ELSE PCD.BillableCode END,PCD.ProcedureCode)) AS [comp-procedure-code],
						EP.ProcedureDateOfService as [date-of-service],
						isnull(EP.ProcedureModifier1,'') + ';' + isnull(EP.ProcedureModifier2,'') + ';' + isnull(EP.ProcedureModifier3,'') + ';' + isnull(EP.ProcedureModifier4,'') as [procedure-modifiers],
						0 AS [paid-amount],
						0 AS [paid-quantity],
						0 AS [assigned-number],
						PMT.PaymentID, PC.PaymentClaimID, PC.PracticeID, PC.PatientID, PC.EncounterID, PC.ClaimID, PC.EOBXml, PC.Notes
				FROM   #ClaimBatch TC
						INNER JOIN Claim C
						ON C.ClaimID = TC.ClaimID
						INNER JOIN dbo.EncounterProcedure EP
						ON EP.EncounterProcedureID = C.EncounterProcedureID
						INNER JOIN ProcedureCodeDictionary PCD
						ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
						INNER JOIN dbo.Encounter E
						ON E.EncounterID = EP.EncounterID
						INNER JOIN PaymentClaim PC
						ON PC.ClaimID = TC.ClaimID
						INNER JOIN Payment PMT
						ON PC.PaymentID = PMT.PaymentID AND PMT.PayerTypeCode = 'I'
				WHERE PC.EOBXml.exist('/eob/insurancePolicyID') = 1 AND PC.EOBXml.value('(/eob/insurancePolicyID)[1]','int') = @cob_insurancePolicyID
									AND PC.EOBXml.value('(/eob/insurancePolicyID)[1]','int') IN (	-- SF 155384
											SELECT TRP1.InsurancePolicyID
											FROM @t_realPrecedence TRP1
											WHERE TRP1.RealPrecedence < (SELECT TOP 1 TRP2.RealPrecedence
												FROM @t_realPrecedence TRP2
												WHERE TRP2.InsurancePolicyID = @PayerInsurancePolicyID))

				-- <SF 26232>
				-- see if there is more than payment for this policy ... if so, we need to pare it down to one payment
				
--				-- debugging
--				SELECT 'Within cob_cursor processing', @cob_othersubscriberTID as [@cob_othersubscriberTID], @cob_insurancePolicyID as[@cob_insurancePolicyID], * from  @t_cob_svcadjudication

				DECLARE @countPaymentsPerInsurancePolicy int
				DECLARE @bestPaymentID int

				SELECT @countPaymentsPerInsurancePolicy = 0
				SELECT @countPaymentsPerInsurancePolicy = count(DISTINCT PaymentID) 
					FROM @t_cob_svcadjudication
					WHERE othersubscriberTID = @cob_othersubscriberTID

				-- only worry about it if there's more than one
				IF @countPaymentsPerInsurancePolicy > 1
				BEGIN
					DECLARE @compProcedureCode varchar(128)
					DECLARE @dateOfService datetime
					DECLARE @procedureModifiers varchar(128)

					DECLARE cob_26232_cursor CURSOR READ_ONLY
					FOR
						SELECT [comp-procedure-code], [date-of-service], [procedure-modifiers], othersubscriberTID  
						FROM @t_cob_svcadjudication 
						GROUP BY [comp-procedure-code], [date-of-service], [procedure-modifiers], othersubscriberTID 

					OPEN cob_26232_cursor

					FETCH NEXT FROM cob_26232_cursor INTO @compProcedureCode, @dateOfService, @procedureModifiers, @cob_othersubscriberTID

					WHILE (@@FETCH_STATUS = 0)
					BEGIN
						IF (@@fetch_status <> -2)
						BEGIN
--							-- debugging
--							SELECT 'ordered list of @t_cob_svcadjudication for this insurance - removing all but top row', @cob_othersubscriberTID as [@cob_othersubscriberTID], @compProcedureCode as [@compProcedureCode], @dateOfService as [@dateOfService], @procedureModifiers as [@procedureModifiers], EOBXml.value('(/eob/denial)[1]','bit') as Denial, *
--								FROM @t_cob_svcadjudication 
--								WHERE othersubscriberTID = @cob_othersubscriberTID AND [comp-procedure-code] = @compProcedureCode 
--								ORDER BY EOBXml.value('(/eob/denial)[1]','bit'), PaymentID DESC

							-- Basically sort the payments by "denial" so non-denials would be 0 and would sort before denials.
							--  If there are nothing but denials, just keep one of them
							--  If there are multiple payments, we'll still keep just one of them
							SELECT TOP 1 @bestPaymentID = PaymentID 
								FROM @t_cob_svcadjudication 
								WHERE othersubscriberTID = @cob_othersubscriberTID AND [comp-procedure-code] = @compProcedureCode AND [date-of-service] = @dateOfService AND [procedure-modifiers] = @procedureModifiers
								ORDER BY EOBXml.value('(/eob/denial)[1]','bit'), PaymentID DESC

							DELETE @t_cob_svcadjudication 
								WHERE othersubscriberTID = @cob_othersubscriberTID AND [comp-procedure-code] = @compProcedureCode AND [date-of-service] = @dateOfService AND [procedure-modifiers] = @procedureModifiers
									AND PaymentID <> @bestPaymentID 

--							-- debugging
--							SELECT 'Within cob_cursor processing - after delete', @bestPaymentID as [@bestPaymentID], @cob_othersubscriberTID as [@cob_othersubscriberTID], @cob_insurancePolicyID as[@cob_insurancePolicyID], * from  @t_cob_svcadjudication
						END
						FETCH NEXT FROM cob_26232_cursor INTO @compProcedureCode, @dateOfService, @procedureModifiers, @cob_othersubscriberTID
					END

					CLOSE cob_26232_cursor
					DEALLOCATE cob_26232_cursor		
						
				END
				-- </SF 26232>

				INSERT INTO @t_cob_svcadjustment_bg (
						svcadjudicationTID,
						[adjustment-type],
						[adjustment-amount],
						[adjustment-quantity],
						[adjustment-category],
						[adjustment-description]
				)
				SELECT
						TCSA.TID AS svcadjudicationTID,
						eboXML1.row.value('@type','varchar(128)') AS [adjustment-type],
						eboXML1.row.value('@amount','Money') AS [adjustment-amount],
						eboXML1.row.value('@units','decimal') AS [adjustment-quantity],				-- EP.ServiceUnitCount
						eboXML1.row.value('@category','varchar(128)') AS [adjustment-category],
						eboXML1.row.value('@description','varchar(256)') AS [adjustment-description]
				FROM   @t_cob_svcadjudication TCSA
						JOIN @t_cob_othersubscriber TCOS
						ON TCOS.TID = TCSA.othersubscriberTID
						CROSS APPLY TCSA.eobXML.nodes('/eob/items/item') AS eboXML1(row)
				WHERE TCSA.EOBXml.exist('/eob/insurancePolicyID') = 1 AND TCSA.EOBXml.value('(/eob/insurancePolicyID)[1]','int') = @cob_insurancePolicyID

			END
			FETCH NEXT FROM cob_cursor INTO @cob_othersubscriberTID, @cob_insurancePolicyID
		END

		CLOSE cob_cursor

		-- case 21341, 21459, 21460
		-- A2 replacement is FB 23825, SF 65973
		-- 42 replacement is FB 24188
		-- SF 150599 - Update @t_cob_svcadjustment_bg (instead of @t_cob_svcadjustment) so that grouping on [adjustment-description] is correct.
		UPDATE @t_cob_svcadjustment_bg SET [adjustment-description] = '45'
		WHERE ISNULL([adjustment-description],'')='' OR ISNULL([adjustment-description],'')='A2' OR ISNULL([adjustment-description],'')='42'

		-- phil 8/5/07 
		--   moved this indented section out of the cursor ... the cursor should only be used to find adjudication / adjustment info from each insurance
		--     Creating the svc adjustments should happen only once

		INSERT INTO @t_cob_svcadjustment (
				svcadjudicationTID,
				[adjustment-type],
				[adjustment-amount],
				[adjustment-quantity],
				[adjustment-category],
				[adjustment-description]
		)
		SELECT 
				svcadjudicationTID,
				[adjustment-type],
				SUM([adjustment-amount]),
				[adjustment-quantity],
				[adjustment-category],
				[adjustment-description]
		FROM @t_cob_svcadjustment_bg
		-- phil 7/23/07 - per FB 22127 ... need something like this where clause ... but that ain't it!
		--WHERE svcadjudicationTID = @cob_othersubscriberTID	
		GROUP BY [adjustment-description], [adjustment-category], [adjustment-type], [adjustment-quantity], svcadjudicationTID

		--DELETE @t_cob_svcadjustment
		--WHERE ISNULL([adjustment-description],'')=''

		-- case 21341, 21459, 21460
		-- A2 replacement is FB 23825, SF 65973
		-- 42 replacement is FB 24188
		UPDATE @t_cob_svcadjustment SET [adjustment-description] = '45'
		WHERE ISNULL([adjustment-description],'')='' OR ISNULL([adjustment-description],'')='A2' OR ISNULL([adjustment-description],'')='42'


		-- phil 8/5/07
		--   Now, these actions need to happen per cob_insurancePolicyId
		--		* updating paid-amount in svcadjudication
		--		* updating payer-paid-amount in othersubscriber
		--		* updating payer-paid-flag in othersubscriber
		OPEN cob_cursor

		FETCH NEXT FROM cob_cursor INTO @cob_othersubscriberTID, @cob_insurancePolicyID

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN

				UPDATE @t_cob_svcadjudication
				SET [paid-amount] = TCS.[adjustment-amount], [paid-quantity] = TCS.[adjustment-quantity]
				FROM @t_cob_svcadjudication TCSA JOIN @t_cob_svcadjustment TCS ON TCSA.TID = TCS.svcadjudicationTID AND TCS.[adjustment-type]='Paid'
				WHERE TCSA.othersubscriberTID = @cob_othersubscriberTID

				UPDATE @t_cob_othersubscriber
				SET [payer-paid-amount] = (SELECT SUM(TCSA.[paid-amount])
				FROM @t_cob_svcadjudication TCSA WHERE TCSA.othersubscriberTID = @cob_othersubscriberTID)
				WHERE TID = @cob_othersubscriberTID

				UPDATE @t_cob_othersubscriber
				SET [payer-allowed-amount] = (SELECT sum(TCSA.EOBXml.value('(/eob/items/item[@type="Allowed"]/@amount)[1]','money'))
				FROM @t_cob_svcadjudication TCSA WHERE TCSA.othersubscriberTID = @cob_othersubscriberTID)
				WHERE TID = @cob_othersubscriberTID

				UPDATE @t_cob_othersubscriber
				SET [patient-responsibility-amount] = (SELECT sum(TCSA.EOBXml.value('(/eob/items/item[@type="Reason" and @category="PR"]/@amount)[1]','money'))
				FROM @t_cob_svcadjudication TCSA WHERE TCSA.othersubscriberTID = @cob_othersubscriberTID)
				WHERE TID = @cob_othersubscriberTID

				UPDATE @t_cob_othersubscriber
				SET [payer-paid-flag] = CASE WHEN [payer-paid-amount] IS NULL THEN 0 ELSE 1 END
				WHERE TID = @cob_othersubscriberTID

			END
			FETCH NEXT FROM cob_cursor INTO @cob_othersubscriberTID, @cob_insurancePolicyID
		END

		CLOSE cob_cursor
		DEALLOCATE cob_cursor

		-- at this point @t_cob_svcadjustment table is filled, time to convert it to a "wide" version suitable for loop 2430 CAS segments:

		INSERT @t_cob_svcadjustment_w (
			[svcadjudicationTID],
			[adjustment-group-code],
			[adjustment-reason-1],
			[adjustment-amount-1],
			[adjustment-quantity-1],
			[adjustment-reason-2],
			[adjustment-amount-2],
			[adjustment-quantity-2],
			[adjustment-reason-3],
			[adjustment-amount-3],
			[adjustment-quantity-3],
			[adjustment-reason-4],
			[adjustment-amount-4],
			[adjustment-quantity-4],
			[adjustment-reason-5],
			[adjustment-amount-5],
			[adjustment-quantity-5],
			[adjustment-reason-6],
			[adjustment-amount-6],
			[adjustment-quantity-6]
	)
		SELECT
			TCS1.[svcadjudicationTID], TCS1.[adjustment-category],
			TCS1.[adjustment-description], TCS1.[adjustment-amount], CAST(TCS1.[adjustment-quantity] AS varchar(128)),
			TCS2.[adjustment-description], TCS2.[adjustment-amount], CAST(TCS2.[adjustment-quantity] AS varchar(128)),
			TCS3.[adjustment-description], TCS3.[adjustment-amount], CAST(TCS3.[adjustment-quantity] AS varchar(128)),
			TCS4.[adjustment-description], TCS4.[adjustment-amount], CAST(TCS4.[adjustment-quantity] AS varchar(128)),
			TCS5.[adjustment-description], TCS5.[adjustment-amount], CAST(TCS5.[adjustment-quantity] AS varchar(128)),
			TCS6.[adjustment-description], TCS6.[adjustment-amount], CAST(TCS6.[adjustment-quantity] AS varchar(128))
		FROM @t_cob_svcadjustment TCS1 
			LEFT OUTER JOIN @t_cob_svcadjustment TCS2 ON TCS1.[svcadjudicationTID] = TCS2.[svcadjudicationTID] AND TCS1.[adjustment-category] = TCS2.[adjustment-category] AND TCS1.TID < TCS2.TID
			LEFT OUTER JOIN @t_cob_svcadjustment TCS3 ON TCS1.[svcadjudicationTID] = TCS3.[svcadjudicationTID] AND TCS1.[adjustment-category] = TCS3.[adjustment-category] AND TCS2.TID < TCS3.TID
			LEFT OUTER JOIN @t_cob_svcadjustment TCS4 ON TCS1.[svcadjudicationTID] = TCS4.[svcadjudicationTID] AND TCS1.[adjustment-category] = TCS4.[adjustment-category] AND TCS3.TID < TCS4.TID
			LEFT OUTER JOIN @t_cob_svcadjustment TCS5 ON TCS1.[svcadjudicationTID] = TCS5.[svcadjudicationTID] AND TCS1.[adjustment-category] = TCS5.[adjustment-category] AND TCS4.TID < TCS5.TID
			LEFT OUTER JOIN @t_cob_svcadjustment TCS6 ON TCS1.[svcadjudicationTID] = TCS6.[svcadjudicationTID] AND TCS1.[adjustment-category] = TCS6.[adjustment-category] AND TCS5.TID < TCS6.TID
		WHERE TCS1.[adjustment-category] IN ('CO', 'CR', 'OA', 'PI', 'PR')
	--	ORDER BY 

		-- remove duplicates, leaving one entry per category per svcadjudicationTID:
		DELETE @t_cob_svcadjustment_w
		FROM @t_cob_svcadjustment_w TN LEFT JOIN
		 (SELECT [svcadjudicationTID], [adjustment-group-code], MIN(TID) TID
		  FROM @t_cob_svcadjustment_w GROUP BY [svcadjudicationTID], [adjustment-group-code]) FilteredTN 
		  ON TN.TID=FilteredTN.TID
		  WHERE FilteredTN.TID IS NULL

		UPDATE @t_cob_svcadjudication SET [paid-quantity] = CAST(1 AS decimal) WHERE [paid-quantity] = 0 OR [paid-quantity] IS NULL

--		-- SF 11947, FB 23105 - support AMT*AAE for BS033
--		-- SF 66664, FB 23972 - support AMT*AAE for BS031
		-- SF 65891, FB 24348 - support this for MR017
		--AMT*AAE Payer Hack                                           
		IF EXISTS ( SELECT * from @PayerHacks where [Name] = 'AMT*AAE')
		BEGIN
			UPDATE @t_cob_svcadjudication
			SET [approved-amount] = TCSA.EOBXml.value('(/eob/items/item[@type="Allowed"]/@amount)[1]','money')
			FROM @t_cob_svcadjudication TCSA
		END

		-- support AMT*B6 allowed amount (Approved Amt Qualifier) at the 2400 service line loop
		-- NOTE in SF 88888 Capario states that AMT*B6 is invalid in 2400 loop so this code should never be uncommented out
--		IF (@PayerNumber IN ('MR060'))	-- SF 88888
--		BEGIN
--			UPDATE @t_cob_svcadjudication
--			SET [allowed-amount] = TCSA.EOBXml.value('(/eob/items/item[@type="Allowed"]/@amount)[1]','money')
--			FROM @t_cob_svcadjudication TCSA
--		END	

--		select '@t_cob_svcadjudication', * from @t_cob_svcadjudication
--		select '@t_cob_svcadjustment_w', * from @t_cob_svcadjustment_w
--		select '@t_cob_othersubscriber', * from @t_cob_othersubscriber
--		select '@t_cob_svcadjustment', * from @t_cob_svcadjustment
--		select '@t_cob_svcadjustment_bg', * from @t_cob_svcadjustment_bg


		-- remove adjudications that have no adjustments (SF case 8679)
		-- does not help the cause though, as the AMT in the SBR loop requires presence of SVD with appropriate CAS segments anyway. 
--		DELETE @t_cob_svcadjudication
--		FROM @t_cob_svcadjudication TADJU LEFT JOIN @t_cob_svcadjustment_w TADJS
--		 ON TADJU.TID = TADJS.svcadjudicationTID
--		 WHERE TADJS.svcadjudicationTID IS NULL
	END

	------------------------------------------------------------------------------------------------------
	-- take care of CLIA number for loop 2300 - case 7531:

	-- first try the override (case 10733):
	SELECT TOP 1 @CliaNumber=L.CLIANumber
	FROM	#ClaimBatch TC
		INNER JOIN Claim C
		ON C.ClaimID = TC.ClaimID
		INNER JOIN dbo.EncounterProcedure EP
		ON EP.EncounterProcedureID = C.EncounterProcedureID
		INNER JOIN dbo.Encounter E
		ON E.EncounterID = EP.EncounterID
		INNER JOIN ServiceLocation L
		ON L.ServiceLocationID = E.LocationID
		INNER JOIN TypeOfService TOS
		ON TOS.TypeOfServiceCode = EP.TypeOfServiceCode
	WHERE	EP.TypeOfServiceCode = '5'		-- Diagnostic Laboratory

	-- not overriden, get the default, if any:
	IF (@CliaNumber IS NULL)
	BEGIN
		SELECT TOP 1 @CliaNumber=L.CLIANumber
		FROM	#ClaimBatch TC
			INNER JOIN Claim C
			ON C.ClaimID = TC.ClaimID
			INNER JOIN dbo.EncounterProcedure EP
			ON EP.EncounterProcedureID = C.EncounterProcedureID
			INNER JOIN dbo.Encounter E
			ON E.EncounterID = EP.EncounterID
			INNER JOIN ServiceLocation L
			ON L.ServiceLocationID = E.LocationID
			INNER JOIN ProcedureCodeDictionary PCD
			ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
			INNER JOIN TypeOfService TOS
			ON TOS.TypeOfServiceCode = PCD.TypeOfServiceCode
		WHERE	PCD.TypeOfServiceCode = '5'		-- Diagnostic Laboratory
	END

	DECLARE @SpinalManipulationFlag BIT
	DECLARE @SpinalConditionCode VARCHAR(1)
	DECLARE @SpinalXrayAvailabilityFlag VARCHAR(1)
	
	SET @SpinalManipulationFlag = 0

	-- Spinal Manipulation related SF 99703, 00213518
	IF @InsuranceProgramCode in ('MB', 'BL')
	AND ( 
			@customer_id = 2329 
			OR ( @customer_id = 5673 AND @PayerNumber = '00251' )
			OR ( @customer_id = 6606 AND @PayerNumber = '00836' )
			OR EXISTS (SELECT * FROM @PayerHacks WHERE [Name] = 'SpinalManipulation')
		)
	BEGIN
		-- Procedure code 98940, 98941, or 98942, 98943 with AT modifier or GY modifier
		IF EXISTS (	
			SELECT *
			FROM	#ClaimBatch TC
				INNER JOIN Claim C
				ON C.ClaimID = TC.ClaimID
				INNER JOIN dbo.EncounterProcedure EP
				ON EP.EncounterProcedureID = C.EncounterProcedureID
				INNER JOIN dbo.Encounter E
				ON E.EncounterID = EP.EncounterID
				INNER JOIN ProcedureCodeDictionary PCD
				ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
			WHERE
				((@InsuranceProgramCode = 'MB' AND (EP.ProcedureModifier1 IN ('AT','GY' ) OR 
													EP.ProcedureModifier2 IN ('AT','GY' ) OR 
													EP.ProcedureModifier3 IN ('AT','GY' ) OR 
													EP.ProcedureModifier4 IN ('AT','GY' )))	-- Only require AT modifier for MB
				OR ( @InsuranceProgramCode = 'BL' AND @customer_id = 2329 ) )
			AND PCD.ProcedureCode IN ('98940', '98941', '98942', '98943')
		)
		BEGIN
			SET @SpinalManipulationFlag = 1
			SET @SpinalConditionCode = 'M'
			SET @SpinalXrayAvailabilityFlag = 'Y'
		END			
	END
	
	DROP TABLE #ClaimBatch

	declare @ContractOtafAmount money
	declare @ContractCode varchar(2)
	set @ContractOtafAmount = null
	set @ContractCode = ''

--select '@t_cob_othersubscriber' as [@t_cob_othersubscriber], * from @t_cob_othersubscriber

	select @ContractOtafAmount = case when @SumContractOtaf = 1 then CAST(sum(isnull(COBOS.[payer-allowed-amount],0.0)) AS varchar(128)) else NULL end
	FROM	@t_cob_othersubscriber COBOS

--select @ContractOtafAmount as [@ContractOtafAmount], @SumContractOtaf as [@SumContractOtaf]

	-- CN104 will include the ContractCode in 2300 loop
	-- SF 113416
	IF @PayerNumber IN ('00049') OR ( @PayerNumber = 'MC030' AND @Customer_ID = 122 AND @PracticeID = 74 ) 
		OR EXISTS(SELECT * FROM @PayerHacks WHERE [Name] = 'CN104IncludeContractCode') -- 00241107
	BEGIN
		SET @ContractCode = 'G' -- Group, Primary Specialty code 082
	END
	
	-- Need to set the patient 'relation-to-insured' value (PAT01, 2000C)  -- SF 212510
	DECLARE @SetPAT01_2000C BIT
	SET @SetPAT01_2000C = 0
	
	IF EXISTS (SELECT * FROM @CustomerHacks WHERE NAME = 'PAT01_2000C_Fix')
	BEGIN
		SET @SetPAT01_2000C = 1
	END
	
	DECLARE @ForceServiceFacility BIT
	SET @ForceServiceFacility = 0
	
	IF (@PayerNumber IN ('BS022')		-- SF 153666 
		AND @customer_id IN ('3617')
		AND @ClearinghouseID = 1) 
		OR (@PayerNumber = 'MR018' AND @customer_id = 82 AND @PracticeID = 5 AND @PlaceOfServiceCode = '12')
		OR (@PayerNumber = '09102' AND @customer_id = 6305 AND @PlaceOfServiceCode = '12')
		OR EXISTS (SELECT * FROM @PayerHacks WHERE NAME = 'ForceServiceFacility')
		BEGIN
			SET @ForceServiceFacility = 1
		END
		

	------------------------------------------------------------------------------------------------------
	-- now get all XML in one big scoop:

	-- ST: TRANSACTION SET HEADER -- BHT
	SELECT	1 AS Tag, NULL AS Parent,
		CONVERT(VARCHAR,@customer_id) AS [transaction!1!customer-id], 
		CONVERT(VARCHAR,@PracticeID) AS [transaction!1!practice-id],
		2 as [transaction!1!claim-settings-edition],	-- Used for disabling some internal validation checks when using claim settings
		2 as [transaction!1!claim-type-id],				-- 0 for professional_4010, 1 for institutional_4010, 2 for professional_5010, 3 for insitutional_5010
		@RenderingTaxIDTypeID as [transaction!1!claim-settings-tax-id-type],
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id) AS [transaction!1!control-number],
		@ClearinghouseConnectionID AS [transaction!1!clearinghouse-connection-id],
		@RoutingPreference AS [transaction!1!routing-preference],
		BB.CreatedDate AS [transaction!1!created-date],
		@TransactionType AS [transaction!1!transaction-type],
		GETDATE() AS [transaction!1!current-date],

		@ProductionFlag  AS [transaction!1!production-flag],
		'' AS [transaction!1!interchange-authorization-id],
		'' AS [transaction!1!interchange-security-id],
		1  AS [transaction!1!original-transaction-flag],

		@SubmitterName AS [transaction!1!submitter-name],
		CASE WHEN @ClearinghouseID <> 3 THEN COALESCE(@RenderingSubmitterNumber, @SubmitterEtin) ELSE @SubmitterEtin END AS [transaction!1!submitter-etin],
		@RenderingSubmitterNumber AS [transaction!1!submitter-id],
		@SubmitterContactName AS [transaction!1!submitter-contact-name],
		@SubmitterContactPhone AS [transaction!1!submitter-contact-phone],
		@SubmitterContactEmail AS [transaction!1!submitter-contact-email],
		@SubmitterContactFax AS [transaction!1!submitter-contact-fax],
		@ReceiverName AS [transaction!1!receiver-name],
		@ReceiverEtin AS [transaction!1!receiver-etin],

		@SuppressRenderingProviderForASC AS [transaction!1!SuppressRenderingProviderForASC],
		@ForcePatientAddressIn2310C AS [transaction!1!ForcePatientAddressIn2310C],
		@PopulatePSsegment AS [transaction!1!PopulatePSsegment],
		
		NULL AS [billing!2!biller-type],
		NULL AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!country],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],
		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-country],
		NULL AS [billing!2!paytopo-name],
		NULL AS [billing!2!paytopo-street-1],
		NULL AS [billing!2!paytopo-street-2],
		NULL AS [billing!2!paytopo-city],
		NULL AS [billing!2!paytopo-state],
		NULL AS [billing!2!paytopo-zipcode],
		NULL AS [billing!2!paytopo-country],
	
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
		NULL as [billing!2!group-taxonomy-code],
		NULL AS [subscriber!3!subscriber-id],
		NULL AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!insurance-type-code],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier-qualifier],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!payer-country],
		NULL AS [subscriber!3!payer-secondary-id],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [subscriber!3!responsible-country],
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [subscriber!3!relation-to-insured-code],
		NULL AS [patient!4!patient-id],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!country],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [patient!4!relation-to-insured],
		NULL AS [patient!4!property-casualty-claim-number],
		NULL AS [claim!2300!claim-id],
		NULL AS [claim!2300!control-number],
		NULL AS [claim!2300!total-claim-amount],
		NULL AS [claim!2300!place-of-service-code],
		NULL AS [claim!2300!provider-signature-flag],
		NULL AS [claim!2300!medicare-assignment-code],
		NULL AS [claim!2300!assignment-of-benefits-flag],
		NULL AS [claim!2300!release-of-information-code],
		NULL AS [claim!2300!patient-signature-source-code],
		NULL AS [claim!2300!auto-accident-related-flag],
		NULL AS [claim!2300!abuse-related-flag],
		NULL AS [claim!2300!pregnancy-related-flag],
		NULL AS [claim!2300!employment-related-flag],
		NULL AS [claim!2300!other-accident-related-flag],
		NULL AS [claim!2300!auto-accident-state],
		NULL AS [claim!2300!special-program-code],
		NULL AS [claim!2300!initial-treatment-date],
		NULL AS [claim!2300!last-menstrual-date],
		NULL AS [claim!2300!referral-date],
		NULL AS [claim!2300!last-seen-date],
		NULL AS [claim!2300!current-illness-date],
		NULL AS [claim!2300!acute-manifestation-date],
		NULL AS [claim!2300!similar-illness-date],
		NULL AS [claim!2300!accident-date],
		NULL AS [claim!2300!last-xray-date],
		NULL AS [claim!2300!disability-begin-date],
		NULL AS [claim!2300!disability-end-date],
		NULL AS [claim!2300!last-worked-date],
		NULL AS [claim!2300!return-to-work-date],
		NULL AS [claim!2300!hospitalization-begin-date],
		NULL AS [claim!2300!hospitalization-end-date],
		NULL AS [claim!2300!pwk-attachment-report-type-code],
		NULL AS [claim!2300!pwk-attachment-control-number],
		NULL AS [claim!2300!patient-paid-amount],
		NULL AS [claim!2300!authorization-number],
		NULL AS [claim!2300!referral-number],
		NULL AS [claim!2300!diagnosis-1],
		NULL AS [claim!2300!diagnosis-2],
		NULL AS [claim!2300!diagnosis-3],
		NULL AS [claim!2300!diagnosis-4],
		NULL AS [claim!2300!diagnosis-5],
		NULL AS [claim!2300!diagnosis-6],
		NULL AS [claim!2300!diagnosis-7],
		NULL AS [claim!2300!diagnosis-8],
		NULL AS [claim!2300!diagnosis-9],
		NULL AS [claim!2300!diagnosis-10],
		NULL AS [claim!2300!diagnosis-11],
		NULL AS [claim!2300!diagnosis-12],
		NULL AS [claim!2300!clia-number],
		NULL AS [claim!2300!referring-provider-flag],
		NULL AS [claim!2300!referring-provider-first-name],
		NULL AS [claim!2300!referring-provider-middle-name],
		NULL AS [claim!2300!referring-provider-last-name],
		NULL AS [claim!2300!referring-provider-suffix],
		NULL AS [claim!2300!referring-provider-upin],
		NULL AS [claim!2300!referring-provider-npi],
		NULL AS [claim!2300!supervising-provider-flag],
		NULL AS [claim!2300!supervising-provider-first-name],
		NULL AS [claim!2300!supervising-provider-middle-name],
		NULL AS [claim!2300!supervising-provider-last-name],
		NULL AS [claim!2300!supervising-provider-suffix],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-npi],
		NULL AS [claim!2300!supervising-provider-id-qualifier],
		NULL AS [claim!2300!supervising-provider-id-number],
		NULL AS [claim!2300!rendering-provider-first-name],
		NULL AS [claim!2300!rendering-provider-middle-name],
		NULL AS [claim!2300!rendering-provider-last-name],
		NULL AS [claim!2300!rendering-provider-suffix],
		NULL AS [claim!2300!rendering-provider-ssn-qual],
		NULL AS [claim!2300!rendering-provider-ssn],
		NULL AS [claim!2300!rendering-provider-upin],
		NULL AS [claim!2300!rendering-provider-npi],
		NULL AS [claim!2300!rendering-provider-specialty-code],
		NULL AS [claim!2300!service-facility-name],
		NULL AS [claim!2300!service-facility-street-1],
		NULL AS [claim!2300!service-facility-street-2],
		NULL AS [claim!2300!service-facility-city],
		NULL AS [claim!2300!service-facility-state],
		NULL AS [claim!2300!service-facility-zip],
		NULL AS [claim!2300!service-facility-country],
		NULL AS [claim!2300!service-facility-id],
		NULL AS [claim!2300!service-facility-id-qualifier],
		NULL AS [claim!2300!service-facility-npi],
		NULL AS [claim!2300!service-facility-force-output],
		NULL AS [claim!2300!service-facility-phone],
		NULL AS [claim!2300!service-facility-phone-ext],
		NULL AS [claim!2300!file-information],
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!hipaa-delay-reason-code],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL  AS [claim!2300!ambulance-pickup-address1],
		NULL  AS [claim!2300!ambulance-pickup-address2],
		NULL  AS [claim!2300!ambulance-pickup-city],
		NULL  AS [claim!2300!ambulance-pickup-state],
		NULL  AS [claim!2300!ambulance-pickup-zipcode],
		NULL  AS [claim!2300!ambulance-fromcountry],
		NULL  AS [claim!2300!ambulance-address-dropoff],
		NULL  AS [claim!2300!ambulance-dropoff-address1],
		NULL  AS [claim!2300!ambulance-dropoff-address2],
		NULL  AS [claim!2300!ambulance-dropoff-city],
		NULL  AS [claim!2300!ambulance-dropoff-state],
		NULL  AS [claim!2300!ambulance-dropoff-zipcode],
		NULL  AS [claim!2300!ambulance-dropoff-country],
		NULL AS [claim!2300!ambulance-purpose-roundtrip],
		NULL AS [claim!2300!ambulance-purpose-stretcher],
		NULL AS [claim!2300!ambulance-condition-1],
		NULL AS [claim!2300!ambulance-condition-2],
		NULL AS [claim!2300!ambulance-condition-3],
		NULL AS [claim!2300!ambulance-condition-4],
		NULL AS [claim!2300!ambulance-condition-5],
		NULL AS [claim!2300!epsdt-referral-given],
		NULL AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		NULL AS [claim!2300!mammography-certification-number],
		NULL AS [claim!2300!contract-otaf-amount],
		NULL AS [claim!2300!contract-code],
		NULL AS [claim!2300!spinal-manipulation-flag],
		NULL AS [claim!2300!spinal-condition-code],
		NULL AS [claim!2300!spinal-xray-availability-flag],
		NULL AS [claim!2300!dcn],
		NULL AS [claim!2300!submit-reason-code], 
		NULL AS [otherpayercob!2320!insurance-policy-id],
		NULL AS [otherpayercob!2320!sum-patient-responsibility],
		NULL AS [otherpayercob!2320!sum-contract-adjustments],
		NULL AS [otherpayercob!2320!insured-different-than-patient-flag],
		NULL AS [otherpayercob!2320!subscriber-first-name],
		NULL AS [otherpayercob!2320!subscriber-middle-name],
		NULL AS [otherpayercob!2320!subscriber-last-name],
		NULL AS [otherpayercob!2320!subscriber-suffix],
		NULL AS [otherpayercob!2320!subscriber-street-1],
		NULL AS [otherpayercob!2320!subscriber-street-2],
		NULL AS [otherpayercob!2320!subscriber-city],
		NULL AS [otherpayercob!2320!subscriber-state],
		NULL AS [otherpayercob!2320!subscriber-zip],
		NULL AS [otherpayercob!2320!subscriber-country],
		NULL AS [otherpayercob!2320!subscriber-birth-date],
		NULL AS [otherpayercob!2320!subscriber-gender],
		NULL AS [otherpayercob!2320!subscriber-assignment-of-benefits-flag],
		NULL AS [otherpayercob!2320!subscriber-release-of-information-code],
		NULL AS [otherpayercob!2320!relation-to-insured-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code-order],
		NULL AS [otherpayercob!2320!claim-filing-indicator-code],
		NULL AS [otherpayercob!2320!plan-name],
		NULL AS [otherpayercob!2320!insurance-type-code],
		NULL AS [otherpayercob!2320!group-number],
		NULL AS [otherpayercob!2320!policy-number],
		NULL AS [otherpayercob!2320!payer-name],
		NULL AS [otherpayercob!2320!payer-identifier-qualifier],
		NULL AS [otherpayercob!2320!payer-identifier],
		NULL AS [otherpayercob!2320!payer-street-1],
		NULL AS [otherpayercob!2320!payer-street-2],
		NULL AS [otherpayercob!2320!payer-city],
		NULL AS [otherpayercob!2320!payer-state],
		NULL AS [otherpayercob!2320!payer-zip],
		NULL AS [otherpayercob!2320!payer-country],
		NULL AS [otherpayercob!2320!payer-secondary-id],
		NULL AS [otherpayercob!2320!payer-contact-name],
		NULL AS [otherpayercob!2320!payer-contact-phone],
		NULL AS [otherpayercob!2320!payer-paid-flag],
		NULL AS [otherpayercob!2320!payer-paid-amount],
		NULL AS [otherpayercob!2320!payer-allowed-amount],
		NULL AS [otherpayercob!2320!payer-cob-allowed-amount],
		NULL AS [otherpayercob!2320!patient-responsibility-amount],
		NULL as [otherpayercob!2320!include-zero-payer-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-cob-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-patient-responsibility-amount],
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!referring-clia-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!drug-ndc-code],
		NULL AS [service!2400!drug-quantity],
		NULL AS [service!2400!drug-units-of-measure],
		NULL AS [service!2400!drug-ref-qualifier],
		NULL AS [service!2400!drug-ref-identifier],
		NULL AS [service!2400!measurement-reference-id-code],
		NULL AS [service!2400!measurement-qualifier],
		NULL AS [service!2400!measurement-value],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!emergency-related-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
		NULL AS [service!2400!hospice-employee-indicator],
		NULL AS [service!2400!dme-flag],
		NULL AS [service!2400!ordering-provider-first-name],
		NULL AS [service!2400!ordering-provider-middle-name],
		NULL AS [service!2400!ordering-provider-last-name],
		NULL AS [service!2400!ordering-provider-suffix],
		NULL AS [service!2400!ordering-provider-ssn-qual],
		NULL AS [service!2400!ordering-provider-ssn],
		NULL AS [service!2400!ordering-provider-upin],
		NULL AS [service!2400!ordering-provider-npi],
		NULL AS [service!2400!ordering-provider-addressline1],
		NULL AS [service!2400!ordering-provider-addressline2],
		NULL AS [service!2400!ordering-provider-city],
		NULL AS [service!2400!ordering-provider-state],
		NULL AS [service!2400!ordering-provider-zipcode],
		NULL AS [service!2400!ordering-provider-phone],
		NULL AS [service!2400!service-note-code],
		NULL AS [service!2400!service-note],
		NULL AS [service!2400!noc-service-note],
		NULL AS [service!2400!contract-otaf-amount],
		NULL AS [service!2400!allowed-amount],
		NULL AS [service!2400!approved-amount],
		NULL AS [service!2400!include-zero-approved-amount],
		NULL AS [adjudication!2430!adjudication-id],
		NULL AS [adjudication!2430!payer-identifier],
		NULL AS [adjudication!2430!monetary-amount],
		NULL AS [adjudication!2430!procedure-code],
		NULL AS [adjudication!2430!quantity],
		NULL AS [adjudication!2430!adjudication-date],
		NULL AS [adjudication!2430!kareo-payment-id],
		NULL AS [adjudication!2430!payer-adjusted-flag],
		NULL AS [adjudication!2430!assigned-number],
		NULL AS [adjustment!243001!adjustment-id],
		NULL AS [adjustment!243001!adjustment-group-code],
		NULL AS [adjustment!243001!adjustment-reason-1],
		NULL AS [adjustment!243001!adjustment-amount-1],
		NULL AS [adjustment!243001!adjustment-quantity-1],
		NULL AS [adjustment!243001!adjustment-reason-2],
		NULL AS [adjustment!243001!adjustment-amount-2],
		NULL AS [adjustment!243001!adjustment-quantity-2],
		NULL AS [adjustment!243001!adjustment-reason-3],
		NULL AS [adjustment!243001!adjustment-amount-3],
		NULL AS [adjustment!243001!adjustment-quantity-3],
		NULL AS [adjustment!243001!adjustment-reason-4],
		NULL AS [adjustment!243001!adjustment-amount-4],
		NULL AS [adjustment!243001!adjustment-quantity-4],
		NULL AS [adjustment!243001!adjustment-reason-5],
		NULL AS [adjustment!243001!adjustment-amount-5],
		NULL AS [adjustment!243001!adjustment-quantity-5],
		NULL AS [adjustment!243001!adjustment-reason-6],
		NULL AS [adjustment!243001!adjustment-amount-6],
		NULL AS [adjustment!243001!adjustment-quantity-6],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id]

	FROM	BillBatch BB
	WHERE	BillBatchID = @batch_id
	-- END OF ST: TRANSACTION SET HEADER -- BHT

	UNION ALL

	-- BILLING/PAY-TO PROVIDER LOOP (2010AA 2010AB)
	SELECT	2, 1,
		CONVERT(VARCHAR,@customer_id) AS [transaction!1!customer-id], 
		CONVERT(VARCHAR,@PracticeID) AS [transaction!1!practice-id],
		2 as [transaction!1!claim-settings-edition], 
		NULL as [transaction!1!claim-type-id],
		@RenderingTaxIDTypeID as [transaction!1!claim-settings-tax-id-type],
		CONVERT(VARCHAR,@batch_id)  AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!transaction-type],
		NULL AS [transaction!1!current-date],

		NULL AS [transaction!1!production-flag],
		NULL AS [transaction!1!interchange-authorization-id],
		NULL AS [transaction!1!interchange-security-id],
		NULL AS [transaction!1!original-transaction-flag],

		NULL AS [transaction!1!submitter-name],
		NULL AS [transaction!1!submitter-etin],
		NULL AS [transaction!1!submitter-id],
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],
		
		NULL AS [transaction!1!SuppressRenderingProviderForASC],
		NULL AS [transaction!1!ForcePatientAddressIn2310C],
		NULL AS [transaction!1!PopulatePSsegment],

		@BillerType AS [billing!2!biller-type],		-- 1 or 2
		@PracticeID AS [billing!2!billing-id],
		
		
		UPPER(@OverridePracticeName) AS [billing!2!name],
		/* Original code that was replaced
		
		CASE WHEN @IndividualBilling = 0 THEN UPPER(PR.AddressLine1) ELSE UPPER(D.AddressLine1) END AS [billing!2!street-1],
		CASE WHEN @IndividualBilling = 0 THEN UPPER(PR.AddressLine2) ELSE UPPER(D.AddressLine2) END AS [billing!2!street-2],
		CASE WHEN @IndividualBilling = 0 THEN UPPER(PR.City) ELSE UPPER(D.City) END AS [billing!2!city],
		CASE WHEN @IndividualBilling = 0 THEN UPPER(PR.State) ELSE UPPER(D.State) END AS [billing!2!state],
		PR.ZipCode AS [billing!2!zip],
		CASE WHEN PR.Country LIKE 'CA%' THEN 'CA' ELSE NULL END AS [billing!2!country],
		*/

		-- Per Adren -> if override exists - always use the override (even if doctor is set as individual billing)
		CASE @OverridePracticeAddressFlag WHEN 1 THEN UPPER(@OverridePracticeAddressLine1) ELSE CASE WHEN @IndividualBilling = 0 THEN UPPER(PR.AddressLine1) ELSE UPPER(D.AddressLine1) END END AS [billing!2!street-1],
		CASE @OverridePracticeAddressFlag WHEN 1 THEN UPPER(@OverridePracticeAddressLine2) ELSE CASE WHEN @IndividualBilling = 0 THEN UPPER(PR.AddressLine2) ELSE UPPER(D.AddressLine2) END END AS [billing!2!street-2],
		CASE @OverridePracticeAddressFlag WHEN 1 THEN UPPER(@OverridePracticeCity) ELSE CASE WHEN @IndividualBilling = 0 THEN UPPER(PR.City) ELSE UPPER(D.City) END END AS [billing!2!city],
		CASE @OverridePracticeAddressFlag WHEN 1 THEN UPPER(@OverridePracticeState) ELSE CASE WHEN @IndividualBilling = 0 THEN UPPER(PR.State) ELSE UPPER(D.State) END END AS [billing!2!state],
		CASE @OverridePracticeAddressFlag WHEN 1 THEN @OverridePracticeZipCode ELSE CASE WHEN @individualBilling = 0 THEN PR.ZipCode ELSE D.ZipCode END END AS [billing!2!zip],
		CASE WHEN PR.Country LIKE 'CA%' THEN 'CA' ELSE NULL END AS [billing!2!country],
				
		'XX' AS [billing!2!ein-qualifier],							-- This indicates NPI
		@BillerIdent AS [billing!2!ein],
		
		/*
		Original code that was replaced
		
		UPPER(PR.Name) AS [billing!2!payto-name],
		UPPER(PR.AddressLine1) AS [billing!2!payto-street-1],
		UPPER(PR.AddressLine2) AS [billing!2!payto-street-2],
		UPPER(PR.City) AS [billing!2!payto-city],
		UPPER(PR.State) AS [billing!2!payto-state],
		PR.ZipCode AS [billing!2!payto-zip],
		CASE WHEN PR.Country LIKE 'CA%' THEN 'CA' ELSE NULL END AS [billing!2!payto-country],
		*/
		
		UPPER(@OverridePracticeName) AS [billing!2!payto-name],
		UPPER(@OverridePracticeAddressLine1) AS [billing!2!payto-street-1],
		UPPER(@OverridePracticeAddressLine2) AS [billing!2!payto-street-2],
		UPPER(@OverridePracticeCity) AS [billing!2!payto-city],
		UPPER(@OverridePracticeState) AS [billing!2!payto-state],
		@OverridePracticeZipCode AS [billing!2!payto-zip],
		CASE WHEN @OverridePracticeCountry LIKE 'CA%' THEN 'CA' ELSE NULL END AS [billing!2!payto-country],
		
		CASE @OverridePayToAddress 
			WHEN 0 THEN LEFT(UPPER(@EnablePayToName), 35)
			WHEN 1 THEN LEFT(UPPER(@EnableGlobalPayToName), 35)
			ELSE NULL END 
			AS [billing!2!paytopo-name],
		
		CASE @OverridePayToAddress 
			WHEN 0 THEN LEFT(UPPER(@EnablePayToAddressLine1), 55)
			WHEN 1 THEN LEFT(UPPER(@EnableGlobalPayToAddressLine1), 55) 
			ELSE NULL END 
			AS [billing!2!paytopo-street-1],
		
		CASE @OverridePayToAddress 
			WHEN 0 THEN LEFT(UPPER(@EnablePayToAddressLine2),55)
			WHEN 1 THEN LEFT(UPPER(@EnableGlobalPayToAddressLine2), 55) 
			ELSE NULL END 
			AS [billing!2!paytopo-street-2],
		
		CASE @OverridePayToAddress 
			WHEN 0 THEN LEFT(UPPER(@EnablePayToCity), 30)
			WHEN 1 THEN LEFT(UPPER(@EnableGlobalPayToCity), 30)
			ELSE NULL END 
			AS [billing!2!paytopo-city],
			
		CASE @OverridePayToAddress 
			WHEN 0 THEN UPPER(@EnablePayToState) 
			WHEN 1 THEN UPPER(@EnableGlobalPayToState)
			ELSE NULL END 
			AS [billing!2!paytopo-state],
			
		CASE @OverridePayToAddress 
			WHEN 0 THEN @EnablePayToZipcode 
			WHEN 1 THEN @EnableGlobalPayToZipcode 
			ELSE NULL END 
			AS [billing!2!paytopo-zipcode],
			
		CASE @OverridePayToAddress 
			WHEN 0 THEN @EnablePayToCountry 
			WHEN 1 THEN @EnableGlobalPayToCountry 
			ELSE NULL 
		END AS [billing!2!paytopo-country],
		
		
		@RenderingTaxID AS [billing!2!payto-ein],
		@PaytoNPI AS [billing!2!payto-npi],
		@GroupTaxonomyCode AS [billing!2!group-taxonomy-code],		-- SF 85862, some payers need the group taxonomy code here when billing as a group
		NULL AS [subscriber!3!subscriber-id],
		NULL AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!insurance-type-code],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier-qualifier],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!payer-country],
		NULL AS [subscriber!3!payer-secondary-id],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [subscriber!3!responsible-country],
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [subscriber!3!relation-to-insured-code],
		NULL AS [patient!4!patient-id],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!country],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [patient!4!relation-to-insured],
		NULL AS [patient!4!property-casualty-claim-number],
		NULL AS [claim!2300!claim-id],
		NULL AS [claim!2300!control-number],
		NULL AS [claim!2300!total-claim-amount],
		NULL AS [claim!2300!place-of-service-code],
		NULL AS [claim!2300!provider-signature-flag],
		NULL AS [claim!2300!medicare-assignment-code],
		NULL AS [claim!2300!assignment-of-benefits-flag],
		NULL AS [claim!2300!release-of-information-code],
		NULL AS [claim!2300!patient-signature-source-code],
		NULL AS [claim!2300!auto-accident-related-flag],
		NULL AS [claim!2300!abuse-related-flag],
		NULL AS [claim!2300!pregnancy-related-flag],
		NULL AS [claim!2300!employment-related-flag],
		NULL AS [claim!2300!other-accident-related-flag],
		NULL AS [claim!2300!auto-accident-state],
		NULL AS [claim!2300!special-program-code],
		NULL AS [claim!2300!initial-treatment-date],
		NULL AS [claim!2300!last-menstrual-date],
		NULL AS [claim!2300!referral-date],
		NULL AS [claim!2300!last-seen-date],
		NULL AS [claim!2300!current-illness-date],
		NULL AS [claim!2300!acute-manifestation-date],
		NULL AS [claim!2300!similar-illness-date],
		NULL AS [claim!2300!accident-date],
		NULL AS [claim!2300!last-xray-date],
		NULL AS [claim!2300!disability-begin-date],
		NULL AS [claim!2300!disability-end-date],
		NULL AS [claim!2300!last-worked-date],
		NULL AS [claim!2300!return-to-work-date],
		NULL AS [claim!2300!hospitalization-begin-date],
		NULL AS [claim!2300!hospitalization-end-date],
		NULL AS [claim!2300!pwk-attachment-report-type-code],
		NULL AS [claim!2300!pwk-attachment-control-number],
		NULL AS [claim!2300!patient-paid-amount],
		NULL AS [claim!2300!authorization-number],
		NULL AS [claim!2300!referral-number],
		NULL AS [claim!2300!diagnosis-1],
		NULL AS [claim!2300!diagnosis-2],
		NULL AS [claim!2300!diagnosis-3],
		NULL AS [claim!2300!diagnosis-4],
		NULL AS [claim!2300!diagnosis-5],
		NULL AS [claim!2300!diagnosis-6],
		NULL AS [claim!2300!diagnosis-7],
		NULL AS [claim!2300!diagnosis-8],
		NULL AS [claim!2300!diagnosis-9],
		NULL AS [claim!2300!diagnosis-10],
		NULL AS [claim!2300!diagnosis-11],
		NULL AS [claim!2300!diagnosis-12],
		NULL AS [claim!2300!clia-number],
		NULL AS [claim!2300!referring-provider-flag],
		NULL AS [claim!2300!referring-provider-first-name],
		NULL AS [claim!2300!referring-provider-middle-name],
		NULL AS [claim!2300!referring-provider-last-name],
		NULL AS [claim!2300!referring-provider-suffix],
		NULL AS [claim!2300!referring-provider-upin],
		NULL AS [claim!2300!referring-provider-npi],
		NULL AS [claim!2300!supervising-provider-flag],
		NULL AS [claim!2300!supervising-provider-first-name],
		NULL AS [claim!2300!supervising-provider-middle-name],
		NULL AS [claim!2300!supervising-provider-last-name],
		NULL AS [claim!2300!supervising-provider-suffix],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-npi],
		NULL AS [claim!2300!supervising-provider-id-qualifier],
		NULL AS [claim!2300!supervising-provider-id-number],
		NULL AS [claim!2300!rendering-provider-first-name],
		NULL AS [claim!2300!rendering-provider-middle-name],
		NULL AS [claim!2300!rendering-provider-last-name],
		NULL AS [claim!2300!rendering-provider-suffix],
		NULL AS [claim!2300!rendering-provider-ssn-qual],
		NULL AS [claim!2300!rendering-provider-ssn],
		NULL AS [claim!2300!rendering-provider-upin],
		NULL AS [claim!2300!rendering-provider-npi],
		NULL AS [claim!2300!rendering-provider-specialty-code],
		NULL AS [claim!2300!service-facility-name],
		NULL AS [claim!2300!service-facility-street-1],
		NULL AS [claim!2300!service-facility-street-2],
		NULL AS [claim!2300!service-facility-city],
		NULL AS [claim!2300!service-facility-state],
		NULL AS [claim!2300!service-facility-zip],
		NULL AS [claim!2300!service-facility-country],
		NULL AS [claim!2300!service-facility-id],
		NULL AS [claim!2300!service-facility-id-qualifier],
		NULL AS [claim!2300!service-facility-npi],
		NULL AS [claim!2300!service-facility-force-output],
		NULL AS [claim!2300!service-facility-phone],
		NULL AS [claim!2300!service-facility-phone-ext],
		NULL AS [claim!2300!file-information],
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!hipaa-delay-reason-code],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL  AS [claim!2300!ambulance-pickup-address1],
		NULL  AS [claim!2300!ambulance-pickup-address2],
		NULL  AS [claim!2300!ambulance-pickup-city],
		NULL  AS [claim!2300!ambulance-pickup-state],
		NULL  AS [claim!2300!ambulance-pickup-zipcode],
		NULL  AS [claim!2300!ambulance-fromcountry],
		NULL  AS [claim!2300!ambulance-address-dropoff],
		NULL  AS [claim!2300!ambulance-dropoff-address1],
		NULL  AS [claim!2300!ambulance-dropoff-address2],
		NULL  AS [claim!2300!ambulance-dropoff-city],
		NULL  AS [claim!2300!ambulance-dropoff-state],
		NULL  AS [claim!2300!ambulance-dropoff-zipcode],
		NULL  AS [claim!2300!ambulance-dropoff-country],
		NULL AS [claim!2300!ambulance-purpose-roundtrip],
		NULL AS [claim!2300!ambulance-purpose-stretcher],
		NULL AS [claim!2300!ambulance-condition-1],
		NULL AS [claim!2300!ambulance-condition-2],
		NULL AS [claim!2300!ambulance-condition-3],
		NULL AS [claim!2300!ambulance-condition-4],
		NULL AS [claim!2300!ambulance-condition-5],
		NULL AS [claim!2300!epsdt-referral-given],
		NULL AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		NULL AS [claim!2300!mammography-certification-number],
		NULL AS [claim!2300!contract-otaf-amount],
		NULL AS [claim!2300!contract-code],
		NULL AS [claim!2300!spinal-manipulation-flag],
		NULL AS [claim!2300!spinal-condition-code],
		NULL AS [claim!2300!spinal-xray-availability-flag],
		NULL AS [claim!2300!dcn],
		NULL AS [claim!2300!submit-reason-code], 
		NULL AS [otherpayercob!2320!insurance-policy-id],
		NULL AS [otherpayercob!2320!sum-patient-responsibility],
		NULL AS [otherpayercob!2320!sum-contract-adjustments],
		NULL AS [otherpayercob!2320!insured-different-than-patient-flag],
		NULL AS [otherpayercob!2320!subscriber-first-name],
		NULL AS [otherpayercob!2320!subscriber-middle-name],
		NULL AS [otherpayercob!2320!subscriber-last-name],
		NULL AS [otherpayercob!2320!subscriber-suffix],
		NULL AS [otherpayercob!2320!subscriber-street-1],
		NULL AS [otherpayercob!2320!subscriber-street-2],
		NULL AS [otherpayercob!2320!subscriber-city],
		NULL AS [otherpayercob!2320!subscriber-state],
		NULL AS [otherpayercob!2320!subscriber-zip],
		NULL AS [otherpayercob!2320!subscriber-country],
		NULL AS [otherpayercob!2320!subscriber-birth-date],
		NULL AS [otherpayercob!2320!subscriber-gender],
		NULL AS [otherpayercob!2320!subscriber-assignment-of-benefits-flag],
		NULL AS [otherpayercob!2320!subscriber-release-of-information-code],
		NULL AS [otherpayercob!2320!relation-to-insured-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code-order],
		NULL AS [otherpayercob!2320!claim-filing-indicator-code],
		NULL AS [otherpayercob!2320!plan-name],
		NULL AS [otherpayercob!2320!insurance-type-code],
		NULL AS [otherpayercob!2320!group-number],
		NULL AS [otherpayercob!2320!policy-number],
		NULL AS [otherpayercob!2320!payer-name],
		NULL AS [otherpayercob!2320!payer-identifier-qualifier],
		NULL AS [otherpayercob!2320!payer-identifier],
		NULL AS [otherpayercob!2320!payer-street-1],
		NULL AS [otherpayercob!2320!payer-street-2],
		NULL AS [otherpayercob!2320!payer-city],
		NULL AS [otherpayercob!2320!payer-state],
		NULL AS [otherpayercob!2320!payer-zip],
		NULL AS [otherpayercob!2320!payer-country],
		NULL AS [otherpayercob!2320!payer-secondary-id],
		NULL AS [otherpayercob!2320!payer-contact-name],
		NULL AS [otherpayercob!2320!payer-contact-phone],
		NULL AS [otherpayercob!2320!payer-paid-flag],
		NULL AS [otherpayercob!2320!payer-paid-amount],
		NULL AS [otherpayercob!2320!payer-allowed-amount],
		NULL AS [otherpayercob!2320!payer-cob-allowed-amount],
		NULL AS [otherpayercob!2320!patient-responsibility-amount],
		NULL as [otherpayercob!2320!include-zero-payer-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-cob-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-patient-responsibility-amount],
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!referring-clia-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!drug-ndc-code],
		NULL AS [service!2400!drug-quantity],
		NULL AS [service!2400!drug-units-of-measure],
		NULL AS [service!2400!drug-ref-qualifier],
		NULL AS [service!2400!drug-ref-identifier],
		NULL AS [service!2400!measurement-reference-id-code],
		NULL AS [service!2400!measurement-qualifier],
		NULL AS [service!2400!measurement-value],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!emergency-related-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
		NULL AS [service!2400!hospice-employee-indicator],
		NULL AS [service!2400!dme-flag],
		NULL AS [service!2400!ordering-provider-first-name],
		NULL AS [service!2400!ordering-provider-middle-name],
		NULL AS [service!2400!ordering-provider-last-name],
		NULL AS [service!2400!ordering-provider-suffix],
		NULL AS [service!2400!ordering-provider-ssn-qual],
		NULL AS [service!2400!ordering-provider-ssn],
		NULL AS [service!2400!ordering-provider-upin],
		NULL AS [service!2400!ordering-provider-npi],
		NULL AS [service!2400!ordering-provider-addressline1],
		NULL AS [service!2400!ordering-provider-addressline2],
		NULL AS [service!2400!ordering-provider-city],
		NULL AS [service!2400!ordering-provider-state],
		NULL AS [service!2400!ordering-provider-zipcode],
		NULL AS [service!2400!ordering-provider-phone],
		NULL AS [service!2400!service-note-code],
		NULL AS [service!2400!service-note],
		NULL AS [service!2400!noc-service-note],
		NULL AS [service!2400!contract-otaf-amount],
		NULL AS [service!2400!allowed-amount],
		NULL AS [service!2400!approved-amount],
		NULL AS [service!2400!include-zero-approved-amount],
		NULL AS [adjudication!2430!adjudication-id],
		NULL AS [adjudication!2430!payer-identifier],
		NULL AS [adjudication!2430!monetary-amount],
		NULL AS [adjudication!2430!procedure-code],
		NULL AS [adjudication!2430!quantity],
		NULL AS [adjudication!2430!adjudication-date],
		NULL AS [adjudication!2430!kareo-payment-id],
		NULL AS [adjudication!2430!payer-adjusted-flag],
		NULL AS [adjudication!2430!assigned-number],
		NULL AS [adjustment!243001!adjustment-id],
		NULL AS [adjustment!243001!adjustment-group-code],
		NULL AS [adjustment!243001!adjustment-reason-1],
		NULL AS [adjustment!243001!adjustment-amount-1],
		NULL AS [adjustment!243001!adjustment-quantity-1],
		NULL AS [adjustment!243001!adjustment-reason-2],
		NULL AS [adjustment!243001!adjustment-amount-2],
		NULL AS [adjustment!243001!adjustment-quantity-2],
		NULL AS [adjustment!243001!adjustment-reason-3],
		NULL AS [adjustment!243001!adjustment-amount-3],
		NULL AS [adjustment!243001!adjustment-quantity-3],
		NULL AS [adjustment!243001!adjustment-reason-4],
		NULL AS [adjustment!243001!adjustment-amount-4],
		NULL AS [adjustment!243001!adjustment-quantity-4],
		NULL AS [adjustment!243001!adjustment-reason-5],
		NULL AS [adjustment!243001!adjustment-amount-5],
		NULL AS [adjustment!243001!adjustment-quantity-5],
		NULL AS [adjustment!243001!adjustment-reason-6],
		NULL AS [adjustment!243001!adjustment-amount-6],
		NULL AS [adjustment!243001!adjustment-quantity-6],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id]

	FROM	BillBatch BB
		INNER JOIN Practice PR
		ON PR.PracticeID = BB.PracticeID
		INNER JOIN Doctor D
		ON D.DoctorID = @RenderingProviderID
	WHERE	BB.BillBatchID = @batch_id
	-- END OF BILLING/PAY-TO PROVIDER LOOP (2010AA 2010AB)

	UNION ALL

	-- SUBSCRIBER HIERARCHICAL LEVEL - LOOP 2000
	SELECT	3, 2,
		CONVERT(VARCHAR,@customer_id) AS [transaction!1!customer-id], 
		CONVERT(VARCHAR,@PracticeID) AS [transaction!1!practice-id],
		2 as [transaction!1!claim-settings-edition], 
		NULL as [transaction!1!claim-type-id],
		@RenderingTaxIDTypeID as [transaction!1!claim-settings-tax-id-type],
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!transaction-type],
		NULL AS [transaction!1!current-date],

		NULL AS [transaction!1!production-flag],
		NULL AS [transaction!1!interchange-authorization-id],
		NULL AS [transaction!1!interchange-security-id],
		NULL AS [transaction!1!original-transaction-flag],

		NULL AS [transaction!1!submitter-name],
		NULL AS [transaction!1!submitter-etin],
		NULL AS [transaction!1!submitter-id],
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],
		
		NULL AS [transaction!1!SuppressRenderingProviderForASC],
		NULL AS [transaction!1!ForcePatientAddressIn2310C],
		NULL AS [transaction!1!PopulatePSsegment],

		@BillerType AS [billing!2!biller-type],
		@PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!country],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],
		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-country],
		NULL AS [billing!2!paytopo-name],
		NULL AS [billing!2!paytopo-street-1],
		NULL AS [billing!2!paytopo-street-2],
		NULL AS [billing!2!paytopo-city],
		NULL AS [billing!2!paytopo-state],
		NULL AS [billing!2!paytopo-zipcode],
		NULL AS [billing!2!paytopo-country],
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
		NULL as [billing!2!group-taxonomy-code],
		@PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
--
-- per FB 22522 any code below that you see that follows the pattern
--     CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' ELSE <original code> END
--   is handling the following case:
--     The @PayerInsurancePolicyID is not in the precedence table.  What used to happen was that GetEdiBillXml would simply fault.
--     Per fb 22522, we now return "ERROR" in some key strings so that we can catch this at validation time

		CASE WHEN RPI.RealPrecedence is NULL 
			THEN 'ERROR' 
			ELSE UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.FirstName
				ELSE (CASE WHEN PI.HolderFirstName is NULL 
					THEN P.ResponsibleFirstName 
					ELSE PI.HolderFirstName 
					END) 
				END) 
			END
			AS [subscriber!3!first-name],
		CASE WHEN RPI.RealPrecedence is NULL 
			THEN 'ERROR' 
			ELSE UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.MiddleName
				ELSE (CASE WHEN PI.HolderMiddleName is NULL 
					THEN P.ResponsibleMiddleName 
					ELSE PI.HolderMiddleName 
					END) 
				END) 
			END
			AS [subscriber!3!middle-name],
		CASE WHEN RPI.RealPrecedence is NULL 
			THEN 'ERROR' 
			ELSE UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.LastName
				ELSE (CASE WHEN PI.HolderLastName is NULL 
					THEN P.ResponsibleLastName 
					ELSE PI.HolderLastName 
					END) 
				END) 
			END
			AS [subscriber!3!last-name],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.Suffix
				ELSE (CASE WHEN PI.HolderSuffix is NULL 
					THEN P.ResponsibleSuffix 
					ELSE PI.HolderSuffix 
					END) 
				END) 
			AS [subscriber!3!suffix],
		(CASE PI.PatientRelationshipToInsured WHEN 'S' THEN 0 ELSE 1 END)
			AS [subscriber!3!insured-different-than-patient-flag],
--		CASE RPI.RealPrecedence WHEN 1 THEN 'P' WHEN 2 THEN 'S' WHEN 3 THEN 'T' WHEN 4 THEN 'A' WHEN 5 THEN 'B' WHEN 6 THEN 'C' WHEN 7 THEN 'D' ELSE 'E' END
	    CASE WHEN @doCOB=1 THEN (CASE RPI.RealPrecedence WHEN 1 THEN 'P' WHEN 2 THEN 'S' WHEN 3 THEN 'T' ELSE 'T' END) ELSE 'P' END
		-- B.PayerResponsibilityCode 
			AS [subscriber!3!payer-responsibility-code],
--		UPPER(CPL.NameTransmitted) AS [subscriber!3!plan-name],
		UPPER(SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ICP.PlanName,'+',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' '),':',''),1,35)) AS [subscriber!3!plan-name],
		CASE WHEN IC.InsuranceProgramCode = 'MB' AND RPI.RealPrecedence > 1 THEN IPT.InsuranceProgramTypeCode ELSE '' END AS [subscriber!3!insurance-type-code],
		CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' ELSE UPPER(PI.GroupNumber) END AS [subscriber!3!group-number],
		CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' ELSE UPPER(PI.PolicyNumber) END AS [subscriber!3!policy-number],
		CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' WHEN CPL.PayerNumber IN ( '00000', '00010' ) THEN ICP.PlanName ELSE UPPER(CPL.NameTransmitted) END AS [subscriber!3!payer-name],
		'PI' AS [subscriber!3!payer-identifier-qualifier],				-- 'PI' for clearinghouse ID or 'XV' for NPI
		CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' WHEN @MedicaidSecondaryPayerMask = 1 THEN '620' ELSE UPPER(CPL.PayerNumber) END AS [subscriber!3!payer-identifier],
		UPPER(ICP.AddressLine1) AS [subscriber!3!payer-street-1],
		UPPER(ICP.AddressLine2) AS [subscriber!3!payer-street-2],
		UPPER(ICP.City) AS [subscriber!3!payer-city],
		UPPER(ICP.State) AS [subscriber!3!payer-state],
		ICP.ZipCode AS [subscriber!3!payer-zip],
		CASE WHEN ICP.Country LIKE 'CA%' THEN 'CA' ELSE NULL END AS [subscriber!3!payer-country],
		@loop2010BB2U AS [subscriber!3!payer-secondary-id],
		CASE PI.PatientRelationshipToInsured WHEN 'S' THEN 0 ELSE 1	END	-- SF 139174, FB 1332
			AS [subscriber!3!responsible-different-than-patient-flag],
		UPPER(PI.HolderFirstName) 
			AS [subscriber!3!responsible-first-name],
		UPPER(PI.HolderMiddleName) 
			AS [subscriber!3!responsible-middle-name],
		UPPER(PI.HolderLastName) 
			AS [subscriber!3!responsible-last-name],
		UPPER(PI.HolderSuffix) AS [subscriber!3!responsible-suffix],
		UPPER(PI.HolderAddressLine1)
			AS [subscriber!3!responsible-street-1],
		UPPER(PI.HolderAddressLine2)
			AS [subscriber!3!responsible-street-2],
		UPPER(PI.HolderCity) AS [subscriber!3!responsible-city],
		UPPER(PI.HolderState) AS [subscriber!3!responsible-state],
		PI.HolderZipCode AS [subscriber!3!responsible-zip],
		CASE WHEN PI.HolderCountry LIKE 'CA%' THEN 'CA' ELSE NULL END AS [subscriber!3!responsible-country],
		@InsuranceProgramCode AS [subscriber!3!claim-filing-indicator-code],
		-- CASE PI.PatientRelationshipToInsured WHEN 'S' THEN '18' WHEN 'U' THEN '01' WHEN 'C' THEN '19' ELSE 'G8' END
		CASE PI.PatientRelationshipToInsured WHEN 'S' THEN '18' ELSE NULL END
		--RS.IndividualRelationshipCode
			 AS [subscriber!3!relation-to-insured-code],
		NULL AS [patient!4!patient-id],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!country],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [patient!4!relation-to-insured],
		NULL AS [patient!4!property-casualty-claim-number],
		NULL AS [claim!2300!claim-id],
		NULL AS [claim!2300!control-number],
		NULL AS [claim!2300!total-claim-amount],
		NULL AS [claim!2300!place-of-service-code],
		NULL AS [claim!2300!provider-signature-flag],
		NULL AS [claim!2300!medicare-assignment-code],
		NULL AS [claim!2300!assignment-of-benefits-flag],
		NULL AS [claim!2300!release-of-information-code],
		NULL AS [claim!2300!patient-signature-source-code],
		NULL AS [claim!2300!auto-accident-related-flag],
		NULL AS [claim!2300!abuse-related-flag],
		NULL AS [claim!2300!pregnancy-related-flag],
		NULL AS [claim!2300!employment-related-flag],
		NULL AS [claim!2300!other-accident-related-flag],
		NULL AS [claim!2300!auto-accident-state],
		NULL AS [claim!2300!special-program-code],
		NULL AS [claim!2300!initial-treatment-date],
		NULL AS [claim!2300!last-menstrual-date],
		NULL AS [claim!2300!referral-date],
		NULL AS [claim!2300!last-seen-date],
		NULL AS [claim!2300!current-illness-date],
		NULL AS [claim!2300!acute-manifestation-date],
		NULL AS [claim!2300!similar-illness-date],
		NULL AS [claim!2300!accident-date],
		NULL AS [claim!2300!last-xray-date],
		NULL AS [claim!2300!disability-begin-date],
		NULL AS [claim!2300!disability-end-date],
		NULL AS [claim!2300!last-worked-date],
		NULL AS [claim!2300!return-to-work-date],
		NULL AS [claim!2300!hospitalization-begin-date],
		NULL AS [claim!2300!hospitalization-end-date],
		NULL AS [claim!2300!pwk-attachment-report-type-code],
		NULL AS [claim!2300!pwk-attachment-control-number],
		NULL AS [claim!2300!patient-paid-amount],
		NULL AS [claim!2300!authorization-number],
		NULL AS [claim!2300!referral-number],
		NULL AS [claim!2300!diagnosis-1],
		NULL AS [claim!2300!diagnosis-2],
		NULL AS [claim!2300!diagnosis-3],
		NULL AS [claim!2300!diagnosis-4],
		NULL AS [claim!2300!diagnosis-5],
		NULL AS [claim!2300!diagnosis-6],
		NULL AS [claim!2300!diagnosis-7],
		NULL AS [claim!2300!diagnosis-8],
		NULL AS [claim!2300!diagnosis-9],
		NULL AS [claim!2300!diagnosis-10],
		NULL AS [claim!2300!diagnosis-11],
		NULL AS [claim!2300!diagnosis-12],
		NULL AS [claim!2300!clia-number],
		NULL AS [claim!2300!referring-provider-flag],
		NULL AS [claim!2300!referring-provider-first-name],
		NULL AS [claim!2300!referring-provider-middle-name],
		NULL AS [claim!2300!referring-provider-last-name],
		NULL AS [claim!2300!referring-provider-suffix],
		NULL AS [claim!2300!referring-provider-upin],
		NULL AS [claim!2300!referring-provider-npi],
		NULL AS [claim!2300!supervising-provider-flag],
		NULL AS [claim!2300!supervising-provider-first-name],
		NULL AS [claim!2300!supervising-provider-middle-name],
		NULL AS [claim!2300!supervising-provider-last-name],
		NULL AS [claim!2300!supervising-provider-suffix],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-npi],
		NULL AS [claim!2300!supervising-provider-id-qualifier],
		NULL AS [claim!2300!supervising-provider-id-number],
		NULL AS [claim!2300!rendering-provider-first-name],
		NULL AS [claim!2300!rendering-provider-middle-name],
		NULL AS [claim!2300!rendering-provider-last-name],
		NULL AS [claim!2300!rendering-provider-suffix],
		NULL AS [claim!2300!rendering-provider-ssn-qual],
		NULL AS [claim!2300!rendering-provider-ssn],
		NULL AS [claim!2300!rendering-provider-upin],
		NULL AS [claim!2300!rendering-provider-npi],
		NULL AS [claim!2300!rendering-provider-specialty-code],
		NULL AS [claim!2300!service-facility-name],
		NULL AS [claim!2300!service-facility-street-1],
		NULL AS [claim!2300!service-facility-street-2],
		NULL AS [claim!2300!service-facility-city],
		NULL AS [claim!2300!service-facility-state],
		NULL AS [claim!2300!service-facility-zip],
		NULL AS [claim!2300!service-facility-country],
		NULL AS [claim!2300!service-facility-id],
		NULL AS [claim!2300!service-facility-id-qualifier],
		NULL AS [claim!2300!service-facility-npi],
		NULL AS [claim!2300!service-facility-force-output],
		NULL AS [claim!2300!service-facility-phone],
		NULL AS [claim!2300!service-facility-phone-ext],
		NULL AS [claim!2300!file-information],
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!hipaa-delay-reason-code],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL  AS [claim!2300!ambulance-pickup-address1],
		NULL  AS [claim!2300!ambulance-pickup-address2],
		NULL  AS [claim!2300!ambulance-pickup-city],
		NULL  AS [claim!2300!ambulance-pickup-state],
		NULL  AS [claim!2300!ambulance-pickup-zipcode],
		NULL  AS [claim!2300!ambulance-fromcountry],
		NULL  AS [claim!2300!ambulance-address-dropoff],
		NULL  AS [claim!2300!ambulance-dropoff-address1],
		NULL  AS [claim!2300!ambulance-dropoff-address2],
		NULL  AS [claim!2300!ambulance-dropoff-city],
		NULL  AS [claim!2300!ambulance-dropoff-state],
		NULL  AS [claim!2300!ambulance-dropoff-zipcode],
		NULL  AS [claim!2300!ambulance-dropoff-country],
		NULL AS [claim!2300!ambulance-purpose-roundtrip],
		NULL AS [claim!2300!ambulance-purpose-stretcher],
		NULL AS [claim!2300!ambulance-condition-1],
		NULL AS [claim!2300!ambulance-condition-2],
		NULL AS [claim!2300!ambulance-condition-3],
		NULL AS [claim!2300!ambulance-condition-4],
		NULL AS [claim!2300!ambulance-condition-5],
		NULL AS [claim!2300!epsdt-referral-given],
		NULL AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		NULL AS [claim!2300!mammography-certification-number],
		NULL AS [claim!2300!contract-otaf-amount],
		NULL AS [claim!2300!contract-code],
		NULL AS [claim!2300!spinal-manipulation-flag],
		NULL AS [claim!2300!spinal-condition-code],
		NULL AS [claim!2300!spinal-xray-availability-flag],
		NULL AS [claim!2300!dcn],
		NULL AS [claim!2300!submit-reason-code], 
		NULL AS [otherpayercob!2320!insurance-policy-id],
		NULL AS [otherpayercob!2320!sum-patient-responsibility],
		NULL AS [otherpayercob!2320!sum-contract-adjustments],
		NULL AS [otherpayercob!2320!insured-different-than-patient-flag],
		NULL AS [otherpayercob!2320!subscriber-first-name],
		NULL AS [otherpayercob!2320!subscriber-middle-name],
		NULL AS [otherpayercob!2320!subscriber-last-name],
		NULL AS [otherpayercob!2320!subscriber-suffix],
		NULL AS [otherpayercob!2320!subscriber-street-1],
		NULL AS [otherpayercob!2320!subscriber-street-2],
		NULL AS [otherpayercob!2320!subscriber-city],
		NULL AS [otherpayercob!2320!subscriber-state],
		NULL AS [otherpayercob!2320!subscriber-zip],
		NULL AS [otherpayercob!2320!subscriber-country],
		NULL AS [otherpayercob!2320!subscriber-birth-date],
		NULL AS [otherpayercob!2320!subscriber-gender],
		NULL AS [otherpayercob!2320!subscriber-assignment-of-benefits-flag],
		NULL AS [otherpayercob!2320!subscriber-release-of-information-code],
		NULL AS [otherpayercob!2320!relation-to-insured-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code-order],
		NULL AS [otherpayercob!2320!claim-filing-indicator-code],
		NULL AS [otherpayercob!2320!plan-name],
		NULL AS [otherpayercob!2320!insurance-type-code],
		NULL AS [otherpayercob!2320!group-number],
		NULL AS [otherpayercob!2320!policy-number],
		NULL AS [otherpayercob!2320!payer-name],
		NULL AS [otherpayercob!2320!payer-identifier-qualifier],
		NULL AS [otherpayercob!2320!payer-identifier],
		NULL AS [otherpayercob!2320!payer-street-1],
		NULL AS [otherpayercob!2320!payer-street-2],
		NULL AS [otherpayercob!2320!payer-city],
		NULL AS [otherpayercob!2320!payer-state],
		NULL AS [otherpayercob!2320!payer-zip],
		NULL AS [otherpayercob!2320!payer-country],
		NULL AS [otherpayercob!2320!payer-secondary-id],
		NULL AS [otherpayercob!2320!payer-contact-name],
		NULL AS [otherpayercob!2320!payer-contact-phone],
		NULL AS [otherpayercob!2320!payer-paid-flag],
		NULL AS [otherpayercob!2320!payer-paid-amount],
		NULL AS [otherpayercob!2320!payer-allowed-amount],
		NULL AS [otherpayercob!2320!payer-cob-allowed-amount],
		NULL AS [otherpayercob!2320!patient-responsibility-amount],
		NULL as [otherpayercob!2320!include-zero-payer-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-cob-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-patient-responsibility-amount],
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!referring-clia-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!drug-ndc-code],
		NULL AS [service!2400!drug-quantity],
		NULL AS [service!2400!drug-units-of-measure],
		NULL AS [service!2400!drug-ref-qualifier],
		NULL AS [service!2400!drug-ref-identifier],
		NULL AS [service!2400!measurement-reference-id-code],
		NULL AS [service!2400!measurement-qualifier],
		NULL AS [service!2400!measurement-value],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!emergency-related-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
		NULL AS [service!2400!hospice-employee-indicator],
		NULL AS [service!2400!dme-flag],
		NULL AS [service!2400!ordering-provider-first-name],
		NULL AS [service!2400!ordering-provider-middle-name],
		NULL AS [service!2400!ordering-provider-last-name],
		NULL AS [service!2400!ordering-provider-suffix],
		NULL AS [service!2400!ordering-provider-ssn-qual],
		NULL AS [service!2400!ordering-provider-ssn],
		NULL AS [service!2400!ordering-provider-upin],
		NULL AS [service!2400!ordering-provider-npi],
		NULL AS [service!2400!ordering-provider-addressline1],
		NULL AS [service!2400!ordering-provider-addressline2],
		NULL AS [service!2400!ordering-provider-city],
		NULL AS [service!2400!ordering-provider-state],
		NULL AS [service!2400!ordering-provider-zipcode],
		NULL AS [service!2400!ordering-provider-phone],
		NULL AS [service!2400!service-note-code],
		NULL AS [service!2400!service-note],
		NULL AS [service!2400!noc-service-note],
		NULL AS [service!2400!contract-otaf-amount],
		NULL AS [service!2400!allowed-amount],
		NULL AS [service!2400!approved-amount],
		NULL AS [service!2400!include-zero-approved-amount],
		NULL AS [adjudication!2430!adjudication-id],
		NULL AS [adjudication!2430!payer-identifier],
		NULL AS [adjudication!2430!monetary-amount],
		NULL AS [adjudication!2430!procedure-code],
		NULL AS [adjudication!2430!quantity],
		NULL AS [adjudication!2430!adjudication-date],
		NULL AS [adjudication!2430!kareo-payment-id],
		NULL AS [adjudication!2430!payer-adjusted-flag],
		NULL AS [adjudication!2430!assigned-number],
		NULL AS [adjustment!243001!adjustment-id],
		NULL AS [adjustment!243001!adjustment-group-code],
		NULL AS [adjustment!243001!adjustment-reason-1],
		NULL AS [adjustment!243001!adjustment-amount-1],
		NULL AS [adjustment!243001!adjustment-quantity-1],
		NULL AS [adjustment!243001!adjustment-reason-2],
		NULL AS [adjustment!243001!adjustment-amount-2],
		NULL AS [adjustment!243001!adjustment-quantity-2],
		NULL AS [adjustment!243001!adjustment-reason-3],
		NULL AS [adjustment!243001!adjustment-amount-3],
		NULL AS [adjustment!243001!adjustment-quantity-3],
		NULL AS [adjustment!243001!adjustment-reason-4],
		NULL AS [adjustment!243001!adjustment-amount-4],
		NULL AS [adjustment!243001!adjustment-quantity-4],
		NULL AS [adjustment!243001!adjustment-reason-5],
		NULL AS [adjustment!243001!adjustment-amount-5],
		NULL AS [adjustment!243001!adjustment-quantity-5],
		NULL AS [adjustment!243001!adjustment-reason-6],
		NULL AS [adjustment!243001!adjustment-amount-6],
		NULL AS [adjustment!243001!adjustment-quantity-6],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id]

	FROM (select @PayerInsurancePolicyID as InsurancePolicyID ) as v
        LEFT join InsurancePolicy PI ON PI.InsurancePolicyID = v.InsurancePolicyID
        LEFT join InsuranceProgramType IPT ON PI.InsuranceProgramTypeId = IPT.InsuranceProgramTypeId
		LEFT JOIN InsuranceCompanyPlan ICP
		ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
		LEFT JOIN InsuranceCompany IC 
		ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
		LEFT OUTER JOIN ClearinghousePayersList CPL
		ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID

		LEFT JOIN @t_realPrecedence RPI
		ON RPI.InsurancePolicyID = PI.InsurancePolicyID
		LEFT JOIN Relationship RS
		ON RS.Relationship = PI.PatientRelationshipToInsured
		LEFT JOIN PatientCase PC
		ON PC.PatientCaseID = PI.PatientCaseID
		LEFT JOIN Patient P
		ON P.PatientID = PC.PatientID
	-- END OF SUBSCRIBER HIERARCHICAL LEVEL - LOOP 2000

	UNION ALL

	-- PATIENT HIERARCHICAL LEVEL - 2010BA
	SELECT	4, 3,
		CONVERT(VARCHAR,@customer_id) AS [transaction!1!customer-id], 
		CONVERT(VARCHAR,@PracticeID) AS [transaction!1!practice-id],
		2 as [transaction!1!claim-settings-edition], 
		NULL as [transaction!1!claim-type-id],
		@RenderingTaxIDTypeID as [transaction!1!claim-settings-tax-id-type],
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!transaction-type],
		NULL AS [transaction!1!current-date],

		NULL AS [transaction!1!production-flag],
		NULL AS [transaction!1!interchange-authorization-id],
		NULL AS [transaction!1!interchange-security-id],
		NULL AS [transaction!1!original-transaction-flag],
		
		NULL AS [transaction!1!submitter-name],
		NULL AS [transaction!1!submitter-etin],
		NULL AS [transaction!1!submitter-id],
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

		NULL AS [transaction!1!SuppressRenderingProviderForASC],
		NULL AS [transaction!1!ForcePatientAddressIn2310C],
		NULL AS [transaction!1!PopulatePSsegment],

		@BillerType AS [billing!2!biller-type],
		@PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!country],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],
		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-country],
		NULL AS [billing!2!paytopo-name],
		NULL AS [billing!2!paytopo-street-1],
		NULL AS [billing!2!paytopo-street-2],
		NULL AS [billing!2!paytopo-city],
		NULL AS [billing!2!paytopo-state],
		NULL AS [billing!2!paytopo-zipcode],
		NULL AS [billing!2!paytopo-country],
	
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
		NULL as [billing!2!group-taxonomy-code],
		@PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!insurance-type-code],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier-qualifier],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!payer-country],
		NULL AS [subscriber!3!payer-secondary-id],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [subscriber!3!responsible-country],
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [subscriber!3!relation-to-insured-code],
		@PatientID AS [patient!4!patient-id],
		UPPER(PI.DependentPolicyNumber) 
			AS [patient!4!dependent-policy-number],
		UPPER(P.FirstName) AS [patient!4!first-name],
		UPPER(P.MiddleName) AS [patient!4!middle-name],
		UPPER(P.LastName) AS [patient!4!last-name],
		UPPER(P.Suffix) AS [patient!4!suffix],
		UPPER(P.AddressLine1) AS [patient!4!street-1],
		UPPER(P.AddressLine2) AS [patient!4!street-2],
		UPPER(P.City) AS [patient!4!city],
		UPPER(P.State) AS [patient!4!state],
		P.ZipCode AS [patient!4!zip],
		CASE WHEN P.Country LIKE 'CA%' THEN 'CA' ELSE NULL END AS [patient!4!country],
		P.DOB AS [patient!4!birth-date],
		UPPER(P.Gender) AS [patient!4!gender],
		CASE WHEN @SetPAT01_2000C = 0 THEN '' ELSE PI.PatientRelationshipToInsured END AS [patient!4!relation-to-insured],
		CASE WHEN (@Customer_ID = 5411 AND @PayerNumber= '31059') OR EXISTS (SELECT * FROM @PayerHacks WHERE [Name] = 'GroupNumAsCasualtyClaimNum') THEN PI.GroupNumber ELSE NULL END AS [patient!4!property-casualty-claim-number],
		NULL AS [claim!2300!claim-id],
		NULL AS [claim!2300!control-number],
		NULL AS [claim!2300!total-claim-amount],
		NULL AS [claim!2300!place-of-service-code],
		NULL AS [claim!2300!provider-signature-flag],
		NULL AS [claim!2300!medicare-assignment-code],
		NULL AS [claim!2300!assignment-of-benefits-flag],
		NULL AS [claim!2300!release-of-information-code],
		NULL AS [claim!2300!patient-signature-source-code],
		NULL AS [claim!2300!auto-accident-related-flag],
		NULL AS [claim!2300!abuse-related-flag],
		NULL AS [claim!2300!pregnancy-related-flag],
		NULL AS [claim!2300!employment-related-flag],
		NULL AS [claim!2300!other-accident-related-flag],
		NULL AS [claim!2300!auto-accident-state],
		NULL AS [claim!2300!special-program-code],
		NULL AS [claim!2300!initial-treatment-date],
		NULL AS [claim!2300!last-menstrual-date],
		NULL AS [claim!2300!referral-date],
		NULL AS [claim!2300!last-seen-date],
		NULL AS [claim!2300!current-illness-date],
		NULL AS [claim!2300!acute-manifestation-date],
		NULL AS [claim!2300!similar-illness-date],
		NULL AS [claim!2300!accident-date],
		NULL AS [claim!2300!last-xray-date],
		NULL AS [claim!2300!disability-begin-date],
		NULL AS [claim!2300!disability-end-date],
		NULL AS [claim!2300!last-worked-date],
		NULL AS [claim!2300!return-to-work-date],
		NULL AS [claim!2300!hospitalization-begin-date],
		NULL AS [claim!2300!hospitalization-end-date],
		NULL AS [claim!2300!pwk-attachment-report-type-code],
		NULL AS [claim!2300!pwk-attachment-control-number],
		NULL AS [claim!2300!patient-paid-amount],
		NULL AS [claim!2300!authorization-number],
		NULL AS [claim!2300!referral-number],
		NULL AS [claim!2300!diagnosis-1],
		NULL AS [claim!2300!diagnosis-2],
		NULL AS [claim!2300!diagnosis-3],
		NULL AS [claim!2300!diagnosis-4],
		NULL AS [claim!2300!diagnosis-5],
		NULL AS [claim!2300!diagnosis-6],
		NULL AS [claim!2300!diagnosis-7],
		NULL AS [claim!2300!diagnosis-8],
		NULL AS [claim!2300!diagnosis-9],
		NULL AS [claim!2300!diagnosis-10],
		NULL AS [claim!2300!diagnosis-11],
		NULL AS [claim!2300!diagnosis-12],
		NULL AS [claim!2300!clia-number],
		NULL AS [claim!2300!referring-provider-flag],
		NULL AS [claim!2300!referring-provider-first-name],
		NULL AS [claim!2300!referring-provider-middle-name],
		NULL AS [claim!2300!referring-provider-last-name],
		NULL AS [claim!2300!referring-provider-suffix],
		NULL AS [claim!2300!referring-provider-upin],
		NULL AS [claim!2300!referring-provider-npi],
		NULL AS [claim!2300!supervising-provider-flag],
		NULL AS [claim!2300!supervising-provider-first-name],
		NULL AS [claim!2300!supervising-provider-middle-name],
		NULL AS [claim!2300!supervising-provider-last-name],
		NULL AS [claim!2300!supervising-provider-suffix],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-npi],
		NULL AS [claim!2300!supervising-provider-id-qualifier],
		NULL AS [claim!2300!supervising-provider-id-number],
		NULL AS [claim!2300!rendering-provider-first-name],
		NULL AS [claim!2300!rendering-provider-middle-name],
		NULL AS [claim!2300!rendering-provider-last-name],
		NULL AS [claim!2300!rendering-provider-suffix],
		NULL AS [claim!2300!rendering-provider-ssn-qual],
		NULL AS [claim!2300!rendering-provider-ssn],
		NULL AS [claim!2300!rendering-provider-upin],
		NULL AS [claim!2300!rendering-provider-npi],
		NULL AS [claim!2300!rendering-provider-specialty-code],
		NULL AS [claim!2300!service-facility-name],
		NULL AS [claim!2300!service-facility-street-1],
		NULL AS [claim!2300!service-facility-street-2],
		NULL AS [claim!2300!service-facility-city],
		NULL AS [claim!2300!service-facility-state],
		NULL AS [claim!2300!service-facility-zip],
		NULL AS [claim!2300!service-facility-country],
		NULL AS [claim!2300!service-facility-id],
		NULL AS [claim!2300!service-facility-id-qualifier],
		NULL AS [claim!2300!service-facility-npi],
		NULL AS [claim!2300!service-facility-force-output],
		NULL AS [claim!2300!service-facility-phone],
		NULL AS [claim!2300!service-facility-phone-ext],
		NULL AS [claim!2300!file-information],
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!hipaa-delay-reason-code],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL  AS [claim!2300!ambulance-pickup-address1],
		NULL  AS [claim!2300!ambulance-pickup-address2],
		NULL  AS [claim!2300!ambulance-pickup-city],
		NULL  AS [claim!2300!ambulance-pickup-state],
		NULL  AS [claim!2300!ambulance-pickup-zipcode],
		NULL  AS [claim!2300!ambulance-fromcountry],
		NULL  AS [claim!2300!ambulance-address-dropoff],
		NULL  AS [claim!2300!ambulance-dropoff-address1],
		NULL  AS [claim!2300!ambulance-dropoff-address2],
		NULL  AS [claim!2300!ambulance-dropoff-city],
		NULL  AS [claim!2300!ambulance-dropoff-state],
		NULL  AS [claim!2300!ambulance-dropoff-zipcode],
		NULL  AS [claim!2300!ambulance-dropoff-country],
		NULL AS [claim!2300!ambulance-purpose-roundtrip],
		NULL AS [claim!2300!ambulance-purpose-stretcher],
		NULL AS [claim!2300!ambulance-condition-1],
		NULL AS [claim!2300!ambulance-condition-2],
		NULL AS [claim!2300!ambulance-condition-3],
		NULL AS [claim!2300!ambulance-condition-4],
		NULL AS [claim!2300!ambulance-condition-5],
		NULL AS [claim!2300!epsdt-referral-given],
		NULL AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		NULL AS [claim!2300!mammography-certification-number],
		NULL AS [claim!2300!contract-otaf-amount],
		NULL AS [claim!2300!contract-code],
		NULL AS [claim!2300!spinal-manipulation-flag],
		NULL AS [claim!2300!spinal-condition-code],
		NULL AS [claim!2300!spinal-xray-availability-flag],
		NULL AS [claim!2300!dcn],
		NULL AS [claim!2300!submit-reason-code], 
		NULL AS [otherpayercob!2320!insurance-policy-id],
		NULL AS [otherpayercob!2320!sum-patient-responsibility],
		NULL AS [otherpayercob!2320!sum-contract-adjustments],
		NULL AS [otherpayercob!2320!insured-different-than-patient-flag],
		NULL AS [otherpayercob!2320!subscriber-first-name],
		NULL AS [otherpayercob!2320!subscriber-middle-name],
		NULL AS [otherpayercob!2320!subscriber-last-name],
		NULL AS [otherpayercob!2320!subscriber-suffix],
		NULL AS [otherpayercob!2320!subscriber-street-1],
		NULL AS [otherpayercob!2320!subscriber-street-2],
		NULL AS [otherpayercob!2320!subscriber-city],
		NULL AS [otherpayercob!2320!subscriber-state],
		NULL AS [otherpayercob!2320!subscriber-zip],
		NULL AS [otherpayercob!2320!subscriber-country],
		NULL AS [otherpayercob!2320!subscriber-birth-date],
		NULL AS [otherpayercob!2320!subscriber-gender],
		NULL AS [otherpayercob!2320!subscriber-assignment-of-benefits-flag],
		NULL AS [otherpayercob!2320!subscriber-release-of-information-code],
		NULL AS [otherpayercob!2320!relation-to-insured-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code-order],
		NULL AS [otherpayercob!2320!claim-filing-indicator-code],
		NULL AS [otherpayercob!2320!plan-name],
		NULL AS [otherpayercob!2320!insurance-type-code],
		NULL AS [otherpayercob!2320!group-number],
		NULL AS [otherpayercob!2320!policy-number],
		NULL AS [otherpayercob!2320!payer-name],
		NULL AS [otherpayercob!2320!payer-identifier-qualifier],
		NULL AS [otherpayercob!2320!payer-identifier],
		NULL AS [otherpayercob!2320!payer-street-1],
		NULL AS [otherpayercob!2320!payer-street-2],
		NULL AS [otherpayercob!2320!payer-city],
		NULL AS [otherpayercob!2320!payer-state],
		NULL AS [otherpayercob!2320!payer-zip],
		NULL AS [otherpayercob!2320!payer-country],
		NULL AS [otherpayercob!2320!payer-secondary-id],
		NULL AS [otherpayercob!2320!payer-contact-name],
		NULL AS [otherpayercob!2320!payer-contact-phone],
		NULL AS [otherpayercob!2320!payer-paid-flag],
		NULL AS [otherpayercob!2320!payer-paid-amount],
		NULL AS [otherpayercob!2320!payer-allowed-amount],
		NULL AS [otherpayercob!2320!payer-cob-allowed-amount],
		NULL AS [otherpayercob!2320!patient-responsibility-amount],
		NULL as [otherpayercob!2320!include-zero-payer-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-cob-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-patient-responsibility-amount],
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!referring-clia-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!drug-ndc-code],
		NULL AS [service!2400!drug-quantity],
		NULL AS [service!2400!drug-units-of-measure],
		NULL AS [service!2400!drug-ref-qualifier],
		NULL AS [service!2400!drug-ref-identifier],
		NULL AS [service!2400!measurement-reference-id-code],
		NULL AS [service!2400!measurement-qualifier],
		NULL AS [service!2400!measurement-value],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!emergency-related-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
		NULL AS [service!2400!hospice-employee-indicator],
		NULL AS [service!2400!dme-flag],
		NULL AS [service!2400!ordering-provider-first-name],
		NULL AS [service!2400!ordering-provider-middle-name],
		NULL AS [service!2400!ordering-provider-last-name],
		NULL AS [service!2400!ordering-provider-suffix],
		NULL AS [service!2400!ordering-provider-ssn-qual],
		NULL AS [service!2400!ordering-provider-ssn],
		NULL AS [service!2400!ordering-provider-upin],
		NULL AS [service!2400!ordering-provider-npi],
		NULL AS [service!2400!ordering-provider-addressline1],
		NULL AS [service!2400!ordering-provider-addressline2],
		NULL AS [service!2400!ordering-provider-city],
		NULL AS [service!2400!ordering-provider-state],
		NULL AS [service!2400!ordering-provider-zipcode],
		NULL AS [service!2400!ordering-provider-phone],
		NULL AS [service!2400!service-note-code],
		NULL AS [service!2400!service-note],
		NULL AS [service!2400!noc-service-note],
		NULL AS [service!2400!contract-otaf-amount],
		NULL AS [service!2400!allowed-amount],
		NULL AS [service!2400!approved-amount],
		NULL AS [service!2400!include-zero-approved-amount],
		NULL AS [adjudication!2430!adjudication-id],
		NULL AS [adjudication!2430!payer-identifier],
		NULL AS [adjudication!2430!monetary-amount],
		NULL AS [adjudication!2430!procedure-code],
		NULL AS [adjudication!2430!quantity],
		NULL AS [adjudication!2430!adjudication-date],
		NULL AS [adjudication!2430!kareo-payment-id],
		NULL AS [adjudication!2430!payer-adjusted-flag],
		NULL AS [adjudication!2430!assigned-number],
		NULL AS [adjustment!243001!adjustment-id],
		NULL AS [adjustment!243001!adjustment-group-code],
		NULL AS [adjustment!243001!adjustment-reason-1],
		NULL AS [adjustment!243001!adjustment-amount-1],
		NULL AS [adjustment!243001!adjustment-quantity-1],
		NULL AS [adjustment!243001!adjustment-reason-2],
		NULL AS [adjustment!243001!adjustment-amount-2],
		NULL AS [adjustment!243001!adjustment-quantity-2],
		NULL AS [adjustment!243001!adjustment-reason-3],
		NULL AS [adjustment!243001!adjustment-amount-3],
		NULL AS [adjustment!243001!adjustment-quantity-3],
		NULL AS [adjustment!243001!adjustment-reason-4],
		NULL AS [adjustment!243001!adjustment-amount-4],
		NULL AS [adjustment!243001!adjustment-quantity-4],
		NULL AS [adjustment!243001!adjustment-reason-5],
		NULL AS [adjustment!243001!adjustment-amount-5],
		NULL AS [adjustment!243001!adjustment-quantity-5],
		NULL AS [adjustment!243001!adjustment-reason-6],
		NULL AS [adjustment!243001!adjustment-amount-6],
		NULL AS [adjustment!243001!adjustment-quantity-6],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id]

	FROM Claim RC
		INNER JOIN Patient P
		ON P.PatientID = RC.PatientID
		INNER JOIN InsurancePolicy PI
		ON PI.InsurancePolicyID = @PayerInsurancePolicyID
	WHERE	RC.ClaimID = @RepresentativeClaimID
	-- END OF PATIENT HIERARCHICAL LEVEL - 2010BA

	UNION ALL

	-- CLAIM INFORMATION - loop 2300 CLM
	-- top 1 is needed below as additional protection for case 7943, although fixed for authorization, if duplicate loop 2300 is caused
	--  by something else it will cause whole file being dropped at ProxyMed, which is really gross... 
	SELECT TOP 1	2300, 4,
		CONVERT(VARCHAR,@customer_id) AS [transaction!1!customer-id], 
		CONVERT(VARCHAR,@PracticeID) AS [transaction!1!practice-id],
		2 as [transaction!1!claim-settings-edition], 
		NULL as [transaction!1!claim-type-id],
		@RenderingTaxIDTypeID as [transaction!1!claim-settings-tax-id-type],
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!transaction-type],
		NULL AS [transaction!1!current-date],

		NULL AS [transaction!1!production-flag],
		NULL AS [transaction!1!interchange-authorization-id],
		NULL AS [transaction!1!interchange-security-id],
		NULL AS [transaction!1!original-transaction-flag],

		NULL AS [transaction!1!submitter-name],
		NULL AS [transaction!1!submitter-etin],
		NULL AS [transaction!1!submitter-id],
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],
		
		NULL AS [transaction!1!SuppressRenderingProviderForASC],
		NULL AS [transaction!1!ForcePatientAddressIn2310C],
		NULL AS [transaction!1!PopulatePSsegment],

		@BillerType AS [billing!2!biller-type],
		@PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!country],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],
		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-country],
		NULL AS [billing!2!paytopo-name],
		NULL AS [billing!2!paytopo-street-1],
		NULL AS [billing!2!paytopo-street-2],
		NULL AS [billing!2!paytopo-city],
		NULL AS [billing!2!paytopo-state],
		NULL AS [billing!2!paytopo-zipcode],
		NULL AS [billing!2!paytopo-country],
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
		NULL as [billing!2!group-taxonomy-code],
		@PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!insurance-type-code],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier-qualifier],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!payer-country],
		NULL AS [subscriber!3!payer-secondary-id],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [subscriber!3!responsible-country],
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [subscriber!3!relation-to-insured-code],
		@PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!country],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [patient!4!relation-to-insured],
		NULL AS [patient!4!property-casualty-claim-number],
		@bill_id AS [claim!2300!claim-id],
		-- [claim!2300!control-number] cannot be more than 20 chars:
--		CONVERT(VARCHAR,@customer_id) + 'K' + CONVERT(VARCHAR,RC.ClaimID) + 'K9'
		CONVERT(VARCHAR,E.EncounterID) + 'Z' + CONVERT(VARCHAR,@customer_id)			-- case 14068, 18103
			 AS [claim!2300!control-number],
		dbo.BusinessRule_EDIBillTotalOriginalChargeAmount(@bill_id) 
			AS [claim!2300!total-claim-amount],
		E.PlaceOfServiceCode AS [claim!2300!place-of-service-code],
		1 AS [claim!2300!provider-signature-flag],					-- RC.ProviderSignatureOnFileFlag 

		-- hack for case 21339 - we need MedicareAssignmentCode to be represented in GUI:
		-- E.MedicareAssignmentCode AS [claim!2300!medicare-assignment-code],
		CASE PTIC.AcceptAssignment WHEN 0 THEN 'C' ELSE NULL END AS [claim!2300!medicare-assignment-code],

		PTIC.AcceptAssignment 
			AS [claim!2300!assignment-of-benefits-flag],
		E.ReleaseOfInformationCode 	
			AS [claim!2300!release-of-information-code],
		'B' -- E.ReleaseSignatureSourceCode -- dont need this in 5010
			AS [claim!2300!patient-signature-source-code],
		PC.AutoAccidentRelatedFlag
			AS [claim!2300!auto-accident-related-flag],
		PC.AbuseRelatedFlag AS [claim!2300!abuse-related-flag], -- dont need this in 5010
		PC.PregnancyRelatedFlag AS [claim!2300!pregnancy-related-flag],
		PC.EmploymentRelatedFlag AS [claim!2300!employment-related-flag],
		PC.OtherAccidentRelatedFlag 
			AS [claim!2300!other-accident-related-flag],
		PC.AutoAccidentRelatedState AS [claim!2300!auto-accident-state],
		CASE WHEN PC.EPSDT = 1 THEN '01' ELSE NULL END AS [claim!2300!special-program-code],-- dont need this in 5010					-- PC.SpecialProgramCode
		@InitialTreatmentDate AS [claim!2300!initial-treatment-date],
		@LastMenstrualDate AS [claim!2300!last-menstrual-date],
		@ReferralDate AS [claim!2300!referral-date],
		@LastSeenDate AS [claim!2300!last-seen-date], 
			-- per fb 22680, if employment-related, don't put out current-illness-date since that generates a DTP*431
		(CASE WHEN ((@customer_id = 122) AND (PC.EmploymentRelatedFlag <> 0))
			THEN NULL ELSE @DateOfInjury 
			END) AS [claim!2300!current-illness-date],
		@AcuteManifestationDate AS [claim!2300!acute-manifestation-date],
		@DateOfSimilarInjury AS [claim!2300!similar-illness-date], -- do not need this in 5010
			-- per fb 22680, if employment-related, also put out accident-date since that generates a DTP*439
		(CASE 
			WHEN (PC.OtherAccidentRelatedFlag <> 0 OR PC.EmploymentRelatedFlag <> 0) 
				-- SF 67127, FB 24071 - put out accident date if nothing else
				THEN isnull(@DateOfInjury,@AccidentDate)
			-- SF 35016, FB 23158 - use AccidentDate for accident-related claims 
			WHEN PC.AutoAccidentRelatedFlag <> 0 
				THEN @AccidentDate
			-- SF 67127, FB 24071 - put out accident date if nothing else
			ELSE @AccidentDate END) AS [claim!2300!accident-date],
		@LastXrayDate AS [claim!2300!last-xray-date],
		@DisabilityStartDate AS [claim!2300!disability-begin-date],
		@DisabilityEndDate AS [claim!2300!disability-end-date],
		@UnableToWorkStartDate AS [claim!2300!last-worked-date],
		@UnableToWorkEndDate AS [claim!2300!return-to-work-date],
		COALESCE(E.HospitalizationStartDT, @HospitalizationStartDate) AS [claim!2300!hospitalization-begin-date],
		COALESCE(E.HospitalizationEndDT, @HospitalizationEndDate) AS [claim!2300!hospitalization-end-date],
		CASE 
			WHEN @PayerNumber='00148' AND @customer_id=4009 -- SF 00170983
				THEN 'OZ'
			WHEN @PayerNumber='00821' AND @customer_id=2597 -- SF 00191498
				THEN 'EB'
			WHEN @PayerNumber='86500' AND @customer_id=5369 -- SF 00198176
				THEN 'B2'
			ELSE 
				NULL 
			END AS [claim!2300!pwk-attachment-report-type-code],
		CASE 
			WHEN (@PayerNumber='00148' AND @customer_id=4009) -- SF 00170983
				OR	(@PayerNumber='00821' AND @customer_id=2597) -- SF 00191498
				OR EXISTS (SELECT * FROM @PayerHacks WHERE [Name] = 'Box19AsPWK06')
				THEN E.Box19
			WHEN ( @PayerNumber='86500' AND @customer_id=5369 ) -- SF 00198176		
				THEN 'AA'	
			ELSE 
				NULL 
			END AS [claim!2300!pwk-attachment-control-number],
		(CASE WHEN @hide_patient_paid_amount = 0 THEN E.AmountPaid ELSE NULL END) AS [claim!2300!patient-paid-amount],	-- RC.PatientPaidAmount
		CASE 
			WHEN (@PayerNumber='MC020' AND @customer_id=4072) OR (@PayerNumber='00029' AND @customer_id=1849)
				OR EXISTS (SELECT * FROM @PayerHacks WHERE [Name] = 'DoNotPopulateAuthNumber')
				THEN NULL
			ELSE
				UPPER(A.AuthorizationNumber)
			END AS [claim!2300!authorization-number],
		CASE 
			WHEN (@PayerNumber='MC020' AND @customer_id=4072) OR (@PayerNumber='00029' AND @customer_id=1849)
				OR EXISTS (SELECT * FROM @PayerHacks WHERE [Name] = 'SendAuthAsReferralNumber')
				THEN UPPER(A.AuthorizationNumber)
			WHEN ( @PayerNumber='MC033' AND @customer_id=5406 AND @PracticeID = 1 )
				THEN UPPER(E.Box19)
			WHEN ( @PayerNumber='MC054' AND @customer_id=5037) OR (@customer_id=6674 AND @PayerNumber='MC024') OR (@customer_id=5950 AND @PayerNumber='MC089')	-- case 00303102/00329987/00337915
				OR EXISTS (SELECT * FROM @PayerHacks WHERE [Name] = 'SendBox19AsReferralNumber')
				THEN UPPER(E.Box19)
			ELSE
				NULL
			END  AS [claim!2300!referral-number],	-- Used to be 9F in referring provider number but not supported in new Claim Settings
		-- list of diagnostic codes:
		(CASE WHEN (@DiagnosisCode1 IS NOT NULL) THEN UPPER(@DiagnosisCode1) ELSE NULL END) AS [claim!2300!diagnosis-1],
		(CASE WHEN (@DiagnosisCode2 IS NOT NULL) THEN UPPER(@DiagnosisCode2) ELSE NULL END) AS [claim!2300!diagnosis-2],
		(CASE WHEN (@DiagnosisCode3 IS NOT NULL) THEN UPPER(@DiagnosisCode3) ELSE NULL END) AS [claim!2300!diagnosis-3],
		(CASE WHEN (@DiagnosisCode4 IS NOT NULL) THEN UPPER(@DiagnosisCode4) ELSE NULL END) AS [claim!2300!diagnosis-4],
		(CASE WHEN (@DiagnosisCode5 IS NOT NULL) THEN UPPER(@DiagnosisCode5) ELSE NULL END) AS [claim!2300!diagnosis-5],
		(CASE WHEN (@DiagnosisCode6 IS NOT NULL) THEN UPPER(@DiagnosisCode6) ELSE NULL END) AS [claim!2300!diagnosis-6],
		(CASE WHEN (@DiagnosisCode7 IS NOT NULL) THEN UPPER(@DiagnosisCode7) ELSE NULL END) AS [claim!2300!diagnosis-7],
		(CASE WHEN (@DiagnosisCode8 IS NOT NULL) THEN UPPER(@DiagnosisCode8) ELSE NULL END) AS [claim!2300!diagnosis-8],
		(CASE WHEN (@DiagnosisCode9 IS NOT NULL) THEN UPPER(@DiagnosisCode9) ELSE NULL END) AS [claim!2300!diagnosis-9],
		(CASE WHEN (@DiagnosisCode10 IS NOT NULL) THEN UPPER(@DiagnosisCode10) ELSE NULL END) AS [claim!2300!diagnosis-10],
		(CASE WHEN (@DiagnosisCode11 IS NOT NULL) THEN UPPER(@DiagnosisCode11) ELSE NULL END) AS [claim!2300!diagnosis-11],
		(CASE WHEN (@DiagnosisCode12 IS NOT NULL) THEN UPPER(@DiagnosisCode12) ELSE NULL END) AS [claim!2300!diagnosis-12],
		@CliaNumber AS [claim!2300!clia-number],
		(CASE WHEN (E.ReferringPhysicianID IS NOT NULL) THEN 1 ELSE 0 END)
			AS [claim!2300!referring-provider-flag],
		UPPER(RP.FirstName) AS [claim!2300!referring-provider-first-name],
		UPPER(RP.MiddleName) 
			AS [claim!2300!referring-provider-middle-name],
		UPPER(RP.LastName) AS [claim!2300!referring-provider-last-name],
		UPPER(RP.Suffix) AS [claim!2300!referring-provider-suffix],
		(CASE 
			WHEN RTRIM(ISNULL(RC.ReferringProviderIDNumber, '')) <> '' THEN UPPER(RC.ReferringProviderIDNumber)
			ELSE ''
		END) AS [claim!2300!referring-provider-upin],
		@ReferringProviderNPI AS [claim!2300!referring-provider-npi],

		CAST((CASE WHEN (SD.DoctorID IS NOT NULL) THEN 1 ELSE 0 END) AS BIT) AS [claim!2300!supervising-provider-flag],
		UPPER(SD.FirstName) AS [claim!2300!supervising-provider-first-name],
		UPPER(SD.MiddleName) AS [claim!2300!supervising-provider-middle-name],
		UPPER(SD.LastName) AS [claim!2300!supervising-provider-last-name],
		UPPER(SD.Suffix) AS [claim!2300!supervising-provider-suffix],
		UPPER(SD.SSN) AS [claim!2300!supervising-provider-ssn],
		@SupervisingProviderNPI AS [claim!2300!supervising-provider-npi],
		@SupervisingProviderNumberType1 AS [claim!2300!supervising-provider-id-qualifier],
		@SupervisingProviderNumber1 AS [claim!2300!supervising-provider-id-number],

		UPPER(D.FirstName) AS [claim!2300!rendering-provider-first-name],
		UPPER(D.MiddleName) AS [claim!2300!rendering-provider-middle-name],
		UPPER(D.LastName) AS [claim!2300!rendering-provider-last-name],
		UPPER(D.Suffix) AS [claim!2300!rendering-provider-suffix],
		NULL AS [claim!2300!rendering-provider-ssn-qual],					-- Now populated directly in provider numbers table
		NULL AS [claim!2300!rendering-provider-ssn],						-- Now populated directly in provider numbers table
		NULL AS [claim!2300!rendering-provider-upin],
		@RenderingProviderNPI AS [claim!2300!rendering-provider-npi],
		CASE WHEN ( @Customer_ID = 5406 AND @PayerNumber = 'MC033' ) OR @SuppressRenderingTaxonomyCode = 1 THEN NULL ELSE UPPER(@RenderingProviderTaxonomyCode) END --00239308 
			AS [claim!2300!rendering-provider-specialty-code],
		UPPER(L.BillingName) AS [claim!2300!service-facility-name],
		UPPER(L.AddressLine1) AS [claim!2300!service-facility-street-1],
		UPPER(L.AddressLine2) AS [claim!2300!service-facility-street-2],
		UPPER(L.City) AS [claim!2300!service-facility-city],
		UPPER(L.State) AS [claim!2300!service-facility-state],
		L.ZipCode AS [claim!2300!service-facility-zip],
		CASE WHEN L.Country LIKE 'CA%' THEN 'CA' ELSE NULL END AS [claim!2300!service-facility-country],
		@ServiceFacilityId AS [claim!2300!service-facility-id],
		@ServiceFacilityIdQualifier AS [claim!2300!service-facility-id-qualifier],
		L.NPI AS [claim!2300!service-facility-npi],
		@ForceServiceFacility AS [claim!2300!service-facility-force-output],
		L.Phone AS [claim!2300!service-facility-phone],
		L.PhoneExt AS [claim!2300!service-facility-phone-ext],
		CASE WHEN (@Customer_ID = 4618 AND @PayerNumber = 'MC029') OR ( @Customer_ID = 4843 AND @PayerNumber = '00185' )THEN 'G' ELSE NULL END AS [claim!2300!file-information],
		CASE WHEN E.EDIClaimNoteReferenceCode IN ('ADD','CER','DCP','DGN','PMT','TPO') AND LEN(E.EDIClaimNote) > 0 THEN E.EDIClaimNoteReferenceCode ELSE NULL END AS [claim!2300!claim-note-code],
		CASE WHEN E.EDIClaimNoteReferenceCode IN ('ADD','CER','DCP','DGN','PMT','TPO') AND LEN(E.EDIClaimNote) > 0 THEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(E.EDIClaimNote,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) ELSE NULL END AS [claim!2300!claim-note],
		CASE WHEN E.EDIClaimNoteReferenceCode IN ('DRC') AND LEN(E.EDIClaimNote) > 0 THEN E.EDIClaimNote ELSE NULL END AS [claim!2300!hipaa-delay-reason-code], -- should be a dropdown of codes and not free text
		CASE WHEN ATI.TransportRecordId IS NULL THEN 0 ELSE 1 END AS [claim!2300!ambulance-transport-flag],
		CASE WHEN ATI.Weight IS NULL THEN NULL ELSE CAST(ATI.Weight AS varchar(30)) END AS [claim!2300!ambulance-patient-weight],
		ATI.AmbulanceTransportCode AS [claim!2300!ambulance-code], --dont need this in 5010
		ATI.AmbulanceTransportReasonCode AS [claim!2300!ambulance-reason-code],
		ATI.Miles AS [claim!2300!ambulance-distance],
		UPPER(ATI.fromaddressline1) AS [claim!2300!ambulance-pickup-address1],
		UPPER(ATI.fromaddressline2) AS [claim!2300!ambulance-pickup-address2],
		UPPER(ATI.fromcity) AS [claim!2300!ambulance-pickup-city],
		UPPER(ATI.fromstate) AS [claim!2300!ambulance-pickup-state],
		UPPER(ATI.fromzipcode) AS [claim!2300!ambulance-pickup-zipcode],
		CASE WHEN ATI.fromcountry LIKE 'CA%' THEN 'CA' ELSE NULL END AS [claim!2300!ambulance-pickup-country], 
		UPPER(ATI.DropOff) AS [claim!2300!ambulance-address-dropoff],
		UPPER(ATI.toaddressline1) AS [claim!2300!ambulance-dropoff-address1],
		UPPER(ATI.toaddressline2) AS [claim!2300!ambulance-dropoff-address2],
		UPPER(ATI.tocity) AS [claim!2300!ambulance-dropoff-city],
		UPPER(ATI.tostate) AS [claim!2300!ambulance-dropoff-state],
		UPPER(ATI.tozipcode) AS [claim!2300!ambulance-dropoff-zipcode],
		CASE WHEN ATI.tocountry LIKE 'CA%' THEN 'CA' ELSE NULL END AS [claim!2300!ambulance-dropoff-country], 
		UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ATI.RoundTripPurposeDescription,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) AS [claim!2300!ambulance-purpose-roundtrip],
		UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ATI.StretcherPurposeDescription,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) AS [claim!2300!ambulance-purpose-stretcher],
		ACI1.AmbulanceCertificationCode AS [claim!2300!ambulance-condition-1], -- cannot empty out the old 4010 code bcoz the first code is a required field
		CASE WHEN ACI2.AmbulanceCertificationCode IN ('02','03','60') THEN NULL ELSE ACI2.AmbulanceCertificationCode END AS [claim!2300!ambulance-condition-2],--codes ignored in 5010
		CASE WHEN ACI3.AmbulanceCertificationCode IN ('02','03','60') THEN NULL ELSE ACI3.AmbulanceCertificationCode END AS [claim!2300!ambulance-condition-3],--codes ignored in 5010
		CASE WHEN ACI4.AmbulanceCertificationCode IN ('02','03','60') THEN NULL ELSE ACI4.AmbulanceCertificationCode END AS [claim!2300!ambulance-condition-4],--codes ignored in 5010
		CASE WHEN ACI5.AmbulanceCertificationCode IN ('02','03','60') THEN NULL ELSE ACI5.AmbulanceCertificationCode END AS [claim!2300!ambulance-condition-5],--codes ignored in 5010
		CASE WHEN PC.EPSDT = 0 OR PC.EPSDTCodeID IS NULL THEN NULL WHEN PC.EPSDTCodeID = 1 THEN 'N' ELSE 'Y' END AS [claim!2300!epsdt-referral-given],
		CASE WHEN PC.EPSDT = 0 OR PC.EPSDTCodeID IS NULL THEN NULL ELSE EPSDTC.Code END AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		@ServiceFacilityMammographyCertificationNumber AS [claim!2300!mammography-certification-number],
		@ContractOtafAmount AS [claim!2300!contract-otaf-amount],
		@ContractCode AS [claim!2300!contract-code],
		@SpinalManipulationFlag AS [claim!2300!spinal-manipulation-flag],
		@SpinalConditionCode AS [claim!2300!spinal-condition-code],
		@SpinalXrayAvailabilityFlag AS [claim!2300!spinal-xray-availability-flag],	
		(CASE WHEN (SR.Code IN (7,8) AND E.DocumentControlNumber IS NOT NULL
					AND E2.EncounterID IS NOT NULL 
					AND CHARINDEX('Z', E.DocumentControlNumber) = 0)
			THEN RTRIM(LTRIM(E.DocumentControlNumber)) + 'Z' + RTRIM(LTRIM(@customer_id))
			ELSE E.DocumentControlNumber
		END) AS [claim!2300!dcn],
		SR.Code AS [claim!2300!submit-reason-code], 
		NULL AS [otherpayercob!2320!insurance-policy-id],
		NULL AS [otherpayercob!2320!sum-patient-responsibility],
		NULL AS [otherpayercob!2320!sum-contract-adjustments],
		NULL AS [otherpayercob!2320!insured-different-than-patient-flag],
		NULL AS [otherpayercob!2320!subscriber-first-name],
		NULL AS [otherpayercob!2320!subscriber-middle-name],
		NULL AS [otherpayercob!2320!subscriber-last-name],
		NULL AS [otherpayercob!2320!subscriber-suffix],
		NULL AS [otherpayercob!2320!subscriber-street-1],
		NULL AS [otherpayercob!2320!subscriber-street-2],
		NULL AS [otherpayercob!2320!subscriber-city],
		NULL AS [otherpayercob!2320!subscriber-state],
		NULL AS [otherpayercob!2320!subscriber-zip],
		NULL AS [otherpayercob!2320!subscriber-country],
		NULL AS [otherpayercob!2320!subscriber-birth-date],
		NULL AS [otherpayercob!2320!subscriber-gender],
		NULL AS [otherpayercob!2320!subscriber-assignment-of-benefits-flag],
		NULL AS [otherpayercob!2320!subscriber-release-of-information-code],
		NULL AS [otherpayercob!2320!relation-to-insured-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code-order],
		NULL AS [otherpayercob!2320!claim-filing-indicator-code],
		NULL AS [otherpayercob!2320!plan-name],
		NULL AS [otherpayercob!2320!insurance-type-code],
		NULL AS [otherpayercob!2320!group-number],
		NULL AS [otherpayercob!2320!policy-number],
		NULL AS [otherpayercob!2320!payer-name],
		NULL AS [otherpayercob!2320!payer-identifier-qualifier],
		NULL AS [otherpayercob!2320!payer-identifier],
		NULL AS [otherpayercob!2320!payer-street-1],
		NULL AS [otherpayercob!2320!payer-street-2],
		NULL AS [otherpayercob!2320!payer-city],
		NULL AS [otherpayercob!2320!payer-state],
		NULL AS [otherpayercob!2320!payer-zip],
		NULL AS [otherpayercob!2320!payer-country],
		NULL AS [otherpayercob!2320!payer-secondary-id],
		NULL AS [otherpayercob!2320!payer-contact-name],
		NULL AS [otherpayercob!2320!payer-contact-phone],
		NULL AS [otherpayercob!2320!payer-paid-flag],
		NULL AS [otherpayercob!2320!payer-paid-amount],
		NULL AS [otherpayercob!2320!payer-allowed-amount],
		NULL AS [otherpayercob!2320!payer-cob-allowed-amount],
		NULL AS [otherpayercob!2320!patient-responsibility-amount],
		NULL as [otherpayercob!2320!include-zero-payer-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-cob-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-patient-responsibility-amount],
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!referring-clia-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!drug-ndc-code],
		NULL AS [service!2400!drug-quantity],
		NULL AS [service!2400!drug-units-of-measure],
		NULL AS [service!2400!drug-ref-qualifier],
		NULL AS [service!2400!drug-ref-identifier],
		NULL AS [service!2400!measurement-reference-id-code],
		NULL AS [service!2400!measurement-qualifier],
		NULL AS [service!2400!measurement-value],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!emergency-related-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
		NULL AS [service!2400!hospice-employee-indicator],
		NULL AS [service!2400!dme-flag],
		NULL AS [service!2400!ordering-provider-first-name],
		NULL AS [service!2400!ordering-provider-middle-name],
		NULL AS [service!2400!ordering-provider-last-name],
		NULL AS [service!2400!ordering-provider-suffix],
		NULL AS [service!2400!ordering-provider-ssn-qual],
		NULL AS [service!2400!ordering-provider-ssn],
		NULL AS [service!2400!ordering-provider-upin],
		NULL AS [service!2400!ordering-provider-npi],
		NULL AS [service!2400!ordering-provider-addressline1],
		NULL AS [service!2400!ordering-provider-addressline2],
		NULL AS [service!2400!ordering-provider-city],
		NULL AS [service!2400!ordering-provider-state],
		NULL AS [service!2400!ordering-provider-zipcode],
		NULL AS [service!2400!ordering-provider-phone],
		NULL AS [service!2400!service-note-code],
		NULL AS [service!2400!service-note],
		NULL AS [service!2400!noc-service-note],
		NULL AS [service!2400!contract-otaf-amount],
		NULL AS [service!2400!allowed-amount],
		NULL AS [service!2400!approved-amount],
		NULL AS [service!2400!include-zero-approved-amount],
		NULL AS [adjudication!2430!adjudication-id],
		NULL AS [adjudication!2430!payer-identifier],
		NULL AS [adjudication!2430!monetary-amount],
		NULL AS [adjudication!2430!procedure-code],
		NULL AS [adjudication!2430!quantity],
		NULL AS [adjudication!2430!adjudication-date],
		NULL AS [adjudication!2430!kareo-payment-id],
		NULL AS [adjudication!2430!payer-adjusted-flag],
		NULL AS [adjudication!2430!assigned-number],
		NULL AS [adjustment!243001!adjustment-id],
		NULL AS [adjustment!243001!adjustment-group-code],
		NULL AS [adjustment!243001!adjustment-reason-1],
		NULL AS [adjustment!243001!adjustment-amount-1],
		NULL AS [adjustment!243001!adjustment-quantity-1],
		NULL AS [adjustment!243001!adjustment-reason-2],
		NULL AS [adjustment!243001!adjustment-amount-2],
		NULL AS [adjustment!243001!adjustment-quantity-2],
		NULL AS [adjustment!243001!adjustment-reason-3],
		NULL AS [adjustment!243001!adjustment-amount-3],
		NULL AS [adjustment!243001!adjustment-quantity-3],
		NULL AS [adjustment!243001!adjustment-reason-4],
		NULL AS [adjustment!243001!adjustment-amount-4],
		NULL AS [adjustment!243001!adjustment-quantity-4],
		NULL AS [adjustment!243001!adjustment-reason-5],
		NULL AS [adjustment!243001!adjustment-amount-5],
		NULL AS [adjustment!243001!adjustment-quantity-5],
		NULL AS [adjustment!243001!adjustment-reason-6],
		NULL AS [adjustment!243001!adjustment-amount-6],
		NULL AS [adjustment!243001!adjustment-quantity-6],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id]

	FROM Claim RC
		INNER JOIN dbo.EncounterProcedure EP
			ON EP.EncounterProcedureID = RC.EncounterProcedureID
		INNER JOIN dbo.Encounter E
			ON E.EncounterID = EP.EncounterID
		LEFT JOIN dbo.AmbulanceTransportInformation ATI
			ON ATI.EncounterID = E.EncounterID

		LEFT JOIN @t_ambulancecertification ACI1 ON ACI1.TID=1
		LEFT JOIN @t_ambulancecertification ACI2 ON ACI2.TID=2
		LEFT JOIN @t_ambulancecertification ACI3 ON ACI3.TID=3
		LEFT JOIN @t_ambulancecertification ACI4 ON ACI4.TID=4
		LEFT JOIN @t_ambulancecertification ACI5 ON ACI5.TID=5

		INNER JOIN PatientCase PC
			ON PC.PatientCaseID = E.PatientCaseID
		INNER JOIN Doctor D
			ON D.DoctorID = E.DoctorID
		LEFT JOIN Doctor SD
			ON SD.DoctorID = E.SupervisingProviderID
		INNER JOIN ServiceLocation L
			ON L.ServiceLocationID = E.LocationID
		LEFT OUTER JOIN Doctor RP
			ON RP.DoctorID = E.ReferringPhysicianID
 		LEFT OUTER JOIN InsurancePolicyAuthorization A
 			ON E.InsurancePolicyAuthorizationID = A.InsurancePolicyAuthorizationID
 		LEFT OUTER JOIN PracticeToInsuranceCompany PTIC
 			ON RC.PracticeID = PTIC.PracticeID AND PTIC.InsuranceCompanyID = @InsuranceCompanyID
		LEFT OUTER JOIN EPSDTCode EPSDTC
			ON PC.EPSDTCodeID = EPSDTC.EPSDTCodeID
		LEFT OUTER JOIN SubmitReason SR
			ON SR.SubmitReasonID = E.SubmitReasonID
		LEFT JOIN Encounter E2 on E.PracticeID = E2.PracticeID AND E2.EncounterID = 
			CASE
				WHEN dbo.IsInteger(E.DocumentControlNumber) = 1 THEN E.DocumentControlNumber
				ELSE -1
			END
			
	WHERE	RC.ClaimID = @RepresentativeClaimID
	-- END OF CLAIM INFORMATION - loop 2300 CLM


	UNION ALL

	-- SUBSCRIBER LEVEL - LOOP 2320 - COB Other Payer
	SELECT	2320, 2300,
		CONVERT(VARCHAR,@customer_id) AS [transaction!1!customer-id], 
		CONVERT(VARCHAR,@PracticeID) AS [transaction!1!practice-id],
		2 as [transaction!1!claim-settings-edition], 
		NULL as [transaction!1!claim-type-id],
		@RenderingTaxIDTypeID as [transaction!1!claim-settings-tax-id-type],
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!transaction-type],
		NULL AS [transaction!1!current-date],

		NULL AS [transaction!1!production-flag],
		NULL AS [transaction!1!interchange-authorization-id],
		NULL AS [transaction!1!interchange-security-id],
		NULL AS [transaction!1!original-transaction-flag],

		NULL AS [transaction!1!submitter-name], 
		NULL AS [transaction!1!submitter-etin],
		NULL AS [transaction!1!submitter-id],
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

		NULL AS [transaction!1!SuppressRenderingProviderForASC],
		NULL AS [transaction!1!ForcePatientAddressIn2310C],
		NULL AS [transaction!1!PopulatePSsegment],
		
		@BillerType AS [billing!2!biller-type],
		@PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!country],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],
		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-country],
		NULL AS [billing!2!paytopo-name],
		NULL AS [billing!2!paytopo-street-1],
		NULL AS [billing!2!paytopo-street-2],
		NULL AS [billing!2!paytopo-city],
		NULL AS [billing!2!paytopo-state],
		NULL AS [billing!2!paytopo-zipcode],
		NULL AS [billing!2!paytopo-country],
		
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
		NULL as [billing!2!group-taxonomy-code],
		@PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!insurance-type-code],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier-qualifier],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!payer-country],
		NULL AS [subscriber!3!payer-secondary-id],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [subscriber!3!responsible-country],
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [subscriber!3!relation-to-insured-code],
		@PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!country],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [patient!4!relation-to-insured],
		NULL AS [patient!4!property-casualty-claim-number],
		@bill_id AS [claim!2300!claim-id],
		NULL AS [claim!2300!control-number],
		NULL AS [claim!2300!total-claim-amount],
		NULL AS [claim!2300!place-of-service-code],
		NULL AS [claim!2300!provider-signature-flag],
		NULL AS [claim!2300!medicare-assignment-code],
		NULL AS [claim!2300!assignment-of-benefits-flag],
		NULL AS [claim!2300!release-of-information-code],
		NULL AS [claim!2300!patient-signature-source-code],
		NULL AS [claim!2300!auto-accident-related-flag],
		NULL AS [claim!2300!abuse-related-flag],
		NULL AS [claim!2300!pregnancy-related-flag],
		NULL AS [claim!2300!employment-related-flag],
		NULL AS [claim!2300!other-accident-related-flag],
		NULL AS [claim!2300!auto-accident-state],
		NULL AS [claim!2300!special-program-code],
		NULL AS [claim!2300!initial-treatment-date],
		NULL AS [claim!2300!last-menstrual-date],
		NULL AS [claim!2300!referral-date],
		NULL AS [claim!2300!last-seen-date],
		NULL AS [claim!2300!current-illness-date],
		NULL AS [claim!2300!acute-manifestation-date],
		NULL AS [claim!2300!similar-illness-date],
		NULL AS [claim!2300!accident-date],
		NULL AS [claim!2300!last-xray-date],
		NULL AS [claim!2300!disability-begin-date],
		NULL AS [claim!2300!disability-end-date],
		NULL AS [claim!2300!last-worked-date],
		NULL AS [claim!2300!return-to-work-date],
		NULL AS [claim!2300!hospitalization-begin-date],
		NULL AS [claim!2300!hospitalization-end-date],
		NULL AS [claim!2300!pwk-attachment-report-type-code],
		NULL AS [claim!2300!pwk-attachment-control-number],
		NULL AS [claim!2300!patient-paid-amount],
		NULL AS [claim!2300!authorization-number],
		NULL AS [claim!2300!referral-number],
		NULL AS [claim!2300!diagnosis-1],
		NULL AS [claim!2300!diagnosis-2],
		NULL AS [claim!2300!diagnosis-3],
		NULL AS [claim!2300!diagnosis-4],
		NULL AS [claim!2300!diagnosis-5],
		NULL AS [claim!2300!diagnosis-6],
		NULL AS [claim!2300!diagnosis-7],
		NULL AS [claim!2300!diagnosis-8],
		NULL AS [claim!2300!diagnosis-9],
		NULL AS [claim!2300!diagnosis-10],
		NULL AS [claim!2300!diagnosis-11],
		NULL AS [claim!2300!diagnosis-12],
		NULL AS [claim!2300!clia-number],
		NULL AS [claim!2300!referring-provider-flag],
		NULL AS [claim!2300!referring-provider-first-name],
		NULL AS [claim!2300!referring-provider-middle-name],
		NULL AS [claim!2300!referring-provider-last-name],
		NULL AS [claim!2300!referring-provider-suffix],
		NULL AS [claim!2300!referring-provider-upin],
		NULL AS [claim!2300!referring-provider-npi],
		NULL AS [claim!2300!supervising-provider-flag],
		NULL AS [claim!2300!supervising-provider-first-name],
		NULL AS [claim!2300!supervising-provider-middle-name],
		NULL AS [claim!2300!supervising-provider-last-name],
		NULL AS [claim!2300!supervising-provider-suffix],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-npi],
		NULL AS [claim!2300!supervising-provider-id-qualifier],
		NULL AS [claim!2300!supervising-provider-id-number],
		NULL AS [claim!2300!rendering-provider-first-name],
		NULL AS [claim!2300!rendering-provider-middle-name],
		NULL AS [claim!2300!rendering-provider-last-name],
		NULL AS [claim!2300!rendering-provider-suffix],
		NULL AS [claim!2300!rendering-provider-ssn-qual],
		NULL AS [claim!2300!rendering-provider-ssn],
		NULL AS [claim!2300!rendering-provider-upin],
		NULL AS [claim!2300!rendering-provider-npi],
		NULL AS [claim!2300!rendering-provider-specialty-code],
		NULL AS [claim!2300!service-facility-name],
		NULL AS [claim!2300!service-facility-street-1],
		NULL AS [claim!2300!service-facility-street-2],
		NULL AS [claim!2300!service-facility-city],
		NULL AS [claim!2300!service-facility-state],
		NULL AS [claim!2300!service-facility-zip],
		NULL AS [claim!2300!service-facility-country],
		NULL AS [claim!2300!service-facility-id],
		NULL AS [claim!2300!service-facility-id-qualifier],
		NULL AS [claim!2300!service-facility-npi],
		NULL AS [claim!2300!service-facility-force-output],
		NULL AS [claim!2300!service-facility-phone],
		NULL AS [claim!2300!service-facility-phone-ext],
		NULL AS [claim!2300!file-information],
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!hipaa-delay-reason-code],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL  AS [claim!2300!ambulance-pickup-address1],
		NULL  AS [claim!2300!ambulance-pickup-address2],
		NULL  AS [claim!2300!ambulance-pickup-city],
		NULL  AS [claim!2300!ambulance-pickup-state],
		NULL  AS [claim!2300!ambulance-pickup-zipcode],
		NULL  AS [claim!2300!ambulance-fromcountry],
		NULL  AS [claim!2300!ambulance-address-dropoff],
		NULL  AS [claim!2300!ambulance-dropoff-address1],
		NULL  AS [claim!2300!ambulance-dropoff-address2],
		NULL  AS [claim!2300!ambulance-dropoff-city],
		NULL  AS [claim!2300!ambulance-dropoff-state],
		NULL  AS [claim!2300!ambulance-dropoff-zipcode],
		NULL  AS [claim!2300!ambulance-dropoff-country],
		NULL AS [claim!2300!ambulance-purpose-roundtrip],
		NULL AS [claim!2300!ambulance-purpose-stretcher],
		NULL AS [claim!2300!ambulance-condition-1],
		NULL AS [claim!2300!ambulance-condition-2],
		NULL AS [claim!2300!ambulance-condition-3],
		NULL AS [claim!2300!ambulance-condition-4],
		NULL AS [claim!2300!ambulance-condition-5],
		NULL AS [claim!2300!epsdt-referral-given],
		NULL AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		NULL AS [claim!2300!mammography-certification-number],
		NULL AS [claim!2300!contract-otaf-amount],
		NULL AS [claim!2300!contract-code],
		NULL AS [claim!2300!spinal-manipulation-flag],
		NULL AS [claim!2300!spinal-condition-code],
		NULL AS [claim!2300!spinal-xray-availability-flag],
		NULL AS [claim!2300!dcn],
		NULL AS [claim!2300!submit-reason-code], 
		COBOS.InsurancePolicyID
			AS [otherpayercob!2320!insurance-policy-id],
		0 AS [otherpayercob!2320!sum-patient-responsibility],
		@SumContractAdjustments AS [otherpayercob!2320!sum-contract-adjustments],
		COBOS.[insured-different-than-patient-flag]
			AS [otherpayercob!2320!insured-different-than-patient-flag],
		COBOS.[subscriber-first-name]
			AS [otherpayercob!2320!subscriber-first-name],
		COBOS.[subscriber-middle-name]
			AS [otherpayercob!2320!subscriber-middle-name],
		COBOS.[subscriber-last-name]
			AS [otherpayercob!2320!subscriber-last-name],
		COBOS.[subscriber-suffix]
			AS [otherpayercob!2320!subscriber-suffix],
		COBOS.[subscriber-street-1]
			AS [otherpayercob!2320!subscriber-street-1],
		COBOS.[subscriber-street-2]
			AS [otherpayercob!2320!subscriber-street-2],
		COBOS.[subscriber-city]
			AS [otherpayercob!2320!subscriber-city],
		COBOS.[subscriber-state]
			AS [otherpayercob!2320!subscriber-state],
		COBOS.[subscriber-zip]
			AS [otherpayercob!2320!subscriber-zip],
		COBOS.[subscriber-country]
			AS [otherpayercob!2320!subscriber-country],
		COBOS.[subscriber-birth-date]
			AS [otherpayercob!2320!subscriber-birth-date],
		COBOS.[subscriber-gender]
			AS [otherpayercob!2320!subscriber-gender],
		COBOS.[subscriber-assignment-of-benefits-flag]
			AS [otherpayercob!2320!subscriber-assignment-of-benefits-flag],
		COBOS.[subscriber-release-of-information-code]
			AS [otherpayercob!2320!subscriber-release-of-information-code],
		COBOS.[relation-to-insured-code]
			AS [otherpayercob!2320!relation-to-insured-code],
		COBOS.[payer-responsibility-code] 	
			AS [otherpayercob!2320!payer-responsibility-code],
		COBOS.[payer-responsibility-code-order]
			AS [otherpayercob!2320!payer-responsibility-code-order],	
		COBOS.[claim-filing-indicator-code]
			AS [otherpayercob!2320!claim-filing-indicator-code],
		COBOS.[plan-name]
			AS [otherpayercob!2320!plan-name],
		COBOS.[insurance-type-code]
			AS [otherpayercob!2320!insurance-type-code],
		COBOS.[group-number]
			AS [otherpayercob!2320!group-number],
		COBOS.[policy-number]
			AS [otherpayercob!2320!policy-number],
--		COBOS.[payer-name] AS [otherpayercob!2320!payer-name],
		COBOS.[payer-name]
			AS [otherpayercob!2320!payer-name],
		COBOS.[payer-identifier-qualifier]
			AS [otherpayercob!2320!payer-identifier-qualifier],
		CASE @PayerNumber
			WHEN 'MC081' THEN '915'
			--WHEN 'MC029' THEN 'D02' Per Jim: This one let�s wait to deploy and only deploy if needed
			ELSE COBOS.[payer-identifier]
		END
			AS [otherpayercob!2320!payer-identifier],
		COBOS.[payer-street-1]
			AS [otherpayercob!2320!payer-street-1],
		COBOS.[payer-street-2]
			AS [otherpayercob!2320!payer-street-2],
		COBOS.[payer-city]
			AS [otherpayercob!2320!payer-city],
		COBOS.[payer-state]
			AS [otherpayercob!2320!payer-state],
		COBOS.[payer-zip]
			AS [otherpayercob!2320!payer-zip],
		COBOS.[payer-country]
			AS [otherpayercob!2320!payer-country],
		COBOS.[payer-secondary-id]
			AS [otherpayercob!2320!payer-secondary-id],
		COBOS.[payer-contact-name]
			AS [otherpayercob!2320!payer-contact-name],
		COBOS.[payer-contact-phone]
			AS [otherpayercob!2320!payer-contact-phone],
		COBOS.[payer-paid-flag] 
			AS [otherpayercob!2320!payer-paid-flag],
		COBOS.[payer-paid-amount]
			AS [otherpayercob!2320!payer-paid-amount],
		case when (@SumAllowedAmount = 1 and @IncludeZeroAllowedAmount = 1) 
				then CAST(COALESCE(COBOS.[payer-allowed-amount],0) AS varchar(128))
			when @SumAllowedAmount = 1
				then CAST(COBOS.[payer-allowed-amount] AS varchar(128))
			else NULL 
		end AS [otherpayercob!2320!payer-allowed-amount],
		case when (@SumCobAllowedAmount = 1 and @IncludeZeroCobAllowedAmount = 1)
				then CAST(COALESCE(COBOS.[payer-allowed-amount], 0) AS varchar(128))
			when @SumCobAllowedAmount = 1
				then CAST(COBOS.[payer-allowed-amount] AS varchar(128)) 
			else NULL 
		end AS [otherpayercob!2320!payer-cob-allowed-amount],
		case when (@SumPatientResponsibility = 1 and @IncludeZeroPatientResponsibilityAmount = 1)
				then CAST(COALESCE(COBOS.[patient-responsibility-amount], 0) AS varchar(128))
			when @SumPatientResponsibility = 1
				then CAST(COBOS.[patient-responsibility-amount] AS varchar(128)) 
			else NULL 
		end AS [otherpayercob!2320!patient-responsibility-amount],
		@IncludeZeroAllowedAmount as [otherpayercob!2320!include-zero-payer-allowed-amount],
		@IncludeZeroCobAllowedAmount as [otherpayercob!2320!include-zero-payer-cob-allowed-amount],
		@IncludeZeroPatientResponsibilityAmount as [otherpayercob!2320!include-zero-payer-patient-responsibility-amount],
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!referring-clia-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!drug-ndc-code],
		NULL AS [service!2400!drug-quantity],
		NULL AS [service!2400!drug-units-of-measure],
		NULL AS [service!2400!drug-ref-qualifier],
		NULL AS [service!2400!drug-ref-identifier],
		NULL AS [service!2400!measurement-reference-id-code],
		NULL AS [service!2400!measurement-qualifier],
		NULL AS [service!2400!measurement-value],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!emergency-related-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
		NULL AS [service!2400!hospice-employee-indicator],
		NULL AS [service!2400!dme-flag],
		NULL AS [service!2400!ordering-provider-first-name],
		NULL AS [service!2400!ordering-provider-middle-name],
		NULL AS [service!2400!ordering-provider-last-name],
		NULL AS [service!2400!ordering-provider-suffix],
		NULL AS [service!2400!ordering-provider-ssn-qual],
		NULL AS [service!2400!ordering-provider-ssn],
		NULL AS [service!2400!ordering-provider-upin],
		NULL AS [service!2400!ordering-provider-npi],
		NULL AS [service!2400!ordering-provider-addressline1],
		NULL AS [service!2400!ordering-provider-addressline2],
		NULL AS [service!2400!ordering-provider-city],
		NULL AS [service!2400!ordering-provider-state],
		NULL AS [service!2400!ordering-provider-zipcode],
		NULL AS [service!2400!ordering-provider-phone],
		NULL AS [service!2400!service-note-code],
		NULL AS [service!2400!service-note],
		NULL AS [service!2400!noc-service-note],
		NULL AS [service!2400!contract-otaf-amount],
		NULL AS [service!2400!allowed-amount],
		NULL AS [service!2400!approved-amount],
		NULL AS [service!2400!include-zero-approved-amount],
		NULL AS [adjudication!2430!adjudication-id],
		NULL AS [adjudication!2430!payer-identifier],
		NULL AS [adjudication!2430!monetary-amount],
		NULL AS [adjudication!2430!procedure-code],
		NULL AS [adjudication!2430!quantity],
		NULL AS [adjudication!2430!adjudication-date],
		NULL AS [adjudication!2430!kareo-payment-id],
		NULL AS [adjudication!2430!payer-adjusted-flag],
		NULL AS [adjudication!2430!assigned-number],
		NULL AS [adjustment!243001!adjustment-id],
		NULL AS [adjustment!243001!adjustment-group-code],
		NULL AS [adjustment!243001!adjustment-reason-1],
		NULL AS [adjustment!243001!adjustment-amount-1],
		NULL AS [adjustment!243001!adjustment-quantity-1],
		NULL AS [adjustment!243001!adjustment-reason-2],
		NULL AS [adjustment!243001!adjustment-amount-2],
		NULL AS [adjustment!243001!adjustment-quantity-2],
		NULL AS [adjustment!243001!adjustment-reason-3],
		NULL AS [adjustment!243001!adjustment-amount-3],
		NULL AS [adjustment!243001!adjustment-quantity-3],
		NULL AS [adjustment!243001!adjustment-reason-4],
		NULL AS [adjustment!243001!adjustment-amount-4],
		NULL AS [adjustment!243001!adjustment-quantity-4],
		NULL AS [adjustment!243001!adjustment-reason-5],
		NULL AS [adjustment!243001!adjustment-amount-5],
		NULL AS [adjustment!243001!adjustment-quantity-5],
		NULL AS [adjustment!243001!adjustment-reason-6],
		NULL AS [adjustment!243001!adjustment-amount-6],
		NULL AS [adjustment!243001!adjustment-quantity-6],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id]

	FROM	@t_cob_othersubscriber COBOS
	-- END OF SUBSCRIBER LEVEL - LOOP 2320 - COB Other Payer


	UNION ALL

	-- SERVICE LINE HIERARCHICAL LEVEL
	SELECT DISTINCT 2400, 2300,
		CONVERT(VARCHAR,@customer_id) AS [transaction!1!customer-id], 
		CONVERT(VARCHAR,@PracticeID) AS [transaction!1!practice-id],
		2 as [transaction!1!claim-settings-edition], 
		NULL as [transaction!1!claim-type-id],
		@RenderingTaxIDTypeID as [transaction!1!claim-settings-tax-id-type],
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!transaction-type],
		NULL AS [transaction!1!current-date],

		NULL AS [transaction!1!production-flag],
		NULL AS [transaction!1!interchange-authorization-id],
		NULL AS [transaction!1!interchange-security-id],
		NULL AS [transaction!1!original-transaction-flag],

		NULL AS [transaction!1!submitter-name],
		NULL AS [transaction!1!submitter-etin],
		NULL AS [transaction!1!submitter-id],
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],
		
		NULL AS [transaction!1!SuppressRenderingProviderForASC],
		NULL AS [transaction!1!ForcePatientAddressIn2310C],
		NULL AS [transaction!1!PopulatePSsegment],

		@BillerType AS [billing!2!biller-type],
		@PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!country],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],
		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-country],
		
		NULL AS [billing!2!paytopo-name],
		NULL AS [billing!2!paytopo-street-1],
		NULL AS [billing!2!paytopo-street-2],
		NULL AS [billing!2!paytopo-city],
		NULL AS [billing!2!paytopo-state],
		NULL AS [billing!2!paytopo-zipcode],
		NULL AS [billing!2!paytopo-country],
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
		NULL as [billing!2!group-taxonomy-code],
		@PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!insurance-type-code],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier-qualifier],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!payer-country],
		NULL AS [subscriber!3!payer-secondary-id],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [subscriber!3!responsible-country],
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [subscriber!3!relation-to-insured-code],
		@PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!country],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [patient!4!relation-to-insured],
		NULL AS [patient!4!property-casualty-claim-number],
		@bill_id AS [claim!2300!claim-id],
		NULL AS [claim!2300!control-number],
		NULL AS [claim!2300!total-claim-amount],
		NULL AS [claim!2300!place-of-service-code],
		NULL AS [claim!2300!provider-signature-flag],
		NULL AS [claim!2300!medicare-assignment-code],
		NULL AS [claim!2300!assignment-of-benefits-flag],
		NULL AS [claim!2300!release-of-information-code],
		NULL AS [claim!2300!patient-signature-source-code],
		NULL AS [claim!2300!auto-accident-related-flag],
		NULL AS [claim!2300!abuse-related-flag],
		NULL AS [claim!2300!pregnancy-related-flag],
		NULL AS [claim!2300!employment-related-flag],
		NULL AS [claim!2300!other-accident-related-flag],
		NULL AS [claim!2300!auto-accident-state],
		NULL AS [claim!2300!special-program-code],
		NULL AS [claim!2300!initial-treatment-date],
		NULL AS [claim!2300!last-menstrual-date],
		NULL AS [claim!2300!referral-date],
		NULL AS [claim!2300!last-seen-date],
		NULL AS [claim!2300!current-illness-date],
		NULL AS [claim!2300!acute-manifestation-date],
		NULL AS [claim!2300!similar-illness-date],
		NULL AS [claim!2300!accident-date],
		NULL AS [claim!2300!last-xray-date],
		NULL AS [claim!2300!disability-begin-date],
		NULL AS [claim!2300!disability-end-date],
		NULL AS [claim!2300!last-worked-date],
		NULL AS [claim!2300!return-to-work-date],
		NULL AS [claim!2300!hospitalization-begin-date],
		NULL AS [claim!2300!hospitalization-end-date],
		NULL AS [claim!2300!pwk-attachment-report-type-code],
		NULL AS [claim!2300!pwk-attachment-control-number],
		NULL AS [claim!2300!patient-paid-amount],
		NULL AS [claim!2300!authorization-number],
		NULL AS [claim!2300!referral-number],
		NULL AS [claim!2300!diagnosis-1],
		NULL AS [claim!2300!diagnosis-2],
		NULL AS [claim!2300!diagnosis-3],
		NULL AS [claim!2300!diagnosis-4],
		NULL AS [claim!2300!diagnosis-5],
		NULL AS [claim!2300!diagnosis-6],
		NULL AS [claim!2300!diagnosis-7],
		NULL AS [claim!2300!diagnosis-8],
		NULL AS [claim!2300!diagnosis-9],
		NULL AS [claim!2300!diagnosis-10],
		NULL AS [claim!2300!diagnosis-11],
		NULL AS [claim!2300!diagnosis-12],
		NULL AS [claim!2300!clia-number],
		NULL AS [claim!2300!referring-provider-flag],
		NULL AS [claim!2300!referring-provider-first-name],
		NULL AS [claim!2300!referring-provider-middle-name],
		NULL AS [claim!2300!referring-provider-last-name],
		NULL AS [claim!2300!referring-provider-suffix],
		NULL AS [claim!2300!referring-provider-upin],
		NULL AS [claim!2300!referring-provider-npi],
		NULL AS [claim!2300!supervising-provider-flag],
		NULL AS [claim!2300!supervising-provider-first-name],
		NULL AS [claim!2300!supervising-provider-middle-name],
		NULL AS [claim!2300!supervising-provider-last-name],
		NULL AS [claim!2300!supervising-provider-suffix],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-npi],
		NULL AS [claim!2300!supervising-provider-id-qualifier],
		NULL AS [claim!2300!supervising-provider-id-number],
		NULL AS [claim!2300!rendering-provider-first-name],
		NULL AS [claim!2300!rendering-provider-middle-name],
		NULL AS [claim!2300!rendering-provider-last-name],
		NULL AS [claim!2300!rendering-provider-suffix],
		NULL AS [claim!2300!rendering-provider-ssn-qual],
		NULL AS [claim!2300!rendering-provider-ssn],
		NULL AS [claim!2300!rendering-provider-upin],
		NULL AS [claim!2300!rendering-provider-npi],
		NULL AS [claim!2300!rendering-provider-specialty-code],
		NULL AS [claim!2300!service-facility-name],
		NULL AS [claim!2300!service-facility-street-1],
		NULL AS [claim!2300!service-facility-street-2],
		NULL AS [claim!2300!service-facility-city],
		NULL AS [claim!2300!service-facility-state],
		NULL AS [claim!2300!service-facility-zip],
		NULL AS [claim!2300!service-facility-country],
		NULL AS [claim!2300!service-facility-id],
		NULL AS [claim!2300!service-facility-id-qualifier],
		NULL AS [claim!2300!service-facility-npi],
		NULL AS [claim!2300!service-facility-force-output],
		NULL AS [claim!2300!service-facility-phone],
		NULL AS [claim!2300!service-facility-phone-ext],
		NULL AS [claim!2300!file-information],
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!hipaa-delay-reason-code],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL  AS [claim!2300!ambulance-pickup-address1],
		NULL  AS [claim!2300!ambulance-pickup-address2],
		NULL  AS [claim!2300!ambulance-pickup-city],
		NULL  AS [claim!2300!ambulance-pickup-state],
		NULL  AS [claim!2300!ambulance-pickup-zipcode],
		NULL  AS [claim!2300!ambulance-fromcountry],
		NULL  AS [claim!2300!ambulance-address-dropoff],
		NULL  AS [claim!2300!ambulance-dropoff-address1],
		NULL  AS [claim!2300!ambulance-dropoff-address2],
		NULL  AS [claim!2300!ambulance-dropoff-city],
		NULL  AS [claim!2300!ambulance-dropoff-state],
		NULL  AS [claim!2300!ambulance-dropoff-zipcode],
		NULL  AS [claim!2300!ambulance-dropoff-country],
		NULL AS [claim!2300!ambulance-purpose-roundtrip],
		NULL AS [claim!2300!ambulance-purpose-stretcher],
		NULL AS [claim!2300!ambulance-condition-1],
		NULL AS [claim!2300!ambulance-condition-2],
		NULL AS [claim!2300!ambulance-condition-3],
		NULL AS [claim!2300!ambulance-condition-4],
		NULL AS [claim!2300!ambulance-condition-5],
		NULL AS [claim!2300!epsdt-referral-given],
		NULL AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		NULL AS [claim!2300!mammography-certification-number],
		NULL AS [claim!2300!contract-otaf-amount],
		NULL AS [claim!2300!contract-code],
		NULL AS [claim!2300!spinal-manipulation-flag],
		NULL AS [claim!2300!spinal-condition-code],
		NULL AS [claim!2300!spinal-xray-availability-flag],
		NULL AS [claim!2300!dcn],
		NULL AS [claim!2300!submit-reason-code], 
		NULL AS [otherpayercob!2320!insurance-policy-id],
		NULL AS [otherpayercob!2320!sum-patient-responsibility],
		NULL AS [otherpayercob!2320!sum-contract-adjustments],
		NULL AS [otherpayercob!2320!insured-different-than-patient-flag],
		NULL AS [otherpayercob!2320!subscriber-first-name],
		NULL AS [otherpayercob!2320!subscriber-middle-name],
		NULL AS [otherpayercob!2320!subscriber-last-name],
		NULL AS [otherpayercob!2320!subscriber-suffix],
		NULL AS [otherpayercob!2320!subscriber-street-1],
		NULL AS [otherpayercob!2320!subscriber-street-2],
		NULL AS [otherpayercob!2320!subscriber-city],
		NULL AS [otherpayercob!2320!subscriber-state],
		NULL AS [otherpayercob!2320!subscriber-zip],
		NULL AS [otherpayercob!2320!subscriber-country],
		NULL AS [otherpayercob!2320!subscriber-birth-date],
		NULL AS [otherpayercob!2320!subscriber-gender],
		NULL AS [otherpayercob!2320!subscriber-assignment-of-benefits-flag],
		NULL AS [otherpayercob!2320!subscriber-release-of-information-code],
		NULL AS [otherpayercob!2320!relation-to-insured-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code-order],
		NULL AS [otherpayercob!2320!claim-filing-indicator-code],
		NULL AS [otherpayercob!2320!plan-name],
		NULL AS [otherpayercob!2320!insurance-type-code],
		NULL AS [otherpayercob!2320!group-number],
		NULL AS [otherpayercob!2320!policy-number],
		NULL AS [otherpayercob!2320!payer-name],
		NULL AS [otherpayercob!2320!payer-identifier-qualifier],
		NULL AS [otherpayercob!2320!payer-identifier],
		NULL AS [otherpayercob!2320!payer-street-1],
		NULL AS [otherpayercob!2320!payer-street-2],
		NULL AS [otherpayercob!2320!payer-city],
		NULL AS [otherpayercob!2320!payer-state],
		NULL AS [otherpayercob!2320!payer-zip],
		NULL AS [otherpayercob!2320!payer-country],
		NULL AS [otherpayercob!2320!payer-secondary-id],
		NULL AS [otherpayercob!2320!payer-contact-name],
		NULL AS [otherpayercob!2320!payer-contact-phone],
		NULL AS [otherpayercob!2320!payer-paid-flag],
		NULL AS [otherpayercob!2320!payer-paid-amount],
		NULL AS [otherpayercob!2320!payer-allowed-amount],
		NULL AS [otherpayercob!2320!payer-cob-allowed-amount],
		NULL AS [otherpayercob!2320!patient-responsibility-amount],
		NULL as [otherpayercob!2320!include-zero-payer-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-cob-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-patient-responsibility-amount],
		C.ClaimID AS [service!2400!service-id],
		-- [service!2400!control-number] no more than 20 chars. Must differ from [claim!2300!control-number]:
		'S' + CONVERT(VARCHAR,@customer_id) + 'K' + CONVERT(VARCHAR,BC.ClaimID) + 'K9'
--		'S' + CONVERT(VARCHAR,BC.ClaimID) + 'Z' + CONVERT(VARCHAR,@customer_id)		-- case 18103, 14068
			AS [service!2400!control-number],
		CASE WHEN @ReferringCliaNumberHack = 1 AND @CliaNumber IS NOT NULL AND '90' IN ( EP.ProcedureModifier1, EP.ProcedureModifier2, EP.ProcedureModifier3, EP.ProcedureModifier4) THEN @CliaNumber ELSE NULL END
			AS [service!2400!referring-clia-number],
		UPPER(ISNULL(CASE WHEN LEN(PCD.BillableCode)=0 THEN NULL ELSE PCD.BillableCode END,PCD.ProcedureCode)) AS [service!2400!procedure-code],
		CASE WHEN EP.EDIServiceNoteReferenceCode = 'NDC' AND LEN(EP.EDIServiceNote) = 11 THEN EP.EDIServiceNote
			ELSE REPLACE(dbo.fn_split(PCD.NDC,1,','),'-','') END AS [service!2400!drug-ndc-code],
		CASE WHEN PCD.NDC is NULL THEN NULL ELSE EP.ServiceUnitCount END AS [service!2400!drug-quantity],
		CASE WHEN PCD.NDC is NULL THEN NULL ELSE ISNULL(dbo.fn_split(PCD.NDC,2,','),'UN') END AS [service!2400!drug-units-of-measure],
		CASE WHEN EP.EDIServiceNoteReferenceCode IN ('RX') AND LEN(EP.EDIServiceNote) > 0 THEN 'XZ' 
			 WHEN EP.EDIServiceNoteReferenceCode IN ('VY') AND LEN(EP.EDIServiceNote) > 0 THEN 'VY' 
			 ELSE NULL END AS [service!2400!drug-ref-qualifier],
		CASE WHEN EP.EDIServiceNoteReferenceCode IN ('RX') AND LEN(EP.EDIServiceNote) > 0 THEN EP.EDIServiceNote 
			 WHEN EP.EDIServiceNoteReferenceCode IN ('VY') AND LEN(EP.EDIServiceNote) > 0 THEN EP.EDIServiceNote 
			 ELSE NULL END AS [service!2400!drug-ref-identifier],
		CASE WHEN EP.EDIServiceNoteReferenceCode IN ('MEA') AND LEN(EP.EDIServiceNote) > 0 THEN dbo.fn_split(EP.EDIServiceNote,1,' ') ELSE NULL END AS [service!2400!measurement-reference-id-code],
		CASE WHEN EP.EDIServiceNoteReferenceCode IN ('MEA') AND LEN(EP.EDIServiceNote) > 0 THEN dbo.fn_split(EP.EDIServiceNote,2,' ') ELSE NULL END AS [service!2400!measurement-qualifier],
		CASE WHEN EP.EDIServiceNoteReferenceCode IN ('MEA') AND LEN(EP.EDIServiceNote) > 0 THEN dbo.fn_split(EP.EDIServiceNote,3,' ')+'.'+dbo.fn_split(EP.EDIServiceNote,4,' ') ELSE NULL END AS [service!2400!measurement-value],
		EP.ProcedureDateOfService AS [service!2400!service-date],
		EP.ServiceEndDate AS [service!2400!service-date-end],
--		dbo.BusinessRule_ClaimAdjustedChargeAmount(C.ClaimID) AS [service!2400!service-charge-amount],
--		[dbo].[fn_RoundUpToPenny]( ISNULL(EP.ServiceUnitCount,1) * ISNULL(EP.ServiceChargeAmount,0) ) AS [service!2400!service-charge-amount],
		dbo.BusinessRule_ClaimOriginalChargeAmount(C.ClaimID) AS [service!2400!service-charge-amount],
		CASE WHEN EP.TypeOfServiceCode = '7' AND EP.AnesthesiaTime > 0
			AND ( @Customer_ID <> 2379 OR @PayerNumber <> '59140') -- SF 00212294 Payer 59140 wants UN instead of MJ
				 THEN 'MJ' ELSE 'UN' END AS [service!2400!service-units],      -- '7' is Anesthesia
		CASE WHEN EP.TypeOfServiceCode = '7' AND EP.AnesthesiaTime > 0 THEN EP.AnesthesiaTime ELSE EP.ServiceUnitCount END AS [service!2400!service-unit-count],
		E.PlaceOfServiceCode AS [service!2400!place-of-service-code],
		PC.EPSDT AS [service!2400!epsdt-flag],
		PC.EmergencyRelated AS [service!2400!emergency-related-flag],
		PC.FamilyPlanning AS [service!2400!family-planning-flag],
		EP.ProcedureModifier1 AS [service!2400!procedure-modifier-1],
		EP.ProcedureModifier2 AS [service!2400!procedure-modifier-2],
		EP.ProcedureModifier3 AS [service!2400!procedure-modifier-3],
		EP.ProcedureModifier4 AS [service!2400!procedure-modifier-4],

		CASE WHEN DCD.DiagnosisCode IS NOT NULL THEN CBDP.Pointer ELSE NULL END AS [service!2400!diagnosis-pointer-1],
		CASE WHEN DCD2.DiagnosisCode IS NOT NULL THEN CBDP2.Pointer ELSE NULL END AS [service!2400!diagnosis-pointer-2],
		CASE WHEN DCD3.DiagnosisCode IS NOT NULL THEN CBDP3.Pointer ELSE NULL END AS [service!2400!diagnosis-pointer-3],
		CASE WHEN DCD4.DiagnosisCode IS NOT NULL THEN CBDP4.Pointer ELSE NULL END AS [service!2400!diagnosis-pointer-4],
		
		CASE WHEN E.PlaceOfServiceCode = 34 AND @HospiceEmployeeIndicator IS NOT NULL THEN @HospiceEmployeeIndicator ELSE NULL END AS [service!2400!hospice-employee-indicator],
		
		CASE 
			WHEN EXISTS (SELECT * FROM @PayerHacks WHERE [Name] = 'Suppress2420E') THEN 0
			WHEN EP.TypeOfServiceCode IN ('A','J','P','R','L','S') 
				OR EP.TypeOfServiceCode IS NULL AND PCD.TypeOfServiceCode IN ('A','J','P','R','L','S') THEN 1
			WHEN (EP.TypeOfServiceCode IN ('Q')
				OR EP.TypeOfServiceCode IS NULL AND PCD.TypeOfServiceCode IN ('Q')) AND @Customer_ID =1190  THEN 1		 
			ELSE NULL 
		END AS [service!2400!dme-flag],
		@OPFirstName AS [service!2400!ordering-provider-first-name],
		@OPMiddleName AS [service!2400!ordering-provider-middle-name],
		@OPLastName AS [service!2400!ordering-provider-last-name],
		@OPSuffix AS [service!2400!ordering-provider-suffix],
		@OPSSNQualifier AS [service!2400!ordering-provider-ssn-qual],
		@OPSSN AS [service!2400!ordering-provider-ssn],
		@OPUPIN AS [service!2400!ordering-provider-upin],
		@OPNPI AS [service!2400!ordering-provider-npi],
		@OPAddressLine1 AS [service!2400!ordering-provider-addressline1],
		@OPAddressLine2 AS [service!2400!ordering-provider-addressline2],
		@OPCity AS [service!2400!ordering-provider-city],
		@OPState AS [service!2400!ordering-provider-state],
		@OPZipCode AS [service!2400!ordering-provider-zipcode],
		@OPPhone AS [service!2400!ordering-provider-phone],
		CASE WHEN EP.EDIServiceNoteReferenceCode IN ('ADD','DCP') AND LEN(EP.EDIServiceNote) > 0 THEN EP.EDIServiceNoteReferenceCode ELSE NULL END AS [service!2400!service-note-code],
		CASE WHEN EP.EDIServiceNoteReferenceCode IN ('ADD','DCP') AND LEN(EP.EDIServiceNote) > 0 THEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(EP.EDIServiceNote,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) ELSE NULL END AS [service!2400!service-note],
		PCD.NOC AS [service!2400!noc-service-note],
		case when @SumCobContractOtaf = 1 then CAST(TCSA.[approved-amount] AS varchar(128)) ELSE NULL END AS [service!2400!contract-otaf-amount],
		CAST(TCSA.[allowed-amount] AS varchar(128)) AS [service!2400!allowed-amount],
		CASE WHEN @IncludeZeroServiceLineApprovedAmount = 1 THEN CAST(COALESCE(TCSA.[approved-amount],0) AS varchar(128)) ELSE CAST(TCSA.[approved-amount] AS varchar(128)) END AS [service!2400!approved-amount],
		@IncludeZeroServiceLineApprovedAmount AS [service!2400!include-zero-approved-amount],
		NULL AS [adjudication!2430!adjudication-id], 
		NULL AS [adjudication!2430!payer-identifier],
		NULL AS [adjudication!2430!monetary-amount],
		NULL AS [adjudication!2430!procedure-code],
		NULL AS [adjudication!2430!quantity],
		NULL AS [adjudication!2430!adjudication-date],
		NULL AS [adjudication!2430!kareo-payment-id],
		NULL AS [adjudication!2430!payer-adjusted-flag],
		NULL AS [adjudication!2430!assigned-number],
		NULL AS [adjustment!243001!adjustment-id],
		NULL AS [adjustment!243001!adjustment-group-code],
		NULL AS [adjustment!243001!adjustment-reason-1],
		NULL AS [adjustment!243001!adjustment-amount-1],
		NULL AS [adjustment!243001!adjustment-quantity-1],
		NULL AS [adjustment!243001!adjustment-reason-2],
		NULL AS [adjustment!243001!adjustment-amount-2],
		NULL AS [adjustment!243001!adjustment-quantity-2],
		NULL AS [adjustment!243001!adjustment-reason-3],
		NULL AS [adjustment!243001!adjustment-amount-3],
		NULL AS [adjustment!243001!adjustment-quantity-3],
		NULL AS [adjustment!243001!adjustment-reason-4],
		NULL AS [adjustment!243001!adjustment-amount-4],
		NULL AS [adjustment!243001!adjustment-quantity-4],
		NULL AS [adjustment!243001!adjustment-reason-5],
		NULL AS [adjustment!243001!adjustment-amount-5],
		NULL AS [adjustment!243001!adjustment-quantity-5],
		NULL AS [adjustment!243001!adjustment-reason-6],
		NULL AS [adjustment!243001!adjustment-amount-6],
		NULL AS [adjustment!243001!adjustment-quantity-6],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id]

	FROM Claim RC
		INNER JOIN BillClaim BC
		ON BC.BillID = @bill_id
		AND BC.BillBatchTypeCode = 'E'
		INNER JOIN Claim C
		ON C.ClaimID = BC.ClaimID
		INNER JOIN dbo.EncounterProcedure EP
		ON EP.EncounterProcedureID = C.EncounterProcedureID
		INNER JOIN ProcedureCodeDictionary PCD
		ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
		INNER JOIN Encounter E
		ON E.EncounterID = EP.EncounterID
		INNER JOIN PatientCase PC
		ON PC.PatientCaseID = E.PatientCaseID

		LEFT JOIN @t_cob_svcadjudication TCSA ON TCSA.ClaimID = BC.ClaimID

		LEFT JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID1=ED.EncounterDiagnosisID
		LEFT JOIN DiagnosisCodeDictionary DCD
		ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID
		LEFT JOIN #ClaimBatchDiagnosesPointers CBDP ON CBDP.ClaimID = BC.ClaimID AND DCD.DiagnosisCode = CBDP.DiagnosisCode

		LEFT JOIN EncounterDiagnosis ED2 ON EP.EncounterDiagnosisID2=ED2.EncounterDiagnosisID
		LEFT JOIN DiagnosisCodeDictionary DCD2
		ON ED2.DiagnosisCodeDictionaryID=DCD2.DiagnosisCodeDictionaryID
		LEFT JOIN #ClaimBatchDiagnosesPointers CBDP2 ON CBDP2.ClaimID = BC.ClaimID AND DCD2.DiagnosisCode = CBDP2.DiagnosisCode

		LEFT JOIN EncounterDiagnosis ED3 ON EP.EncounterDiagnosisID3=ED3.EncounterDiagnosisID
		LEFT JOIN DiagnosisCodeDictionary DCD3
		ON ED3.DiagnosisCodeDictionaryID=DCD3.DiagnosisCodeDictionaryID
		LEFT JOIN #ClaimBatchDiagnosesPointers CBDP3 ON CBDP3.ClaimID = BC.ClaimID AND DCD3.DiagnosisCode = CBDP3.DiagnosisCode

		LEFT JOIN EncounterDiagnosis ED4 ON EP.EncounterDiagnosisID4=ED4.EncounterDiagnosisID
		LEFT JOIN DiagnosisCodeDictionary DCD4
		ON ED4.DiagnosisCodeDictionaryID=DCD4.DiagnosisCodeDictionaryID	
		LEFT JOIN #ClaimBatchDiagnosesPointers CBDP4 ON CBDP4.ClaimID = BC.ClaimID AND DCD4.DiagnosisCode = CBDP4.DiagnosisCode


		LEFT JOIN VoidedClaims VC
		ON VC.ClaimID = BC.ClaimID

	WHERE	RC.ClaimID = @RepresentativeClaimID
	AND		VC.ClaimID IS NULL
	-- END OF SERVICE LINE HIERARCHICAL LEVEL

	UNION ALL

	-- RENDERING PROVIDER NUMBERS - INSURANCE PLAN ASSIGNED PROVIDER ID
	-- Rendering provider numbers for REF (Doctor provider numbers, Loop 2310B):
	SELECT DISTINCT	10, 2300,
		CONVERT(VARCHAR,@customer_id) AS [transaction!1!customer-id], 
		CONVERT(VARCHAR,@PracticeID) AS [transaction!1!practice-id],
		2 as [transaction!1!claim-settings-edition], 
		NULL as [transaction!1!claim-type-id],
		@RenderingTaxIDTypeID as [transaction!1!claim-settings-tax-id-type],
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!transaction-type],
		NULL AS [transaction!1!current-date],

		NULL AS [transaction!1!production-flag],
		NULL AS [transaction!1!interchange-authorization-id],
		NULL AS [transaction!1!interchange-security-id],
		NULL AS [transaction!1!original-transaction-flag],

		NULL AS [transaction!1!submitter-name],
		NULL AS [transaction!1!submitter-etin],
		NULL AS [transaction!1!submitter-id],
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],
		
		NULL AS [transaction!1!SuppressRenderingProviderForASC],
		NULL AS [transaction!1!ForcePatientAddressIn2310C],
		NULL AS [transaction!1!PopulatePSsegment],

		@BillerType AS [billing!2!biller-type],
		@PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!country],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],
		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-country],
		NULL AS [billing!2!paytopo-name],
		NULL AS [billing!2!paytopo-street-1],
		NULL AS [billing!2!paytopo-street-2],
		NULL AS [billing!2!paytopo-city],
		NULL AS [billing!2!paytopo-state],
		NULL AS [billing!2!paytopo-zipcode],
		NULL AS [billing!2!paytopo-country],
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
		NULL as [billing!2!group-taxonomy-code],
		@PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!insurance-type-code],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier-qualifier],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!payer-country],
		NULL AS [subscriber!3!payer-secondary-id],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [subscriber!3!responsible-country],
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [subscriber!3!relation-to-insured-code],
		@PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!country],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [patient!4!relation-to-insured],
		NULL AS [patient!4!property-casualty-claim-number],
		@bill_id AS [claim!2300!claim-id],
		NULL AS [claim!2300!control-number],
		NULL AS [claim!2300!total-claim-amount],
		NULL AS [claim!2300!place-of-service-code],
		NULL AS [claim!2300!provider-signature-flag],
		NULL AS [claim!2300!medicare-assignment-code],
		NULL AS [claim!2300!assignment-of-benefits-flag],
		NULL AS [claim!2300!release-of-information-code],
		NULL AS [claim!2300!patient-signature-source-code],
		NULL AS [claim!2300!auto-accident-related-flag],
		NULL AS [claim!2300!abuse-related-flag],
		NULL AS [claim!2300!pregnancy-related-flag],
		NULL AS [claim!2300!employment-related-flag],
		NULL AS [claim!2300!other-accident-related-flag],
		NULL AS [claim!2300!auto-accident-state],
		NULL AS [claim!2300!special-program-code],
		NULL AS [claim!2300!initial-treatment-date],
		NULL AS [claim!2300!last-menstrual-date],
		NULL AS [claim!2300!referral-date],
		NULL AS [claim!2300!last-seen-date],
		NULL AS [claim!2300!current-illness-date],
		NULL AS [claim!2300!acute-manifestation-date],
		NULL AS [claim!2300!similar-illness-date],
		NULL AS [claim!2300!accident-date],
		NULL AS [claim!2300!last-xray-date],
		NULL AS [claim!2300!disability-begin-date],
		NULL AS [claim!2300!disability-end-date],
		NULL AS [claim!2300!last-worked-date],
		NULL AS [claim!2300!return-to-work-date],
		NULL AS [claim!2300!hospitalization-begin-date],
		NULL AS [claim!2300!hospitalization-end-date],
		NULL AS [claim!2300!pwk-attachment-report-type-code],
		NULL AS [claim!2300!pwk-attachment-control-number],
		NULL AS [claim!2300!patient-paid-amount],
		NULL AS [claim!2300!authorization-number],
		NULL AS [claim!2300!referral-number],
		NULL AS [claim!2300!diagnosis-1],
		NULL AS [claim!2300!diagnosis-2],
		NULL AS [claim!2300!diagnosis-3],
		NULL AS [claim!2300!diagnosis-4],
		NULL AS [claim!2300!diagnosis-5],
		NULL AS [claim!2300!diagnosis-6],
		NULL AS [claim!2300!diagnosis-7],
		NULL AS [claim!2300!diagnosis-8],
		NULL AS [claim!2300!diagnosis-9],
		NULL AS [claim!2300!diagnosis-10],
		NULL AS [claim!2300!diagnosis-11],
		NULL AS [claim!2300!diagnosis-12],
		NULL AS [claim!2300!clia-number],
		NULL AS [claim!2300!referring-provider-flag],
		NULL AS [claim!2300!referring-provider-first-name],
		NULL AS [claim!2300!referring-provider-middle-name],
		NULL AS [claim!2300!referring-provider-last-name],
		NULL AS [claim!2300!referring-provider-suffix],
		NULL AS [claim!2300!referring-provider-upin],
		NULL AS [claim!2300!referring-provider-npi],
		NULL AS [claim!2300!supervising-provider-flag],
		NULL AS [claim!2300!supervising-provider-first-name],
		NULL AS [claim!2300!supervising-provider-middle-name],
		NULL AS [claim!2300!supervising-provider-last-name],
		NULL AS [claim!2300!supervising-provider-suffix],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-npi],
		NULL AS [claim!2300!supervising-provider-id-qualifier],
		NULL AS [claim!2300!supervising-provider-id-number],
		NULL AS [claim!2300!rendering-provider-first-name],
		NULL AS [claim!2300!rendering-provider-middle-name],
		NULL AS [claim!2300!rendering-provider-last-name],
		NULL AS [claim!2300!rendering-provider-suffix],
		NULL AS [claim!2300!rendering-provider-ssn-qual],
		NULL AS [claim!2300!rendering-provider-ssn],
		NULL AS [claim!2300!rendering-provider-upin],
		NULL AS [claim!2300!rendering-provider-npi],
		NULL AS [claim!2300!rendering-provider-specialty-code],
		NULL AS [claim!2300!service-facility-name],
		NULL AS [claim!2300!service-facility-street-1],
		NULL AS [claim!2300!service-facility-street-2],
		NULL AS [claim!2300!service-facility-city],
		NULL AS [claim!2300!service-facility-state],
		NULL AS [claim!2300!service-facility-zip],
		NULL AS [claim!2300!service-facility-country],
		NULL AS [claim!2300!service-facility-id],
		NULL AS [claim!2300!service-facility-id-qualifier],
		NULL AS [claim!2300!service-facility-npi],
		NULL AS [claim!2300!service-facility-force-output],
		NULL AS [claim!2300!service-facility-phone],
		NULL AS [claim!2300!service-facility-phone-ext],
		NULL AS [claim!2300!file-information],
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!hipaa-delay-reason-code],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL  AS [claim!2300!ambulance-pickup-address1],
		NULL  AS [claim!2300!ambulance-pickup-address2],
		NULL  AS [claim!2300!ambulance-pickup-city],
		NULL  AS [claim!2300!ambulance-pickup-state],
		NULL  AS [claim!2300!ambulance-pickup-zipcode],
		NULL  AS [claim!2300!ambulance-fromcountry],
		NULL  AS [claim!2300!ambulance-address-dropoff],
		NULL  AS [claim!2300!ambulance-dropoff-address1],
		NULL  AS [claim!2300!ambulance-dropoff-address2],
		NULL  AS [claim!2300!ambulance-dropoff-city],
		NULL  AS [claim!2300!ambulance-dropoff-state],
		NULL  AS [claim!2300!ambulance-dropoff-zipcode],
		NULL  AS [claim!2300!ambulance-dropoff-country],
		NULL AS [claim!2300!ambulance-purpose-roundtrip],
		NULL AS [claim!2300!ambulance-purpose-stretcher],
		NULL AS [claim!2300!ambulance-condition-1],
		NULL AS [claim!2300!ambulance-condition-2],
		NULL AS [claim!2300!ambulance-condition-3],
		NULL AS [claim!2300!ambulance-condition-4],
		NULL AS [claim!2300!ambulance-condition-5],
		NULL AS [claim!2300!epsdt-referral-given],
		NULL AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		NULL AS [claim!2300!mammography-certification-number],
		NULL AS [claim!2300!contract-otaf-amount],
		NULL AS [claim!2300!contract-code],
		NULL AS [claim!2300!spinal-manipulation-flag],
		NULL AS [claim!2300!spinal-condition-code],
		NULL AS [claim!2300!spinal-xray-availability-flag],
		NULL AS [claim!2300!dcn],
		NULL AS [claim!2300!submit-reason-code], 
		NULL AS [otherpayercob!2320!insurance-policy-id],		-- @PayerInsurancePolicyID - the NULL here would break some rare submissions, and any variable may ruin DISTINCT.
		NULL AS [otherpayercob!2320!sum-patient-responsibility],
		NULL AS [otherpayercob!2320!sum-contract-adjustments],
		NULL AS [otherpayercob!2320!insured-different-than-patient-flag],
		NULL AS [otherpayercob!2320!subscriber-first-name],
		NULL AS [otherpayercob!2320!subscriber-middle-name],
		NULL AS [otherpayercob!2320!subscriber-last-name],
		NULL AS [otherpayercob!2320!subscriber-suffix],
		NULL AS [otherpayercob!2320!subscriber-street-1],
		NULL AS [otherpayercob!2320!subscriber-street-2],
		NULL AS [otherpayercob!2320!subscriber-city],
		NULL AS [otherpayercob!2320!subscriber-state],
		NULL AS [otherpayercob!2320!subscriber-zip],
		NULL AS [otherpayercob!2320!subscriber-country],
		NULL AS [otherpayercob!2320!subscriber-birth-date],
		NULL AS [otherpayercob!2320!subscriber-gender],
		NULL AS [otherpayercob!2320!subscriber-assignment-of-benefits-flag],
		NULL AS [otherpayercob!2320!subscriber-release-of-information-code],
		NULL AS [otherpayercob!2320!relation-to-insured-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code-order],
		NULL AS [otherpayercob!2320!claim-filing-indicator-code],
		NULL AS [otherpayercob!2320!plan-name],
		NULL AS [otherpayercob!2320!insurance-type-code],
		NULL AS [otherpayercob!2320!group-number],
		NULL AS [otherpayercob!2320!policy-number],
		NULL AS [otherpayercob!2320!payer-name],
		NULL AS [otherpayercob!2320!payer-identifier-qualifier],
		NULL AS [otherpayercob!2320!payer-identifier],
		NULL AS [otherpayercob!2320!payer-street-1],
		NULL AS [otherpayercob!2320!payer-street-2],
		NULL AS [otherpayercob!2320!payer-city],
		NULL AS [otherpayercob!2320!payer-state],
		NULL AS [otherpayercob!2320!payer-zip],
		NULL AS [otherpayercob!2320!payer-country],
		NULL AS [otherpayercob!2320!payer-secondary-id],
		NULL AS [otherpayercob!2320!payer-contact-name],
		NULL AS [otherpayercob!2320!payer-contact-phone],
		NULL AS [otherpayercob!2320!payer-paid-flag],
		NULL AS [otherpayercob!2320!payer-paid-amount],
		NULL AS [otherpayercob!2320!payer-allowed-amount],
		NULL AS [otherpayercob!2320!payer-cob-allowed-amount],
		NULL AS [otherpayercob!2320!patient-responsibility-amount],
		NULL as [otherpayercob!2320!include-zero-payer-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-cob-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-patient-responsibility-amount],
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!referring-clia-number],		
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!drug-ndc-code],
		NULL AS [service!2400!drug-quantity],
		NULL AS [service!2400!drug-units-of-measure],
		NULL AS [service!2400!drug-ref-qualifier],
		NULL AS [service!2400!drug-ref-identifier],
		NULL AS [service!2400!measurement-reference-id-code],
		NULL AS [service!2400!measurement-qualifier],
		NULL AS [service!2400!measurement-value],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!emergency-related-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
		NULL AS [service!2400!hospice-employee-indicator],
		NULL AS [service!2400!dme-flag],
		NULL AS [service!2400!ordering-provider-first-name],
		NULL AS [service!2400!ordering-provider-middle-name],
		NULL AS [service!2400!ordering-provider-last-name],
		NULL AS [service!2400!ordering-provider-suffix],
		NULL AS [service!2400!ordering-provider-ssn-qual],
		NULL AS [service!2400!ordering-provider-ssn],
		NULL AS [service!2400!ordering-provider-upin],
		NULL AS [service!2400!ordering-provider-npi],
		NULL AS [service!2400!ordering-provider-addressline1],
		NULL AS [service!2400!ordering-provider-addressline2],
		NULL AS [service!2400!ordering-provider-city],
		NULL AS [service!2400!ordering-provider-state],
		NULL AS [service!2400!ordering-provider-zipcode],
		NULL AS [service!2400!ordering-provider-phone],
		NULL AS [service!2400!service-note-code],
		NULL AS [service!2400!service-note],
		NULL AS [service!2400!noc-service-note],
		NULL AS [service!2400!contract-otaf-amount],
		NULL AS [service!2400!allowed-amount],
		NULL AS [service!2400!approved-amount],
		NULL AS [service!2400!include-zero-approved-amount],
		NULL AS [adjudication!2430!adjudication-id],
		NULL AS [adjudication!2430!payer-identifier],
		NULL AS [adjudication!2430!monetary-amount],
		NULL AS [adjudication!2430!procedure-code],
		NULL AS [adjudication!2430!quantity],
		NULL AS [adjudication!2430!adjudication-date],
		NULL AS [adjudication!2430!kareo-payment-id],
		NULL AS [adjudication!2430!payer-adjusted-flag],
		NULL AS [adjudication!2430!assigned-number],
		NULL AS [adjustment!243001!adjustment-id],
		NULL AS [adjustment!243001!adjustment-group-code],
		NULL AS [adjustment!243001!adjustment-reason-1],
		NULL AS [adjustment!243001!adjustment-amount-1],
		NULL AS [adjustment!243001!adjustment-quantity-1],
		NULL AS [adjustment!243001!adjustment-reason-2],
		NULL AS [adjustment!243001!adjustment-amount-2],
		NULL AS [adjustment!243001!adjustment-quantity-2],
		NULL AS [adjustment!243001!adjustment-reason-3],
		NULL AS [adjustment!243001!adjustment-amount-3],
		NULL AS [adjustment!243001!adjustment-quantity-3],
		NULL AS [adjustment!243001!adjustment-reason-4],
		NULL AS [adjustment!243001!adjustment-amount-4],
		NULL AS [adjustment!243001!adjustment-quantity-4],
		NULL AS [adjustment!243001!adjustment-reason-5],
		NULL AS [adjustment!243001!adjustment-amount-5],
		NULL AS [adjustment!243001!adjustment-quantity-5],
		NULL AS [adjustment!243001!adjustment-reason-6],
		NULL AS [adjustment!243001!adjustment-amount-6],
		NULL AS [adjustment!243001!adjustment-quantity-6],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],
		PT.ANSIReferenceIdentificationQualifier AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		PT.ProviderNumber AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id]

	FROM	@t_providernumbers PT
	-- END OF RENDERING PROVIDER NUMBERS - INSURANCE PLAN ASSIGNED PROVIDER ID

	UNION ALL

	-- REFERRING PROVIDER NUMBERS - INSURANCE PLAN ASSIGNED PROVIDER ID
	SELECT DISTINCT	11, 2300,
		CONVERT(VARCHAR,@customer_id) AS [transaction!1!customer-id], 
		CONVERT(VARCHAR,@PracticeID) AS [transaction!1!practice-id],
		2 as [transaction!1!claim-settings-edition], 
		NULL as [transaction!1!claim-type-id],
		@RenderingTaxIDTypeID as [transaction!1!claim-settings-tax-id-type],
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!transaction-type],
		NULL AS [transaction!1!current-date],

		NULL AS [transaction!1!production-flag],
		NULL AS [transaction!1!interchange-authorization-id],
		NULL AS [transaction!1!interchange-security-id],
		NULL AS [transaction!1!original-transaction-flag],

		NULL AS [transaction!1!submitter-name],
		NULL AS [transaction!1!submitter-etin],
		NULL AS [transaction!1!submitter-id],
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

		NULL AS [transaction!1!SuppressRenderingProviderForASC],
		NULL AS [transaction!1!ForcePatientAddressIn2310C],
		NULL AS [transaction!1!PopulatePSsegment],
		
		@BillerType AS [billing!2!biller-type],
		@PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!country],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],
		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-country],
		NULL AS [billing!2!paytopo-name],
		NULL AS [billing!2!paytopo-street-1],
		NULL AS [billing!2!paytopo-street-2],
		NULL AS [billing!2!paytopo-city],
		NULL AS [billing!2!paytopo-state],
		NULL AS [billing!2!paytopo-zipcode],
		NULL AS [billing!2!paytopo-country],
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
		NULL as [billing!2!group-taxonomy-code],
		@PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!insurance-type-code],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier-qualifier],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!payer-country],
		NULL AS [subscriber!3!payer-secondary-id],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [subscriber!3!responsible-country],
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [subscriber!3!relation-to-insured-code],
		@PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!country],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [patient!4!relation-to-insured],
		NULL AS [patient!4!property-casualty-claim-number],
		@bill_id AS [claim!2300!claim-id],
		NULL AS [claim!2300!control-number],
		NULL AS [claim!2300!total-claim-amount],
		NULL AS [claim!2300!place-of-service-code],
		NULL AS [claim!2300!provider-signature-flag],
		NULL AS [claim!2300!medicare-assignment-code],
		NULL AS [claim!2300!assignment-of-benefits-flag],
		NULL AS [claim!2300!release-of-information-code],
		NULL AS [claim!2300!patient-signature-source-code],
		NULL AS [claim!2300!auto-accident-related-flag],
		NULL AS [claim!2300!abuse-related-flag],
		NULL AS [claim!2300!pregnancy-related-flag],
		NULL AS [claim!2300!employment-related-flag],
		NULL AS [claim!2300!other-accident-related-flag],
		NULL AS [claim!2300!auto-accident-state],
		NULL AS [claim!2300!special-program-code],
		NULL AS [claim!2300!initial-treatment-date],
		NULL AS [claim!2300!last-menstrual-date],
		NULL AS [claim!2300!referral-date],
		NULL AS [claim!2300!last-seen-date],
		NULL AS [claim!2300!current-illness-date],
		NULL AS [claim!2300!acute-manifestation-date],
		NULL AS [claim!2300!similar-illness-date],
		NULL AS [claim!2300!accident-date],
		NULL AS [claim!2300!last-xray-date],
		NULL AS [claim!2300!disability-begin-date],
		NULL AS [claim!2300!disability-end-date],
		NULL AS [claim!2300!last-worked-date],
		NULL AS [claim!2300!return-to-work-date],
		NULL AS [claim!2300!hospitalization-begin-date],
		NULL AS [claim!2300!hospitalization-end-date],
		NULL AS [claim!2300!pwk-attachment-report-type-code],
		NULL AS [claim!2300!pwk-attachment-control-number],
		NULL AS [claim!2300!patient-paid-amount],
		NULL AS [claim!2300!authorization-number],
		NULL AS [claim!2300!referral-number],
		NULL AS [claim!2300!diagnosis-1],
		NULL AS [claim!2300!diagnosis-2],
		NULL AS [claim!2300!diagnosis-3],
		NULL AS [claim!2300!diagnosis-4],
		NULL AS [claim!2300!diagnosis-5],
		NULL AS [claim!2300!diagnosis-6],
		NULL AS [claim!2300!diagnosis-7],
		NULL AS [claim!2300!diagnosis-8],
		NULL AS [claim!2300!diagnosis-9],
		NULL AS [claim!2300!diagnosis-10],
		NULL AS [claim!2300!diagnosis-11],
		NULL AS [claim!2300!diagnosis-12],
		NULL AS [claim!2300!clia-number],
		NULL AS [claim!2300!referring-provider-flag],
		NULL AS [claim!2300!referring-provider-first-name],
		NULL AS [claim!2300!referring-provider-middle-name],
		NULL AS [claim!2300!referring-provider-last-name],
		NULL AS [claim!2300!referring-provider-suffix],
		NULL AS [claim!2300!referring-provider-upin],
		NULL AS [claim!2300!referring-provider-npi],
		NULL AS [claim!2300!supervising-provider-flag],
		NULL AS [claim!2300!supervising-provider-first-name],
		NULL AS [claim!2300!supervising-provider-middle-name],
		NULL AS [claim!2300!supervising-provider-last-name],
		NULL AS [claim!2300!supervising-provider-suffix],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-npi],
		NULL AS [claim!2300!supervising-provider-id-qualifier],
		NULL AS [claim!2300!supervising-provider-id-number],
		NULL AS [claim!2300!rendering-provider-first-name],
		NULL AS [claim!2300!rendering-provider-middle-name],
		NULL AS [claim!2300!rendering-provider-last-name],
		NULL AS [claim!2300!rendering-provider-suffix],
		NULL AS [claim!2300!rendering-provider-ssn-qual],
		NULL AS [claim!2300!rendering-provider-ssn],
		NULL AS [claim!2300!rendering-provider-upin],
		NULL AS [claim!2300!rendering-provider-npi],
		NULL AS [claim!2300!rendering-provider-specialty-code],
		NULL AS [claim!2300!service-facility-name],
		NULL AS [claim!2300!service-facility-street-1],
		NULL AS [claim!2300!service-facility-street-2],
		NULL AS [claim!2300!service-facility-city],
		NULL AS [claim!2300!service-facility-state],
		NULL AS [claim!2300!service-facility-zip],
		NULL AS [claim!2300!service-facility-country],
		NULL AS [claim!2300!service-facility-id],
		NULL AS [claim!2300!service-facility-id-qualifier],
		NULL AS [claim!2300!service-facility-npi],
		NULL AS [claim!2300!service-facility-force-output],
		NULL AS [claim!2300!service-facility-phone],
		NULL AS [claim!2300!service-facility-phone-ext],
		NULL AS [claim!2300!file-information],
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!hipaa-delay-reason-code],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL  AS [claim!2300!ambulance-pickup-address1],
		NULL  AS [claim!2300!ambulance-pickup-address2],
		NULL  AS [claim!2300!ambulance-pickup-city],
		NULL  AS [claim!2300!ambulance-pickup-state],
		NULL  AS [claim!2300!ambulance-pickup-zipcode],
		NULL  AS [claim!2300!ambulance-fromcountry],
		NULL  AS [claim!2300!ambulance-address-dropoff],
		NULL  AS [claim!2300!ambulance-dropoff-address1],
		NULL  AS [claim!2300!ambulance-dropoff-address2],
		NULL  AS [claim!2300!ambulance-dropoff-city],
		NULL  AS [claim!2300!ambulance-dropoff-state],
		NULL  AS [claim!2300!ambulance-dropoff-zipcode],
		NULL  AS [claim!2300!ambulance-dropoff-country],
		NULL AS [claim!2300!ambulance-purpose-roundtrip],
		NULL AS [claim!2300!ambulance-purpose-stretcher],
		NULL AS [claim!2300!ambulance-condition-1],
		NULL AS [claim!2300!ambulance-condition-2],
		NULL AS [claim!2300!ambulance-condition-3],
		NULL AS [claim!2300!ambulance-condition-4],
		NULL AS [claim!2300!ambulance-condition-5],
		NULL AS [claim!2300!epsdt-referral-given],
		NULL AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		NULL AS [claim!2300!mammography-certification-number],
		NULL AS [claim!2300!contract-otaf-amount],
		NULL AS [claim!2300!contract-code],
		NULL AS [claim!2300!spinal-manipulation-flag],
		NULL AS [claim!2300!spinal-condition-code],
		NULL AS [claim!2300!spinal-xray-availability-flag],
		NULL AS [claim!2300!dcn],
		NULL AS [claim!2300!submit-reason-code], 
		NULL AS [otherpayercob!2320!insurance-policy-id],		-- @PayerInsurancePolicyID - the NULL here would break some rare submissions, and any variable may ruin DISTINCT.
		NULL AS [otherpayercob!2320!sum-patient-responsibility],
		NULL AS [otherpayercob!2320!sum-contract-adjustments],
		NULL AS [otherpayercob!2320!insured-different-than-patient-flag],
		NULL AS [otherpayercob!2320!subscriber-first-name],
		NULL AS [otherpayercob!2320!subscriber-middle-name],
		NULL AS [otherpayercob!2320!subscriber-last-name],
		NULL AS [otherpayercob!2320!subscriber-suffix],
		NULL AS [otherpayercob!2320!subscriber-street-1],
		NULL AS [otherpayercob!2320!subscriber-street-2],
		NULL AS [otherpayercob!2320!subscriber-city],
		NULL AS [otherpayercob!2320!subscriber-state],
		NULL AS [otherpayercob!2320!subscriber-zip],
		NULL AS [otherpayercob!2320!subscriber-country],
		NULL AS [otherpayercob!2320!subscriber-birth-date],
		NULL AS [otherpayercob!2320!subscriber-gender],
		NULL AS [otherpayercob!2320!subscriber-assignment-of-benefits-flag],
		NULL AS [otherpayercob!2320!subscriber-release-of-information-code],
		NULL AS [otherpayercob!2320!relation-to-insured-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code-order],
		NULL AS [otherpayercob!2320!claim-filing-indicator-code],
		NULL AS [otherpayercob!2320!plan-name],
		NULL AS [otherpayercob!2320!insurance-type-code],
		NULL AS [otherpayercob!2320!group-number],
		NULL AS [otherpayercob!2320!policy-number],
		NULL AS [otherpayercob!2320!payer-name],
		NULL AS [otherpayercob!2320!payer-identifier-qualifier],
		NULL AS [otherpayercob!2320!payer-identifier],
		NULL AS [otherpayercob!2320!payer-street-1],
		NULL AS [otherpayercob!2320!payer-street-2],
		NULL AS [otherpayercob!2320!payer-city],
		NULL AS [otherpayercob!2320!payer-state],
		NULL AS [otherpayercob!2320!payer-zip],
		NULL AS [otherpayercob!2320!payer-country],
		NULL AS [otherpayercob!2320!payer-secondary-id],
		NULL AS [otherpayercob!2320!payer-contact-name],
		NULL AS [otherpayercob!2320!payer-contact-phone],
		NULL AS [otherpayercob!2320!payer-paid-flag],
		NULL AS [otherpayercob!2320!payer-paid-amount],
		NULL AS [otherpayercob!2320!payer-allowed-amount],
		NULL AS [otherpayercob!2320!payer-cob-allowed-amount],
		NULL AS [otherpayercob!2320!patient-responsibility-amount],
		NULL as [otherpayercob!2320!include-zero-payer-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-cob-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-patient-responsibility-amount],
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],        
		NULL AS [service!2400!referring-clia-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!drug-ndc-code],
		NULL AS [service!2400!drug-quantity],
		NULL AS [service!2400!drug-units-of-measure],
		NULL AS [service!2400!drug-ref-qualifier],
		NULL AS [service!2400!drug-ref-identifier],
		NULL AS [service!2400!measurement-reference-id-code],
		NULL AS [service!2400!measurement-qualifier],
		NULL AS [service!2400!measurement-value],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!emergency-related-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
		NULL AS [service!2400!hospice-employee-indicator],
		NULL AS [service!2400!dme-flag],
		NULL AS [service!2400!ordering-provider-first-name],
		NULL AS [service!2400!ordering-provider-middle-name],
		NULL AS [service!2400!ordering-provider-last-name],
		NULL AS [service!2400!ordering-provider-suffix],
		NULL AS [service!2400!ordering-provider-ssn-qual],
		NULL AS [service!2400!ordering-provider-ssn],
		NULL AS [service!2400!ordering-provider-upin],
		NULL AS [service!2400!ordering-provider-npi],
		NULL AS [service!2400!ordering-provider-addressline1],
		NULL AS [service!2400!ordering-provider-addressline2],
		NULL AS [service!2400!ordering-provider-city],
		NULL AS [service!2400!ordering-provider-state],
		NULL AS [service!2400!ordering-provider-zipcode],
		NULL AS [service!2400!ordering-provider-phone],
		NULL AS [service!2400!service-note-code],
		NULL AS [service!2400!service-note],
		NULL AS [service!2400!noc-service-note],
		NULL AS [service!2400!contract-otaf-amount],
		NULL AS [service!2400!allowed-amount],
		NULL AS [service!2400!approved-amount],
		NULL AS [service!2400!include-zero-approved-amount],
		NULL AS [adjudication!2430!adjudication-id],
		NULL AS [adjudication!2430!payer-identifier],
		NULL AS [adjudication!2430!monetary-amount],
		NULL AS [adjudication!2430!procedure-code],
		NULL AS [adjudication!2430!quantity],
		NULL AS [adjudication!2430!adjudication-date],
		NULL AS [adjudication!2430!kareo-payment-id],
		NULL AS [adjudication!2430!payer-adjusted-flag],
		NULL AS [adjudication!2430!assigned-number],
		NULL AS [adjustment!243001!adjustment-id],
		NULL AS [adjustment!243001!adjustment-group-code],
		NULL AS [adjustment!243001!adjustment-reason-1],
		NULL AS [adjustment!243001!adjustment-amount-1],
		NULL AS [adjustment!243001!adjustment-quantity-1],
		NULL AS [adjustment!243001!adjustment-reason-2],
		NULL AS [adjustment!243001!adjustment-amount-2],
		NULL AS [adjustment!243001!adjustment-quantity-2],
		NULL AS [adjustment!243001!adjustment-reason-3],
		NULL AS [adjustment!243001!adjustment-amount-3],
		NULL AS [adjustment!243001!adjustment-quantity-3],
		NULL AS [adjustment!243001!adjustment-reason-4],
		NULL AS [adjustment!243001!adjustment-amount-4],
		NULL AS [adjustment!243001!adjustment-quantity-4],
		NULL AS [adjustment!243001!adjustment-reason-5],
		NULL AS [adjustment!243001!adjustment-amount-5],
		NULL AS [adjustment!243001!adjustment-quantity-5],
		NULL AS [adjustment!243001!adjustment-reason-6],
		NULL AS [adjustment!243001!adjustment-amount-6],
		NULL AS [adjustment!243001!adjustment-quantity-6],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		RT.ANSIReferenceIdentificationQualifier AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		RT.ProviderNumber AS [referringprovidernumbers!11!referring-provider-provider-id]

	FROM	@t_refprovidernumbers RT
	-- END OF REFERRING PROVIDER NUMBERS - INSURANCE PLAN ASSIGNED PROVIDER ID

	UNION ALL

	-- Service Line Adjudication -- Loop 2430 
	SELECT DISTINCT 2430, 2400,
		CONVERT(VARCHAR,@customer_id) AS [transaction!1!customer-id], 
		CONVERT(VARCHAR,@PracticeID) AS [transaction!1!practice-id],
		2 as [transaction!1!claim-settings-edition], 
		NULL as [transaction!1!claim-type-id],
		@RenderingTaxIDTypeID as [transaction!1!claim-settings-tax-id-type],
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!transaction-type],
		NULL AS [transaction!1!current-date],

		NULL AS [transaction!1!production-flag],
		NULL AS [transaction!1!interchange-authorization-id],
		NULL AS [transaction!1!interchange-security-id],
		NULL AS [transaction!1!original-transaction-flag],

		NULL AS [transaction!1!submitter-name],
		NULL AS [transaction!1!submitter-etin],
		NULL AS [transaction!1!submitter-id],
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],
		
		NULL AS [transaction!1!SuppressRenderingProviderForASC],
		NULL AS [transaction!1!ForcePatientAddressIn2310C],
		NULL AS [transaction!1!PopulatePSsegment],

		@BillerType AS [billing!2!biller-type],
		@PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!country],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],
		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-country],
		
		NULL AS [billing!2!paytopo-name],
		NULL AS [billing!2!paytopo-street-1],
		NULL AS [billing!2!paytopo-street-2],
		NULL AS [billing!2!paytopo-city],
		NULL AS [billing!2!paytopo-state],
		NULL AS [billing!2!paytopo-zipcode],
		NULL AS [billing!2!paytopo-country],
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
		NULL as [billing!2!group-taxonomy-code],
		@PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!insurance-type-code],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier-qualifier],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!payer-country],
		NULL AS [subscriber!3!payer-secondary-id],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [subscriber!3!responsible-country],
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [subscriber!3!relation-to-insured-code],
		@PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!country],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [patient!4!relation-to-insured],
		NULL AS [patient!4!property-casualty-claim-number],
		@bill_id AS [claim!2300!claim-id],
		NULL AS [claim!2300!control-number],
		NULL AS [claim!2300!total-claim-amount],
		NULL AS [claim!2300!place-of-service-code],
		NULL AS [claim!2300!provider-signature-flag],
		NULL AS [claim!2300!medicare-assignment-code],
		NULL AS [claim!2300!assignment-of-benefits-flag],
		NULL AS [claim!2300!release-of-information-code],
		NULL AS [claim!2300!patient-signature-source-code],
		NULL AS [claim!2300!auto-accident-related-flag],
		NULL AS [claim!2300!abuse-related-flag],
		NULL AS [claim!2300!pregnancy-related-flag],
		NULL AS [claim!2300!employment-related-flag],
		NULL AS [claim!2300!other-accident-related-flag],
		NULL AS [claim!2300!auto-accident-state],
		NULL AS [claim!2300!special-program-code],
		NULL AS [claim!2300!initial-treatment-date],
		NULL AS [claim!2300!last-menstrual-date],
		NULL AS [claim!2300!referral-date],
		NULL AS [claim!2300!last-seen-date],
		NULL AS [claim!2300!current-illness-date],
		NULL AS [claim!2300!acute-manifestation-date],
		NULL AS [claim!2300!similar-illness-date],
		NULL AS [claim!2300!accident-date],
		NULL AS [claim!2300!last-xray-date],
		NULL AS [claim!2300!disability-begin-date],
		NULL AS [claim!2300!disability-end-date],
		NULL AS [claim!2300!last-worked-date],
		NULL AS [claim!2300!return-to-work-date],
		NULL AS [claim!2300!hospitalization-begin-date],
		NULL AS [claim!2300!hospitalization-end-date],
		NULL AS [claim!2300!pwk-attachment-report-type-code],
		NULL AS [claim!2300!pwk-attachment-control-number],
		NULL AS [claim!2300!patient-paid-amount],
		NULL AS [claim!2300!authorization-number],
		NULL AS [claim!2300!referral-number],
		NULL AS [claim!2300!diagnosis-1],
		NULL AS [claim!2300!diagnosis-2],
		NULL AS [claim!2300!diagnosis-3],
		NULL AS [claim!2300!diagnosis-4],
		NULL AS [claim!2300!diagnosis-5],
		NULL AS [claim!2300!diagnosis-6],
		NULL AS [claim!2300!diagnosis-7],
		NULL AS [claim!2300!diagnosis-8],
		NULL AS [claim!2300!diagnosis-9],
		NULL AS [claim!2300!diagnosis-10],
		NULL AS [claim!2300!diagnosis-11],
		NULL AS [claim!2300!diagnosis-12],
		NULL AS [claim!2300!clia-number],
		NULL AS [claim!2300!referring-provider-flag],
		NULL AS [claim!2300!referring-provider-first-name],
		NULL AS [claim!2300!referring-provider-middle-name],
		NULL AS [claim!2300!referring-provider-last-name],
		NULL AS [claim!2300!referring-provider-suffix],
		NULL AS [claim!2300!referring-provider-upin],
		NULL AS [claim!2300!referring-provider-npi],
		NULL AS [claim!2300!supervising-provider-flag],
		NULL AS [claim!2300!supervising-provider-first-name],
		NULL AS [claim!2300!supervising-provider-middle-name],
		NULL AS [claim!2300!supervising-provider-last-name],
		NULL AS [claim!2300!supervising-provider-suffix],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-npi],
		NULL AS [claim!2300!supervising-provider-id-qualifier],
		NULL AS [claim!2300!supervising-provider-id-number],
		NULL AS [claim!2300!rendering-provider-first-name],
		NULL AS [claim!2300!rendering-provider-middle-name],
		NULL AS [claim!2300!rendering-provider-last-name],
		NULL AS [claim!2300!rendering-provider-suffix],
		NULL AS [claim!2300!rendering-provider-ssn-qual],
		NULL AS [claim!2300!rendering-provider-ssn],
		NULL AS [claim!2300!rendering-provider-upin],
		NULL AS [claim!2300!rendering-provider-npi],
		NULL AS [claim!2300!rendering-provider-specialty-code],
		NULL AS [claim!2300!service-facility-name],
		NULL AS [claim!2300!service-facility-street-1],
		NULL AS [claim!2300!service-facility-street-2],
		NULL AS [claim!2300!service-facility-city],
		NULL AS [claim!2300!service-facility-state],
		NULL AS [claim!2300!service-facility-zip],
		NULL AS [claim!2300!service-facility-country],
		NULL AS [claim!2300!service-facility-id],
		NULL AS [claim!2300!service-facility-id-qualifier],
		NULL AS [claim!2300!service-facility-npi],
		NULL AS [claim!2300!service-facility-force-output],
		NULL AS [claim!2300!service-facility-phone],
		NULL AS [claim!2300!service-facility-phone-ext],
		NULL AS [claim!2300!file-information],
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!hipaa-delay-reason-code],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL  AS [claim!2300!ambulance-pickup-address1],
		NULL  AS [claim!2300!ambulance-pickup-address2],
		NULL  AS [claim!2300!ambulance-pickup-city],
		NULL  AS [claim!2300!ambulance-pickup-state],
		NULL  AS [claim!2300!ambulance-pickup-zipcode],
		NULL  AS [claim!2300!ambulance-fromcountry],
		NULL  AS [claim!2300!ambulance-address-dropoff],
		NULL  AS [claim!2300!ambulance-dropoff-address1],
		NULL  AS [claim!2300!ambulance-dropoff-address2],
		NULL  AS [claim!2300!ambulance-dropoff-city],
		NULL  AS [claim!2300!ambulance-dropoff-state],
		NULL  AS [claim!2300!ambulance-dropoff-zipcode],
		NULL  AS [claim!2300!ambulance-dropoff-country],
		NULL AS [claim!2300!ambulance-purpose-roundtrip],
		NULL AS [claim!2300!ambulance-purpose-stretcher],
		NULL AS [claim!2300!ambulance-condition-1],
		NULL AS [claim!2300!ambulance-condition-2],
		NULL AS [claim!2300!ambulance-condition-3],
		NULL AS [claim!2300!ambulance-condition-4],
		NULL AS [claim!2300!ambulance-condition-5],
		NULL AS [claim!2300!epsdt-referral-given],
		NULL AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		NULL AS [claim!2300!mammography-certification-number],
		NULL AS [claim!2300!contract-otaf-amount],
		NULL AS [claim!2300!contract-code],
		NULL AS [claim!2300!spinal-manipulation-flag],
		NULL AS [claim!2300!spinal-condition-code],
		NULL AS [claim!2300!spinal-xray-availability-flag],
		NULL AS [claim!2300!dcn],
		NULL AS [claim!2300!submit-reason-code], 
		@PayerInsurancePolicyID AS [otherpayercob!2320!insurance-policy-id],
		NULL AS [otherpayercob!2320!sum-patient-responsibility],
		NULL AS [otherpayercob!2320!sum-contract-adjustments],
		NULL AS [otherpayercob!2320!insured-different-than-patient-flag],
		NULL AS [otherpayercob!2320!subscriber-first-name],
		NULL AS [otherpayercob!2320!subscriber-middle-name],
		NULL AS [otherpayercob!2320!subscriber-last-name],
		NULL AS [otherpayercob!2320!subscriber-suffix],
		NULL AS [otherpayercob!2320!subscriber-street-1],
		NULL AS [otherpayercob!2320!subscriber-street-2],
		NULL AS [otherpayercob!2320!subscriber-city],
		NULL AS [otherpayercob!2320!subscriber-state],
		NULL AS [otherpayercob!2320!subscriber-zip],
		NULL AS [otherpayercob!2320!subscriber-country],
		NULL AS [otherpayercob!2320!subscriber-birth-date],
		NULL AS [otherpayercob!2320!subscriber-gender],
		NULL AS [otherpayercob!2320!subscriber-assignment-of-benefits-flag],
		NULL AS [otherpayercob!2320!subscriber-release-of-information-code],
		NULL AS [otherpayercob!2320!relation-to-insured-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code-order],
		NULL AS [otherpayercob!2320!claim-filing-indicator-code],
		NULL AS [otherpayercob!2320!plan-name],
		NULL AS [otherpayercob!2320!insurance-type-code],
		NULL AS [otherpayercob!2320!group-number],
		NULL AS [otherpayercob!2320!policy-number],
		NULL AS [otherpayercob!2320!payer-name],
		NULL AS [otherpayercob!2320!payer-identifier-qualifier],
		NULL AS [otherpayercob!2320!payer-identifier],
		NULL AS [otherpayercob!2320!payer-street-1],
		NULL AS [otherpayercob!2320!payer-street-2],
		NULL AS [otherpayercob!2320!payer-city],
		NULL AS [otherpayercob!2320!payer-state],
		NULL AS [otherpayercob!2320!payer-zip],
		NULL AS [otherpayercob!2320!payer-country],
		NULL AS [otherpayercob!2320!payer-secondary-id],
		NULL AS [otherpayercob!2320!payer-contact-name],
		NULL AS [otherpayercob!2320!payer-contact-phone],
		NULL AS [otherpayercob!2320!payer-paid-flag],
		NULL AS [otherpayercob!2320!payer-paid-amount],
		NULL AS [otherpayercob!2320!payer-allowed-amount],
		NULL AS [otherpayercob!2320!payer-cob-allowed-amount],
		NULL AS [otherpayercob!2320!patient-responsibility-amount],
		NULL as [otherpayercob!2320!include-zero-payer-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-cob-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-patient-responsibility-amount],
		TCSA.ClaimID AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!referring-clia-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!drug-ndc-code],
		NULL AS [service!2400!drug-quantity],
		NULL AS [service!2400!drug-units-of-measure],
		NULL AS [service!2400!drug-ref-qualifier],
		NULL AS [service!2400!drug-ref-identifier],
		NULL AS [service!2400!measurement-reference-id-code],
		NULL AS [service!2400!measurement-qualifier],
		NULL AS [service!2400!measurement-value],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!emergency-related-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
		NULL AS [service!2400!hospice-employee-indicator],
		NULL AS [service!2400!dme-flag],
		NULL AS [service!2400!ordering-provider-first-name],
		NULL AS [service!2400!ordering-provider-middle-name],
		NULL AS [service!2400!ordering-provider-last-name],
		NULL AS [service!2400!ordering-provider-suffix],
		NULL AS [service!2400!ordering-provider-ssn-qual],
		NULL AS [service!2400!ordering-provider-ssn],
		NULL AS [service!2400!ordering-provider-upin],
		NULL AS [service!2400!ordering-provider-npi],
		NULL AS [service!2400!ordering-provider-addressline1],
		NULL AS [service!2400!ordering-provider-addressline2],
		NULL AS [service!2400!ordering-provider-city],
		NULL AS [service!2400!ordering-provider-state],
		NULL AS [service!2400!ordering-provider-zipcode],
		NULL AS [service!2400!ordering-provider-phone],
		NULL AS [service!2400!service-note-code],
		NULL AS [service!2400!service-note],
		NULL AS [service!2400!noc-service-note],
		NULL AS [service!2400!contract-otaf-amount],
		NULL AS [service!2400!allowed-amount],
		NULL AS [service!2400!approved-amount],
		NULL AS [service!2400!include-zero-approved-amount],
		TCSA.[TID] AS [adjudication!2430!adjudication-id],
		CASE @PayerNumber
			WHEN 'MC081' THEN '915'
			--WHEN 'MC029' THEN 'D02' Per Jim: This one let�s wait to deploy and only deploy if needed
			ELSE TCOS.[payer-identifier] END AS [adjudication!2430!payer-identifier],
		CAST(TCSA.[paid-amount] AS varchar(128)) AS [adjudication!2430!monetary-amount],
		TCSA.[comp-procedure-code] AS [adjudication!2430!procedure-code],
		TCSA.[paid-quantity]  AS [adjudication!2430!quantity],
		TCSA.[adjudication-date] AS [adjudication!2430!adjudication-date],
		TCSA.[PaymentID] AS [adjudication!2430!kareo-payment-id],
		'1' AS [adjudication!2430!payer-adjusted-flag],
		TCSA.[assigned-number] AS [adjudication!2430!assigned-number],
		NULL AS [adjustment!243001!adjustment-id],
		NULL AS [adjustment!243001!adjustment-group-code],
		NULL AS [adjustment!243001!adjustment-reason-1],
		NULL AS [adjustment!243001!adjustment-amount-1],
		NULL AS [adjustment!243001!adjustment-quantity-1],
		NULL AS [adjustment!243001!adjustment-reason-2],
		NULL AS [adjustment!243001!adjustment-amount-2],
		NULL AS [adjustment!243001!adjustment-quantity-2],
		NULL AS [adjustment!243001!adjustment-reason-3],
		NULL AS [adjustment!243001!adjustment-amount-3],
		NULL AS [adjustment!243001!adjustment-quantity-3],
		NULL AS [adjustment!243001!adjustment-reason-4],
		NULL AS [adjustment!243001!adjustment-amount-4],
		NULL AS [adjustment!243001!adjustment-quantity-4],
		NULL AS [adjustment!243001!adjustment-reason-5],
		NULL AS [adjustment!243001!adjustment-amount-5],
		NULL AS [adjustment!243001!adjustment-quantity-5],
		NULL AS [adjustment!243001!adjustment-reason-6],
		NULL AS [adjustment!243001!adjustment-amount-6],
		NULL AS [adjustment!243001!adjustment-quantity-6],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id]

	FROM @t_cob_svcadjudication TCSA
		JOIN @t_cob_othersubscriber TCOS ON TCOS.TID = TCSA.othersubscriberTID

	-- END OF Service Line Adjudication -- Loop 2430 

	UNION ALL

	-- Service Line Adjustments -- Loop 2430 CAS SEGMENTS
	SELECT	243001, 2430,
		CONVERT(VARCHAR,@customer_id) AS [transaction!1!customer-id], 
		CONVERT(VARCHAR,@PracticeID) AS [transaction!1!practice-id],
		2 as [transaction!1!claim-settings-edition], 
		NULL as [transaction!1!claim-type-id],
		@RenderingTaxIDTypeID as [transaction!1!claim-settings-tax-id-type],
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!transaction-type],
		NULL AS [transaction!1!current-date],

		NULL AS [transaction!1!production-flag],
		NULL AS [transaction!1!interchange-authorization-id],
		NULL AS [transaction!1!interchange-security-id],
		NULL AS [transaction!1!original-transaction-flag],

		NULL AS [transaction!1!submitter-name],
		NULL AS [transaction!1!submitter-etin],
		NULL AS [transaction!1!submitter-id],
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],
		
		NULL AS [transaction!1!SuppressRenderingProviderForASC],
		NULL AS [transaction!1!ForcePatientAddressIn2310C],
		NULL AS [transaction!1!PopulatePSsegment],

		@BillerType AS [billing!2!biller-type],
		@PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!country],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],
		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-country],
		
		NULL AS [billing!2!paytopo-name],
		NULL AS [billing!2!paytopo-street-1],
		NULL AS [billing!2!paytopo-street-2],
		NULL AS [billing!2!paytopo-city],
		NULL AS [billing!2!paytopo-state],
		NULL AS [billing!2!paytopo-zipcode],
		NULL AS [billing!2!paytopo-country],
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
		NULL as [billing!2!group-taxonomy-code],
		@PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!insurance-type-code],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier-qualifier],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!payer-country],
		NULL AS [subscriber!3!payer-secondary-id],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [subscriber!3!responsible-country],
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [subscriber!3!relation-to-insured-code],
		@PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!country],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [patient!4!relation-to-insured],
		NULL AS [patient!4!property-casualty-claim-number],
		@bill_id AS [claim!2300!claim-id],
		NULL AS [claim!2300!control-number],
		NULL AS [claim!2300!total-claim-amount],
		NULL AS [claim!2300!place-of-service-code],
		NULL AS [claim!2300!provider-signature-flag],
		NULL AS [claim!2300!medicare-assignment-code],
		NULL AS [claim!2300!assignment-of-benefits-flag],
		NULL AS [claim!2300!release-of-information-code],
		NULL AS [claim!2300!patient-signature-source-code],
		NULL AS [claim!2300!auto-accident-related-flag],
		NULL AS [claim!2300!abuse-related-flag],
		NULL AS [claim!2300!pregnancy-related-flag],
		NULL AS [claim!2300!employment-related-flag],
		NULL AS [claim!2300!other-accident-related-flag],
		NULL AS [claim!2300!auto-accident-state],
		NULL AS [claim!2300!special-program-code],
		NULL AS [claim!2300!initial-treatment-date],
		NULL AS [claim!2300!last-menstrual-date],
		NULL AS [claim!2300!referral-date],
		NULL AS [claim!2300!last-seen-date],
		NULL AS [claim!2300!current-illness-date],
		NULL AS [claim!2300!acute-manifestation-date],
		NULL AS [claim!2300!similar-illness-date],
		NULL AS [claim!2300!accident-date],
		NULL AS [claim!2300!last-xray-date],
		NULL AS [claim!2300!disability-begin-date],
		NULL AS [claim!2300!disability-end-date],
		NULL AS [claim!2300!last-worked-date],
		NULL AS [claim!2300!return-to-work-date],
		NULL AS [claim!2300!hospitalization-begin-date],
		NULL AS [claim!2300!hospitalization-end-date],
		NULL AS [claim!2300!pwk-attachment-report-type-code],
		NULL AS [claim!2300!pwk-attachment-control-number],
		NULL AS [claim!2300!patient-paid-amount],
		NULL AS [claim!2300!authorization-number],
		NULL AS [claim!2300!referral-number],
		NULL AS [claim!2300!diagnosis-1],
		NULL AS [claim!2300!diagnosis-2],
		NULL AS [claim!2300!diagnosis-3],
		NULL AS [claim!2300!diagnosis-4],
		NULL AS [claim!2300!diagnosis-5],
		NULL AS [claim!2300!diagnosis-6],
		NULL AS [claim!2300!diagnosis-7],
		NULL AS [claim!2300!diagnosis-8],
		NULL AS [claim!2300!diagnosis-9],
		NULL AS [claim!2300!diagnosis-10],
		NULL AS [claim!2300!diagnosis-11],
		NULL AS [claim!2300!diagnosis-12],
		NULL AS [claim!2300!clia-number],
		NULL AS [claim!2300!referring-provider-flag],
		NULL AS [claim!2300!referring-provider-first-name],
		NULL AS [claim!2300!referring-provider-middle-name],
		NULL AS [claim!2300!referring-provider-last-name],
		NULL AS [claim!2300!referring-provider-suffix],
		NULL AS [claim!2300!referring-provider-upin],
		NULL AS [claim!2300!referring-provider-npi],
		NULL AS [claim!2300!supervising-provider-flag],
		NULL AS [claim!2300!supervising-provider-first-name],
		NULL AS [claim!2300!supervising-provider-middle-name],
		NULL AS [claim!2300!supervising-provider-last-name],
		NULL AS [claim!2300!supervising-provider-suffix],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-npi],
		NULL AS [claim!2300!supervising-provider-id-qualifier],
		NULL AS [claim!2300!supervising-provider-id-number],
		NULL AS [claim!2300!rendering-provider-first-name],
		NULL AS [claim!2300!rendering-provider-middle-name],
		NULL AS [claim!2300!rendering-provider-last-name],
		NULL AS [claim!2300!rendering-provider-suffix],
		NULL AS [claim!2300!rendering-provider-ssn-qual],
		NULL AS [claim!2300!rendering-provider-ssn],
		NULL AS [claim!2300!rendering-provider-upin],
		NULL AS [claim!2300!rendering-provider-npi],
		NULL AS [claim!2300!rendering-provider-specialty-code],
		NULL AS [claim!2300!service-facility-name],
		NULL AS [claim!2300!service-facility-street-1],
		NULL AS [claim!2300!service-facility-street-2],
		NULL AS [claim!2300!service-facility-city],
		NULL AS [claim!2300!service-facility-state],
		NULL AS [claim!2300!service-facility-zip],
		NULL AS [claim!2300!service-facility-country],
		NULL AS [claim!2300!service-facility-id],
		NULL AS [claim!2300!service-facility-id-qualifier],
		NULL AS [claim!2300!service-facility-npi],
		NULL AS [claim!2300!service-facility-force-output],
		NULL AS [claim!2300!service-facility-phone],
		NULL AS [claim!2300!service-facility-phone-ext],
		NULL AS [claim!2300!file-information],
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!hipaa-delay-reason-code],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL  AS [claim!2300!ambulance-pickup-address1],
		NULL  AS [claim!2300!ambulance-pickup-address2],
		NULL  AS [claim!2300!ambulance-pickup-city],
		NULL  AS [claim!2300!ambulance-pickup-state],
		NULL  AS [claim!2300!ambulance-pickup-zipcode],
		NULL  AS [claim!2300!ambulance-fromcountry],
		NULL  AS [claim!2300!ambulance-address-dropoff],
		NULL  AS [claim!2300!ambulance-dropoff-address1],
		NULL  AS [claim!2300!ambulance-dropoff-address2],
		NULL  AS [claim!2300!ambulance-dropoff-city],
		NULL  AS [claim!2300!ambulance-dropoff-state],
		NULL  AS [claim!2300!ambulance-dropoff-zipcode],
		NULL  AS [claim!2300!ambulance-dropoff-country],
		NULL AS [claim!2300!ambulance-purpose-roundtrip],
		NULL AS [claim!2300!ambulance-purpose-stretcher],
		NULL AS [claim!2300!ambulance-condition-1],
		NULL AS [claim!2300!ambulance-condition-2],
		NULL AS [claim!2300!ambulance-condition-3],
		NULL AS [claim!2300!ambulance-condition-4],
		NULL AS [claim!2300!ambulance-condition-5],
		NULL AS [claim!2300!epsdt-referral-given],
		NULL AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		NULL AS [claim!2300!mammography-certification-number],
		NULL AS [claim!2300!contract-otaf-amount],
		NULL AS [claim!2300!contract-code],
		NULL AS [claim!2300!spinal-manipulation-flag],
		NULL AS [claim!2300!spinal-condition-code],
		NULL AS [claim!2300!spinal-xray-availability-flag],
		NULL AS [claim!2300!dcn],
		NULL AS [claim!2300!submit-reason-code], 
		@PayerInsurancePolicyID AS [otherpayercob!2320!insurance-policy-id],
		NULL AS [otherpayercob!2320!sum-patient-responsibility],
		NULL AS [otherpayercob!2320!sum-contract-adjustments],
		NULL AS [otherpayercob!2320!insured-different-than-patient-flag],
		NULL AS [otherpayercob!2320!subscriber-first-name],
		NULL AS [otherpayercob!2320!subscriber-middle-name],
		NULL AS [otherpayercob!2320!subscriber-last-name],
		NULL AS [otherpayercob!2320!subscriber-suffix],
		NULL AS [otherpayercob!2320!subscriber-street-1],
		NULL AS [otherpayercob!2320!subscriber-street-2],
		NULL AS [otherpayercob!2320!subscriber-city],
		NULL AS [otherpayercob!2320!subscriber-state],
		NULL AS [otherpayercob!2320!subscriber-zip],
		NULL AS [otherpayercob!2320!subscriber-country],
		NULL AS [otherpayercob!2320!subscriber-birth-date],
		NULL AS [otherpayercob!2320!subscriber-gender],
		NULL AS [otherpayercob!2320!subscriber-assignment-of-benefits-flag],
		NULL AS [otherpayercob!2320!subscriber-release-of-information-code],
		NULL AS [otherpayercob!2320!relation-to-insured-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code-order],
		NULL AS [otherpayercob!2320!claim-filing-indicator-code],
		NULL AS [otherpayercob!2320!plan-name],
		NULL AS [otherpayercob!2320!insurance-type-code],
		NULL AS [otherpayercob!2320!group-number],
		NULL AS [otherpayercob!2320!policy-number],
		NULL AS [otherpayercob!2320!payer-name],
		NULL AS [otherpayercob!2320!payer-identifier-qualifier],
		NULL AS [otherpayercob!2320!payer-identifier],
		NULL AS [otherpayercob!2320!payer-street-1],
		NULL AS [otherpayercob!2320!payer-street-2],
		NULL AS [otherpayercob!2320!payer-city],
		NULL AS [otherpayercob!2320!payer-state],
		NULL AS [otherpayercob!2320!payer-zip],
		NULL AS [otherpayercob!2320!payer-country],
		NULL AS [otherpayercob!2320!payer-secondary-id],
		NULL AS [otherpayercob!2320!payer-contact-name],
		NULL AS [otherpayercob!2320!payer-contact-phone],
		NULL AS [otherpayercob!2320!payer-paid-flag],
		NULL AS [otherpayercob!2320!payer-paid-amount],
		NULL AS [otherpayercob!2320!payer-allowed-amount],
		NULL AS [otherpayercob!2320!payer-cob-allowed-amount],
		NULL AS [otherpayercob!2320!patient-responsibility-amount],
		NULL as [otherpayercob!2320!include-zero-payer-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-cob-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-patient-responsibility-amount],
		TCSA.ClaimID AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!referring-clia-number],		
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!drug-ndc-code],
		NULL AS [service!2400!drug-quantity],
		NULL AS [service!2400!drug-units-of-measure],
		NULL AS [service!2400!drug-ref-qualifier],
		NULL AS [service!2400!drug-ref-identifier],
		NULL AS [service!2400!measurement-reference-id-code],
		NULL AS [service!2400!measurement-qualifier],
		NULL AS [service!2400!measurement-value],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!emergency-related-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
		NULL AS [service!2400!hospice-employee-indicator],
		NULL AS [service!2400!dme-flag],
		NULL AS [service!2400!ordering-provider-first-name],
		NULL AS [service!2400!ordering-provider-middle-name],
		NULL AS [service!2400!ordering-provider-last-name],
		NULL AS [service!2400!ordering-provider-suffix],
		NULL AS [service!2400!ordering-provider-ssn-qual],
		NULL AS [service!2400!ordering-provider-ssn],
		NULL AS [service!2400!ordering-provider-upin],
		NULL AS [service!2400!ordering-provider-npi],
		NULL AS [service!2400!ordering-provider-addressline1],
		NULL AS [service!2400!ordering-provider-addressline2],
		NULL AS [service!2400!ordering-provider-city],
		NULL AS [service!2400!ordering-provider-state],
		NULL AS [service!2400!ordering-provider-zipcode],
		NULL AS [service!2400!ordering-provider-phone],
		NULL AS [service!2400!service-note-code],
		NULL AS [service!2400!service-note],
		NULL AS [service!2400!noc-service-note],
		NULL AS [service!2400!contract-otaf-amount],
		NULL AS [service!2400!allowed-amount],
		NULL AS [service!2400!approved-amount],
		NULL AS [service!2400!include-zero-approved-amount],
		TCSA.[TID] AS [adjudication!2430!adjudication-id],
		CASE @PayerNumber
			WHEN 'MC081' THEN '915'
			--WHEN 'MC029' THEN 'D02'  Per Jim: This one let�s wait to deploy and only deploy if needed
			ELSE TCOS.[payer-identifier] END AS [adjudication!2430!payer-identifier],
		CAST(TCSA.[paid-amount] AS varchar(128)) AS [adjudication!2430!monetary-amount],
		TCSA.[comp-procedure-code] AS [adjudication!2430!procedure-code],
		TCSA.[paid-quantity] AS [adjudication!2430!quantity],
		TCSA.[adjudication-date] AS [adjudication!2430!adjudication-date],
		TCSA.[PaymentID] AS [adjudication!2430!kareo-payment-id],
		'1' AS [adjudication!2430!payer-adjusted-flag],
		TCSA.[assigned-number] AS [adjudication!2430!assigned-number],
		TCSW.[TID] AS [adjustment!243001!adjustment-id],
		TCSW.[adjustment-group-code] AS [adjustment!243001!adjustment-group-code],
		TCSW.[adjustment-reason-1] AS [adjustment!243001!adjustment-reason-1],
		TCSW.[adjustment-amount-1] AS [adjustment!243001!adjustment-amount-1],
		TCSW.[adjustment-quantity-1] AS [adjustment!243001!adjustment-quantity-1],
		TCSW.[adjustment-reason-2] AS [adjustment!243001!adjustment-reason-2],
		TCSW.[adjustment-amount-2] AS [adjustment!243001!adjustment-amount-2],
		TCSW.[adjustment-quantity-2] AS [adjustment!243001!adjustment-quantity-2],
		TCSW.[adjustment-reason-3] AS [adjustment!243001!adjustment-reason-3],
		TCSW.[adjustment-amount-3] AS [adjustment!243001!adjustment-amount-3],
		TCSW.[adjustment-quantity-3] AS [adjustment!243001!adjustment-quantity-3],
		TCSW.[adjustment-reason-4] AS [adjustment!243001!adjustment-reason-4],
		TCSW.[adjustment-amount-4] AS [adjustment!243001!adjustment-amount-4],
		TCSW.[adjustment-quantity-4] AS [adjustment!243001!adjustment-quantity-4],
		TCSW.[adjustment-reason-5] AS [adjustment!243001!adjustment-reason-5],
		TCSW.[adjustment-amount-5] AS [adjustment!243001!adjustment-amount-5],
		TCSW.[adjustment-quantity-5] AS [adjustment!243001!adjustment-quantity-5],
		TCSW.[adjustment-reason-6] AS [adjustment!243001!adjustment-reason-6],
		TCSW.[adjustment-amount-6] AS [adjustment!243001!adjustment-amount-6],
		TCSW.[adjustment-quantity-6] AS [adjustment!243001!adjustment-quantity-6],
		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],
		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id]

	FROM @t_cob_svcadjustment_w TCSW 
		JOIN @t_cob_svcadjudication TCSA ON TCSA.TID = TCSW.svcadjudicationTID
		JOIN @t_cob_othersubscriber TCOS ON TCOS.TID = TCSA.othersubscriberTID
--	WHERE TCSW.[adjustment-category] IN ('CO', 'CR', 'OA', 'PI', 'PR')

	-- END OF Service Line Adjustments -- Loop 2430 CAS SEGMENTS 

	UNION ALL

	-- BILLING PROVIDER SECONDARY IDENTIFICATION
	-- payer assigned provider IDs for the Practice, Loop 2010AA (Group Numbers):  
	-- the "secondaryident" portions below are under assumption that billing and pay-to are the same (which they always are in real life).
	-- if they ever differ, some code needs to be written to place them correctly.

	SELECT	9, 2,
		CONVERT(VARCHAR,@customer_id) AS [transaction!1!customer-id], 
		CONVERT(VARCHAR,@PracticeID) AS [transaction!1!practice-id],
		2 as [transaction!1!claim-settings-edition], 
		NULL as [transaction!1!claim-type-id],
		@RenderingTaxIDTypeID as [transaction!1!claim-settings-tax-id-type],
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
		NULL AS [transaction!1!transaction-type],
		NULL AS [transaction!1!current-date],

		NULL AS [transaction!1!production-flag],
		NULL AS [transaction!1!interchange-authorization-id],
		NULL AS [transaction!1!interchange-security-id],
		NULL AS [transaction!1!original-transaction-flag],

		NULL AS [transaction!1!submitter-name],
		NULL AS [transaction!1!submitter-etin],
		NULL AS [transaction!1!submitter-id],
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],
		
		NULL AS [transaction!1!SuppressRenderingProviderForASC],
		NULL AS [transaction!1!ForcePatientAddressIn2310C],
		NULL AS [transaction!1!PopulatePSsegment],

		@BillerType AS [billing!2!biller-type],
		@PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!country],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],
		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-country],
		NULL AS [billing!2!paytopo-name],
		NULL AS [billing!2!paytopo-street-1],
		NULL AS [billing!2!paytopo-street-2],
		NULL AS [billing!2!paytopo-city],
		NULL AS [billing!2!paytopo-state],
		NULL AS [billing!2!paytopo-zipcode],
		NULL AS [billing!2!paytopo-country],
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
		NULL as [billing!2!group-taxonomy-code],
		NULL AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!insurance-type-code],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier-qualifier],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
		NULL AS [subscriber!3!payer-country],
		NULL AS [subscriber!3!payer-secondary-id],
		NULL AS [subscriber!3!responsible-different-than-patient-flag],
		NULL AS [subscriber!3!responsible-first-name],
		NULL AS [subscriber!3!responsible-middle-name],
		NULL AS [subscriber!3!responsible-last-name],
		NULL AS [subscriber!3!responsible-suffix],
		NULL AS [subscriber!3!responsible-street-1],
		NULL AS [subscriber!3!responsible-street-2],
		NULL AS [subscriber!3!responsible-city],
		NULL AS [subscriber!3!responsible-state],
		NULL AS [subscriber!3!responsible-zip],
		NULL AS [subscriber!3!responsible-country],
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [subscriber!3!relation-to-insured-code],
		@PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!dependent-policy-number],
		NULL AS [patient!4!first-name],
		NULL AS [patient!4!middle-name],
		NULL AS [patient!4!last-name],
		NULL AS [patient!4!suffix],
		NULL AS [patient!4!street-1],
		NULL AS [patient!4!street-2],
		NULL AS [patient!4!city],
		NULL AS [patient!4!state],
		NULL AS [patient!4!zip],
		NULL AS [patient!4!country],
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [patient!4!relation-to-insured],
		NULL AS [patient!4!property-casualty-claim-number],
		@bill_id AS [claim!2300!claim-id],
		NULL AS [claim!2300!control-number],
		NULL AS [claim!2300!total-claim-amount],
		NULL AS [claim!2300!place-of-service-code],
		NULL AS [claim!2300!provider-signature-flag],
		NULL AS [claim!2300!medicare-assignment-code],
		NULL AS [claim!2300!assignment-of-benefits-flag],
		NULL AS [claim!2300!release-of-information-code],
		NULL AS [claim!2300!patient-signature-source-code],
		NULL AS [claim!2300!auto-accident-related-flag],
		NULL AS [claim!2300!abuse-related-flag],
		NULL AS [claim!2300!pregnancy-related-flag],
		NULL AS [claim!2300!employment-related-flag],
		NULL AS [claim!2300!other-accident-related-flag],
		NULL AS [claim!2300!auto-accident-state],
		NULL AS [claim!2300!special-program-code],
		NULL AS [claim!2300!initial-treatment-date],
		NULL AS [claim!2300!last-menstrual-date],
		NULL AS [claim!2300!referral-date],
		NULL AS [claim!2300!last-seen-date],
		NULL AS [claim!2300!current-illness-date],
		NULL AS [claim!2300!acute-manifestation-date],
		NULL AS [claim!2300!similar-illness-date],
		NULL AS [claim!2300!accident-date],
		NULL AS [claim!2300!last-xray-date],
		NULL AS [claim!2300!disability-begin-date],
		NULL AS [claim!2300!disability-end-date],
		NULL AS [claim!2300!last-worked-date],
		NULL AS [claim!2300!return-to-work-date],
		NULL AS [claim!2300!hospitalization-begin-date],
		NULL AS [claim!2300!hospitalization-end-date],
		NULL AS [claim!2300!pwk-attachment-report-type-code],
		NULL AS [claim!2300!pwk-attachment-control-number],
		NULL AS [claim!2300!patient-paid-amount],
		NULL AS [claim!2300!authorization-number],
		NULL AS [claim!2300!referral-number],
		NULL AS [claim!2300!diagnosis-1],
		NULL AS [claim!2300!diagnosis-2],
		NULL AS [claim!2300!diagnosis-3],
		NULL AS [claim!2300!diagnosis-4],
		NULL AS [claim!2300!diagnosis-5],
		NULL AS [claim!2300!diagnosis-6],
		NULL AS [claim!2300!diagnosis-7],
		NULL AS [claim!2300!diagnosis-8],
		NULL AS [claim!2300!diagnosis-9],
		NULL AS [claim!2300!diagnosis-10],
		NULL AS [claim!2300!diagnosis-11],
		NULL AS [claim!2300!diagnosis-12],
		NULL AS [claim!2300!clia-number],
		NULL AS [claim!2300!referring-provider-flag],
		NULL AS [claim!2300!referring-provider-first-name],
		NULL AS [claim!2300!referring-provider-middle-name],
		NULL AS [claim!2300!referring-provider-last-name],
		NULL AS [claim!2300!referring-provider-suffix],
		NULL AS [claim!2300!referring-provider-upin],
		NULL AS [claim!2300!referring-provider-npi],
		NULL AS [claim!2300!supervising-provider-flag],
		NULL AS [claim!2300!supervising-provider-first-name],
		NULL AS [claim!2300!supervising-provider-middle-name],
		NULL AS [claim!2300!supervising-provider-last-name],
		NULL AS [claim!2300!supervising-provider-suffix],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-npi],
		NULL AS [claim!2300!supervising-provider-id-qualifier],
		NULL AS [claim!2300!supervising-provider-id-number],
		NULL AS [claim!2300!rendering-provider-first-name],
		NULL AS [claim!2300!rendering-provider-middle-name],
		NULL AS [claim!2300!rendering-provider-last-name],
		NULL AS [claim!2300!rendering-provider-suffix],
		NULL AS [claim!2300!rendering-provider-ssn-qual],
		NULL AS [claim!2300!rendering-provider-ssn],
		NULL AS [claim!2300!rendering-provider-upin],
		NULL AS [claim!2300!rendering-provider-npi],
		NULL AS [claim!2300!rendering-provider-specialty-code],
		NULL AS [claim!2300!service-facility-name],
		NULL AS [claim!2300!service-facility-street-1],
		NULL AS [claim!2300!service-facility-street-2],
		NULL AS [claim!2300!service-facility-city],
		NULL AS [claim!2300!service-facility-state],
		NULL AS [claim!2300!service-facility-zip],
		NULL AS [claim!2300!service-facility-country],
		NULL AS [claim!2300!service-facility-id],
		NULL AS [claim!2300!service-facility-id-qualifier],
		NULL AS [claim!2300!service-facility-npi],
		NULL AS [claim!2300!service-facility-force-output],
		NULL AS [claim!2300!service-facility-phone],
		NULL AS [claim!2300!service-facility-phone-ext],
		NULL AS [claim!2300!file-information],
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!hipaa-delay-reason-code],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL  AS [claim!2300!ambulance-pickup-address1],
		NULL  AS [claim!2300!ambulance-pickup-address2],
		NULL  AS [claim!2300!ambulance-pickup-city],
		NULL  AS [claim!2300!ambulance-pickup-state],
		NULL  AS [claim!2300!ambulance-pickup-zipcode],
		NULL  AS [claim!2300!ambulance-fromcountry],
		NULL  AS [claim!2300!ambulance-address-dropoff],
		NULL  AS [claim!2300!ambulance-dropoff-address1],
		NULL  AS [claim!2300!ambulance-dropoff-address2],
		NULL  AS [claim!2300!ambulance-dropoff-city],
		NULL  AS [claim!2300!ambulance-dropoff-state],
		NULL  AS [claim!2300!ambulance-dropoff-zipcode],
		NULL  AS [claim!2300!ambulance-dropoff-country],
		NULL AS [claim!2300!ambulance-purpose-roundtrip],
		NULL AS [claim!2300!ambulance-purpose-stretcher],
		NULL AS [claim!2300!ambulance-condition-1],
		NULL AS [claim!2300!ambulance-condition-2],
		NULL AS [claim!2300!ambulance-condition-3],
		NULL AS [claim!2300!ambulance-condition-4],
		NULL AS [claim!2300!ambulance-condition-5],
		NULL AS [claim!2300!epsdt-referral-given],
		NULL AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		NULL AS [claim!2300!mammography-certification-number],
		NULL AS [claim!2300!contract-otaf-amount],
		NULL AS [claim!2300!contract-code],
		NULL AS [claim!2300!spinal-manipulation-flag],
		NULL AS [claim!2300!spinal-condition-code],
		NULL AS [claim!2300!spinal-xray-availability-flag],
		NULL AS [claim!2300!dcn],
		NULL AS [claim!2300!submit-reason-code], 
		@PayerInsurancePolicyID AS [otherpayercob!2320!insurance-policy-id],
		NULL AS [otherpayercob!2320!sum-patient-responsibility],
		NULL AS [otherpayercob!2320!sum-contract-adjustments],
		NULL AS [otherpayercob!2320!insured-different-than-patient-flag],
		NULL AS [otherpayercob!2320!subscriber-first-name],
		NULL AS [otherpayercob!2320!subscriber-middle-name],
		NULL AS [otherpayercob!2320!subscriber-last-name],
		NULL AS [otherpayercob!2320!subscriber-suffix],
		NULL AS [otherpayercob!2320!subscriber-street-1],
		NULL AS [otherpayercob!2320!subscriber-street-2],
		NULL AS [otherpayercob!2320!subscriber-city],
		NULL AS [otherpayercob!2320!subscriber-state],
		NULL AS [otherpayercob!2320!subscriber-zip],
		NULL AS [otherpayercob!2320!subscriber-country],
		NULL AS [otherpayercob!2320!subscriber-birth-date],
		NULL AS [otherpayercob!2320!subscriber-gender],
		NULL AS [otherpayercob!2320!subscriber-assignment-of-benefits-flag],
		NULL AS [otherpayercob!2320!subscriber-release-of-information-code],
		NULL AS [otherpayercob!2320!relation-to-insured-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code],
		NULL AS [otherpayercob!2320!payer-responsibility-code-order],
		NULL AS [otherpayercob!2320!claim-filing-indicator-code],
		NULL AS [otherpayercob!2320!plan-name],
		NULL AS [otherpayercob!2320!insurance-type-code],
		NULL AS [otherpayercob!2320!group-number],
		NULL AS [otherpayercob!2320!policy-number],
		NULL AS [otherpayercob!2320!payer-name],
		NULL AS [otherpayercob!2320!payer-identifier-qualifier],
		NULL AS [otherpayercob!2320!payer-identifier],
		NULL AS [otherpayercob!2320!payer-street-1],
		NULL AS [otherpayercob!2320!payer-street-2],
		NULL AS [otherpayercob!2320!payer-city],
		NULL AS [otherpayercob!2320!payer-state],
		NULL AS [otherpayercob!2320!payer-zip],
		NULL AS [otherpayercob!2320!payer-country],
		NULL AS [otherpayercob!2320!payer-secondary-id],
		NULL AS [otherpayercob!2320!payer-contact-name],
		NULL AS [otherpayercob!2320!payer-contact-phone],
		NULL AS [otherpayercob!2320!payer-paid-flag],
		NULL AS [otherpayercob!2320!payer-paid-amount],
		NULL AS [otherpayercob!2320!payer-allowed-amount],
		NULL AS [otherpayercob!2320!payer-cob-allowed-amount],
		NULL AS [otherpayercob!2320!patient-responsibility-amount],
		NULL as [otherpayercob!2320!include-zero-payer-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-cob-allowed-amount],
		NULL as [otherpayercob!2320!include-zero-payer-patient-responsibility-amount],
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],        
		NULL AS [service!2400!referring-clia-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!drug-ndc-code],
		NULL AS [service!2400!drug-quantity],
		NULL AS [service!2400!drug-units-of-measure],
		NULL AS [service!2400!drug-ref-qualifier],
		NULL AS [service!2400!drug-ref-identifier],
		NULL AS [service!2400!measurement-reference-id-code],
		NULL AS [service!2400!measurement-qualifier],
		NULL AS [service!2400!measurement-value],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!emergency-related-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
		NULL AS [service!2400!hospice-employee-indicator],
		NULL AS [service!2400!dme-flag],
		NULL AS [service!2400!ordering-provider-first-name],
		NULL AS [service!2400!ordering-provider-middle-name],
		NULL AS [service!2400!ordering-provider-last-name],
		NULL AS [service!2400!ordering-provider-suffix],
		NULL AS [service!2400!ordering-provider-ssn-qual],
		NULL AS [service!2400!ordering-provider-ssn],
		NULL AS [service!2400!ordering-provider-upin],
		NULL AS [service!2400!ordering-provider-npi],
		NULL AS [service!2400!ordering-provider-addressline1],
		NULL AS [service!2400!ordering-provider-addressline2],
		NULL AS [service!2400!ordering-provider-city],
		NULL AS [service!2400!ordering-provider-state],
		NULL AS [service!2400!ordering-provider-zipcode],
		NULL AS [service!2400!ordering-provider-phone],
		NULL AS [service!2400!service-note-code],
		NULL AS [service!2400!service-note],
		NULL AS [service!2400!noc-service-note],
		NULL AS [service!2400!contract-otaf-amount],
		NULL AS [service!2400!allowed-amount],
		NULL AS [service!2400!approved-amount],
		NULL AS [service!2400!include-zero-approved-amount],
		NULL AS [adjudication!2430!adjudication-id],
		NULL AS [adjudication!2430!payer-identifier],
		NULL AS [adjudication!2430!monetary-amount],
		NULL AS [adjudication!2430!procedure-code],
		NULL AS [adjudication!2430!quantity],
		NULL AS [adjudication!2430!adjudication-date],
		NULL AS [adjudication!2430!kareo-payment-id],
		NULL AS [adjudication!2430!payer-adjusted-flag],
		NULL AS [adjudication!2430!assigned-number],
		NULL AS [adjustment!243001!adjustment-id],
		NULL AS [adjustment!243001!adjustment-group-code],
		NULL AS [adjustment!243001!adjustment-reason-1],
		NULL AS [adjustment!243001!adjustment-amount-1],
		NULL AS [adjustment!243001!adjustment-quantity-1],
		NULL AS [adjustment!243001!adjustment-reason-2],
		NULL AS [adjustment!243001!adjustment-amount-2],
		NULL AS [adjustment!243001!adjustment-quantity-2],
		NULL AS [adjustment!243001!adjustment-reason-3],
		NULL AS [adjustment!243001!adjustment-amount-3],
		NULL AS [adjustment!243001!adjustment-quantity-3],
		NULL AS [adjustment!243001!adjustment-reason-4],
		NULL AS [adjustment!243001!adjustment-amount-4],
		NULL AS [adjustment!243001!adjustment-quantity-4],
		NULL AS [adjustment!243001!adjustment-reason-5],
		NULL AS [adjustment!243001!adjustment-amount-5],
		NULL AS [adjustment!243001!adjustment-quantity-5],
		NULL AS [adjustment!243001!adjustment-reason-6],
		NULL AS [adjustment!243001!adjustment-amount-6],
		NULL AS [adjustment!243001!adjustment-quantity-6],
		TT.ANSIReferenceIdentificationQualifier AS [secondaryident!9!id-qualifier],
		TT.GroupNumber AS [secondaryident!9!provider-id],
		TT.ANSIReferenceIdentificationQualifier AS [secondaryident!9!payto-id-qualifier],
		TT.GroupNumber AS [secondaryident!9!payto-provider-id],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id]

		FROM	@t_groupnumbers TT

	-- END OF BILLING PROVIDER SECONDARY IDENTIFICATION


	ORDER BY -- Tag, Parent,
		[transaction!1!transaction-id],
		[billing!2!billing-id], 
		[subscriber!3!subscriber-id], 
		[patient!4!patient-id], 
		[claim!2300!claim-id],
		[renderingprovidernumbers!10!rendering-provider-id-qualifier],
		[referringprovidernumbers!11!referring-provider-id-qualifier],
		[service!2400!service-id], 
		[otherpayercob!2320!payer-responsibility-code-order],
		[adjudication!2430!adjudication-id],
		[adjustment!243001!adjustment-id],
		[secondaryident!9!id-qualifier]

	FOR XML EXPLICIT

	-- clean-up:

	DELETE @t_groupnumbers
	DELETE @t_providernumbers
	DELETE @t_refprovidernumbers
	DELETE @t_ambulancecertification
	DELETE @t_realPrecedence

	DROP TABLE #ClaimBatchDiagnosesPointers

	
----------- This sproc needs to be recompiled at a regular interval -------------

	DECLARE @CurrentProcedureName nvarchar(128)
	SET @CurrentProcedureName = OBJECT_NAME(@@PROCID)

	Update SystemProcedureCounter
	SET ExecutionCount = ExecutionCount + 1,
		@ExecutionCount = ExecutionCount + 1,
		@RecompileInterval = RecompileInterval
	WHERE ProcedureName = @CurrentProcedureName

	IF @ExecutionCount % @RecompileInterval = 0
		exec sp_recompile @CurrentProcedureName

----------- END of Recompile ----------------------------------------------------


END
