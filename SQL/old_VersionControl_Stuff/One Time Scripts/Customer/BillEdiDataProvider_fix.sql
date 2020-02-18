--===========================================================================
-- 
-- BILL DATA PROVIDER - EDI/XML portion
--
--===========================================================================


IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BillDataProvider_GetEDIBillsForBatch'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.BillDataProvider_GetEDIBillsForBatch
GO

--===========================================================================
-- GET EDI BILL XML
--===========================================================================
CREATE PROCEDURE dbo.BillDataProvider_GetEDIBillsForBatch
	@batch_id INT
AS
BEGIN

	SELECT BillID 
	FROM Bill_EDI BE
	WHERE BE.BillBatchID = @batch_id
	
	RETURN

END
GO

--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BillDataProvider_GetEDIBatchXML'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.BillDataProvider_GetEDIBatchXML
GO

--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BillDataProvider_GetEDIBatchXML1'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.BillDataProvider_GetEDIBatchXML1
GO

--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BillDataProvider_GetEDIBillXML'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.BillDataProvider_GetEDIBillXML
GO


--===========================================================================
-- GET EDI BILL XML
--===========================================================================
CREATE PROCEDURE dbo.BillDataProvider_GetEDIBillXML
	@batch_id INT,
	@bill_id INT
AS
BEGIN

	IF (@bill_id < 1)
	BEGIN
		SELECT TOP 1 @bill_id = BillID FROM Bill_EDI BE ORDER BY BillID DESC
		PRINT @bill_id
	END

	IF (@batch_id < 1)
		SELECT @batch_id = BillBatchID FROM Bill_EDI BE WHERE BillID = @bill_id

	-- some variables that can be overridden for specific payers:
	DECLARE @loop2310Bqual int
	DECLARE @loop2310Btaxid varchar(30)
	SET @loop2310Bqual = 34			-- means SSN, while some payers require TIN with qualifier 24 (case 5477)

	DECLARE @loop2010BB2U varchar(30)	-- case 5492

	-- get values that go into the header from shared DB:
	DECLARE @customer_id INT

	SELECT @customer_id = CustomerID FROM Master..SysDatabases SDB INNER JOIN SysFiles SF 
	ON SDB.FileName=SF.FileName
	INNER JOIN Superbill_Shared..Customer C ON SDB.Name=C.DatabaseName

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

	SELECT  @ClearinghouseConnectionID = C.ClearinghouseConnectionID,
		@ProductionFlag = ProductionFlag,
		@SubmitterEtin = SubmitterEtin
--		@SubmitterContactName = SubmitterContactName,
--		@SubmitterName = SubmitterName,
--		@SubmitterContactPhone = SubmitterContactPhone,
--		@SubmitterContactEmail = SubmitterContactEmail,
--		@SubmitterContactFax = SubmitterContactFax,
--		@ReceiverName = ReceiverName,
--		@ReceiverEtin = ReceiverEtin
	FROM Superbill_Shared..Customer C
		 JOIN Superbill_Shared..ClearinghouseConnection CC ON CC.ClearinghouseConnectionID = C.ClearinghouseConnectionID
	WHERE C.CustomerID = @customer_id

	-- if Clearinghouse Connection is not set up, we return here.
	-- Broker Server knows to throw friendly exception message when empty XML comes out of here:
	IF (@SubmitterEtin IS NULL)
		return;

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

	DECLARE @PracticeID INT
	DECLARE @PatientID INT
	DECLARE @RepresentativeClaimID INT
	DECLARE @RepresentativeEncounterID INT
	DECLARE @LocationID INT
	DECLARE @InsuranceCompanyPlanID INT
	DECLARE @PlanName VARCHAR(256)			-- something like 'Medicare Part B of Arizona' from ICP
	DECLARE @PayerName VARCHAR(256)			-- something like 'MEDICARE ARIZONA' - NameTransmitted from CPL
	DECLARE @PayerNumber VARCHAR(30)		-- something like 'MR049'
	DECLARE @InsuranceProgramCode CHAR(2)		-- something like 'CI' for SBR09
	DECLARE @hide_patient_paid_amount BIT		-- case 8396
	DECLARE @RoutingPreference VARCHAR(500)
	DECLARE @SupervisingProviderID INT		-- doctor ID
	DECLARE @SupervisingProviderIdQualifier CHAR(2)	-- one of G2, 1D, 1B provider number qualifier depends on insurance type 
	DECLARE @SupervisingProviderIdNumber VARCHAR(30)	-- actual provider number
	DECLARE @SupervisingProviderUpin VARCHAR(30)
	DECLARE @ServiceFacilityIdQualifier CHAR(2)

	SET @SupervisingProviderIdQualifier = 'G2'
	SET @hide_patient_paid_amount = 0

	-- SET @RoutingPreference = 'PROXYMED'

	SELECT TOP 1 
		@PracticeID = P.PracticeID,
		@PatientID = P.PatientID,
		@RepresentativeClaimID = B.RepresentativeClaimID,
		@RepresentativeEncounterID = E.EncounterID,
		@LocationID = E.LocationID,
		@InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID,
