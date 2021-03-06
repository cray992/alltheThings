
--===========================================================================
-- GET EDI BILL XML
-- dbo.BillDataProvider_GetEDIBillXML 0, 202194
-- dbo.BillDataProvider_GetEDIBillXML 0, 0
--===========================================================================
ALTER PROCEDURE [dbo].[BillDataProvider_GetEDIBillXML]
	@batch_id INT,
	@bill_id INT

-- WITH RECOMPILE
AS
BEGIN
	
-- =========== Declaration Section (DML) To prevent recompiling of sproc mid-stream ===============----
	DECLARE @loop2010BB2U varchar(30)	-- case 5492

	-- some variables that can be overridden for specific payers:
	DECLARE @loop2310Bqual char(2)
	DECLARE @loop2310Btaxid varchar(30)

	-- get values that go into the header from shared DB:
	DECLARE @customer_id INT

	DECLARE @ClearinghouseConnectionId INT
	DECLARE @ProductionFlag INT
	DECLARE @SubmitterName VARCHAR(100)
	DECLARE @SubmitterEtin VARCHAR(100)
	DECLARE @SubmitterContactName VARCHAR(100)
	DECLARE @SubmitterContactPhone VARCHAR(100)
	DECLARE @SubmitterContactEmail VARCHAR(100)
	DECLARE @SubmitterContactFax VARCHAR(100)
	DECLARE @ReceiverName VARCHAR(100)
	DECLARE @ReceiverEtin VARCHAR(100)



	DECLARE @PracticeID INT
	DECLARE @PracticeEIN VARCHAR(32)
	DECLARE @PracticeNPI VARCHAR(32)
	DECLARE @RenderingProviderID INT
	DECLARE @RenderingProviderNPI VARCHAR(32)
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
	DECLARE @SupervisingProviderNPI varchar(32)
	DECLARE @SupervisingProviderIdQualifier CHAR(2)		-- one of G2, 1D, 1B provider number qualifier depends on insurance type 
	DECLARE @SupervisingProviderIdNumber VARCHAR(30)	-- actual provider number
	DECLARE @SupervisingProviderUpin VARCHAR(30)
	DECLARE @ServiceFacilityIdQualifier CHAR(2)
	DECLARE @TransactionType CHAR(2)		-- 'CH' or 'RP'
	DECLARE @PayerSupportsSecondaryElectronicBilling BIT
	DECLARE @PayerSupportsCoordinationOfBenefits BIT
	DECLARE @PracticeInsuranceUseSecondaryElectronicBilling BIT
	DECLARE @PracticeInsuranceUseCoordinationOfBenefits BIT

	DECLARE @t_realPrecedence Table(RealPrecedence int identity(1,1), InsurancePolicyID int, StatedPrecedence int)

	DECLARE @t_PatientCaseDate Table(PatientCaseID int, StartDate DateTime, EndDate DateTime, PatientCaseDateTypeID int)

	DECLARE @InitialTreatmentDate		DateTime
	DECLARE @DateOfInjury				DateTime
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

	DECLARE @SubmitterNameOverride VARCHAR(100)
	DECLARE @SubmitterEtinOverride VARCHAR(100)
	DECLARE @ReceiverNameOverride VARCHAR(100)
	DECLARE @ReceiverEtinOverride VARCHAR(100)

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

	DECLARE @ReferralNumber VARCHAR(100)

	DECLARE @needFacilityId bit

	DECLARE @IndBillerYesNo VARCHAR(256)	-- 'yes' or 'no'
	DECLARE @BillerType VARCHAR(1)		-- biller type for loop  2010AA, 1(indiv) or 2(group)
	DECLARE @BillerQual VARCHAR(2)		-- actual qualifier - XX, 24 or 34, for NM108 "ein-qualifier"
	DECLARE @BillerIdent VARCHAR(32)	-- actual value for NM109  "ein"

	DECLARE @IndBillerNPI VARCHAR(32)	-- for qualifier XX  (NPI)
	DECLARE @IndBillerSSN VARCHAR(32)	-- for qualifier 34  (SSN)
	DECLARE @IndBillerEIN VARCHAR(32)	-- for qualifier 24  (EIN)

	DECLARE @GroupBillerUsesEIN VARCHAR(32)	-- force qualifier 24 for loop 2310B, if NPI is missing

	DECLARE @PaytoEIN VARCHAR(32)
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
	DECLARE @CobOtherPayerInsurancePolicyID INT

	DECLARE @doCOB BIT
	DECLARE @doNPI BIT			-- SF case 00007862, FB case 14025
	DECLARE @doNPI2000 BIT		-- SF case 00007668

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
		[payer-paid-amount] money
		)

	DECLARE @t_cob_svcadjudication Table (
		TID int identity(1,1),
		[othersubscriberTID] int,					-- joins with @t_cob_othersubscriber.TID
			-- this is computed to fill loop 2420 SVD segment:
		[adjudication-date] datetime,
		[comp-procedure-code] varchar(128),
		[paid-amount] money,
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





	CREATE TABLE #BatchDiagnoses(
		DiagnosisCode varchar(64),
		RID int IDENTITY(1,1)
	)


	CREATE TABLE #ClaimBatch( ClaimID INT)
	create table #ClaimBatchDiagnoses( ClaimID INT, DiagnosisCode varchar(16), ListSequence INT )
	create table #ClaimBatchDiagnoses1( ClaimID INT, DiagnosisCode varchar(16), ListSequence INT )
	CREATE TABLE #ClaimBatchDiagnosesPointers (ClaimID INT, DiagnosisCode varchar(16), Pointer INT)

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





	SET @loop2310Bqual = '34'			-- means SSN, while some payers require EIN with qualifier 24 (case 5477)


	SELECT @customer_id = CustomerID FROM Master..SysDatabases SDB INNER JOIN SysFiles SF 
	ON SDB.FileName=SF.FileName
	INNER JOIN SharedServer.Superbill_Shared.dbo.Customer C ON SDB.Name=C.DatabaseName

-- per FB 22324 - no longer require this connection
--	SELECT  @ClearinghouseConnectionID = C.ClearinghouseConnectionID,
--		@ProductionFlag = ProductionFlag,
--		@SubmitterEtin = SubmitterEtin
----		@SubmitterContactName = SubmitterContactName,
----		@SubmitterName = SubmitterName,
----		@SubmitterContactPhone = SubmitterContactPhone,
----		@SubmitterContactEmail = SubmitterContactEmail,
----		@SubmitterContactFax = SubmitterContactFax,
----		@ReceiverName = ReceiverName,
----		@ReceiverEtin = ReceiverEtin
--	FROM SharedServer.Superbill_Shared.dbo.Customer C
--		 JOIN SharedServer.Superbill_Shared.dbo.ClearinghouseConnection CC ON CC.ClearinghouseConnectionID = C.ClearinghouseConnectionID
--	WHERE C.CustomerID = @customer_id
--
--	-- if Clearinghouse Connection is not set up, we return here.
--	-- Broker Server knows to throw friendly exception message when empty XML comes out of here:
--	IF (@SubmitterEtin IS NULL)
--		return;
--

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

	SET @SupervisingProviderIdQualifier = 'G2'

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
		@PracticeEIN = PR.EIN,
		@PracticeNPI = PR.NPI,
		@RenderingProviderID = RD.DoctorID,
		@RenderingProviderNPI = RD.NPI,
		@SupervisingProviderID = SD.DoctorID,
		@SupervisingProviderNPI = SD.NPI,
		@PatientID = P.PatientID,
		@EncounterID = E.EncounterID,
		@LocationID = E.LocationID,
		@ServiceFacilityIdQualifier = LNT.ANSIReferenceIdentificationQualifier,
		@PlaceOfServiceCode = E.PlaceOfServiceCode
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

	-- SF case 00007862, FB case 14025   TBD
	-- see if we need to supress NPI sending for those payers who haven't prepared to accept them:

	SET @doNPI = 1

	IF (@ClearinghouseID = 1 AND @PayerNumber IN ('01260', 'MBHCR', 'AXN01'))
	BEGIN
		SET @doNPI = 0
	END

	IF (@ClearinghouseID = 2 AND @PayerNumber IN ('01260', 'AXN01'))
	BEGIN
		SET @doNPI = 0
	END

	IF (@ClearinghouseID = 3 AND @PayerNumber IN ('01260', '77035'))
	BEGIN
		SET @doNPI = 0
	END

	-- similarly allow or suppress Biller loop NPI:
	SET @doNPI2000 = 1