--		@InsuranceProgramCode = ISNULL(P.InsuranceProgramCode,IC.InsuranceProgramCode),
		@InsuranceProgramCode = IC.InsuranceProgramCode,
		@PlanName = ICP.PlanName,
		@PayerName = CPL.NameTransmitted,
		@PayerNumber = CPL.PayerNumber,
		@SupervisingProviderID = SD.DoctorID,
		@RoutingPreference = CH.RoutingName
	FROM	Bill_EDI B
		INNER JOIN Claim RC
		ON RC.ClaimID = B.RepresentativeClaimID
		INNER JOIN dbo.EncounterProcedure EP
		ON EP.EncounterProcedureID = RC.EncounterProcedureID
		INNER JOIN dbo.Encounter E
			ON E.EncounterID = EP.EncounterID
		LEFT JOIN Doctor SD
			ON SD.DoctorID = E.SupervisingProviderID
		INNER JOIN Patient P
		ON P.PatientID = RC.PatientID
			INNER JOIN InsurancePolicy PI
			ON PI.InsurancePolicyID = B.PayerInsurancePolicyID
			INNER JOIN InsuranceCompanyPlan ICP
				INNER JOIN InsuranceCompany IC 
				ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
				LEFT OUTER JOIN ClearinghousePayersList CPL
				ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID
			ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
		INNER JOIN superbill_shared..Clearinghouse CH
		ON CH.ClearinghouseID = CPL.ClearinghouseID
	WHERE	B.BillID = @bill_id

	-- case 8805: prepare Ordering Provider info for DME bills, if any:

	DECLARE @OPFirstName  VARCHAR(256)
	DECLARE @OPMiddleName  VARCHAR(256)
	DECLARE @OPLastName  VARCHAR(256)
	DECLARE @OPSuffix  VARCHAR(256)
	DECLARE @OPSSNQualifier  CHAR(2)
	DECLARE @OPSSN  VARCHAR(30)
	DECLARE @OPUPIN  VARCHAR(30)
	DECLARE @OPAddressLine1  VARCHAR(256)
	DECLARE @OPAddressLine2  VARCHAR(256)
	DECLARE @OPCity  VARCHAR(256)
	DECLARE @OPState  VARCHAR(256)
	DECLARE @OPZipCode  VARCHAR(30)
	DECLARE @OPPhone  VARCHAR(30)

	SELECT TOP 1 
		@OPFirstName = UPPER(RP.FirstName),
		@OPMiddleName = UPPER(RP.MiddleName),
		@OPLastName = UPPER(RP.LastName),
		@OPSuffix = UPPER(RP.Suffix),
		@OPSSNQualifier = '24',
		@OPSSN = ISNULL(CASE WHEN LEN(RP.SSN) > 0 THEN RP.SSN ELSE NULL END,'999999999'),
		@OPUPIN = UPPER(COALESCE(UPIN.ProviderNumber, '')),
		@OPAddressLine1 = UPPER(RP.AddressLine1),
		@OPAddressLine2 = UPPER(RP.AddressLine2),
		@OPCity = UPPER(RP.City),
		@OPState = UPPER(RP.State),
		@OPZipCode = RP.ZipCode,
		@OPPhone = RP.WorkPhone
	FROM	Claim RC
		INNER JOIN dbo.EncounterProcedure EP
			ON EP.EncounterProcedureID = RC.EncounterProcedureID
		INNER JOIN dbo.Encounter E
			ON E.EncounterID = EP.EncounterID
		INNER JOIN PatientCase PC
			ON PC.PatientCaseID = E.PatientCaseID
		LEFT OUTER JOIN Doctor RP
			ON RP.DoctorID = E.ReferringPhysicianID
		LEFT OUTER JOIN ProviderNumber UPIN
			ON UPIN.DoctorID = RP.DoctorID
			AND UPIN.ProviderNumberTypeID = 25
	WHERE	RC.ClaimID = @RepresentativeClaimID

	-- case 8560 - get Ambulance Certification codes for the encounter:

	DECLARE @t_ambulancecertification Table(TID int identity(1,1), AmbulanceCertificationCode char(2))

	INSERT INTO @t_ambulancecertification
	SELECT TOP 5
		ACI.AmbulanceCertificationCode
	FROM	Claim RC
		INNER JOIN dbo.EncounterProcedure EP
			ON EP.EncounterProcedureID = RC.EncounterProcedureID
		INNER JOIN dbo.Encounter E
			ON E.EncounterID = EP.EncounterID
		INNER JOIN AmbulanceCertificationInformation ACI
			ON E.EncounterID = ACI.EncounterID
	WHERE	RC.ClaimID = @RepresentativeClaimID
	ORDER BY ACI.AmbulanceCertificationCode

	-- get those group numbers into a temp table so that tweaking them is easy. They are sorted and duplicates removed:

	DECLARE @t_groupnumbers Table(TID int identity(1,1),
		 ANSIReferenceIdentificationQualifier varchar(10),
		 GroupNumber varchar(50),
		 LocationID int,
		 InsuranceCompanyPlanID int)

	INSERT INTO @t_groupnumbers (ANSIReferenceIdentificationQualifier, GroupNumber, LocationID, InsuranceCompanyPlanID)
		SELECT GNT.ANSIReferenceIdentificationQualifier, PIGN.GroupNumber, PIGN.LocationID, PIGN.InsuranceCompanyPlanID
		FROM	PracticeInsuranceGroupNumber PIGN
			INNER JOIN GroupNumberType GNT
			ON GNT.GroupNumberTypeID = PIGN.GroupNumberTypeID
		WHERE	PIGN.PracticeID = @PracticeID
			AND PIGN.AttachConditionsTypeID IN (1, 3)
			AND (
			     PIGN.InsuranceCompanyPlanID IS NULL
				 OR
			     PIGN.InsuranceCompanyPlanID = @InsuranceCompanyPlanID
			)
			-- loop 2010AA, page 92 of 837.pdf:
			AND GNT.ANSIReferenceIdentificationQualifier IN
				('0B','1A','1B','1C','1D','1G','1H','1J','B3','BQ','EI','FH','G2','G5','LU','SY','U3','X5','SN','SM','RN','RM')
			AND (PIGN.LocationID IS NULL OR PIGN.LocationID = @LocationID)
		ORDER BY ANSIReferenceIdentificationQualifier, InsuranceCompanyPlanID DESC, LocationID DESC

	DELETE @t_groupnumbers
	FROM @t_groupnumbers TN LEFT JOIN
	 (SELECT ANSIReferenceIdentificationQualifier, MIN(TID) TID
	  FROM @t_groupnumbers GROUP BY ANSIReferenceIdentificationQualifier) FilteredTN 
	  ON TN.TID=FilteredTN.TID
	  WHERE FilteredTN.TID IS NULL

	DECLARE @SubmitterNameOverride VARCHAR(100)
	DECLARE @SubmitterEtinOverride VARCHAR(100)
	DECLARE @ReceiverNameOverride VARCHAR(100)
	DECLARE @ReceiverEtinOverride VARCHAR(100)
	
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

	-- same way, get individual provider numbers into a temp table so that tweaking them is easy. Also sorted and duplicates removed:

	DECLARE @t_providernumbers Table(TID int identity(1,1),
		 ANSIReferenceIdentificationQualifier varchar(10),
		 ProviderNumber varchar(50),
		 LocationID int,
		 InsuranceCompanyPlanID int,
		 PayerInsurancePolicyID int,
		 ProviderNumberID int
		 )

	INSERT INTO @t_providernumbers (ANSIReferenceIdentificationQualifier, ProviderNumber, LocationID, InsuranceCompanyPlanID, PayerInsurancePolicyID, ProviderNumberID)
		SELECT PNT.ANSIReferenceIdentificationQualifier, PN.ProviderNumber, PN.LocationID, PN.InsuranceCompanyPlanID, B.PayerInsurancePolicyID, PN.ProviderNumberID
		FROM	Bill_EDI B
			INNER JOIN Claim RC
			ON RC.ClaimID = B.RepresentativeClaimID
			INNER JOIN dbo.EncounterProcedure EP
			ON EP.EncounterProcedureID = RC.EncounterProcedureID
			INNER JOIN dbo.Encounter E
			ON E.EncounterID = EP.EncounterID
			INNER JOIN InsurancePolicy PI
			ON PI.InsurancePolicyID = B.PayerInsurancePolicyID
			INNER JOIN InsuranceCompanyPlan ICP
			ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
			INNER JOIN Doctor D
			ON D.DoctorID = E.DoctorID
			INNER JOIN ProviderNumber PN
			ON PN.DoctorID = D.DoctorID 
			INNER JOIN ProviderNumberType PNT
			ON PN.ProviderNumberTypeID = PNT.ProviderNumberTypeID
		WHERE	B.BillID = @bill_id
			AND PN.AttachConditionsTypeID IN (1, 3)
			-- loop 2310B, pages 296-297 of 837.pdf:
			AND  PNT.ANSIReferenceIdentificationQualifier IN ('0B','1B','1C','1D','1G','1H','G2','EI','LU','N5','SY','X5','Z0','Z1','G5','U3')
			AND (PN.InsuranceCompanyPlanID IS NULL OR PN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
			AND (PN.LocationID IS NULL OR PN.LocationID = E.LocationID)
		ORDER BY PNT.ANSIReferenceIdentificationQualifier, PN.InsuranceCompanyPlanID DESC, PN.LocationID DESC
	
	DELETE @t_providernumbers
	FROM @t_providernumbers TN LEFT JOIN
	 (SELECT ANSIReferenceIdentificationQualifier, MIN(TID) TID
	  FROM @t_providernumbers GROUP BY ANSIReferenceIdentificationQualifier) FilteredTN 
	  ON TN.TID=FilteredTN.TID
	  WHERE FilteredTN.TID IS NULL

	-- same way, get referring provider numbers into a temp table so that tweaking them is easy. Also sorted and duplicates removed:

	DECLARE @t_refprovidernumbers Table(TID int identity(1,1),
		 ANSIReferenceIdentificationQualifier varchar(10),
		 ProviderNumber varchar(50),
		 LocationID int,
		 InsuranceCompanyPlanID int,
		 PayerInsurancePolicyID int,
		 ProviderNumberID int
		 )

	INSERT INTO @t_refprovidernumbers (ANSIReferenceIdentificationQualifier, ProviderNumber, LocationID, InsuranceCompanyPlanID, PayerInsurancePolicyID, ProviderNumberID)
		SELECT PNT.ANSIReferenceIdentificationQualifier, PN.ProviderNumber, PN.LocationID, PN.InsuranceCompanyPlanID, B.PayerInsurancePolicyID, PN.ProviderNumberID
		FROM	Bill_EDI B
			INNER JOIN Claim RC
			ON RC.ClaimID = B.RepresentativeClaimID
			INNER JOIN dbo.EncounterProcedure EP
			ON EP.EncounterProcedureID = RC.EncounterProcedureID
			INNER JOIN dbo.Encounter E
			ON E.EncounterID = EP.EncounterID
			INNER JOIN InsurancePolicy PI
			ON PI.InsurancePolicyID = B.PayerInsurancePolicyID
			INNER JOIN InsuranceCompanyPlan ICP
			ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
			INNER JOIN Doctor D
			ON D.DoctorID = E.ReferringPhysicianID
			INNER JOIN ProviderNumber PN
			ON PN.DoctorID = D.DoctorID 
			INNER JOIN ProviderNumberType PNT
			ON PN.ProviderNumberTypeID = PNT.ProviderNumberTypeID
		WHERE	B.BillID = @bill_id
			AND PN.AttachConditionsTypeID IN (1, 3)
			-- loop 2310B, pages 296-297 of 837.pdf:
			AND  PNT.ANSIReferenceIdentificationQualifier IN ('0B','1B','1C','1D','1G','1H','EI','G2','LU','N5','SY','X5')
			AND (PN.InsuranceCompanyPlanID IS NULL OR PN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
			AND (PN.LocationID IS NULL OR PN.LocationID = E.LocationID)
		ORDER BY PNT.ANSIReferenceIdentificationQualifier, PN.InsuranceCompanyPlanID DESC, PN.LocationID DESC

	DELETE @t_refprovidernumbers
	FROM @t_refprovidernumbers TN LEFT JOIN
	 (SELECT ANSIReferenceIdentificationQualifier, MIN(TID) TID
	  FROM @t_refprovidernumbers GROUP BY ANSIReferenceIdentificationQualifier) FilteredTN 
	  ON TN.TID=FilteredTN.TID
	  WHERE FilteredTN.TID IS NULL

	------------------------------------------------------------------------------------------------------
	-- do whatever is needed to accommodate payer-specific requirements for this envelope:

	-- case 5620:
	IF (@PayerNumber = 'BS029')
 	    DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier = '1G'

	-- case 5498:
	IF (@PayerNumber LIKE 'BS%')
		DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier IN  ('1C', '1D', '1H') 

	IF (@PayerNumber LIKE 'MR%')
		DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier IN  ('1B', '1D', '1H') 

	-- case 5477, 6039, and also RoguePayers list for Noridian payers:
	IF (@PayerNumber IN ('MR034', 'MR036', 'MR084', 'MR083', 'MR004', 'MR074', 'MR006', 'MR010', 'MR011', 'MR008', 'MR007', 'MR057', 'BS074', 'BS057', 'MC026', 'BS003'))
	BEGIN
		SET @loop2310Bqual = 24
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

	IF (@PayerNumber LIKE 'MB%')
	BEGIN
	    SET @SupervisingProviderIdQualifier = '1C'
	END

	-- case 8396:
	IF (@PayerNumber IN ('MC010','MR025'))
 	    SET @hide_patient_paid_amount = 1

	-- case 8114:
	IF (@PayerNumber IN ('MC051'))
	BEGIN
		SET @ServiceFacilityIdQualifier = '1D'		-- also flags that ID is needed
	END


	------------------------------------------------------------------------------------------------------
	-- case 7799 - same way, get individual provider numbers for a Supervising Provider into a temp table. Also sorted and duplicates removed:

	DECLARE @t_supprovidernumbers Table(TID int identity(1,1),
		 ANSIReferenceIdentificationQualifier varchar(10),
		 ProviderNumber varchar(50),
		 LocationID int,
		 InsuranceCompanyPlanID int,
		 PayerInsurancePolicyID int,
		 ProviderNumberID int
		 )

	IF (@SupervisingProviderID IS NOT NULL)
	BEGIN
	    INSERT INTO @t_supprovidernumbers (ANSIReferenceIdentificationQualifier, ProviderNumber, LocationID, InsuranceCompanyPlanID, PayerInsurancePolicyID, ProviderNumberID)
		SELECT PNT.ANSIReferenceIdentificationQualifier, PN.ProviderNumber, PN.LocationID, PN.InsuranceCompanyPlanID, B.PayerInsurancePolicyID, PN.ProviderNumberID
		FROM	Bill_EDI B
			INNER JOIN Claim RC
			ON RC.ClaimID = B.RepresentativeClaimID
			INNER JOIN dbo.EncounterProcedure EP
			ON EP.EncounterProcedureID = RC.EncounterProcedureID
			INNER JOIN dbo.Encounter E
			ON E.EncounterID = EP.EncounterID
			INNER JOIN InsurancePolicy PI
			ON PI.InsurancePolicyID = B.PayerInsurancePolicyID
			INNER JOIN InsuranceCompanyPlan ICP
			ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
			INNER JOIN Doctor SD
			ON SD.DoctorID = E.SupervisingProviderID
			INNER JOIN ProviderNumber PN
			ON PN.DoctorID = SD.DoctorID
			INNER JOIN ProviderNumberType PNT
			ON PN.ProviderNumberTypeID = PNT.ProviderNumberTypeID
		WHERE	B.BillID = @bill_id
			AND PN.AttachConditionsTypeID IN (1, 3)
			-- loop 2310B, pages 296-297 of 837.pdf:
			AND  PNT.ANSIReferenceIdentificationQualifier IN ('0B','1B','1C','1D','1G','1H','G2','EI','LU','N5','SY','X5','G5')
			AND (PN.InsuranceCompanyPlanID IS NULL OR PN.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID)
			AND (PN.LocationID IS NULL OR PN.LocationID = E.LocationID)
		ORDER BY PNT.ANSIReferenceIdentificationQualifier, PN.InsuranceCompanyPlanID DESC, PN.LocationID DESC
	
	    DELETE @t_supprovidernumbers
	    FROM @t_supprovidernumbers TN LEFT JOIN
		 (SELECT ANSIReferenceIdentificationQualifier, MIN(TID) TID
		  FROM @t_supprovidernumbers GROUP BY ANSIReferenceIdentificationQualifier) FilteredTN 
		  ON TN.TID=FilteredTN.TID
		  WHERE FilteredTN.TID IS NULL

	    SELECT TOP 1 @SupervisingProviderIdNumber = ProviderNumber
	    FROM @t_supprovidernumbers WHERE 
		 ANSIReferenceIdentificationQualifier = @SupervisingProviderIdQualifier

	    SELECT TOP 1 @SupervisingProviderUpin = ProviderNumber
	    FROM @t_supprovidernumbers WHERE 
		 ANSIReferenceIdentificationQualifier = '1G'

	END


	------------------------------------------------------------------------------------------------------
	-- individual billers supply PRV in loop 2000A and do not have Loop 2310B:
	-- (case 6018):

	DECLARE @IndBillerYesNo VARCHAR(256)	-- 'yes' or 'no'
	DECLARE @IndBillerSSN VARCHAR(32)	-- for qualifier 34
	DECLARE @IndBillerEIN VARCHAR(32)	-- for qualifier 24
	DECLARE @IndBillerQual VARCHAR(2)	-- actual qualifier 24 or 34
	DECLARE @BillerType VARCHAR(1)		-- biller type for loop  2010AA, 1(indiv) or 2(group)
	DECLARE @GroupBillerUsesEIN VARCHAR(32)	-- force qualifier 24 for loop 2310B

	SET @BillerType = '2'		-- default is group
	SET @IndBillerQual = '24'	-- default is EIN

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
	IF (@IndBillerYesNo IS NULL OR @IndBillerYesNo <> 'yes')
	BEGIN
		DECLARE @groupNumbersCount INT
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

	IF (@IndBillerYesNo IS NOT NULL AND @IndBillerYesNo = 'yes')
	BEGIN
		-- we are billing for individual provider, loops 2000, 2010AA and 2310BB are affected

		SET @BillerType = '1'

		SELECT 	@IndBillerSSN = ProviderNumber FROM @t_providernumbers
			 WHERE ANSIReferenceIdentificationQualifier = 'Z1' AND ProviderNumber <> 'EI'
	
		IF (@IndBillerSSN IS NOT NULL )
		BEGIN
			SET @IndBillerQual = '34'		-- indicated that SSN is used here
			SET @IndBillerEIN = @IndBillerSSN
		END

		-- group numbers don't matter any more, we need individual numbers instead:
		DELETE @t_groupnumbers

		INSERT INTO @t_groupnumbers (ANSIReferenceIdentificationQualifier, GroupNumber, LocationID, InsuranceCompanyPlanID)
			SELECT ANSIReferenceIdentificationQualifier, ProviderNumber, LocationID, InsuranceCompanyPlanID
			FROM	@t_providernumbers

	END
	ELSE
	BEGIN
		-- if requested, force using EIN instead of SSN for loop 2310B:
		SELECT 	@GroupBillerUsesEIN = ProviderNumber FROM @t_providernumbers
			 WHERE ANSIReferenceIdentificationQualifier = 'Z1' AND ProviderNumber = 'EI'

		IF (@GroupBillerUsesEIN IS NOT NULL)
		BEGIN
			-- similar block is used above for Noridians:
			SET @loop2310Bqual = 24
			SELECT 	@loop2310Btaxid = ProviderNumber FROM @t_providernumbers WHERE ANSIReferenceIdentificationQualifier = 'EI'
		END
	END

	-- @IndBillerEIN can be still NULL here, if no Practice EIN override is intended

	DELETE @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier IN  ('Z0', 'Z1') 
	DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier IN  ('Z0', 'Z1') 
	IF (@PayerNumber <> 'BS028')
	BEGIN
	    DELETE @t_groupnumbers WHERE ANSIReferenceIdentificationQualifier IN  ('EI') 
	    DELETE @t_providernumbers WHERE ANSIReferenceIdentificationQualifier IN  ('EI') 
	END

	------------------------------------------------------------------------------------------------------

	-- list all claims in the bill:
	SELECT C.ClaimID
	INTO #ClaimBatch
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
	SELECT
		CB.ClaimID, DiagnosisCode, ED.ListSequence
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
	SELECT * INTO #ClaimBatchDiagnoses1 FROM #ClaimBatchDiagnoses ORDER BY ListSequence, ClaimID

	CREATE TABLE #BatchDiagnoses(
		DiagnosisCode varchar(64),
		RID int IDENTITY(1,1)
	)

	-- make the list of diag codes:
	INSERT INTO #BatchDiagnoses (DiagnosisCode)
	SELECT DISTINCT DiagnosisCode FROM #ClaimBatchDiagnoses1

	--SELECT * FROM #BatchDiagnoses

	-- here is final pointers temp table - claim, diag, pointer:
	SELECT DISTINCT	CBD.ClaimID, CBD.DiagnosisCode, BD.RID AS Pointer INTO #ClaimBatchDiagnosesPointers FROM #ClaimBatchDiagnoses CBD JOIN #BatchDiagnoses BD ON  BD.DiagnosisCode = CBD.DiagnosisCode

	DROP TABLE #ClaimBatchDiagnoses
	DROP TABLE #ClaimBatchDiagnoses1

	-- prepare all diag codes we need for all service lines involved:
	DECLARE @DiagnosisCode1 VARCHAR(32)
	SELECT  @DiagnosisCode1 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 1

	DECLARE @DiagnosisCode2 VARCHAR(32)
	SELECT  @DiagnosisCode2 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 2

	DECLARE @DiagnosisCode3 VARCHAR(32)
	SELECT  @DiagnosisCode3 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 3

	DECLARE @DiagnosisCode4 VARCHAR(32)
	SELECT  @DiagnosisCode4 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 4

	DECLARE @DiagnosisCode5 VARCHAR(32)
	SELECT  @DiagnosisCode5 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 5

	DECLARE @DiagnosisCode6 VARCHAR(32)
	SELECT  @DiagnosisCode6 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 6

	DECLARE @DiagnosisCode7 VARCHAR(32)
	SELECT  @DiagnosisCode7 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 7

	DECLARE @DiagnosisCode8 VARCHAR(32)
	SELECT  @DiagnosisCode8 = DiagnosisCode FROM #BatchDiagnoses WHERE RID = 8

	DROP TABLE #BatchDiagnoses

	------------------------------------------------------------------------------------------------------
	-- take care of CLIA number for loop 2300 - case 7531:

	DECLARE @CliaNumber VARCHAR(100)

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
	WHERE	PCD.TypeOfServiceCode = '5'

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
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],

		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],

		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-ein],

		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],

		NULL AS [subscriber!3!subscriber-id],
		NULL AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
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
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
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
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!pregnancy-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!last-menstrual-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!referral-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!clia-number],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!supervising-provider-flag],
		NULL AS [claim!5!supervising-provider-first-name],
		NULL AS [claim!5!supervising-provider-middle-name],
		NULL AS [claim!5!supervising-provider-last-name],
		NULL AS [claim!5!supervising-provider-suffix],
		NULL AS [claim!5!supervising-provider-ssn-qual],
		NULL AS [claim!5!supervising-provider-ssn],
		NULL AS [claim!5!supervising-provider-upin],
		NULL AS [claim!5!supervising-provider-id-qualifier],
		NULL AS [claim!5!supervising-provider-id-number],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn-qual],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [claim!5!service-facility-id],
		NULL AS [claim!5!service-facility-id-qualifier],
		NULL AS [claim!5!claim-note-code],
		NULL AS [claim!5!claim-note],
		NULL AS [claim!5!ambulance-transport-flag],
		NULL AS [claim!5!ambulance-patient-weight],
		NULL AS [claim!5!ambulance-code],
		NULL AS [claim!5!ambulance-reason-code],
		NULL AS [claim!5!ambulance-distance],
		NULL AS [claim!5!ambulance-address-pickup],
		NULL AS [claim!5!ambulance-address-dropoff],
		NULL AS [claim!5!ambulance-purpose-roundtrip],
		NULL AS [claim!5!ambulance-purpose-stretcher],
		NULL AS [claim!5!ambulance-condition-1],
		NULL AS [claim!5!ambulance-condition-2],
		NULL AS [claim!5!ambulance-condition-3],
		NULL AS [claim!5!ambulance-condition-4],
		NULL AS [claim!5!ambulance-condition-5],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [service!7!dme-flag],
		NULL AS [service!7!ordering-provider-first-name],
		NULL AS [service!7!ordering-provider-middle-name],
		NULL AS [service!7!ordering-provider-last-name],
		NULL AS [service!7!ordering-provider-suffix],
		NULL AS [service!7!ordering-provider-ssn-qual],
		NULL AS [service!7!ordering-provider-ssn],
		NULL AS [service!7!ordering-provider-upin],
		NULL AS [service!7!ordering-provider-addressline1],
		NULL AS [service!7!ordering-provider-addressline2],
		NULL AS [service!7!ordering-provider-city],
		NULL AS [service!7!ordering-provider-state],
		NULL AS [service!7!ordering-provider-zipcode],
		NULL AS [service!7!ordering-provider-phone],
		NULL AS [service!7!service-note-code],
		NULL AS [service!7!service-note],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
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
		PR.PracticeID AS [billing!2!billing-id],
		UPPER(PR.Name) AS [billing!2!name],
		UPPER(PR.AddressLine1) AS [billing!2!street-1],
		UPPER(PR.AddressLine2) AS [billing!2!street-2],
		UPPER(PR.City) AS [billing!2!city],
		UPPER(PR.State) AS [billing!2!state],
		PR.ZipCode AS [billing!2!zip],
		@IndBillerQual AS [billing!2!ein-qualifier],
		ISNULL(@IndBillerEIN, PR.EIN) AS [billing!2!ein],

		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],

		UPPER(PR.Name) AS [billing!2!payto-name],
		UPPER(PR.AddressLine1) AS [billing!2!payto-street-1],
		UPPER(PR.AddressLine2) AS [billing!2!payto-street-2],
		UPPER(PR.City) AS [billing!2!payto-city],
		UPPER(PR.State) AS [billing!2!payto-state],
		PR.ZipCode AS [billing!2!payto-zip],
		PR.EIN AS [billing!2!payto-ein],

		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],

		NULL AS [subscriber!3!subscriber-id],
		NULL AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
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
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
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
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!pregnancy-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!last-menstrual-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!referral-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!clia-number],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!supervising-provider-flag],
		NULL AS [claim!5!supervising-provider-first-name],
		NULL AS [claim!5!supervising-provider-middle-name],
		NULL AS [claim!5!supervising-provider-last-name],
		NULL AS [claim!5!supervising-provider-suffix],
		NULL AS [claim!5!supervising-provider-ssn-qual],
		NULL AS [claim!5!supervising-provider-ssn],
		NULL AS [claim!5!supervising-provider-upin],
		NULL AS [claim!5!supervising-provider-id-qualifier],
		NULL AS [claim!5!supervising-provider-id-number],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn-qual],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [claim!5!service-facility-id],
		NULL AS [claim!5!service-facility-id-qualifier],
		NULL AS [claim!5!claim-note-code],
		NULL AS [claim!5!claim-note],
		NULL AS [claim!5!ambulance-transport-flag],
		NULL AS [claim!5!ambulance-patient-weight],
		NULL AS [claim!5!ambulance-code],
		NULL AS [claim!5!ambulance-reason-code],
		NULL AS [claim!5!ambulance-distance],
		NULL AS [claim!5!ambulance-address-pickup],
		NULL AS [claim!5!ambulance-address-dropoff],
		NULL AS [claim!5!ambulance-purpose-roundtrip],
		NULL AS [claim!5!ambulance-purpose-stretcher],
		NULL AS [claim!5!ambulance-condition-1],
		NULL AS [claim!5!ambulance-condition-2],
		NULL AS [claim!5!ambulance-condition-3],
		NULL AS [claim!5!ambulance-condition-4],
		NULL AS [claim!5!ambulance-condition-5],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [service!7!dme-flag],
		NULL AS [service!7!ordering-provider-first-name],
		NULL AS [service!7!ordering-provider-middle-name],
		NULL AS [service!7!ordering-provider-last-name],
		NULL AS [service!7!ordering-provider-suffix],
		NULL AS [service!7!ordering-provider-ssn-qual],
		NULL AS [service!7!ordering-provider-ssn],
		NULL AS [service!7!ordering-provider-upin],
		NULL AS [service!7!ordering-provider-addressline1],
		NULL AS [service!7!ordering-provider-addressline2],
		NULL AS [service!7!ordering-provider-city],
		NULL AS [service!7!ordering-provider-state],
		NULL AS [service!7!ordering-provider-zipcode],
		NULL AS [service!7!ordering-provider-phone],
		NULL AS [service!7!service-note-code],
		NULL AS [service!7!service-note],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
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
		P.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],

		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],

		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-ein],

		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],

		B.PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.FirstName
			ELSE PI.HolderFirstName END) 
			AS [subscriber!3!first-name],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.MiddleName
			ELSE P.MiddleName END)
			AS [subscriber!3!middle-name],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.LastName
			ELSE PI.HolderLastName END)
			AS [subscriber!3!last-name],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.Suffix
			ELSE PI.HolderSuffix END)
			AS [subscriber!3!suffix],
		(CASE PI.PatientRelationshipToInsured WHEN 'S' THEN 0 ELSE 1 END)
			AS [subscriber!3!insured-different-than-patient-flag],
		B.PayerResponsibilityCode 
			AS [subscriber!3!payer-responsibility-code],
		UPPER(SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ICP.PlanName,'+',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' '),1,35)) AS [subscriber!3!plan-name],