--	IF (@ClearinghouseID = 3) -- AND @PayerNumber IN ('00570', '77035'))
--	BEGIN
--		SET @doNPI2000 = 1
--	END

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

	-- ok, we know enough about big claim and insurances involved in this billing act
	---------------------------------------------------------------------------------------------------------------------

	-- case 14717: prepare all dates:


	INSERT @t_PatientCaseDate (PatientCaseID, StartDate, EndDate, PatientCaseDateTypeID)
	SELECT PCD.PatientCaseID, PCD.StartDate, PCD.EndDate, PCD.PatientCaseDateTypeID
	FROM PatientCaseDate PCD
	WHERE PCD.PracticeID = @PracticeID AND PCD.PatientCaseID = @PatientCaseID
	ORDER BY PatientCaseDateID DESC


	SELECT TOP 1 
		@InitialTreatmentDate = InitialTreatmentDate.StartDate,
		@DateOfInjury = DateOfInjury.StartDate,
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
	WHERE	PC.PatientCaseID = @PatientCaseID

	DELETE @t_PatientCaseDate

	-- case 8805: prepare Ordering Provider info for DME bills, if any:

	SELECT TOP 1 
		@OPFirstName = UPPER(OP.FirstName),
		@OPMiddleName = UPPER(OP.MiddleName),
		@OPLastName = UPPER(OP.LastName),
		@OPSuffix = UPPER(OP.Suffix),
		@OPSSNQualifier = '24',
		@OPSSN = ISNULL(CASE WHEN LEN(OP.SSN) > 0 THEN OP.SSN ELSE NULL END,'999999999'),
		@OPUPIN = UPPER(COALESCE(UPIN.ProviderNumber, '')),
		@OPNPI = CASE @doNPI WHEN 1 THEN OP.NPI ELSE NULL END,
		@OPAddressLine1 = UPPER(OP.AddressLine1),
		@OPAddressLine2 = UPPER(OP.AddressLine2),
		@OPCity = UPPER(OP.City),
		@OPState = UPPER(OP.State),
		@OPZipCode = OP.ZipCode,
		@OPPhone = OP.WorkPhone
	FROM dbo.Encounter E
		LEFT OUTER JOIN Doctor OP
			ON OP.DoctorID = E.ReferringPhysicianID
		LEFT OUTER JOIN ProviderNumber UPIN
			ON UPIN.DoctorID = OP.DoctorID
			AND UPIN.ProviderNumberTypeID = 25
	WHERE	E.EncounterID = @EncounterID



	-- case 8560 - get Ambulance Certification codes for the encounter:
	INSERT INTO @t_ambulancecertification
	SELECT TOP 5
		ACI.AmbulanceCertificationCode
	FROM AmbulanceCertificationInformation ACI
	WHERE ACI.EncounterID = @EncounterID
	ORDER BY ACI.AmbulanceCertificationCode

	-- get those group numbers into a temp table so that tweaking them is easy. They are sorted and duplicates removed:

	DECLARE @groupNumberQualifiers xml
	SET @groupNumberQualifiers = dbo.fn_CreateSelectionsRoot()
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'0B')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'1A')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'1B')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'1C')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'1D')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'1G')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'1H')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'1J')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'B3')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'BQ')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'EI')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'FH')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'G2')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'G5')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'LU')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'SY')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'U3')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'X5')

	--the use of the following is probably not optimal: we add them and then remove them
    --instead should get these codes separately
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'SN')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'SM')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'RN')
	SET @groupNumberQualifiers = dbo.fn_AddQualifierToSelections(@groupNumberQualifiers,'RM')


	INSERT INTO @t_groupnumbers(ANSIReferenceIdentificationQualifier, GroupNumber)
	SELECT 
		Qualifier, 
		Number
	FROM
		dbo.fn_BillDataProvider_GetMultipleGroupNumbersForPractice
		(
			@PracticeID,
			@LocationID,
			@InsuranceCompanyPlanID,
			DEFAULT,
			DEFAULT,
			3, --electronic claim attachment condition
			DEFAULT, --default limit
			@groupNumberQualifiers
		)


	SELECT 	@SubmitterNameOverride = GroupNumber FROM @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier = 'SM'
	SELECT 	@SubmitterEtinOverride = GroupNumber FROM @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier = 'SN'
	SELECT 	@ReceiverNameOverride = GroupNumber FROM @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier = 'RM'
	SELECT 	@ReceiverEtinOverride = GroupNumber FROM @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier = 'RN'

	IF (@SubmitterNameOverride IS NOT NULL)
		SET @SubmitterName = @SubmitterNameOverride

	IF (@SubmitterEtinOverride IS NOT NULL)
		SET @SubmitterEtin = @SubmitterEtinOverride

	IF (@ReceiverNameOverride IS NOT NULL)
		SET @ReceiverName = @ReceiverNameOverride

	IF (@ReceiverEtinOverride IS NOT NULL)
		SET @ReceiverEtin = @ReceiverEtinOverride

	DELETE @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier IN ('SM', 'SN', 'RM', 'RN')

	DECLARE @providerNumberQualifiers xml
	SET @providerNumberQualifiers = dbo.fn_CreateSelectionsRoot()
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'0B')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'1A')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'1B')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'1C')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'1D')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'1G')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'1H')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'G2')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'EI')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'LU')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'N5')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'SY')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'X5')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'Z0')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'Z1')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'G5')
	SET @providerNumberQualifiers = dbo.fn_AddQualifierToSelections(@providerNumberQualifiers,'U3')


	INSERT INTO @t_providernumbers(ANSIReferenceIdentificationQualifier, ProviderNumber)
	SELECT 
		Qualifier, 
		Number
	FROM
		Claim RC
		INNER JOIN dbo.EncounterProcedure EP
			ON EP.EncounterProcedureID = RC.EncounterProcedureID
		INNER JOIN dbo.Encounter E
			ON E.EncounterID = EP.EncounterID
		INNER JOIN InsurancePolicy PI
			ON PI.InsurancePolicyID = @PayerInsurancePolicyID
		CROSS APPLY dbo.fn_BillDataProvider_GetMultipleProviderNumbersForProvider
		(
			E.DoctorID,
			E.LocationID,
			PI.InsuranceCompanyPlanID,
			DEFAULT,
			DEFAULT,
			3, --electronic claim attachment condition
			DEFAULT, --default limit
			@providerNumberQualifiers
		) ProviderNumbers
	WHERE	RC.ClaimID = @RepresentativeClaimID

	DECLARE @refProviderNumberQualifiers xml

	SET @refProviderNumberQualifiers = dbo.fn_CreateSelectionsRoot()
	SET @refProviderNumberQualifiers = dbo.fn_AddQualifierToSelections(@refProviderNumberQualifiers,'0B')
	SET @refProviderNumberQualifiers = dbo.fn_AddQualifierToSelections(@refProviderNumberQualifiers,'1B')
	SET @refProviderNumberQualifiers = dbo.fn_AddQualifierToSelections(@refProviderNumberQualifiers,'1C')
	SET @refProviderNumberQualifiers = dbo.fn_AddQualifierToSelections(@refProviderNumberQualifiers,'1D')
	SET @refProviderNumberQualifiers = dbo.fn_AddQualifierToSelections(@refProviderNumberQualifiers,'1G')
	SET @refProviderNumberQualifiers = dbo.fn_AddQualifierToSelections(@refProviderNumberQualifiers,'1H')
	SET @refProviderNumberQualifiers = dbo.fn_AddQualifierToSelections(@refProviderNumberQualifiers,'G2')
	SET @refProviderNumberQualifiers = dbo.fn_AddQualifierToSelections(@refProviderNumberQualifiers,'LU')
	SET @refProviderNumberQualifiers = dbo.fn_AddQualifierToSelections(@refProviderNumberQualifiers,'N5')
	SET @refProviderNumberQualifiers = dbo.fn_AddQualifierToSelections(@refProviderNumberQualifiers,'X5')

	--ref providers have an additional type, which will get deleted a little bit later
	SET @refProviderNumberQualifiers = dbo.fn_AddQualifierToSelections(@refProviderNumberQualifiers,'9F')

	INSERT INTO @t_refprovidernumbers(ANSIReferenceIdentificationQualifier, ProviderNumber)
	SELECT 
		Qualifier, 
		Number
	FROM
		Claim RC
		INNER JOIN dbo.EncounterProcedure EP
			ON EP.EncounterProcedureID = RC.EncounterProcedureID
		INNER JOIN dbo.Encounter E
			ON E.EncounterID = EP.EncounterID
		INNER JOIN InsurancePolicy PI
			ON PI.InsurancePolicyID = @PayerInsurancePolicyID
		CROSS APPLY dbo.fn_BillDataProvider_GetMultipleProviderNumbersForProvider
		(
			E.ReferringPhysicianID,
			E.LocationID,
			PI.InsuranceCompanyPlanID,
			DEFAULT,
			DEFAULT,
			3, --electronic claim attachment condition
			DEFAULT, --default limit
			@refProviderNumberQualifiers
		) ProviderNumbers
	WHERE	RC.ClaimID = @RepresentativeClaimID


	-- get Referral Number (case 8038)
	SELECT @ReferralNumber = ProviderNumber FROM @t_refprovidernumbers WHERE ANSIReferenceIdentificationQualifier = '9F'
	DELETE @t_refprovidernumbers WHERE ANSIReferenceIdentificationQualifier = '9F'

	------------------------------------------------------------------------------------------------------
	-- do whatever is needed to accommodate payer-specific requirements for this envelope:

	-- case 5620:
	IF (@PayerNumber = 'BS029')
 	    DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier = '1G'

	-- case 5498:
	IF (@PayerNumber LIKE 'BS%')
		DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier IN  ('1C', '1D', '1H') 

	IF (@PayerNumber LIKE 'MR0%')	-- case 12804 -- mind MRC01 - MERCY CARE AHCCCS
		DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier IN  ('1A', '1B', '1D', '1H') 

	-- case 5477, 6039, and also RoguePayers list for Noridian payers:
	IF (@PayerNumber IN ('MR034', 'MR036', 'MR084', 'MR083', 'MR004', 'MR074', 'MR006', 'MR010', 'MR011', 'MR008', 'MR007', 'MR057', 'BS074', 'BS057', 'MC026', 'BS003', 'BS031'))
	BEGIN
		SET @loop2310Bqual = '24'
		SELECT 	@loop2310Btaxid = ProviderNumber FROM @t_providernumbers WHERE ANSIReferenceIdentificationQualifier = 'EI'
	END

	-- case 5492:
	IF (@PlanName LIKE 'BC/BS OF SOUTH CAROLINA-%')
		SET @loop2010BB2U=SUBSTRING(@PlanName,CHARINDEX('-',@PlanName)+1,3)