--		UPPER(CPL.NameTransmitted) AS [subscriber!3!plan-name],
		UPPER(PI.GroupNumber) AS [subscriber!3!group-number],
		UPPER(PI.PolicyNumber) AS [subscriber!3!policy-number],
		UPPER(CPL.NameTransmitted) AS [subscriber!3!payer-name],
		UPPER(CPL.PayerNumber) AS [subscriber!3!payer-identifier],
		UPPER(ICP.AddressLine1) AS [subscriber!3!payer-street-1],
		UPPER(ICP.AddressLine2) AS [subscriber!3!payer-street-2],
		UPPER(ICP.City) AS [subscriber!3!payer-city],
		UPPER(ICP.State) AS [subscriber!3!payer-state],
		ICP.ZipCode AS [subscriber!3!payer-zip],
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
		@InsuranceProgramCode AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
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
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!pregnancy-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!last-menstrual-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!referral-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!clia-number],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!supervising-provider-flag],
		NULL AS [claim!5!supervising-provider-first-name],
		NULL AS [claim!5!supervising-provider-middle-name],
		NULL AS [claim!5!supervising-provider-last-name],
		NULL AS [claim!5!supervising-provider-suffix],
		NULL AS [claim!5!supervising-provider-ssn-qual],
		NULL AS [claim!5!supervising-provider-ssn],
		NULL AS [claim!5!supervising-provider-upin],
		NULL AS [claim!5!supervising-provider-id-qualifier],
		NULL AS [claim!5!supervising-provider-id-number],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn-qual],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [claim!5!service-facility-id],
		NULL AS [claim!5!service-facility-id-qualifier],
		NULL AS [claim!5!claim-note-code],
		NULL AS [claim!5!claim-note],
		NULL AS [claim!5!ambulance-transport-flag],
		NULL AS [claim!5!ambulance-patient-weight],
		NULL AS [claim!5!ambulance-code],
		NULL AS [claim!5!ambulance-reason-code],
		NULL AS [claim!5!ambulance-distance],
		NULL AS [claim!5!ambulance-address-pickup],
		NULL AS [claim!5!ambulance-address-dropoff],
		NULL AS [claim!5!ambulance-purpose-roundtrip],
		NULL AS [claim!5!ambulance-purpose-stretcher],
		NULL AS [claim!5!ambulance-condition-1],
		NULL AS [claim!5!ambulance-condition-2],
		NULL AS [claim!5!ambulance-condition-3],
		NULL AS [claim!5!ambulance-condition-4],
		NULL AS [claim!5!ambulance-condition-5],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [service!7!dme-flag],
		NULL AS [service!7!ordering-provider-first-name],
		NULL AS [service!7!ordering-provider-middle-name],
		NULL AS [service!7!ordering-provider-last-name],
		NULL AS [service!7!ordering-provider-suffix],
		NULL AS [service!7!ordering-provider-ssn-qual],
		NULL AS [service!7!ordering-provider-ssn],
		NULL AS [service!7!ordering-provider-upin],
		NULL AS [service!7!ordering-provider-addressline1],
		NULL AS [service!7!ordering-provider-addressline2],
		NULL AS [service!7!ordering-provider-city],
		NULL AS [service!7!ordering-provider-state],
		NULL AS [service!7!ordering-provider-zipcode],
		NULL AS [service!7!ordering-provider-phone],
		NULL AS [service!7!service-note-code],
		NULL AS [service!7!service-note],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B
		INNER JOIN InsurancePolicy PI
			INNER JOIN InsuranceCompanyPlan ICP
			ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
			INNER JOIN InsuranceCompany IC 
			ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
			LEFT OUTER JOIN ClearinghousePayersList CPL
			ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID
		ON PI.InsurancePolicyID = B.PayerInsurancePolicyID
		INNER JOIN PatientCase PC
		ON PC.PatientCaseID = PI.PatientCaseID
		INNER JOIN Patient P
		ON P.PatientID = PC.PatientID
	WHERE	B.BillID = @bill_id
	-- END OF SUBSCRIBER HIERARCHICAL LEVEL - LOOP 2000

	UNION ALL

	-- PATIENT HIERARCHICAL LEVEL - 2010BA
	SELECT	4, 3,
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
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
		P.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],

		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],

		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-ein],

		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],

		B.PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
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
		NULL AS [subscriber!3!claim-filing-indicator-code],
		RC.PatientID AS [patient!4!patient-id],
		PI.PatientRelationshipToInsured
			AS [patient!4!relation-to-insured-code],
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
		P.DOB AS [patient!4!birth-date],
		UPPER(P.Gender) AS [patient!4!gender],
		NULL AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!pregnancy-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!last-menstrual-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!referral-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!clia-number],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!supervising-provider-flag],
		NULL AS [claim!5!supervising-provider-first-name],
		NULL AS [claim!5!supervising-provider-middle-name],
		NULL AS [claim!5!supervising-provider-last-name],
		NULL AS [claim!5!supervising-provider-suffix],
		NULL AS [claim!5!supervising-provider-ssn-qual],
		NULL AS [claim!5!supervising-provider-ssn],
		NULL AS [claim!5!supervising-provider-upin],
		NULL AS [claim!5!supervising-provider-id-qualifier],
		NULL AS [claim!5!supervising-provider-id-number],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn-qual],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [claim!5!service-facility-id],
		NULL AS [claim!5!service-facility-id-qualifier],
		NULL AS [claim!5!claim-note-code],
		NULL AS [claim!5!claim-note],
		NULL AS [claim!5!ambulance-transport-flag],
		NULL AS [claim!5!ambulance-patient-weight],
		NULL AS [claim!5!ambulance-code],
		NULL AS [claim!5!ambulance-reason-code],
		NULL AS [claim!5!ambulance-distance],
		NULL AS [claim!5!ambulance-address-pickup],
		NULL AS [claim!5!ambulance-address-dropoff],
		NULL AS [claim!5!ambulance-purpose-roundtrip],
		NULL AS [claim!5!ambulance-purpose-stretcher],
		NULL AS [claim!5!ambulance-condition-1],
		NULL AS [claim!5!ambulance-condition-2],
		NULL AS [claim!5!ambulance-condition-3],
		NULL AS [claim!5!ambulance-condition-4],
		NULL AS [claim!5!ambulance-condition-5],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [service!7!dme-flag],
		NULL AS [service!7!ordering-provider-first-name],
		NULL AS [service!7!ordering-provider-middle-name],
		NULL AS [service!7!ordering-provider-last-name],
		NULL AS [service!7!ordering-provider-suffix],
		NULL AS [service!7!ordering-provider-ssn-qual],
		NULL AS [service!7!ordering-provider-ssn],
		NULL AS [service!7!ordering-provider-upin],
		NULL AS [service!7!ordering-provider-addressline1],
		NULL AS [service!7!ordering-provider-addressline2],
		NULL AS [service!7!ordering-provider-city],
		NULL AS [service!7!ordering-provider-state],
		NULL AS [service!7!ordering-provider-zipcode],
		NULL AS [service!7!ordering-provider-phone],
		NULL AS [service!7!service-note-code],
		NULL AS [service!7!service-note],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B
		INNER JOIN Claim RC
		ON RC.ClaimID = B.RepresentativeClaimID
		INNER JOIN Patient P
		ON P.PatientID = RC.PatientID
		INNER JOIN InsurancePolicy PI
		ON PI.InsurancePolicyID = B.PayerInsurancePolicyID
	WHERE	B.BillID = @bill_id
	-- END OF PATIENT HIERARCHICAL LEVEL - 2010BA

	UNION ALL

	-- CLAIM INFORMATION - loop 2300 CLM
	-- top 1 is needed below as additional protection for case 7943, although fixed for authorization, if duplicate loop 2300 is caused
	--  by something else it will cause whole file being dropped at ProxyMed, which is really gross... 
	SELECT TOP 1	5, 4,
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
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
		RC.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],

		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],

		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-ein],

		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],

		B.PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
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
		NULL AS [subscriber!3!claim-filing-indicator-code],
		RC.PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
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
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		B.BillID AS [claim!5!claim-id],
		-- [claim!5!control-number] cannot be more than 20 chars:
		CONVERT(VARCHAR,RC.PatientID) + 'K'
			+ CONVERT(VARCHAR,RC.ClaimID) + 'K9'
			-- + CONVERT(VARCHAR,B.BillBatchID) + 'K' 
			-- + CONVERT(VARCHAR,B.BillID)
			 AS [claim!5!control-number],
		dbo.BusinessRule_EDIBillTotalAdjustedChargeAmount(B.BillID) 
			AS [claim!5!total-claim-amount],
		E.PlaceOfServiceCode AS [claim!5!place-of-service-code],
		1 AS [claim!5!provider-signature-flag],					-- RC.ProviderSignatureOnFileFlag 
		E.MedicareAssignmentCode AS [claim!5!medicare-assignment-code],
		E.AssignmentOfBenefitsFlag 
			AS [claim!5!assignment-of-benefits-flag],
		E.ReleaseOfInformationCode 	
			AS [claim!5!release-of-information-code],
		'B' -- E.ReleaseSignatureSourceCode 
			AS [claim!5!patient-signature-source-code],
		PC.AutoAccidentRelatedFlag
			AS [claim!5!auto-accident-related-flag],
		PC.AbuseRelatedFlag AS [claim!5!abuse-related-flag],
		PC.PregnancyRelatedFlag AS [claim!5!pregnancy-related-flag],
		PC.EmploymentRelatedFlag AS [claim!5!employment-related-flag],
		PC.OtherAccidentRelatedFlag 
			AS [claim!5!other-accident-related-flag],
		PC.AutoAccidentRelatedState AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],					-- PC.SpecialProgramCode
		InitialTreatmentDate.StartDate AS [claim!5!initial-treatment-date],
		LastMenstrualDate.StartDate AS [claim!5!last-menstrual-date],
		NULL AS [claim!5!referral-date],					-- PC.ReferralDate
		NULL AS [claim!5!last-seen-date],					-- PC.LastSeenDate 
		DateOfInjury.StartDate AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],				-- PC.AcuteManifestationDate
		DateOfSimilarInjury.StartDate AS [claim!5!similar-illness-date],
		(CASE WHEN (PC.AutoAccidentRelatedFlag <> 0 OR PC.OtherAccidentRelatedFlag <> 0) 
			THEN DateOfInjury.StartDate ELSE NULL 
			END) AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],					-- PC.LastXrayDate
		Disability.StartDate AS [claim!5!disability-begin-date],
		Disability.EndDate AS [claim!5!disability-end-date],
		UnableToWork.StartDate AS [claim!5!last-worked-date],
		UnableToWork.EndDate AS [claim!5!return-to-work-date],
		COALESCE(E.HospitalizationStartDT, Hospitalization.StartDate) AS [claim!5!hospitalization-begin-date],
		COALESCE(E.HospitalizationEndDT, Hospitalization.EndDate) AS [claim!5!hospitalization-end-date],
		(CASE WHEN @hide_patient_paid_amount = 0 THEN E.AmountPaid ELSE NULL END) AS [claim!5!patient-paid-amount],	-- RC.PatientPaidAmount
		UPPER(A.AuthorizationNumber) AS [claim!5!authorization-number],
		RC.ReferringProviderIDNumber AS [claim!5!referral-number],
		-- list of diagnostic codes:
		(CASE WHEN (@DiagnosisCode1 IS NOT NULL) THEN UPPER(@DiagnosisCode1) ELSE NULL END) AS [claim!5!diagnosis-1],
		(CASE WHEN (@DiagnosisCode2 IS NOT NULL) THEN UPPER(@DiagnosisCode2) ELSE NULL END) AS [claim!5!diagnosis-2],
		(CASE WHEN (@DiagnosisCode3 IS NOT NULL) THEN UPPER(@DiagnosisCode3) ELSE NULL END) AS [claim!5!diagnosis-3],
		(CASE WHEN (@DiagnosisCode4 IS NOT NULL) THEN UPPER(@DiagnosisCode4) ELSE NULL END) AS [claim!5!diagnosis-4],
		(CASE WHEN (@DiagnosisCode5 IS NOT NULL) THEN UPPER(@DiagnosisCode5) ELSE NULL END) AS [claim!5!diagnosis-5],
		(CASE WHEN (@DiagnosisCode6 IS NOT NULL) THEN UPPER(@DiagnosisCode6) ELSE NULL END) AS [claim!5!diagnosis-6],
		(CASE WHEN (@DiagnosisCode7 IS NOT NULL) THEN UPPER(@DiagnosisCode7) ELSE NULL END) AS [claim!5!diagnosis-7],
		(CASE WHEN (@DiagnosisCode8 IS NOT NULL) THEN UPPER(@DiagnosisCode8) ELSE NULL END) AS [claim!5!diagnosis-8],
		@CliaNumber AS [claim!5!clia-number],
		(CASE WHEN (E.ReferringPhysicianID IS NOT NULL) THEN 1 ELSE 0 END)
			AS [claim!5!referring-provider-flag],
		UPPER(RP.FirstName) AS [claim!5!referring-provider-first-name],
		UPPER(RP.MiddleName) 
			AS [claim!5!referring-provider-middle-name],
		UPPER(RP.LastName) AS [claim!5!referring-provider-last-name],
		UPPER(RP.Suffix) AS [claim!5!referring-provider-suffix],
		(CASE 
			WHEN RTRIM(ISNULL(RC.ReferringProviderIDNumber, '')) <> '' THEN UPPER(RC.ReferringProviderIDNumber)
			ELSE UPPER(ISNULL(UPIN.ProviderNumber, '')) 
		END) AS [claim!5!referring-provider-upin],

		CAST((CASE WHEN (SD.DoctorID IS NOT NULL) THEN 1 ELSE 0 END) AS BIT) AS [claim!5!supervising-provider-flag],
		UPPER(SD.FirstName) AS [claim!5!supervising-provider-first-name],
		UPPER(SD.MiddleName) AS [claim!5!supervising-provider-middle-name],
		UPPER(SD.LastName) AS [claim!5!supervising-provider-last-name],
		UPPER(SD.Suffix) AS [claim!5!supervising-provider-suffix],
		'34' AS [claim!5!supervising-provider-ssn-qual],
		UPPER(SD.SSN) AS [claim!5!supervising-provider-ssn],
		UPPER(@SupervisingProviderUpin) AS [claim!5!supervising-provider-upin],
		@SupervisingProviderIdQualifier AS [claim!5!supervising-provider-id-qualifier],
		@SupervisingProviderIdNumber AS [claim!5!supervising-provider-id-number],

		UPPER(D.FirstName) AS [claim!5!rendering-provider-first-name],
		UPPER(D.MiddleName) AS [claim!5!rendering-provider-middle-name],
		UPPER(D.LastName) AS [claim!5!rendering-provider-last-name],
		UPPER(D.Suffix) AS [claim!5!rendering-provider-suffix],
		CAST(@loop2310Bqual AS VARCHAR(30)) AS [claim!5!rendering-provider-ssn-qual],
		UPPER(ISNULL(@loop2310Btaxid, D.SSN)) AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		-- UPPER(D.UPIN) AS [claim!5!rendering-provider-upin],
		UPPER(D.TaxonomyCode) 
			AS [claim!5!rendering-provider-specialty-code],
		UPPER(L.BillingName) AS [claim!5!service-facility-name],
		UPPER(L.AddressLine1) AS [claim!5!service-facility-street-1],
		UPPER(L.AddressLine2) AS [claim!5!service-facility-street-2],
		UPPER(L.City) AS [claim!5!service-facility-city],
		UPPER(L.State) AS [claim!5!service-facility-state],
		L.ZipCode AS [claim!5!service-facility-zip],
		CASE WHEN @ServiceFacilityIdQualifier IS NULL THEN NULL ELSE L.HCFABox32FacilityID END AS [claim!5!service-facility-id],
		CASE WHEN L.HCFABox32FacilityID IS NULL THEN NULL ELSE @ServiceFacilityIdQualifier END AS [claim!5!service-facility-id-qualifier],
		CASE WHEN E.EDIClaimNoteReferenceCode IN ('ADD','CER','DCP','DGN','PMT','TPO') AND LEN(E.EDIClaimNote) > 0 THEN E.EDIClaimNoteReferenceCode ELSE NULL END AS [claim!5!claim-note-code],
		CASE WHEN E.EDIClaimNoteReferenceCode IN ('ADD','CER','DCP','DGN','PMT','TPO') AND LEN(E.EDIClaimNote) > 0 THEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(E.EDIClaimNote,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) ELSE NULL END AS [claim!5!claim-note],
		CASE WHEN ATI.TransportRecordId IS NULL THEN 0 ELSE 1 END AS [claim!5!ambulance-transport-flag],
		CASE WHEN ATI.Weight IS NULL THEN NULL ELSE CAST(ATI.Weight AS varchar(30)) END AS [claim!5!ambulance-patient-weight],
		ATI.AmbulanceTransportCode AS [claim!5!ambulance-code],
		ATI.AmbulanceTransportReasonCode AS [claim!5!ambulance-reason-code],
		ATI.Miles AS [claim!5!ambulance-distance],
		UPPER(ATI.PickUp) AS [claim!5!ambulance-address-pickup],
		UPPER(ATI.DropOff) AS [claim!5!ambulance-address-dropoff],
		UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ATI.RoundTripPurposeDescription,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) AS [claim!5!ambulance-purpose-roundtrip],
		UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ATI.StretcherPurposeDescription,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) AS [claim!5!ambulance-purpose-stretcher],
		ACI1.AmbulanceCertificationCode AS [claim!5!ambulance-condition-1],
		ACI2.AmbulanceCertificationCode AS [claim!5!ambulance-condition-2],
		ACI3.AmbulanceCertificationCode AS [claim!5!ambulance-condition-3],
		ACI4.AmbulanceCertificationCode AS [claim!5!ambulance-condition-4],
		ACI5.AmbulanceCertificationCode AS [claim!5!ambulance-condition-5],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [service!7!dme-flag],
		NULL AS [service!7!ordering-provider-first-name],
		NULL AS [service!7!ordering-provider-middle-name],
		NULL AS [service!7!ordering-provider-last-name],
		NULL AS [service!7!ordering-provider-suffix],
		NULL AS [service!7!ordering-provider-ssn-qual],
		NULL AS [service!7!ordering-provider-ssn],
		NULL AS [service!7!ordering-provider-upin],
		NULL AS [service!7!ordering-provider-addressline1],
		NULL AS [service!7!ordering-provider-addressline2],
		NULL AS [service!7!ordering-provider-city],
		NULL AS [service!7!ordering-provider-state],
		NULL AS [service!7!ordering-provider-zipcode],
		NULL AS [service!7!ordering-provider-phone],
		NULL AS [service!7!service-note-code],
		NULL AS [service!7!service-note],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B
		INNER JOIN Claim RC
		ON RC.ClaimID = B.RepresentativeClaimID

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
		LEFT JOIN PatientCaseDate AS InitialTreatmentDate
			ON InitialTreatmentDate.PatientCaseID = PC.PatientCaseID
			AND InitialTreatmentDate.PatientCaseDateTypeID = 1
		LEFT JOIN PatientCaseDate AS DateOfInjury
			ON DateOfInjury.PatientCaseID = PC.PatientCaseID
			AND DateOfInjury.PatientCaseDateTypeID = 2
		LEFT JOIN PatientCaseDate AS DateOfSimilarInjury
			ON DateOfSimilarInjury.PatientCaseID = PC.PatientCaseID
			AND DateOfSimilarInjury.PatientCaseDateTypeID = 3
		LEFT JOIN PatientCaseDate AS UnableToWork
			ON UnableToWork.PatientCaseID = PC.PatientCaseID
			AND UnableToWork.PatientCaseDateTypeID = 4
		LEFT JOIN PatientCaseDate AS Disability
			ON Disability.PatientCaseID = PC.PatientCaseID
			AND Disability.PatientCaseDateTypeID = 5
		LEFT JOIN PatientCaseDate AS Hospitalization
			ON Hospitalization.PatientCaseID = PC.PatientCaseID
			AND Hospitalization.PatientCaseDateTypeID = 6
		LEFT JOIN PatientCaseDate AS LastMenstrualDate
			ON LastMenstrualDate.PatientCaseID = PC.PatientCaseID
			AND LastMenstrualDate.PatientCaseDateTypeID = 7
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

	WHERE	B.BillID = @bill_id
	-- END OF CLAIM INFORMATION - loop 2300 CLM


	UNION ALL

	-- SUBSCRIBER LEVEL - DIFFERENT THAN PATIENT
	SELECT	6, 5,
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
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
		RC.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],

		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],

		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-ein],

		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],

		B.PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
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
		NULL AS [subscriber!3!claim-filing-indicator-code],
		RC.PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
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
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		B.BillID AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!pregnancy-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!last-menstrual-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!referral-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!clia-number],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!supervising-provider-flag],
		NULL AS [claim!5!supervising-provider-first-name],
		NULL AS [claim!5!supervising-provider-middle-name],
		NULL AS [claim!5!supervising-provider-last-name],
		NULL AS [claim!5!supervising-provider-suffix],
		NULL AS [claim!5!supervising-provider-ssn-qual],
		NULL AS [claim!5!supervising-provider-ssn],
		NULL AS [claim!5!supervising-provider-upin],
		NULL AS [claim!5!supervising-provider-id-qualifier],
		NULL AS [claim!5!supervising-provider-id-number],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn-qual],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [claim!5!service-facility-id],
		NULL AS [claim!5!service-facility-id-qualifier],
		NULL AS [claim!5!claim-note-code],
		NULL AS [claim!5!claim-note],
		NULL AS [claim!5!ambulance-transport-flag],
		NULL AS [claim!5!ambulance-patient-weight],
		NULL AS [claim!5!ambulance-code],
		NULL AS [claim!5!ambulance-reason-code],
		NULL AS [claim!5!ambulance-distance],
		NULL AS [claim!5!ambulance-address-pickup],
		NULL AS [claim!5!ambulance-address-dropoff],
		NULL AS [claim!5!ambulance-purpose-roundtrip],
		NULL AS [claim!5!ambulance-purpose-stretcher],
		NULL AS [claim!5!ambulance-condition-1],
		NULL AS [claim!5!ambulance-condition-2],
		NULL AS [claim!5!ambulance-condition-3],
		NULL AS [claim!5!ambulance-condition-4],
		NULL AS [claim!5!ambulance-condition-5],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id],
		PI.InsurancePolicyID AS [secondary!6!secondary-id],
		(CASE PI.PatientRelationshipToInsured WHEN 'S' THEN 0 ELSE 1 END)
			AS [secondary!6!insured-different-than-patient-flag],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.FirstName
			ELSE PI.HolderFirstName END)
			AS [secondary!6!subscriber-first-name],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.MiddleName
			ELSE PI.HolderMiddleName END)
			AS [secondary!6!subscriber-middle-name],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.Lastname
			ELSE PI.HolderLastName END)
			AS [secondary!6!subscriber-last-name],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.Suffix
			ELSE PI.HolderSuffix END)
			AS [secondary!6!subscriber-suffix],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.AddressLine1
			ELSE PI.HolderAddressLine1 END)
			AS [secondary!6!subscriber-street-1],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.AddressLine2
			ELSE PI.HolderAddressLine2 END)
			AS [secondary!6!subscriber-street-2],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.City
			ELSE PI.HolderCity END)
			AS [secondary!6!subscriber-city],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.State
			ELSE PI.HolderState END)
			AS [secondary!6!subscriber-state],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.ZipCode
			ELSE PI.HolderZipCode END)
			AS [secondary!6!subscriber-zip],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.DOB
			ELSE PI.HolderDOB END)
			AS [secondary!6!subscriber-birth-date],
		UPPER(CASE PI.PatientRelationshipToInsured
			WHEN 'S' THEN P.Gender
			ELSE PI.HolderGender END)
			AS [secondary!6!subscriber-gender],
		UPPER(PI.PatientRelationshipToInsured)
			AS [secondary!6!relation-to-insured-code],
		B.PayerResponsibilityCode 	
			AS [secondary!6!payer-responsibility-code],
		UPPER(SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ICP.PlanName,'+',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' '),1,35)) AS [secondary!6!plan-name],
		UPPER(PI.GroupNumber) AS [secondary!6!group-number],
		UPPER(PI.PolicyNumber) AS [secondary!6!policy-numer],
--		UPPER(ICP.PlanName) AS [secondary!6!payer-name],
		UPPER(CPL.NameTransmitted) AS [secondary!6!payer-name],
		CPL.PayerNumber AS [secondary!6!payer-identifier],
		UPPER(COALESCE(ICP.ContactFirstName + ' ', '')
			+ COALESCE(ICP.ContactMiddleName + ' ', '')
			+ COALESCE(ICP.ContactLastName, ''))
			AS [secondary!6!payer-contact-name],
		ICP.Phone AS [secondary!6!payer-contact-phone],
		dbo.BusinessRule_EDIBillPayerPaid(
			B.BillID, 
			ICP.InsuranceCompanyPlanID) 
			AS [secondary!6!payer-paid-flag],
		dbo.BusinessRule_EDIBillPayerPaidAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID)
			AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [service!7!dme-flag],
		NULL AS [service!7!ordering-provider-first-name],
		NULL AS [service!7!ordering-provider-middle-name],
		NULL AS [service!7!ordering-provider-last-name],
		NULL AS [service!7!ordering-provider-suffix],
		NULL AS [service!7!ordering-provider-ssn-qual],
		NULL AS [service!7!ordering-provider-ssn],
		NULL AS [service!7!ordering-provider-upin],
		NULL AS [service!7!ordering-provider-addressline1],
		NULL AS [service!7!ordering-provider-addressline2],
		NULL AS [service!7!ordering-provider-city],
		NULL AS [service!7!ordering-provider-state],
		NULL AS [service!7!ordering-provider-zipcode],
		NULL AS [service!7!ordering-provider-phone],
		NULL AS [service!7!service-note-code],
		NULL AS [service!7!service-note],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B
		INNER JOIN Claim RC
		ON RC.ClaimID = B.RepresentativeClaimID
		INNER JOIN Patient P
		ON P.PatientID = RC.PatientID
			INNER JOIN InsurancePolicy PI
			ON PI.InsurancePolicyID = B.PayerInsurancePolicyID
			INNER JOIN InsuranceCompanyPlan ICP
				INNER JOIN InsuranceCompany IC 
				ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
				LEFT OUTER JOIN ClearinghousePayersList CPL
				ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID
			ON ICP.InsuranceCompanyPlanID = PI.InsuranceCompanyPlanID
		AND PI.InsurancePolicyID <> B.PayerInsurancePolicyID
	WHERE	B.BillID = @bill_id
	-- END OF SUBSCRIBER LEVEL - DIFFERENT THAN PATIENT


	UNION ALL

	-- RENDERING PROVIDER NUMBERS - INSURANCE PLAN ASSIGNED PROVIDER ID
	-- Rendering provider numbers for REF (Doctor provider numbers, Loop 2310B):
	SELECT DISTINCT	10, 5,
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
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
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],

		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],

		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-ein],

		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],

		PT.PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
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
		NULL AS [subscriber!3!claim-filing-indicator-code],
		@PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
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
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		@bill_id AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!pregnancy-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!last-menstrual-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!referral-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!clia-number],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!supervising-provider-flag],
		NULL AS [claim!5!supervising-provider-first-name],
		NULL AS [claim!5!supervising-provider-middle-name],
		NULL AS [claim!5!supervising-provider-last-name],
		NULL AS [claim!5!supervising-provider-suffix],
		NULL AS [claim!5!supervising-provider-ssn-qual],
		NULL AS [claim!5!supervising-provider-ssn],
		NULL AS [claim!5!supervising-provider-upin],
		NULL AS [claim!5!supervising-provider-id-qualifier],
		NULL AS [claim!5!supervising-provider-id-number],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn-qual],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [claim!5!service-facility-id],
		NULL AS [claim!5!service-facility-id-qualifier],
		NULL AS [claim!5!claim-note-code],
		NULL AS [claim!5!claim-note],
		NULL AS [claim!5!ambulance-transport-flag],
		NULL AS [claim!5!ambulance-patient-weight],
		NULL AS [claim!5!ambulance-code],
		NULL AS [claim!5!ambulance-reason-code],
		NULL AS [claim!5!ambulance-distance],
		NULL AS [claim!5!ambulance-address-pickup],
		NULL AS [claim!5!ambulance-address-dropoff],
		NULL AS [claim!5!ambulance-purpose-roundtrip],
		NULL AS [claim!5!ambulance-purpose-stretcher],
		NULL AS [claim!5!ambulance-condition-1],
		NULL AS [claim!5!ambulance-condition-2],
		NULL AS [claim!5!ambulance-condition-3],
		NULL AS [claim!5!ambulance-condition-4],
		NULL AS [claim!5!ambulance-condition-5],
		PT.ANSIReferenceIdentificationQualifier AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		PT.ProviderNumber AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id],
		PT.ProviderNumberID AS [secondary!6!secondary-id],		-- the NULL here would break some rare submissions, and any variable may ruin DISTINCT.
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [service!7!dme-flag],
		NULL AS [service!7!ordering-provider-first-name],
		NULL AS [service!7!ordering-provider-middle-name],
		NULL AS [service!7!ordering-provider-last-name],
		NULL AS [service!7!ordering-provider-suffix],
		NULL AS [service!7!ordering-provider-ssn-qual],
		NULL AS [service!7!ordering-provider-ssn],
		NULL AS [service!7!ordering-provider-upin],
		NULL AS [service!7!ordering-provider-addressline1],
		NULL AS [service!7!ordering-provider-addressline2],
		NULL AS [service!7!ordering-provider-city],
		NULL AS [service!7!ordering-provider-state],
		NULL AS [service!7!ordering-provider-zipcode],
		NULL AS [service!7!ordering-provider-phone],
		NULL AS [service!7!service-note-code],
		NULL AS [service!7!service-note],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]

	FROM	@t_providernumbers PT
	-- END OF RENDERING PROVIDER NUMBERS - INSURANCE PLAN ASSIGNED PROVIDER ID

	UNION ALL

	-- REFERRING PROVIDER NUMBERS - INSURANCE PLAN ASSIGNED PROVIDER ID
	SELECT DISTINCT	11, 5,
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
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
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],

		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],

		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-ein],

		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],

		RT.PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		@bill_id AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
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
		NULL AS [subscriber!3!claim-filing-indicator-code],
		@PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
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
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		@bill_id AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!pregnancy-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!last-menstrual-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!referral-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!clia-number],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!supervising-provider-flag],
		NULL AS [claim!5!supervising-provider-first-name],
		NULL AS [claim!5!supervising-provider-middle-name],
		NULL AS [claim!5!supervising-provider-last-name],
		NULL AS [claim!5!supervising-provider-suffix],
		NULL AS [claim!5!supervising-provider-ssn-qual],
		NULL AS [claim!5!supervising-provider-ssn],
		NULL AS [claim!5!supervising-provider-upin],
		NULL AS [claim!5!supervising-provider-id-qualifier],
		NULL AS [claim!5!supervising-provider-id-number],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn-qual],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [claim!5!service-facility-id],
		NULL AS [claim!5!service-facility-id-qualifier],
		NULL AS [claim!5!claim-note-code],
		NULL AS [claim!5!claim-note],
		NULL AS [claim!5!ambulance-transport-flag],
		NULL AS [claim!5!ambulance-patient-weight],
		NULL AS [claim!5!ambulance-code],
		NULL AS [claim!5!ambulance-reason-code],
		NULL AS [claim!5!ambulance-distance],
		NULL AS [claim!5!ambulance-address-pickup],
		NULL AS [claim!5!ambulance-address-dropoff],
		NULL AS [claim!5!ambulance-purpose-roundtrip],
		NULL AS [claim!5!ambulance-purpose-stretcher],
		NULL AS [claim!5!ambulance-condition-1],
		NULL AS [claim!5!ambulance-condition-2],
		NULL AS [claim!5!ambulance-condition-3],
		NULL AS [claim!5!ambulance-condition-4],
		NULL AS [claim!5!ambulance-condition-5],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		RT.ANSIReferenceIdentificationQualifier AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		RT.ProviderNumber AS [referringprovidernumbers!11!referring-provider-provider-id],
		RT.ProviderNumberID AS [secondary!6!secondary-id],		-- the NULL here would break some rare submissions, and any variable may ruin DISTINCT.
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [service!7!dme-flag],
		NULL AS [service!7!ordering-provider-first-name],
		NULL AS [service!7!ordering-provider-middle-name],
		NULL AS [service!7!ordering-provider-last-name],
		NULL AS [service!7!ordering-provider-suffix],
		NULL AS [service!7!ordering-provider-ssn-qual],
		NULL AS [service!7!ordering-provider-ssn],
		NULL AS [service!7!ordering-provider-upin],
		NULL AS [service!7!ordering-provider-addressline1],
		NULL AS [service!7!ordering-provider-addressline2],
		NULL AS [service!7!ordering-provider-city],
		NULL AS [service!7!ordering-provider-state],
		NULL AS [service!7!ordering-provider-zipcode],
		NULL AS [service!7!ordering-provider-phone],
		NULL AS [service!7!service-note-code],
		NULL AS [service!7!service-note],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]

	FROM	@t_refprovidernumbers RT
	-- END OF REFERRING PROVIDER NUMBERS - INSURANCE PLAN ASSIGNED PROVIDER ID

	UNION ALL

	-- SERVICE LINE HIERARCHICAL LEVEL
	SELECT 7, 5,
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
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
		RC.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],

		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],

		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-ein],

		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],

		B.PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
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
		NULL AS [subscriber!3!claim-filing-indicator-code],
		RC.PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
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
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		B.BillID AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!pregnancy-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!last-menstrual-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!referral-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!clia-number],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!supervising-provider-flag],
		NULL AS [claim!5!supervising-provider-first-name],
		NULL AS [claim!5!supervising-provider-middle-name],
		NULL AS [claim!5!supervising-provider-last-name],
		NULL AS [claim!5!supervising-provider-suffix],
		NULL AS [claim!5!supervising-provider-ssn-qual],
		NULL AS [claim!5!supervising-provider-ssn],
		NULL AS [claim!5!supervising-provider-upin],
		NULL AS [claim!5!supervising-provider-id-qualifier],
		NULL AS [claim!5!supervising-provider-id-number],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn-qual],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [claim!5!service-facility-id],
		NULL AS [claim!5!service-facility-id-qualifier],
		NULL AS [claim!5!claim-note-code],
		NULL AS [claim!5!claim-note],
		NULL AS [claim!5!ambulance-transport-flag],
		NULL AS [claim!5!ambulance-patient-weight],
		NULL AS [claim!5!ambulance-code],
		NULL AS [claim!5!ambulance-reason-code],
		NULL AS [claim!5!ambulance-distance],
		NULL AS [claim!5!ambulance-address-pickup],
		NULL AS [claim!5!ambulance-address-dropoff],
		NULL AS [claim!5!ambulance-purpose-roundtrip],
		NULL AS [claim!5!ambulance-purpose-stretcher],
		NULL AS [claim!5!ambulance-condition-1],
		NULL AS [claim!5!ambulance-condition-2],
		NULL AS [claim!5!ambulance-condition-3],
		NULL AS [claim!5!ambulance-condition-4],
		NULL AS [claim!5!ambulance-condition-5],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		C.ClaimID AS [service!7!service-id],
		-- [service!7!control-number] no more than 20 chars. Must differ from [claim!5!control-number]:
		'S' + CONVERT(VARCHAR,RC.PatientID) + 'K'
			+ CONVERT(VARCHAR,BC.ClaimID) + 'K9'
			-- + CONVERT(VARCHAR,B.BillBatchID) + 'K' 
			-- + CONVERT(VARCHAR,BC.BillID)
			AS [service!7!control-number],
		UPPER(PCD.ProcedureCode) AS [service!7!procedure-code],
		EP.ProcedureDateOfService AS [service!7!service-date],
		dbo.BusinessRule_ClaimAdjustedChargeAmount(C.ClaimID) AS [service!7!service-charge-amount],