/*
	IF (@PlanName LIKE 'BC/BS OF SOUTH CAROLINA-130%')
		SET @loop2010BB2U = '130'

	IF (@PlanName LIKE 'BC/BS OF SOUTH CAROLINA-400%')
		SET @loop2010BB2U = '400'

	............
*/

	-- case 5840:
	IF (@PayerNumber = 'MC024')
 	    DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier NOT IN  ('1D', 'Z0', 'Z1', 'EI')


	-- case 7865:
	IF (@PayerNumber LIKE 'MC%')
	BEGIN
	    SET @SupervisingProviderIdQualifier = '1D'
	END

	IF (@PayerNumber LIKE 'BS%')
	BEGIN
	    SET @SupervisingProviderIdQualifier = '1B'
	END

	-- SF 30027, FB 23078 - medicare payers need a 1C REF segment for supervising provider
	IF (@customer_id IN (878,856) AND @InsuranceProgramCode = 'MB')
	BEGIN
	    SET @SupervisingProviderIdQualifier = '1C'
	END

	-- case 8396:
	IF (@PayerNumber IN ('MC010','MR025'))
 	    SET @hide_patient_paid_amount = 1

	-- at this point @ServiceFacilityIdQualifier is picked from ServiceLocation (usually 1J)
	SET @needFacilityId = 0

	-- case 8114:
	IF (@PayerNumber IN ('MC051','MC093'))
	BEGIN
		SET @ServiceFacilityIdQualifier = '1D'		-- also flags that ID is needed
		SET @needFacilityId = 1
	END

	-- case 20712:
	IF (@PayerNumber IN ('BS027'))
	BEGIN
		SET @needFacilityId = 1
	END

	-- case 10711:
	IF (@PayerNumber IN ('54704','95044') AND @customer_id = 277)
	BEGIN
		SET @needFacilityId = 1
	END

	-- case 16249: [exclusion for cust 622 is SF 19355, FB 23131]
	IF (@PlaceOfServiceCode = '31' AND @InsuranceProgramCode IN ('MB') AND @customer_id NOT IN (622))
	BEGIN
		-- SET @ServiceFacilityIdQualifier = 'LU'		-- also flags that ID is needed
		SET @needFacilityId = 1
	END

	IF (@needFacilityId <> 1)
	BEGIN
		SET @ServiceFacilityIdQualifier = NULL
	END

	------------------------------------------------------------------------------------------------------
	-- SF 12226 and SF 28487
	DECLARE @SumContractAdjustments bit
	SELECT @SumContractAdjustments = 0
	-- case 10711:
	IF (@PayerNumber IN ('BS049','BS017') AND @customer_id = 122)
	BEGIN
		SET @SumContractAdjustments = 1
	END

	------------------------------------------------------------------------------------------------------
	-- case 7799 - same way, get individual provider numbers for a Supervising Provider into a temp table. Also sorted and duplicates removed:

	IF (@SupervisingProviderID IS NOT NULL)
	BEGIN

		SELECT 
			@SupervisingProviderIdNumber = SupervisingProvider_ProviderNumber.Number
		FROM
			Claim RC
			INNER JOIN dbo.EncounterProcedure EP
				ON EP.EncounterProcedureID = RC.EncounterProcedureID
			INNER JOIN dbo.Encounter E
				ON E.EncounterID = EP.EncounterID
			INNER JOIN InsurancePolicy PI
				ON PI.InsurancePolicyID = @PayerInsurancePolicyID
			CROSS APPLY dbo.fn_BillDataProvider_GetSingleProviderNumberForProvider
			(
				E.SupervisingProviderID,
				E.LocationID,
				PI.InsuranceCompanyPlanID,
				@SupervisingProviderIdQualifier, 
				null, 
				3 -- eclaims
			) SupervisingProvider_ProviderNumber
		WHERE	RC.ClaimID = @RepresentativeClaimID

		SELECT 
			@SupervisingProviderUpin = SupervisingProvider_UPIN.Number
		FROM
			Claim RC
			INNER JOIN dbo.EncounterProcedure EP
				ON EP.EncounterProcedureID = RC.EncounterProcedureID
			INNER JOIN dbo.Encounter E
				ON E.EncounterID = EP.EncounterID
			INNER JOIN InsurancePolicy PI
				ON PI.InsurancePolicyID = @PayerInsurancePolicyID
			CROSS APPLY dbo.fn_BillDataProvider_GetSingleProviderNumberForProvider
			(
				E.SupervisingProviderID,
				E.LocationID,
				PI.InsuranceCompanyPlanID,
				'1G',  --UPIN 
				null, 
				3 -- eclaims
			) SupervisingProvider_UPIN
		WHERE	RC.ClaimID = @RepresentativeClaimID

	END


	------------------------------------------------------------------------------------------------------
	-- individual billers supply PRV in loop 2000A and do not have Loop 2310B:
	-- (case 6018):
	SET @BillerType = '2'		-- default is group
	SET @BillerQual = '24'	-- default is EIN

	-- we may just use EI to override Practice EIN, even if Ind Biller is not intended:
	SELECT 	@IndBillerEIN = ProviderNumber FROM @t_providernumbers
			 WHERE ANSIReferenceIdentificationQualifier = 'EI'

	-- supplying Z0=yes turns individual billing mode on
	SELECT 	@IndBillerYesNo = ProviderNumber FROM @t_providernumbers
			 WHERE ANSIReferenceIdentificationQualifier = 'Z0' AND ProviderNumber = 'yes'

	-- case 10494:
	-- case 7872:
	-- the request (or by default) is to build as a group. Do the final checking here to make sure we have group numbers at all,
	-- and force individual mode if group billing is obviously impossible:
	IF (ISNULL(@IndBillerYesNo,'no') <> 'yes')
	BEGIN

		SELECT @groupNumbersCount = COUNT(*) FROM @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier NOT IN ('1G','EI','SY','Z0','Z1')	-- default

		IF (@PayerNumber LIKE 'BC%')
		BEGIN
			SELECT @groupNumbersCount = COUNT(*) FROM @t_groupnumbers WHERE (ANSIReferenceIdentificationQualifier = '1A' OR ANSIReferenceIdentificationQualifier = '1B')
		END
	
		IF (@PayerNumber LIKE 'BS%')
		BEGIN
			SELECT @groupNumbersCount = COUNT(*) FROM @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier = '1B'
		END
	
		IF (@PayerNumber LIKE 'MB%')
		BEGIN
			SELECT @groupNumbersCount = COUNT(*) FROM @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier = '1C'
		END

		IF (@PayerNumber LIKE 'MC%')
		BEGIN
			SELECT @groupNumbersCount = COUNT(*) FROM @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier = '1D'
		END

		IF(@groupNumbersCount = 0)
		BEGIN
			SET @IndBillerYesNo = 'yes'
		END
	END

	IF (ISNULL(@IndBillerYesNo,'no') = 'yes')
	BEGIN
		-- we are billing for individual provider, loops 2000, 2010AA and 2310BB are affected

		SET @BillerType = '1'

		SELECT 	@IndBillerSSN = ProviderNumber FROM @t_providernumbers
			 WHERE ANSIReferenceIdentificationQualifier = 'Z1' AND ProviderNumber <> 'EI'
	
		IF (@IndBillerSSN IS NOT NULL )
		BEGIN
			SET @BillerQual = '34'		-- indicated that SSN is used here
			SET @IndBillerEIN = @IndBillerSSN
		END

		-- group numbers don't matter any more, we need individual numbers instead:
		DELETE @t_groupnumbers

		INSERT INTO @t_groupnumbers (ANSIReferenceIdentificationQualifier, GroupNumber)
			SELECT ANSIReferenceIdentificationQualifier, ProviderNumber
			FROM	@t_providernumbers

		SET @BillerIdent = ISNULL(@IndBillerEIN, @PracticeEIN)
		SET @PaytoEIN = ISNULL(@IndBillerEIN, @PracticeEIN)
		SET @PaytoNPI = @RenderingProviderNPI

		IF(@doNPI2000 = 1 AND @RenderingProviderNPI IS NOT NULL)
		BEGIN
			IF(NOT EXISTS(SELECT * FROM @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier='EI'))
			BEGIN
				INSERT INTO @t_groupnumbers (ANSIReferenceIdentificationQualifier, GroupNumber)
				VALUES ('EI', @BillerIdent)
			END

			SET @BillerQual = 'XX'
			SET @BillerIdent = @RenderingProviderNPI
		END
	END
	ELSE
	BEGIN
		-- group billing here, see if we need to tweak rendering provider loop:

		-- if requested, force using EIN instead of SSN for loop 2310B:
		SELECT 	@GroupBillerUsesEIN = ProviderNumber FROM @t_providernumbers
			 WHERE ANSIReferenceIdentificationQualifier = 'Z1' AND ProviderNumber = 'EI'

		-- if provider has EI defined, and NPI is used, use it for the REF*EI : 
		IF (@doNPI = 1 AND @RenderingProviderNPI IS NOT NULL AND LEN(@RenderingProviderNPI) = 10 AND (SELECT ProviderNumber FROM @t_providernumbers WHERE ANSIReferenceIdentificationQualifier = 'EI') IS NOT NULL)
		BEGIN
			SET @GroupBillerUsesEIN = 'yes'
		END

		IF (@GroupBillerUsesEIN IS NOT NULL)
		BEGIN
			-- similar block is used above for Noridians:
			SET @loop2310Bqual = '24'
			SELECT 	@loop2310Btaxid = ProviderNumber FROM @t_providernumbers WHERE ANSIReferenceIdentificationQualifier = 'EI'
		END

		SET @BillerIdent = @PracticeEIN
		SET @PaytoEIN = @PracticeEIN
		SET @PaytoNPI = @PracticeNPI

		IF(@doNPI2000 = 1 AND @PracticeNPI IS NOT NULL)
		BEGIN
			IF(NOT EXISTS(SELECT * FROM @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier='EI'))
			BEGIN
				INSERT INTO @t_groupnumbers (ANSIReferenceIdentificationQualifier, GroupNumber)
				VALUES ('EI', @PracticeEIN)
			END

			SET @BillerQual = 'XX'
			SET @BillerIdent = @PracticeNPI
		END

	END

	-- @IndBillerEIN can be still NULL here, if no Practice EIN override is intended

	DELETE @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier IN  ('Z0', 'Z1') 
	DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier IN  ('Z0', 'Z1') 

	IF (@loop2310Bqual <> 'XX' AND @PayerNumber <> 'BS028')
	BEGIN
		IF (@BillerQual <> 'XX')
		BEGIN
		    DELETE @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier IN  ('EI') 
		END
	    DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier IN  ('EI') 
	END

	-- make sure we don't have invalid qualifiers in loop 2310B: 
	IF (ISNULL(@BillerType,'1') = '2')
	BEGIN
		DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier NOT IN  ('0B', '1B', '1C', '1D', '1G', '1H', 'EI', 'G2', 'LU', 'N5', 'SY', 'X5') 
		-- 0B, 1G, G2, LU - new May 2006 doc allows only these
	END

	-- the 'SY' or 'EI' will be added of NPI is present, delete the one we might have; also Medicare does not tolerate SY:
	IF (@doNPI = 1 AND @RenderingProviderNPI IS NOT NULL AND LEN(@RenderingProviderNPI) = 10 OR @InsuranceProgramCode = 'MB' OR @loop2310Bqual = '34')
	BEGIN
	    DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier IN  ('SY') 
	END

	IF (@doNPI = 1 AND @RenderingProviderNPI IS NOT NULL AND LEN(@RenderingProviderNPI) = 10 AND @loop2310Bqual = '24')
	BEGIN
	    DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier IN  ('EI') 
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

	--Fetch claims' diagnoses into temp table
	INSERT INTO #ClaimBatchDiagnoses (ClaimID, DiagnosisCode, ListSequence)
	SELECT
		CB.ClaimID, DiagnosisCode, ED.ListSequence
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID1=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID

	UNION

	SELECT
		CB.ClaimID, DiagnosisCode, ED.ListSequence
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID2=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode, ED.ListSequence
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID3=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode, ED.ListSequence
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID4=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode, ED.ListSequence
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID5=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode, ED.ListSequence
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID6=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode, ED.ListSequence
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID7=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID


	UNION

	SELECT
		CB.ClaimID, DiagnosisCode, ED.ListSequence
	FROM
		#ClaimBatch CB
		INNER JOIN Claim C ON C.ClaimID = CB.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN EncounterDiagnosis ED ON EP.EncounterDiagnosisID8=ED.EncounterDiagnosisID
		INNER JOIN DiagnosisCodeDictionary DCD ON ED.DiagnosisCodeDictionaryID=DCD.DiagnosisCodeDictionaryID

	-- we want codes that are listed first in claims generally go first in the list:
	INSERT INTO #ClaimBatchDiagnoses1
	SELECT * FROM #ClaimBatchDiagnoses ORDER BY ListSequence, ClaimID

	-- make the list of diag codes:
	INSERT INTO #BatchDiagnoses (DiagnosisCode)
	SELECT DiagnosisCode FROM #ClaimBatchDiagnoses1 GROUP BY DiagnosisCode ORDER BY MIN(ListSequence)

	--SELECT * FROM #BatchDiagnoses

	-- here is final pointers temp table - claim, diag, pointer:
	INSERT INTO #ClaimBatchDiagnosesPointers (ClaimID, DiagnosisCode, Pointer )
	SELECT DISTINCT	CBD.ClaimID, CBD.DiagnosisCode, BD.RID AS Pointer  FROM #ClaimBatchDiagnoses CBD JOIN #BatchDiagnoses BD ON  BD.DiagnosisCode = CBD.DiagnosisCode

	DROP TABLE #ClaimBatchDiagnoses
	DROP TABLE #ClaimBatchDiagnoses1

	-- prepare all diag codes we need for all service lines involved:

	SELECT  @DiagnosisCode1 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 1

	SELECT  @DiagnosisCode2 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 2

	SELECT  @DiagnosisCode3 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 3

	SELECT  @DiagnosisCode4 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 4

	SELECT  @DiagnosisCode5 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 5

	SELECT  @DiagnosisCode6 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 6

	SELECT  @DiagnosisCode7 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 7

	SELECT  @DiagnosisCode8 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 8

	DROP TABLE #BatchDiagnoses

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
				ELSE PI.HolderAddressLine1 END)
				AS [subscriber-street-1],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.AddressLine2
				ELSE PI.HolderAddressLine2 END)
				AS [subscriber-street-2],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.City
				ELSE PI.HolderCity END)
				AS [subscriber-city],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.State
				ELSE PI.HolderState END)
				AS [subscriber-state],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN P.ZipCode
				ELSE PI.HolderZipCode END)
				AS [subscriber-zip],
			UPPER(CASE PI.PatientRelationshipToInsured
				WHEN 'S' THEN (CASE WHEN P.Country LIKE 'CA%' THEN 'CA' ELSE NULL END)
				ELSE (CASE WHEN PI.HolderCountry LIKE 'CA%' THEN 'CA' ELSE NULL END) END)
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
			IC.InsuranceProgramCode
				AS [claim-filing-indicator-code],
			UPPER(SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ICP.PlanName,'+',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' '),1,35)) AS [plan-name],
			'C1' AS [insurance-type-code],
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
						[paid-amount],
						[paid-quantity],
						[assigned-number],
						PaymentID, PaymentClaimID, PracticeID, PatientID, EncounterID, ClaimID, EOBXml, Notes
				)
				SELECT
						@cob_othersubscriberTID AS othersubscriberTID,
						PMT.AdjudicationDate AS [adjudication-date],
						UPPER(ISNULL(CASE WHEN LEN(PCD.BillableCode)=0 THEN NULL ELSE PCD.BillableCode END,PCD.ProcedureCode)) AS [comp-procedure-code],
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

				-- <SF 26232>
				-- see if there is more than payment for this policy ... if so, we need to pare it down to one payment
				
--				-- debugging
--				SELECT 'Within cob_cursor processing', @cob_othersubscriberTID as [@cob_othersubscriberTID], @cob_insurancePolicyID as[@cob_insurancePolicyID], * from  @t_cob_svcadjudication

				DECLARE @countPaymentsPerInsurancePolicy int
				DECLARE @tidBestPayment int

				SELECT @countPaymentsPerInsurancePolicy = 0
				SELECT @countPaymentsPerInsurancePolicy = count(1) 
					FROM @t_cob_svcadjudication
					WHERE othersubscriberTID = @cob_othersubscriberTID

				-- only worry about it if there's more than one
				IF @countPaymentsPerInsurancePolicy > 1
				BEGIN
					DECLARE @compProcedureCode varchar(128)

					DECLARE cob_26232_cursor CURSOR READ_ONLY
					FOR
						SELECT [comp-procedure-code], othersubscriberTID  
						FROM @t_cob_svcadjudication 
						GROUP BY [comp-procedure-code], othersubscriberTID 

					OPEN cob_26232_cursor

					FETCH NEXT FROM cob_26232_cursor INTO @compProcedureCode, @cob_othersubscriberTID

					WHILE (@@FETCH_STATUS = 0)
					BEGIN
						IF (@@fetch_status <> -2)
						BEGIN