--		C.ServiceChargeAmount * C.ServiceUnitCount AS [service!7!service-charge-amount],
		EP.ServiceUnitCount AS [service!7!service-unit-count],
		E.PlaceOfServiceCode AS [service!7!place-of-service-code],
		EP.ProcedureModifier1 AS [service!7!procedure-modifier-1],
		EP.ProcedureModifier2 AS [service!7!procedure-modifier-2],
		EP.ProcedureModifier3 AS [service!7!procedure-modifier-3],
		EP.ProcedureModifier4 AS [service!7!procedure-modifier-4],

		CASE WHEN DCD.DiagnosisCode IS NOT NULL THEN CBDP.Pointer ELSE NULL END AS [service!7!diagnosis-pointer-1],
		CASE WHEN DCD2.DiagnosisCode IS NOT NULL THEN CBDP2.Pointer ELSE NULL END AS [service!7!diagnosis-pointer-2],
		CASE WHEN DCD3.DiagnosisCode IS NOT NULL THEN CBDP3.Pointer ELSE NULL END AS [service!7!diagnosis-pointer-3],
		CASE WHEN DCD4.DiagnosisCode IS NOT NULL THEN CBDP4.Pointer ELSE NULL END AS [service!7!diagnosis-pointer-4],

		CASE WHEN PCD.TypeOfServiceCode IN ('A','J','P','R') THEN 1 ELSE NULL END AS [service!7!dme-flag],
		@OPFirstName AS [service!7!ordering-provider-first-name],
		@OPMiddleName AS [service!7!ordering-provider-middle-name],
		@OPLastName AS [service!7!ordering-provider-last-name],
		@OPSuffix AS [service!7!ordering-provider-suffix],
		@OPSSNQualifier AS [service!7!ordering-provider-ssn-qual],
		@OPSSN AS [service!7!ordering-provider-ssn],
		@OPUPIN AS [service!7!ordering-provider-upin],
		@OPAddressLine1 AS [service!7!ordering-provider-addressline1],
		@OPAddressLine2 AS [service!7!ordering-provider-addressline2],
		@OPCity AS [service!7!ordering-provider-city],
		@OPState AS [service!7!ordering-provider-state],
		@OPZipCode AS [service!7!ordering-provider-zipcode],
		@OPPhone AS [service!7!ordering-provider-phone],
		CASE WHEN C.EDIServiceNoteReferenceCode IN ('ADD','DCP','PMT','TPO') AND LEN(C.EDIServiceNote) > 0 THEN C.EDIServiceNoteReferenceCode ELSE NULL END AS [service!7!service-note-code],
		CASE WHEN C.EDIServiceNoteReferenceCode IN ('ADD','DCP','PMT','TPO') AND LEN(C.EDIServiceNote) > 0 THEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.EDIServiceNote,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) ELSE NULL END AS [service!7!service-note],