--							-- debugging
--							SELECT 'ordered list of @t_cob_svcadjudication for this insurance - removing all but top row', @cob_othersubscriberTID as [@cob_othersubscriberTID], EOBXml.value('(/eob/denial)[1]','bit') as Denial, *
--								FROM @t_cob_svcadjudication 
--								WHERE othersubscriberTID = @cob_othersubscriberTID AND [comp-procedure-code] = @compProcedureCode 
--								ORDER BY EOBXml.value('(/eob/denial)[1]','bit')

							-- Basically sort the payments by "denial" so non-denials would be 0 and would sort before denials.
							--  If there are nothing but denials, just keep one of them
							--  If there are multiple payments, we'll still keep just one of them
							SELECT TOP 1 @tidBestPayment = TID 
								FROM @t_cob_svcadjudication 
								WHERE othersubscriberTID = @cob_othersubscriberTID AND [comp-procedure-code] = @compProcedureCode 
								ORDER BY EOBXml.value('(/eob/denial)[1]','bit')

							DELETE @t_cob_svcadjudication 
								WHERE othersubscriberTID = @cob_othersubscriberTID AND [comp-procedure-code] = @compProcedureCode 
									AND TID <> @tidBestPayment 

--							-- debugging
--							SELECT 'Within cob_cursor processing - after delete', @cob_othersubscriberTID as [@cob_othersubscriberTID], @cob_insurancePolicyID as[@cob_insurancePolicyID], * from  @t_cob_svcadjudication
						END
						FETCH NEXT FROM cob_26232_cursor INTO @compProcedureCode, @cob_othersubscriberTID
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
				UPDATE @t_cob_svcadjustment SET [adjustment-description] = '45'
				WHERE ISNULL([adjustment-description],'')=''

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

	DROP TABLE #ClaimBatch


	------------------------------------------------------------------------------------------------------
	-- now get all XML in one big scoop:

	-- ST: TRANSACTION SET HEADER -- BHT
	SELECT	1 AS Tag, NULL AS Parent,
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
		@SubmitterEtin AS [transaction!1!submitter-etin],
		@SubmitterContactName AS [transaction!1!submitter-contact-name],
		@SubmitterContactPhone AS [transaction!1!submitter-contact-phone],
		@SubmitterContactEmail AS [transaction!1!submitter-contact-email],
		@SubmitterContactFax AS [transaction!1!submitter-contact-fax],
		@ReceiverName AS [transaction!1!receiver-name],
		@ReceiverEtin AS [transaction!1!receiver-etin],

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
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
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
		NULL AS [claim!2300!supervising-provider-ssn-qual],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-upin],
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
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL AS [claim!2300!ambulance-address-pickup],
		NULL AS [claim!2300!ambulance-address-dropoff],
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
		NULL AS [otherpayercob!2320!insurance-policy-id],
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
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
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
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

		@BillerType AS [billing!2!biller-type],		-- 1 or 2
		@PracticeID AS [billing!2!billing-id],
		UPPER(PR.Name) AS [billing!2!name],
		UPPER(PR.AddressLine1) AS [billing!2!street-1],
		UPPER(PR.AddressLine2) AS [billing!2!street-2],
		UPPER(PR.City) AS [billing!2!city],
		UPPER(PR.State) AS [billing!2!state],
		PR.ZipCode AS [billing!2!zip],
		CASE WHEN PR.Country LIKE 'CA%' THEN 'CA' ELSE NULL END AS [billing!2!country],
		@BillerQual AS [billing!2!ein-qualifier],
		@BillerIdent AS [billing!2!ein],
		UPPER(PR.Name) AS [billing!2!payto-name],
		UPPER(PR.AddressLine1) AS [billing!2!payto-street-1],
		UPPER(PR.AddressLine2) AS [billing!2!payto-street-2],
		UPPER(PR.City) AS [billing!2!payto-city],
		UPPER(PR.State) AS [billing!2!payto-state],
		PR.ZipCode AS [billing!2!payto-zip],
		CASE WHEN PR.Country LIKE 'CA%' THEN 'CA' ELSE NULL END AS [billing!2!payto-country],
		@PaytoEIN AS [billing!2!payto-ein],
		@PaytoNPI AS [billing!2!payto-npi],
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
		NULL AS [claim!2300!supervising-provider-ssn-qual],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-upin],
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
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL AS [claim!2300!ambulance-address-pickup],
		NULL AS [claim!2300!ambulance-address-dropoff],
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
		NULL AS [otherpayercob!2320!insurance-policy-id],
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
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
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
	WHERE	BB.BillBatchID = @batch_id
	-- END OF BILLING/PAY-TO PROVIDER LOOP (2010AA 2010AB)

	UNION ALL

	-- SUBSCRIBER HIERARCHICAL LEVEL - LOOP 2000
	SELECT	3, 2,
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
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

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
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
		@PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
--
-- per FB 22522 any code below that you see that follows the pattern
--     CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' ELSE <original code> END
--   is handling the following case:
--     The @PayerInsurancePolicyID is not in the precedence table.  What used to happen was that GetEdiBillXml would simply fault.
--     Per fb 22522, we now return "ERROR" in some key strings so that we can catch this at validation time

		CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' ELSE UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.FirstName
			ELSE PI.HolderFirstName END) END
			AS [subscriber!3!first-name],
		CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' ELSE UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.MiddleName
			ELSE P.MiddleName END) END
			AS [subscriber!3!middle-name],
		CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' ELSE UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.LastName
			ELSE PI.HolderLastName END) END
			AS [subscriber!3!last-name],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.Suffix
			ELSE PI.HolderSuffix END)
			AS [subscriber!3!suffix],
		(CASE PI.PatientRelationshipToInsured WHEN 'S' THEN 0 ELSE 1 END)
			AS [subscriber!3!insured-different-than-patient-flag],
--		CASE RPI.RealPrecedence WHEN 1 THEN 'P' WHEN 2 THEN 'S' WHEN 3 THEN 'T' WHEN 4 THEN 'A' WHEN 5 THEN 'B' WHEN 6 THEN 'C' WHEN 7 THEN 'D' ELSE 'E' END
		CASE WHEN @doCOB=1 THEN (CASE RPI.RealPrecedence WHEN 1 THEN 'P' WHEN 2 THEN 'S' WHEN 3 THEN 'T' ELSE 'T' END) ELSE 'P' END
		-- B.PayerResponsibilityCode 
			AS [subscriber!3!payer-responsibility-code],
--		UPPER(CPL.NameTransmitted) AS [subscriber!3!plan-name],
		UPPER(SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ICP.PlanName,'+',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' '),1,35)) AS [subscriber!3!plan-name],
		CASE WHEN IC.InsuranceProgramCode = 'MB' AND RPI.RealPrecedence > 1 THEN '12' ELSE '' END AS [subscriber!3!insurance-type-code],
		CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' ELSE UPPER(PI.GroupNumber) END AS [subscriber!3!group-number],
		CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' ELSE UPPER(PI.PolicyNumber) END AS [subscriber!3!policy-number],
		CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' ELSE UPPER(CPL.NameTransmitted) END AS [subscriber!3!payer-name],
		'PI' AS [subscriber!3!payer-identifier-qualifier],				-- 'PI' for clearinghouse ID or 'XV' for NPI
		CASE WHEN RPI.RealPrecedence is NULL THEN 'ERROR' ELSE UPPER(CPL.PayerNumber) END AS [subscriber!3!payer-identifier],
		UPPER(ICP.AddressLine1) AS [subscriber!3!payer-street-1],
		UPPER(ICP.AddressLine2) AS [subscriber!3!payer-street-2],
		UPPER(ICP.City) AS [subscriber!3!payer-city],
		UPPER(ICP.State) AS [subscriber!3!payer-state],
		ICP.ZipCode AS [subscriber!3!payer-zip],
		CASE WHEN ICP.Country LIKE 'CA%' THEN 'CA' ELSE NULL END AS [subscriber!3!payer-country],
		@loop2010BB2U AS [subscriber!3!payer-secondary-id],
		P.ResponsibleDifferentThanPatient
			AS [subscriber!3!responsible-different-than-patient-flag],
		UPPER(P.ResponsibleFirstName) 
			AS [subscriber!3!responsible-first-name],
		UPPER(P.ResponsibleMiddleName) 
			AS [subscriber!3!responsible-middle-name],
		UPPER(P.ResponsibleLastName) 
			AS [subscriber!3!responsible-last-name],
		UPPER(P.ResponsibleSuffix) AS [subscriber!3!responsible-suffix],
		UPPER(P.ResponsibleAddressLine1)
			AS [subscriber!3!responsible-street-1],
		UPPER(P.ResponsibleAddressLine2)
			AS [subscriber!3!responsible-street-2],
		UPPER(P.ResponsibleCity) AS [subscriber!3!responsible-city],
		UPPER(P.ResponsibleState) AS [subscriber!3!responsible-state],
		P.ResponsibleZipCode AS [subscriber!3!responsible-zip],
		CASE WHEN P.ResponsibleCountry LIKE 'CA%' THEN 'CA' ELSE NULL END AS [subscriber!3!responsible-country],
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
		NULL AS [claim!2300!supervising-provider-ssn-qual],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-upin],
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
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL AS [claim!2300!ambulance-address-pickup],
		NULL AS [claim!2300!ambulance-address-dropoff],
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
		NULL AS [otherpayercob!2320!insurance-policy-id],
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
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
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
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

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
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
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
		NULL AS [claim!2300!supervising-provider-ssn-qual],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-upin],
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
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL AS [claim!2300!ambulance-address-pickup],
		NULL AS [claim!2300!ambulance-address-dropoff],
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
		NULL AS [otherpayercob!2320!insurance-policy-id],
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
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
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
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

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
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
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
		'B' -- E.ReleaseSignatureSourceCode 
			AS [claim!2300!patient-signature-source-code],
		PC.AutoAccidentRelatedFlag
			AS [claim!2300!auto-accident-related-flag],
		PC.AbuseRelatedFlag AS [claim!2300!abuse-related-flag],
		PC.PregnancyRelatedFlag AS [claim!2300!pregnancy-related-flag],
		PC.EmploymentRelatedFlag AS [claim!2300!employment-related-flag],
		PC.OtherAccidentRelatedFlag 
			AS [claim!2300!other-accident-related-flag],
		PC.AutoAccidentRelatedState AS [claim!2300!auto-accident-state],
		CASE WHEN PC.EPSDT = 1 THEN '01' ELSE NULL END AS [claim!2300!special-program-code],					-- PC.SpecialProgramCode
		@InitialTreatmentDate AS [claim!2300!initial-treatment-date],
		@LastMenstrualDate AS [claim!2300!last-menstrual-date],
		@ReferralDate AS [claim!2300!referral-date],
		@LastSeenDate AS [claim!2300!last-seen-date], 
			-- per fb 22680, if employment-related, don't put out current-illness-date since that generates a DTP*431
		(CASE WHEN (PC.EmploymentRelatedFlag <> 0) 
			THEN NULL ELSE @DateOfInjury 
			END) AS [claim!2300!current-illness-date],
		@AcuteManifestationDate AS [claim!2300!acute-manifestation-date],
		@DateOfSimilarInjury AS [claim!2300!similar-illness-date],
			-- per fb 22680, if employment-related, also put out accident-date since that generates a DTP*439
		(CASE WHEN (PC.AutoAccidentRelatedFlag <> 0 OR PC.OtherAccidentRelatedFlag <> 0 OR PC.EmploymentRelatedFlag <> 0) 
			THEN @DateOfInjury ELSE NULL 
			END) AS [claim!2300!accident-date],
		@LastXrayDate AS [claim!2300!last-xray-date],
		@DisabilityStartDate AS [claim!2300!disability-begin-date],
		@DisabilityEndDate AS [claim!2300!disability-end-date],
		@UnableToWorkStartDate AS [claim!2300!last-worked-date],
		@UnableToWorkEndDate AS [claim!2300!return-to-work-date],
		COALESCE(E.HospitalizationStartDT, @HospitalizationStartDate) AS [claim!2300!hospitalization-begin-date],
		COALESCE(E.HospitalizationEndDT, @HospitalizationEndDate) AS [claim!2300!hospitalization-end-date],
		(CASE WHEN @hide_patient_paid_amount = 0 THEN E.AmountPaid ELSE NULL END) AS [claim!2300!patient-paid-amount],	-- RC.PatientPaidAmount
		UPPER(A.AuthorizationNumber) AS [claim!2300!authorization-number],
		@ReferralNumber AS [claim!2300!referral-number],
		-- list of diagnostic codes:
		(CASE WHEN (@DiagnosisCode1 IS NOT NULL) THEN UPPER(@DiagnosisCode1) ELSE NULL END) AS [claim!2300!diagnosis-1],
		(CASE WHEN (@DiagnosisCode2 IS NOT NULL) THEN UPPER(@DiagnosisCode2) ELSE NULL END) AS [claim!2300!diagnosis-2],
		(CASE WHEN (@DiagnosisCode3 IS NOT NULL) THEN UPPER(@DiagnosisCode3) ELSE NULL END) AS [claim!2300!diagnosis-3],
		(CASE WHEN (@DiagnosisCode4 IS NOT NULL) THEN UPPER(@DiagnosisCode4) ELSE NULL END) AS [claim!2300!diagnosis-4],
		(CASE WHEN (@DiagnosisCode5 IS NOT NULL) THEN UPPER(@DiagnosisCode5) ELSE NULL END) AS [claim!2300!diagnosis-5],
		(CASE WHEN (@DiagnosisCode6 IS NOT NULL) THEN UPPER(@DiagnosisCode6) ELSE NULL END) AS [claim!2300!diagnosis-6],
		(CASE WHEN (@DiagnosisCode7 IS NOT NULL) THEN UPPER(@DiagnosisCode7) ELSE NULL END) AS [claim!2300!diagnosis-7],
		(CASE WHEN (@DiagnosisCode8 IS NOT NULL) THEN UPPER(@DiagnosisCode8) ELSE NULL END) AS [claim!2300!diagnosis-8],
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
			ELSE UPPER(ISNULL(UPIN.ProviderNumber, '')) 
		END) AS [claim!2300!referring-provider-upin],
		CASE @doNPI WHEN 1 THEN RP.NPI ELSE NULL END AS [claim!2300!referring-provider-npi],

		CAST((CASE WHEN (SD.DoctorID IS NOT NULL) THEN 1 ELSE 0 END) AS BIT) AS [claim!2300!supervising-provider-flag],
		UPPER(SD.FirstName) AS [claim!2300!supervising-provider-first-name],
		UPPER(SD.MiddleName) AS [claim!2300!supervising-provider-middle-name],
		UPPER(SD.LastName) AS [claim!2300!supervising-provider-last-name],
		UPPER(SD.Suffix) AS [claim!2300!supervising-provider-suffix],
		'34' AS [claim!2300!supervising-provider-ssn-qual],
		UPPER(SD.SSN) AS [claim!2300!supervising-provider-ssn],
		UPPER(@SupervisingProviderUpin) AS [claim!2300!supervising-provider-upin],
		CASE @doNPI WHEN 1 THEN SD.NPI ELSE NULL END AS [claim!2300!supervising-provider-npi],
		@SupervisingProviderIdQualifier AS [claim!2300!supervising-provider-id-qualifier],
		@SupervisingProviderIdNumber AS [claim!2300!supervising-provider-id-number],

		UPPER(D.FirstName) AS [claim!2300!rendering-provider-first-name],
		UPPER(D.MiddleName) AS [claim!2300!rendering-provider-middle-name],
		UPPER(D.LastName) AS [claim!2300!rendering-provider-last-name],
		UPPER(D.Suffix) AS [claim!2300!rendering-provider-suffix],
		@loop2310Bqual AS [claim!2300!rendering-provider-ssn-qual],
		UPPER(ISNULL(@loop2310Btaxid, D.SSN)) AS [claim!2300!rendering-provider-ssn],
		NULL AS [claim!2300!rendering-provider-upin],
		-- UPPER(D.UPIN) AS [claim!2300!rendering-provider-upin],
		CASE @doNPI WHEN 1 THEN D.NPI ELSE NULL END AS [claim!2300!rendering-provider-npi],
		UPPER(D.TaxonomyCode) 
			AS [claim!2300!rendering-provider-specialty-code],
		UPPER(L.BillingName) AS [claim!2300!service-facility-name],
		UPPER(L.AddressLine1) AS [claim!2300!service-facility-street-1],
		UPPER(L.AddressLine2) AS [claim!2300!service-facility-street-2],
		UPPER(L.City) AS [claim!2300!service-facility-city],
		UPPER(L.State) AS [claim!2300!service-facility-state],
		L.ZipCode AS [claim!2300!service-facility-zip],
		CASE WHEN L.Country LIKE 'CA%' THEN 'CA' ELSE NULL END AS [claim!2300!service-facility-country],
		CASE WHEN @needFacilityId <> 1 OR @ServiceFacilityIdQualifier IS NULL THEN NULL ELSE L.HCFABox32FacilityID END AS [claim!2300!service-facility-id],
		CASE WHEN @needFacilityId <> 1 OR L.HCFABox32FacilityID IS NULL THEN NULL ELSE @ServiceFacilityIdQualifier END AS [claim!2300!service-facility-id-qualifier],
		CASE @doNPI WHEN 1 THEN L.NPI ELSE NULL END AS [claim!2300!service-facility-npi],
		CASE WHEN E.EDIClaimNoteReferenceCode IN ('ADD','CER','DCP','DGN','PMT','TPO') AND LEN(E.EDIClaimNote) > 0 THEN E.EDIClaimNoteReferenceCode ELSE NULL END AS [claim!2300!claim-note-code],
		CASE WHEN E.EDIClaimNoteReferenceCode IN ('ADD','CER','DCP','DGN','PMT','TPO') AND LEN(E.EDIClaimNote) > 0 THEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(E.EDIClaimNote,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) ELSE NULL END AS [claim!2300!claim-note],
		CASE WHEN ATI.TransportRecordId IS NULL THEN 0 ELSE 1 END AS [claim!2300!ambulance-transport-flag],
		CASE WHEN ATI.Weight IS NULL THEN NULL ELSE CAST(ATI.Weight AS varchar(30)) END AS [claim!2300!ambulance-patient-weight],
		ATI.AmbulanceTransportCode AS [claim!2300!ambulance-code],
		ATI.AmbulanceTransportReasonCode AS [claim!2300!ambulance-reason-code],
		ATI.Miles AS [claim!2300!ambulance-distance],
		UPPER(ATI.PickUp) AS [claim!2300!ambulance-address-pickup],
		UPPER(ATI.DropOff) AS [claim!2300!ambulance-address-dropoff],
		UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ATI.RoundTripPurposeDescription,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) AS [claim!2300!ambulance-purpose-roundtrip],
		UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ATI.StretcherPurposeDescription,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) AS [claim!2300!ambulance-purpose-stretcher],
		ACI1.AmbulanceCertificationCode AS [claim!2300!ambulance-condition-1],
		ACI2.AmbulanceCertificationCode AS [claim!2300!ambulance-condition-2],
		ACI3.AmbulanceCertificationCode AS [claim!2300!ambulance-condition-3],
		ACI4.AmbulanceCertificationCode AS [claim!2300!ambulance-condition-4],
		ACI5.AmbulanceCertificationCode AS [claim!2300!ambulance-condition-5],
		CASE WHEN PC.EPSDT = 0 OR PC.EPSDTCodeID IS NULL THEN NULL WHEN PC.EPSDTCodeID = 1 THEN 'N' ELSE 'Y' END AS [claim!2300!epsdt-referral-given],
		CASE WHEN PC.EPSDT = 0 OR PC.EPSDTCodeID IS NULL THEN NULL ELSE EPSDTC.Code END AS [claim!2300!epsdt-referral-condition-1],
		NULL AS [claim!2300!epsdt-referral-condition-2],
		NULL AS [claim!2300!epsdt-referral-condition-3],
		NULL AS [otherpayercob!2320!insurance-policy-id],
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
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
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
		LEFT OUTER JOIN ProviderNumber UPIN
			ON UPIN.DoctorID = RP.DoctorID
			AND UPIN.ProviderNumberTypeID = 25
 		LEFT OUTER JOIN InsurancePolicyAuthorization A
 			ON E.InsurancePolicyAuthorizationID = A.InsurancePolicyAuthorizationID
 		LEFT OUTER JOIN PracticeToInsuranceCompany PTIC
 			ON RC.PracticeID = PTIC.PracticeID AND PTIC.InsuranceCompanyID = @InsuranceCompanyID
		LEFT OUTER JOIN EPSDTCode EPSDTC
			ON PC.EPSDTCodeID = EPSDTC.EPSDTCodeID

	WHERE	RC.ClaimID = @RepresentativeClaimID
	-- END OF CLAIM INFORMATION - loop 2300 CLM


	UNION ALL

	-- SUBSCRIBER LEVEL - LOOP 2320 - COB Other Payer
	SELECT	2320, 2300,
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
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

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
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
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
		NULL AS [claim!2300!supervising-provider-ssn-qual],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-upin],
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
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL AS [claim!2300!ambulance-address-pickup],
		NULL AS [claim!2300!ambulance-address-dropoff],
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
		COBOS.InsurancePolicyID
			AS [otherpayercob!2320!insurance-policy-id],
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
		COBOS.[payer-identifier]
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
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
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
	SELECT 2400, 2300,
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
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

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
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
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
		NULL AS [claim!2300!supervising-provider-ssn-qual],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-upin],
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
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL AS [claim!2300!ambulance-address-pickup],
		NULL AS [claim!2300!ambulance-address-dropoff],
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
		NULL AS [otherpayercob!2320!insurance-policy-id],
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
		C.ClaimID AS [service!2400!service-id],
		-- [service!2400!control-number] no more than 20 chars. Must differ from [claim!2300!control-number]:
		'S' + CONVERT(VARCHAR,@customer_id) + 'K' + CONVERT(VARCHAR,BC.ClaimID) + 'K9'