--		CASE WHEN EP.EDIServiceNoteReferenceCode IN ('ADD','DCP','PMT','TPO') AND LEN(EP.EDIServiceNote) > 0 THEN EP.EDIServiceNoteReferenceCode ELSE NULL END AS [service!7!service-note-code],
--		CASE WHEN EP.EDIServiceNoteReferenceCode IN ('ADD','DCP','PMT','TPO') AND LEN(EP.EDIServiceNote) > 0 THEN UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(EP.EDIServiceNote,'+',''),CHAR(13),' '),CHAR(10),''),'!',''),'*',''),':',''),'(',''),')',''),'#',''),',',''),'.',''),'/',''),'"',''),'&',' '),'''',''),'-',' '),'  ',' '),'  ',' ')) ELSE NULL END AS [service!7!service-note],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B	
		INNER JOIN Claim RC
		ON RC.ClaimID = B.RepresentativeClaimID
		INNER JOIN BillClaim BC
		ON BC.BillID = B.BillID
		AND BC.BillBatchTypeCode = 'E'
		INNER JOIN Claim C
		ON C.ClaimID = BC.ClaimID
		INNER JOIN dbo.EncounterProcedure EP
		ON EP.EncounterProcedureID = C.EncounterProcedureID
		INNER JOIN ProcedureCodeDictionary PCD
		ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
		INNER JOIN Encounter E
		ON E.EncounterID = EP.EncounterID

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

	WHERE	B.BillID = @bill_id
	-- END OF SERVICE LINE HIERARCHICAL LEVEL

	UNION ALL

	-- ? not used ?
	SELECT	8, 7,
		CONVERT(VARCHAR,@batch_id) AS [transaction!1!transaction-id],
		CONVERT(VARCHAR,@bill_id)  AS [transaction!1!control-number],
		NULL AS [transaction!1!clearinghouse-connection-id],
		NULL AS [transaction!1!routing-preference],
		NULL AS [transaction!1!created-date],
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
		RC.PracticeID AS [billing!2!billing-id],
		NULL AS [billing!2!name],
		NULL AS [billing!2!street-1],
		NULL AS [billing!2!street-2],
		NULL AS [billing!2!city],
		NULL AS [billing!2!state],
		NULL AS [billing!2!zip],
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],

		NULL AS [secondaryident!9!id-qualifier],
		NULL AS [secondaryident!9!provider-id],

		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-ein],

		NULL AS [secondaryident!9!payto-id-qualifier],
		NULL AS [secondaryident!9!payto-provider-id],

		B.PayerInsurancePolicyID AS [subscriber!3!subscriber-id],
		B.BillID AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
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
		NULL AS [subscriber!3!claim-filing-indicator-code],
		RC.PatientID AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
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
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		B.BillID AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!pregnancy-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!last-menstrual-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!referral-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!clia-number],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!supervising-provider-flag],
		NULL AS [claim!5!supervising-provider-first-name],
		NULL AS [claim!5!supervising-provider-middle-name],
		NULL AS [claim!5!supervising-provider-last-name],
		NULL AS [claim!5!supervising-provider-suffix],
		NULL AS [claim!5!supervising-provider-ssn-qual],
		NULL AS [claim!5!supervising-provider-ssn],
		NULL AS [claim!5!supervising-provider-upin],
		NULL AS [claim!5!supervising-provider-id-qualifier],
		NULL AS [claim!5!supervising-provider-id-number],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn-qual],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [claim!5!service-facility-id],
		NULL AS [claim!5!service-facility-id-qualifier],
		NULL AS [claim!5!claim-note-code],
		NULL AS [claim!5!claim-note],
		NULL AS [claim!5!ambulance-transport-flag],
		NULL AS [claim!5!ambulance-patient-weight],
		NULL AS [claim!5!ambulance-code],
		NULL AS [claim!5!ambulance-reason-code],
		NULL AS [claim!5!ambulance-distance],
		NULL AS [claim!5!ambulance-address-pickup],
		NULL AS [claim!5!ambulance-address-dropoff],
		NULL AS [claim!5!ambulance-purpose-roundtrip],
		NULL AS [claim!5!ambulance-purpose-stretcher],
		NULL AS [claim!5!ambulance-condition-1],
		NULL AS [claim!5!ambulance-condition-2],
		NULL AS [claim!5!ambulance-condition-3],
		NULL AS [claim!5!ambulance-condition-4],
		NULL AS [claim!5!ambulance-condition-5],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		C.ClaimID AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [service!7!dme-flag],
		NULL AS [service!7!ordering-provider-first-name],
		NULL AS [service!7!ordering-provider-middle-name],
		NULL AS [service!7!ordering-provider-last-name],
		NULL AS [service!7!ordering-provider-suffix],
		NULL AS [service!7!ordering-provider-ssn-qual],
		NULL AS [service!7!ordering-provider-ssn],
		NULL AS [service!7!ordering-provider-upin],
		NULL AS [service!7!ordering-provider-addressline1],
		NULL AS [service!7!ordering-provider-addressline2],
		NULL AS [service!7!ordering-provider-city],
		NULL AS [service!7!ordering-provider-state],
		NULL AS [service!7!ordering-provider-zipcode],
		NULL AS [service!7!ordering-provider-phone],
		NULL AS [service!7!service-note-code],
		NULL AS [service!7!service-note],
		CT.ClaimTransactionID AS [adjudication!8!adjudication-id],
		CPL.PayerNumber AS [adjudication!8!payer-identifier],
		CT.Amount AS [adjudication!8!paid-amount],
		CT.Quantity AS [adjudication!8!paid-unit-count],
		PMT.PostingDate AS [adjudication!8!paid-date],
		dbo.BusinessRule_EDIBillPayerAdjusted(
			B.BillID,
			ICP.InsuranceCompanyPlanID)
			AS [adjudication!8!payer-adjusted-flag],
		dbo.BusinessRule_EDIBillPayerAdjustmentCode(
			B.BillID,
			ICP.InsuranceCompanyPlanID, 
			1) 
			AS [adjudication!8!adjustment-reason-1],
		dbo.BusinessRule_EDIBillPayerAdjustmentAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			1)
			AS [adjudication!8!adjustment-amount-1],
		dbo.BusinessRule_EDIBillPayerAdjustmentCode(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			1)
			AS [adjudication!8!adjustment-reason-2],
		dbo.BusinessRule_EDIBillPayerAdjustmentAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			2)
			AS [adjudication!8!adjustment-amount-2],
		dbo.BusinessRule_EDIBillPayerAdjustmentCode(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			3)
			AS [adjudication!8!adjustment-reason-3],
		dbo.BusinessRule_EDIBillPayerAdjustmentAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			3)
			AS [adjudication!8!adjustment-amount-3],
		dbo.BusinessRule_EDIBillPayerAdjustmentCode(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			4)
			AS [adjudication!8!adjustment-reason-4],
		dbo.BusinessRule_EDIBillPayerAdjustmentAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			4)
			AS [adjudication!8!adjustment-amount-4],
		dbo.BusinessRule_EDIBillPayerAdjustmentCode(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			5)
			AS [adjudication!8!adjustment-reason-5],
		dbo.BusinessRule_EDIBillPayerAdjustmentAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			5)
			AS [adjudication!8!adjustment-amount-5],
		dbo.BusinessRule_EDIBillPayerAdjustmentCode(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			6)
			AS [adjudication!8!adjustment-reason-6],
		dbo.BusinessRule_EDIBillPayerAdjustmentAmount(
			B.BillID,
			ICP.InsuranceCompanyPlanID,
			6)
			AS [adjudication!8!adjustment-amount-6]
	FROM	Bill_EDI B
		INNER JOIN Claim RC
		ON RC.ClaimID = B.RepresentativeClaimID
		INNER JOIN BillClaim BC
		ON BC.BillID = B.BillID
		AND BC.BillBatchTypeCode = 'E'
		INNER JOIN Claim C
		ON C.ClaimID = BC.ClaimID
		INNER JOIN ClaimTransaction CT
		ON CT.ClaimID = C.ClaimID
		AND CT.ClaimTransactionTypeCode = 'PAY'
		INNER JOIN Payment PMT
		ON PMT.PaymentID = CT.ReferenceID
		AND PMT.PayerTypeCode = 'I'
		INNER JOIN InsuranceCompanyPlan ICP
			INNER JOIN InsuranceCompany IC 
			ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
			LEFT OUTER JOIN ClearinghousePayersList CPL
			ON IC.ClearinghousePayerID = CPL.ClearinghousePayerID
		ON ICP.InsuranceCompanyPlanID = PMT.PayerID
	WHERE	B.BillID = @bill_id
	-- END OF ? not used ?

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
		NULL AS [billing!2!ein-qualifier],
		NULL AS [billing!2!ein],

		TT.ANSIReferenceIdentificationQualifier AS [secondaryident!9!id-qualifier],
		TT.GroupNumber AS [secondaryident!9!provider-id],

		NULL AS [billing!2!payto-name],
		NULL AS [billing!2!payto-street-1],
		NULL AS [billing!2!payto-street-2],
		NULL AS [billing!2!payto-city],
		NULL AS [billing!2!payto-state],
		NULL AS [billing!2!payto-zip],
		NULL AS [billing!2!payto-ein],

		TT.ANSIReferenceIdentificationQualifier AS [secondaryident!9!payto-id-qualifier],
		TT.GroupNumber AS [secondaryident!9!payto-provider-id],

		NULL AS [subscriber!3!subscriber-id],
		NULL AS [subscriber!3!encounter-id],
		NULL AS [subscriber!3!first-name],
		NULL AS [subscriber!3!middle-name],
		NULL AS [subscriber!3!last-name],
		NULL AS [subscriber!3!suffix],
		NULL AS [subscriber!3!insured-different-than-patient-flag],
		NULL AS [subscriber!3!payer-responsibility-code],
		NULL AS [subscriber!3!plan-name],
		NULL AS [subscriber!3!group-number],
		NULL AS [subscriber!3!policy-number],
		NULL AS [subscriber!3!payer-name],
		NULL AS [subscriber!3!payer-identifier],
		NULL AS [subscriber!3!payer-street-1],
		NULL AS [subscriber!3!payer-street-2],
		NULL AS [subscriber!3!payer-city],
		NULL AS [subscriber!3!payer-state],
		NULL AS [subscriber!3!payer-zip],
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
		NULL AS [subscriber!3!claim-filing-indicator-code],
		NULL AS [patient!4!patient-id],
		NULL AS [patient!4!relation-to-insured-code],
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
		NULL AS [patient!4!birth-date],
		NULL AS [patient!4!gender],
		NULL AS [claim!5!claim-id],
		NULL AS [claim!5!control-number],
		NULL AS [claim!5!total-claim-amount],
		NULL AS [claim!5!place-of-service-code],
		NULL AS [claim!5!provider-signature-flag],
		NULL AS [claim!5!medicare-assignment-code],
		NULL AS [claim!5!assignment-of-benefits-flag],
		NULL AS [claim!5!release-of-information-code],
		NULL AS [claim!5!patient-signature-source-code],
		NULL AS [claim!5!auto-accident-related-flag],
		NULL AS [claim!5!abuse-related-flag],
		NULL AS [claim!5!pregnancy-related-flag],
		NULL AS [claim!5!employment-related-flag],
		NULL AS [claim!5!other-accident-related-flag],
		NULL AS [claim!5!auto-accident-state],
		NULL AS [claim!5!special-program-code],
		NULL AS [claim!5!initial-treatment-date],
		NULL AS [claim!5!last-menstrual-date],
		NULL AS [claim!5!referral-date],
		NULL AS [claim!5!last-seen-date],
		NULL AS [claim!5!current-illness-date],
		NULL AS [claim!5!acute-manifestation-date],
		NULL AS [claim!5!similar-illness-date],
		NULL AS [claim!5!accident-date],
		NULL AS [claim!5!last-xray-date],
		NULL AS [claim!5!disability-begin-date],
		NULL AS [claim!5!disability-end-date],
		NULL AS [claim!5!last-worked-date],
		NULL AS [claim!5!return-to-work-date],
		NULL AS [claim!5!hospitalization-begin-date],
		NULL AS [claim!5!hospitalization-end-date],
		NULL AS [claim!5!patient-paid-amount],
		NULL AS [claim!5!authorization-number],
		NULL AS [claim!5!referral-number],
		NULL AS [claim!5!diagnosis-1],
		NULL AS [claim!5!diagnosis-2],
		NULL AS [claim!5!diagnosis-3],
		NULL AS [claim!5!diagnosis-4],
		NULL AS [claim!5!diagnosis-5],
		NULL AS [claim!5!diagnosis-6],
		NULL AS [claim!5!diagnosis-7],
		NULL AS [claim!5!diagnosis-8],
		NULL AS [claim!5!clia-number],
		NULL AS [claim!5!referring-provider-flag],
		NULL AS [claim!5!referring-provider-first-name],
		NULL AS [claim!5!referring-provider-middle-name],
		NULL AS [claim!5!referring-provider-last-name],
		NULL AS [claim!5!referring-provider-suffix],
		NULL AS [claim!5!referring-provider-upin],
		NULL AS [claim!5!supervising-provider-flag],
		NULL AS [claim!5!supervising-provider-first-name],
		NULL AS [claim!5!supervising-provider-middle-name],
		NULL AS [claim!5!supervising-provider-last-name],
		NULL AS [claim!5!supervising-provider-suffix],
		NULL AS [claim!5!supervising-provider-ssn-qual],
		NULL AS [claim!5!supervising-provider-ssn],
		NULL AS [claim!5!supervising-provider-upin],
		NULL AS [claim!5!supervising-provider-id-qualifier],
		NULL AS [claim!5!supervising-provider-id-number],
		NULL AS [claim!5!rendering-provider-first-name],
		NULL AS [claim!5!rendering-provider-middle-name],
		NULL AS [claim!5!rendering-provider-last-name],
		NULL AS [claim!5!rendering-provider-suffix],
		NULL AS [claim!5!rendering-provider-ssn-qual],
		NULL AS [claim!5!rendering-provider-ssn],
		NULL AS [claim!5!rendering-provider-upin],
		NULL AS [claim!5!rendering-provider-specialty-code],
		NULL AS [claim!5!service-facility-name],
		NULL AS [claim!5!service-facility-street-1],
		NULL AS [claim!5!service-facility-street-2],
		NULL AS [claim!5!service-facility-city],
		NULL AS [claim!5!service-facility-state],
		NULL AS [claim!5!service-facility-zip],
		NULL AS [claim!5!service-facility-id],
		NULL AS [claim!5!service-facility-id-qualifier],
		NULL AS [claim!5!claim-note-code],
		NULL AS [claim!5!claim-note],
		NULL AS [claim!5!ambulance-transport-flag],
		NULL AS [claim!5!ambulance-patient-weight],
		NULL AS [claim!5!ambulance-code],
		NULL AS [claim!5!ambulance-reason-code],
		NULL AS [claim!5!ambulance-distance],
		NULL AS [claim!5!ambulance-address-pickup],
		NULL AS [claim!5!ambulance-address-dropoff],
		NULL AS [claim!5!ambulance-purpose-roundtrip],
		NULL AS [claim!5!ambulance-purpose-stretcher],
		NULL AS [claim!5!ambulance-condition-1],
		NULL AS [claim!5!ambulance-condition-2],
		NULL AS [claim!5!ambulance-condition-3],
		NULL AS [claim!5!ambulance-condition-4],
		NULL AS [claim!5!ambulance-condition-5],
		NULL AS [renderingprovidernumbers!10!rendering-provider-id-qualifier],
		NULL AS [renderingprovidernumbers!10!rendering-provider-provider-id],
		NULL AS [referringprovidernumbers!11!referring-provider-id-qualifier],
		NULL AS [referringprovidernumbers!11!referring-provider-provider-id],
		NULL AS [secondary!6!secondary-id],
		NULL AS [secondary!6!insured-different-than-patient-flag],
		NULL AS [secondary!6!subscriber-first-name],
		NULL AS [secondary!6!subscriber-middle-name],
		NULL AS [secondary!6!subscriber-last-name],
		NULL AS [secondary!6!subscriber-suffix],
		NULL AS [secondary!6!subscriber-street-1],
		NULL AS [secondary!6!subscriber-street-2],
		NULL AS [secondary!6!subscriber-city],
		NULL AS [secondary!6!subscriber-state],
		NULL AS [secondary!6!subscriber-zip],
		NULL AS [secondary!6!subscriber-birth-date],
		NULL AS [secondary!6!subscriber-gender],
		NULL AS [secondary!6!relation-to-insured-code],
		NULL AS [secondary!6!payer-responsibility-code],
		NULL AS [secondary!6!plan-name],
		NULL AS [secondary!6!group-number],
		NULL AS [secondary!6!policy-numer],
		NULL AS [secondary!6!payer-name],
		NULL AS [secondary!6!payer-identifier],
		NULL AS [secondary!6!payer-contact-name],
		NULL AS [secondary!6!payer-contact-phone],
		NULL AS [secondary!6!payer-paid-flag],
		NULL AS [secondary!6!payer-paid-amount],
		NULL AS [service!7!service-id],
		NULL AS [service!7!control-number],
		NULL AS [service!7!procedure-code],
		NULL AS [service!7!service-date],
		NULL AS [service!7!service-charge-amount],
		NULL AS [service!7!service-unit-count],
		NULL AS [service!7!place-of-service-code],
		NULL AS [service!7!procedure-modifier-1],
		NULL AS [service!7!procedure-modifier-2],
		NULL AS [service!7!procedure-modifier-3],
		NULL AS [service!7!procedure-modifier-4],
		NULL AS [service!7!diagnosis-pointer-1],
		NULL AS [service!7!diagnosis-pointer-2],
		NULL AS [service!7!diagnosis-pointer-3],
		NULL AS [service!7!diagnosis-pointer-4],
		NULL AS [service!7!dme-flag],
		NULL AS [service!7!ordering-provider-first-name],
		NULL AS [service!7!ordering-provider-middle-name],
		NULL AS [service!7!ordering-provider-last-name],
		NULL AS [service!7!ordering-provider-suffix],
		NULL AS [service!7!ordering-provider-ssn-qual],
		NULL AS [service!7!ordering-provider-ssn],
		NULL AS [service!7!ordering-provider-upin],
		NULL AS [service!7!ordering-provider-addressline1],
		NULL AS [service!7!ordering-provider-addressline2],
		NULL AS [service!7!ordering-provider-city],
		NULL AS [service!7!ordering-provider-state],
		NULL AS [service!7!ordering-provider-zipcode],
		NULL AS [service!7!ordering-provider-phone],
		NULL AS [service!7!service-note-code],
		NULL AS [service!7!service-note],
		NULL AS [adjudication!8!adjudication-id],
		NULL AS [adjudication!8!payer-identifier],
		NULL AS [adjudication!8!paid-amount],
		NULL AS [adjudication!8!paid-unit-count],
		NULL AS [adjudication!8!paid-date],
		NULL AS [adjudication!8!payer-adjusted-flag],
		NULL AS [adjudication!8!adjustment-reason-1],
		NULL AS [adjudication!8!adjustment-amount-1],
		NULL AS [adjudication!8!adjustment-reason-2],
		NULL AS [adjudication!8!adjustment-amount-2],
		NULL AS [adjudication!8!adjustment-reason-3],
		NULL AS [adjudication!8!adjustment-amount-3],
		NULL AS [adjudication!8!adjustment-reason-4],
		NULL AS [adjudication!8!adjustment-amount-4],
		NULL AS [adjudication!8!adjustment-reason-5],
		NULL AS [adjudication!8!adjustment-amount-5],
		NULL AS [adjudication!8!adjustment-reason-6],
		NULL AS [adjudication!8!adjustment-amount-6]

		FROM	@t_groupnumbers TT

	-- END OF BILLING PROVIDER SECONDARY IDENTIFICATION


	ORDER BY [transaction!1!transaction-id],
		[transaction!1!control-number],
		[billing!2!billing-id], 
		[subscriber!3!subscriber-id], 
		[subscriber!3!encounter-id], 
		[patient!4!patient-id], 
		[claim!5!claim-id], 
		[secondary!6!secondary-id], 
		[service!7!service-id], 
		[adjudication!8!adjudication-id],
		[secondaryident!9!id-qualifier]

	FOR XML EXPLICIT

	-- clean-up:

	DELETE @t_groupnumbers
	DELETE @t_providernumbers
	DELETE @t_refprovidernumbers
	DELETE @t_supprovidernumbers
	DELETE @t_ambulancecertification

	DROP TABLE #ClaimBatchDiagnosesPointers

END
GO