--		'S' + CONVERT(VARCHAR,BC.ClaimID) + 'Z' + CONVERT(VARCHAR,@customer_id)		-- case 18103, 14068
			AS [service!2400!control-number],
		UPPER(ISNULL(CASE WHEN LEN(PCD.BillableCode)=0 THEN NULL ELSE PCD.BillableCode END,PCD.ProcedureCode)) AS [service!2400!procedure-code],
		EP.ProcedureDateOfService AS [service!2400!service-date],
		EP.ServiceEndDate AS [service!2400!service-date-end],
--		dbo.BusinessRule_ClaimAdjustedChargeAmount(C.ClaimID) AS [service!2400!service-charge-amount],
--		[dbo].[fn_RoundUpToPenny]( ISNULL(EP.ServiceUnitCount,1) * ISNULL(EP.ServiceChargeAmount,0) ) AS [service!2400!service-charge-amount],
		dbo.BusinessRule_ClaimOriginalChargeAmount(C.ClaimID) AS [service!2400!service-charge-amount],
		CASE WHEN EP.TypeOfServiceCode = '7' AND EP.AnesthesiaTime > 0 THEN 'MJ' ELSE 'UN' END AS [service!2400!service-units],      -- '7' is Anesthesia
		CASE WHEN EP.TypeOfServiceCode = '7' AND EP.AnesthesiaTime > 0 THEN EP.AnesthesiaTime ELSE EP.ServiceUnitCount END AS [service!2400!service-unit-count],
		E.PlaceOfServiceCode AS [service!2400!place-of-service-code],
		PC.EPSDT AS [service!2400!epsdt-flag],
		PC.FamilyPlanning AS [service!2400!family-planning-flag],
		EP.ProcedureModifier1 AS [service!2400!procedure-modifier-1],
		EP.ProcedureModifier2 AS [service!2400!procedure-modifier-2],
		EP.ProcedureModifier3 AS [service!2400!procedure-modifier-3],
		EP.ProcedureModifier4 AS [service!2400!procedure-modifier-4],

		CASE WHEN DCD.DiagnosisCode IS NOT NULL THEN CBDP.Pointer ELSE NULL END AS [service!2400!diagnosis-pointer-1],
		CASE WHEN DCD2.DiagnosisCode IS NOT NULL THEN CBDP2.Pointer ELSE NULL END AS [service!2400!diagnosis-pointer-2],
		CASE WHEN DCD3.DiagnosisCode IS NOT NULL THEN CBDP3.Pointer ELSE NULL END AS [service!2400!diagnosis-pointer-3],
		CASE WHEN DCD4.DiagnosisCode IS NOT NULL THEN CBDP4.Pointer ELSE NULL END AS [service!2400!diagnosis-pointer-4],

		CASE WHEN EP.TypeOfServiceCode IN ('A','J','P','R') OR EP.TypeOfServiceCode IS NULL AND PCD.TypeOfServiceCode IN ('A','J','P','R') THEN 1 ELSE NULL END AS [service!2400!dme-flag],
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
		CASE WHEN EP.EDIServiceNoteReferenceCode IN ('ADD','DCP','PMT','TPO') AND LEN(EP.EDIServiceNote) > 0 THEN EP.EDIServiceNoteReferenceCode ELSE NULL END AS [service!2400!service-note-code],
		CASE WHEN EP.EDIServiceNoteReferenceCode IN ('ADD','DCP','PMT','TPO') AND LEN(EP.EDIServiceNote) > 0 THEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(EP.EDIServiceNote,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) ELSE NULL END AS [service!2400!service-note],
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

		LEFT JOIN EncounterDiagnosis ED5 ON EP.EncounterDiagnosisID5=ED5.EncounterDiagnosisID
		LEFT JOIN DiagnosisCodeDictionary DCD5
		ON ED5.DiagnosisCodeDictionaryID=DCD5.DiagnosisCodeDictionaryID	
		LEFT JOIN #ClaimBatchDiagnosesPointers CBDP5 ON CBDP5.ClaimID = BC.ClaimID AND DCD5.DiagnosisCode = CBDP5.DiagnosisCode

		LEFT JOIN EncounterDiagnosis ED6 ON EP.EncounterDiagnosisID6=ED6.EncounterDiagnosisID
		LEFT JOIN DiagnosisCodeDictionary DCD6
		ON ED6.DiagnosisCodeDictionaryID=DCD6.DiagnosisCodeDictionaryID	
		LEFT JOIN #ClaimBatchDiagnosesPointers CBDP6 ON CBDP6.ClaimID = BC.ClaimID AND DCD6.DiagnosisCode = CBDP6.DiagnosisCode

		LEFT JOIN EncounterDiagnosis ED7 ON EP.EncounterDiagnosisID7=ED7.EncounterDiagnosisID
		LEFT JOIN DiagnosisCodeDictionary DCD7
		ON ED7.DiagnosisCodeDictionaryID=DCD7.DiagnosisCodeDictionaryID	
		LEFT JOIN #ClaimBatchDiagnosesPointers CBDP7 ON CBDP7.ClaimID = BC.ClaimID AND DCD7.DiagnosisCode = CBDP7.DiagnosisCode

		LEFT JOIN EncounterDiagnosis ED8 ON EP.EncounterDiagnosisID8=ED8.EncounterDiagnosisID
		LEFT JOIN DiagnosisCodeDictionary DCD8
		ON ED8.DiagnosisCodeDictionaryID=DCD8.DiagnosisCodeDictionaryID	
		LEFT JOIN #ClaimBatchDiagnosesPointers CBDP8 ON CBDP8.ClaimID = BC.ClaimID AND DCD8.DiagnosisCode = CBDP8.DiagnosisCode

	WHERE	RC.ClaimID = @RepresentativeClaimID
	-- END OF SERVICE LINE HIERARCHICAL LEVEL

	UNION ALL

	-- RENDERING PROVIDER NUMBERS - INSURANCE PLAN ASSIGNED PROVIDER ID
	-- Rendering provider numbers for REF (Doctor provider numbers, Loop 2310B):
	SELECT DISTINCT	10, 2300,
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
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

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
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
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
		NULL AS [claim!2300!supervising-provider-ssn-qual],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-upin],
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
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL AS [claim!2300!ambulance-address-pickup],
		NULL AS [claim!2300!ambulance-address-dropoff],
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
		NULL AS [otherpayercob!2320!insurance-policy-id],		-- @PayerInsurancePolicyID - the NULL here would break some rare submissions, and any variable may ruin DISTINCT.
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
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
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
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

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
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
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
		NULL AS [claim!2300!supervising-provider-ssn-qual],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-upin],
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
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL AS [claim!2300!ambulance-address-pickup],
		NULL AS [claim!2300!ambulance-address-dropoff],
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
		NULL AS [otherpayercob!2320!insurance-policy-id],		-- @PayerInsurancePolicyID - the NULL here would break some rare submissions, and any variable may ruin DISTINCT.
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
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
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
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

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
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
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
		NULL AS [claim!2300!supervising-provider-ssn-qual],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-upin],
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
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL AS [claim!2300!ambulance-address-pickup],
		NULL AS [claim!2300!ambulance-address-dropoff],
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
		@PayerInsurancePolicyID AS [otherpayercob!2320!insurance-policy-id],
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
		TCSA.ClaimID AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
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
		TCSA.[TID] AS [adjudication!2430!adjudication-id],
		TCOS.[payer-identifier] AS [adjudication!2430!payer-identifier],
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
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

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
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
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
		NULL AS [claim!2300!supervising-provider-ssn-qual],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-upin],
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
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL AS [claim!2300!ambulance-address-pickup],
		NULL AS [claim!2300!ambulance-address-dropoff],
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
		@PayerInsurancePolicyID AS [otherpayercob!2320!insurance-policy-id],
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
		TCSA.ClaimID AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
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
		TCSA.[TID] AS [adjudication!2430!adjudication-id],
		TCOS.[payer-identifier] AS [adjudication!2430!payer-identifier],
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
		NULL AS [transaction!1!submitter-contact-name],
		NULL AS [transaction!1!submitter-contact-phone],
		NULL AS [transaction!1!submitter-contact-email],
		NULL AS [transaction!1!submitter-contact-fax],
		NULL AS [transaction!1!receiver-name],
		NULL AS [transaction!1!receiver-etin],

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
		NULL AS [billing!2!payto-ein],
		NULL AS [billing!2!payto-npi],
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
		NULL AS [claim!2300!supervising-provider-ssn-qual],
		NULL AS [claim!2300!supervising-provider-ssn],
		NULL AS [claim!2300!supervising-provider-upin],
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
		NULL AS [claim!2300!claim-note-code],
		NULL AS [claim!2300!claim-note],
		NULL AS [claim!2300!ambulance-transport-flag],
		NULL AS [claim!2300!ambulance-patient-weight],
		NULL AS [claim!2300!ambulance-code],
		NULL AS [claim!2300!ambulance-reason-code],
		NULL AS [claim!2300!ambulance-distance],
		NULL AS [claim!2300!ambulance-address-pickup],
		NULL AS [claim!2300!ambulance-address-dropoff],
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
		@PayerInsurancePolicyID AS [otherpayercob!2320!insurance-policy-id],
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
		NULL AS [service!2400!service-id],
		NULL AS [service!2400!control-number],
		NULL AS [service!2400!procedure-code],
		NULL AS [service!2400!service-date],
		NULL AS [service!2400!service-date-end],
		NULL AS [service!2400!service-charge-amount],
		NULL AS [service!2400!service-units],
		NULL AS [service!2400!service-unit-count],
		NULL AS [service!2400!place-of-service-code],
		NULL AS [service!2400!epsdt-flag],
		NULL AS [service!2400!family-planning-flag],
		NULL AS [service!2400!procedure-modifier-1],
		NULL AS [service!2400!procedure-modifier-2],
		NULL AS [service!2400!procedure-modifier-3],
		NULL AS [service!2400!procedure-modifier-4],
		NULL AS [service!2400!diagnosis-pointer-1],
		NULL AS [service!2400!diagnosis-pointer-2],
		NULL AS [service!2400!diagnosis-pointer-3],
		NULL AS [service!2400!diagnosis-pointer-4],
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
		[otherpayercob!2320!insurance-policy-id], 
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
