set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


--===========================================================================
-- GET ENCOUNTER FORM XML
-- AppointmentDataProvider_GetEncounterFormXml 94369, 7
--===========================================================================
ALTER PROCEDURE [dbo].[AppointmentDataProvider_GetEncounterFormXml]
	@DocumentID INT,
	@EncounterTemplateID INT,
	@ProviderID INT = NULL
AS
BEGIN

/************************************************************************************************
	Declare 'constants'
************************************************************************************************/
	DECLARE @DefaultEncounterFormTypeID int
	SET	@DefaultEncounterFormTypeID = 2		-- Default to the two page encounter form

	DECLARE @form_name varchar(32)
	SET	@form_name = 'EncounterForm'

	DECLARE	@PrintingFormID INT
	SET	@PrintingFormID = 9				-- Encounter Form

	DECLARE	@PrintingFormDetailsOnePageID INT
	SET	@PrintingFormDetailsOnePageID = 12		-- Encounter Form (One Page)

	DECLARE	@PrintingFormDetailsTwoPage1ID INT
	SET	@PrintingFormDetailsTwoPage1ID = 13		-- Encounter Form (Two Page) - Page 1

	DECLARE	@PrintingFormDetailsTwoPage2ID INT
	SET	@PrintingFormDetailsTwoPage2ID = 14		-- Encounter Form (Two Page) - Page 2

	DECLARE	@PrintingFormDetailsV2TwoPage1ID INT
	SET	@PrintingFormDetailsV2TwoPage1ID = 17	-- Encounter Form Version 2 (Two Page) - Page 1

	DECLARE	@PrintingFormDetailsV2TwoPage2ID INT
	SET	@PrintingFormDetailsV2TwoPage2ID = 18	-- Encounter Form Version 2 (Two Page) - Page 2

/************************************************************************************************
	Extract data from xml passed in
************************************************************************************************/
	-- Get the appointment date and encounter template to use for this document
	DECLARE	@AppointmentID INT
	DECLARE @EncounterFormTypeID INT
	DECLARE @TimezoneOffset INT
	DECLARE @PracticeID INT
	DECLARE @AppointmentStartDate DATETIME
	DECLARE @SelectionXML VARCHAR(8000)

	SELECT	@PracticeID = PracticeID,
		@SelectionXML = DocumentParameters
	FROM	Document
	WHERE	DocumentID = @DocumentID

	DECLARE @x_doc INT
	EXEC sp_xml_preparedocument @x_doc OUTPUT, @SelectionXML

	SELECT	@AppointmentID = S.AppointmentID,
		@AppointmentStartDate = S.StartDate, 
		@EncounterFormTypeID = CASE WHEN EFT.EncounterFormTypeID IS NULL THEN @DefaultEncounterFormTypeID ELSE EFT.EncounterFormTypeID END, 
		@TimezoneOffset = CASE WHEN S.TimezoneOffset IS NULL THEN 0 ELSE s.TimezoneOffset END
	FROM	OPENXML(@x_doc, 'selection')
	WITH (	AppointmentID INT,
		StartDate DATETIME, 
		TimezoneOffset INT) S
	LEFT OUTER JOIN
		EncounterTemplate ET
	ON	   ET.EncounterTemplateID = @EncounterTemplateID
	LEFT OUTER JOIN
		EncounterFormType EFT
	ON	   EFT.EncounterFormTypeID = ET.EncounterFormTypeID

	EXEC sp_xml_removedocument @x_doc

/************************************************************************************************
	Create temp tables
************************************************************************************************/
	-- Create tables necessary for the results
	CREATE TABLE #t_result(
			TID int identity(1,1),
			XMLText text)

	CREATE TABLE #t_procedurecategoryassociation(
			TID int identity(1,1),
			ProcedureCategoryID int,
			ProcedureCategoryName varchar(64))

	CREATE TABLE #t_procedurecategory(
			ProcedureCategoryName varchar(64))

	CREATE TABLE #t_procedurecode(
			ProcedureCategory int,
			ProcedureCode varchar(32),
			ProcedureName varchar(300))

	CREATE TABLE #t_diagnosiscategoryassociation(
			TID int identity(1,1),
			DiagnosisCategoryID int,
			DiagnosisCategoryName varchar(64))

	CREATE TABLE #t_diagnosiscategory(
			DiagnosisCategoryName varchar(64))

	CREATE TABLE #t_diagnosiscode(
			DiagnosisCategory int,
			DiagnosisCode varchar(16),
			DiagnosisName varchar(300))

/************************************************************************************************
	Get Patient Related Info
************************************************************************************************/
DECLARE @CurrentDate DATETIME
SET @CurrentDate=GETDATE()

IF @AppointmentID is NOT NULL
BEGIN
	
	--PATIENT INFO
	DECLARE @PatientInfo TABLE(PatientID INT, PatientName VARCHAR(200), AddressLine1 VARCHAR(256),
				   AddressLine2 VARCHAR(256), CityStateZip VARCHAR(139),
				   ResponsiblePerson VARCHAR(200), DOB VARCHAR(10), HomePhone VARCHAR(20), WorkPhone VARCHAR(20), 
				   Gender VARCHAR(1))
	INSERT @PatientInfo(PatientID, PatientName, AddressLine1, AddressLine2, CityStateZip, 
			    ResponsiblePerson, DOB, HomePhone, WorkPhone, Gender)
	SELECT P.PatientID, 
	       dbo.fn_FormatFirstMiddleLast(FirstName, MiddleName, LastName) PatientName,
	       ISNULL(AddressLine1,'') AddressLine1, ISNULL(AddressLine2,'') AddressLine2, dbo.fn_FormatCityStateZip(City, State, ZipCode) CityStateZip, 
	       ISNULL(CASE WHEN ResponsibleDifferentThanPatient=1
		    THEN dbo.fn_FormatFirstMiddleLast(ResponsibleFirstName, ResponsibleMiddleName, ResponsibleLastName) END, '') ResponsiblePerson,
	       ISNULL(CONVERT(CHAR(10),DOB,101),'') DOB, ISNULL(dbo.fn_FormatPhone(HomePhone),'') HomePhone, ISNULL(dbo.fn_FormatPhone(WorkPhone), '') WorkPhone, 
	       P.Gender
	FROM Patient P INNER JOIN Appointment APP ON P.PatientID=APP.PatientID
	WHERE AppointmentID=@AppointmentID

	--PATIENT INSURANCE INFO
	--Define Insurance Precedence based upon existing precedence value
	DECLARE @PatIns TABLE(RID INT IDENTITY(1,1), PatientID INT, PlanName VARCHAR(128),Precedence INT, Copay MONEY, Deductible MONEY)
	INSERT @PatIns(PatientID, PlanName, Precedence, Copay, Deductible)
	SELECT App.PatientID, PlanName, Precedence, IP.Copay, IP.Deductible
	FROM Appointment App INNER JOIN InsurancePolicy IP ON App.PatientCaseID=IP.PatientCaseID
	INNER JOIN InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	WHERE AppointmentID=@AppointmentID AND Active = 1 AND (PolicyEndDate >= @CurrentDate OR PolicyEndDate IS NULL)
	ORDER BY Precedence 

	--Update Primary
	DECLARE @PatInsPrec TABLE(PatientID INT, PrimaryIns VARCHAR(128), SecondaryIns VARCHAR(128), Copay MONEY, Deductible MONEY, MRID INT)
	INSERT @PatInsPrec(PatientID, PrimaryIns, Copay, Deductible, MRID)
	SELECT PatI.PatientID, PatI.PlanName PrimaryIns,  Copay, Deductible, MRID
	FROM @PatIns PatI INNER JOIN (SELECT PatientID, MIN(RID) MRID
				      FROM @PatIns
				      GROUP BY PatientID) PrimaryIns 
	ON PatI.PatientID=PrimaryIns.PatientID AND PatI.RID=PrimaryIns.MRID
	
	--Remove those insurances already labeled as primary
	DELETE @PatIns
	FROM @PatIns PatI INNER JOIN @PatInsPrec PatIP ON PatI.RID=PatIP.MRID
	
	--Update Secondary
	UPDATE @PatInsPrec SET SecondaryIns=UpdList.PlanName
	FROM @PatInsPrec PatIP INNER JOIN 
	(SELECT PatI.PatientID, PatI.PlanName
	FROM @PatIns PatI INNER JOIN (SELECT PatientID, MIN(RID) MRID
				      FROM @PatIns
				      GROUP BY PatientID) SecondaryIns
	ON PatI.PatientID=SecondaryIns.PatientID AND PatI.RID=SecondaryIns.MRID) UpdList
	ON PatIP.PatientID=UpdList.PatientID
	
	--APPOINTMENT INFO
	--Get Appointment Reason
	DECLARE @AppReason TABLE(PatientID INT, Reason VARCHAR(256))
	INSERT @AppReason(PatientID, Reason)
	SELECT PatientID,  AR.Name Reason
	FROM Appointment A INNER JOIN AppointmentToAppointmentReason ATAR
	ON A.AppointmentID=ATAR.AppointmentID
	INNER JOIN AppointmentReason AR ON ATAR.AppointmentReasonID=AR.AppointmentReasonID
	WHERE A.AppointmentID=@AppointmentID AND PrimaryAppointment=1
	
	--Get Appointment Provider
	DECLARE @AppProvider TABLE(RID INT IDENTITY(1,1),PatientID INT, ProviderID INT, Provider VARCHAR(230))
	INSERT @AppProvider(PatientID, ProviderID, Provider)
	SELECT App.PatientID, ResourceID ProviderID, CASE WHEN Prefix='' THEN '' ELSE Prefix+' ' END+
	FirstName+CASE WHEN MiddleName='' THEN ' ' ELSE ' '+MiddleName+' ' END+
	LastName+CASE WHEN Suffix='' THEN '' ELSE ' '+Suffix END+ CASE WHEN ISNULL(Degree,'')='' THEN '' ELSE ' '+Degree END  Provider
	FROM Appointment APP INNER JOIN AppointmentToResource ATR ON APP.AppointmentID=ATR.AppointmentID
	INNER JOIN Doctor D ON ATR.ResourceID=D.DoctorID
	WHERE App.AppointmentID=@AppointmentID
	AND APP.AppointmentResourceTypeID=1 AND PatientID IS NOT NULL
	Order By AppointmentToResourceID

	DECLARE @OverrideProvider VARCHAR(230)
	SELECT @OverrideProvider=Provider
	FROM @AppProvider
	WHERE ProviderID=@ProviderID
	
	--Assure only 1st listed Provider is returned, delete other records of providers listed as App resources
	DELETE @AppProvider
	FROM @AppProvider AP LEFT JOIN 
	(SELECT PatientID, MIN(RID) MinRID FROM @AppProvider GROUP BY PatientID) FP
	ON AP.PatientID=FP.PatientID AND AP.RID=FP.MinRID
	WHERE FP.MinRID IS NULL
	
	--Get Other Appointment Info
	DECLARE @AppOther TABLE(PatientID INT, AppDateTime DATETIME, POS VARCHAR(128), RefProvider VARCHAR(230))
	INSERT @AppOther(PatientID, AppDateTime, POS, RefProvider)
	SELECT APP.PatientID, 
	CASE WHEN @AppointmentStartDate IS NULL THEN DATEADD(hour, @TimezoneOffset, StartDate) ELSE DATEADD(hour, @TimezoneOffset, @AppointmentStartDate) END AS AppDateTime, 
	SL.Name POS, 
	CASE WHEN RP.Prefix='' THEN '' ELSE RP.Prefix+' ' END+
	RP.FirstName+CASE WHEN RP.MiddleName='' THEN ' ' ELSE ' '+RP.MiddleName+' ' END+
	RP.LastName+CASE WHEN RP.Suffix='' THEN '' ELSE ' '+RP.Suffix END+ CASE WHEN ISNULL(Degree,'')='' THEN '' ELSE ' '+Degree END RefProvider
	FROM Appointment APP INNER JOIN ServiceLocation SL ON APP.ServiceLocationID=SL.ServiceLocationID
	INNER JOIN Patient P ON APP.PatientID=P.PatientID LEFT JOIN ReferringPhysician RP
	ON P.ReferringPhysicianID=RP.ReferringPhysicianID
	WHERE APP.AppointmentID=@AppointmentID
	
	--PATIENT BALANCES AND PAYMENT DATE INFO
	--Get Patient Account Balances

	DECLARE @Balances TABLE(PracticeID INT, PatientID INT, ClaimID INT, Amount MONEY)
	INSERT @Balances(PracticeID, PatientID, ClaimID, Amount)
	SELECT CA.PracticeID, CA.PatientID, ClaimID, 
	SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN -1*Amount ELSE Amount END) Amount
	FROM ClaimAccounting CA INNER JOIN Appointment A ON CA.PracticeID=A.PracticeID AND CA.PatientID=A.PatientID
	WHERE AppointmentID=@AppointmentID AND Status=0
	GROUP BY CA.PracticeID, CA.PatientID, ClaimID
	
	DECLARE @SumBalances TABLE(PatientID INT, InsBalance MONEY, PatientBalance MONEY)
	INSERT @SumBalances(PatientID, InsBalance, PatientBalance)
	SELECT B.PatientID, 
	SUM(CASE WHEN InsurancePolicyID IS NOT NULL THEN Amount ELSE 0 END) InsBalance,
	SUM(CASE WHEN InsurancePolicyID IS NULL THEN Amount ELSE 0 END) PatientBalance
	FROM @Balances B INNER JOIN ClaimAccounting_Assignments CAA ON B.PracticeID=CAA.PracticeID 
	AND B.PatientID=CAA.PatientID AND B.ClaimID=CAA.ClaimID
	WHERE Status=0 AND LastAssignment=1
	GROUP BY B.PatientID

	DECLARE @Patients TABLE(PracticeID INT, PatientID INT)
	INSERT @Patients(PracticeID, PatientID)
	SELECT DISTINCT PracticeID, PatientID FROM @Balances
	
	--Get Last Payment Dates on Patient Accounts
	DECLARE @Payments TABLE(PatientID INT, LastInsPay DATETIME, LastPatientPay DATETIME)
	INSERT @Payments(PatientID, LastInsPay, LastPatientPay)
	SELECT PatientID, MAX(CASE WHEN PayerTypeCode='I' THEN PostingDate ELSE NULL END) LastInsPay,
	MAX(CASE WHEN PayerTypeCode='P' THEN PostingDate ELSE NULL END) LastPatientPay
	FROM (
	SELECT Pays.PatientID, PayerTypeCode, PostingDate
	FROM ClaimAccounting CA INNER JOIN (
	SELECT ICA.PatientID, PayerTypeCode, Max(PCT.ClaimTransactionID) MaxID
	FROM Payment P INNER JOIN PaymentClaimTransaction PCT ON P.PaymentID=PCT.PaymentID
	INNER JOIN ClaimAccounting ICA ON PCT.ClaimtransactionID=ICA.ClaimTransactionID
	INNER JOIN @Patients Pat ON ICA.PracticeID=Pat.PracticeID AND ICA.PatientID=Pat.PatientID
	WHERE ClaimTransactionTypeCode='PAY'
	GROUP BY ICA.PatientID, PayerTypeCode) Pays
	ON CA.ClaimTransactionID=Pays.MaxID) PayDates
	GROUP BY PatientID


	SELECT 	PInfo.PatientID, PatientName, AddressLine1, AddressLine2, CityStateZip, ResponsiblePerson, DOB, HomePhone, G.LongName as Gender, 
		CONVERT(CHAR(10), DOB, 101) + ', ' + CONVERT(VARCHAR(3), dbo.fn_GetAge(DOB, getdate())) as DOBAge, 
		CASE WHEN len(HomePhone) > 0 AND len(WorkPhone) > 0 THEN
			HomePhone + ' (home), ' + WorkPhone + ' (work)'
		     WHEN len(HomePhone) > 0 THEN
			HomePhone + ' (home)'
		     WHEN len(WorkPhone) > 0 THEN
			WorkPhone + ' (work)' 
		END as FullPhone, 
	       	PrimaryIns, SecondaryIns, dbo.fn_FormatDateTime(AO.AppDateTime) as AppDateTime, POS, RefProvider, ISNULL(@OverrideProvider,Provider) Provider, Reason, 
		LEFT(PrimaryIns, 50) + ' - Copay: $' + CONVERT(VARCHAR(12),Copay,1) as PrimaryInsWithCopay, 
	       	'$' + CONVERT(VARCHAR(12),InsBalance,1) as InsBalance, 
	       	'$' + CONVERT(VARCHAR(12),PatientBalance,1) as PatientBalance, 
		CONVERT(CHAR(10),LastInsPay,101) as LastInsPay, 
		CONVERT(CHAR(10),LastPatientPay,101) as LastPatientPay, 
		'$' + CONVERT(VARCHAR(12),Copay,1) as Copay, 
		'$' + CONVERT(VARCHAR(12),Deductible,1) as Deductible
	INTO #t_patientinfo
	FROM @PatientInfo PInfo LEFT JOIN @PatInsPrec PIP ON PInfo.PatientID=PIP.PatientID
	LEFT JOIN @AppOther AO ON PInfo.PatientID=AO.PatientID
	LEFT JOIN @AppProvider AP ON PInfo.PatientID=AP.PatientID
	LEFT JOIN @AppReason AR ON PInfo.PatientID=AR.PatientID
	LEFT JOIN @SumBalances SB ON PInfo.PatientID=SB.PatientID
	LEFT JOIN @Payments P ON PInfo.PatientID=P.PatientID
	LEFT JOIN Gender G ON G.Gender = PInfo.Gender
END

/************************************************************************************************
	Get Practice Related Info
************************************************************************************************/
	DECLARE @TemplateName VARCHAR(150)

	IF @EncounterTemplateID<>0
	BEGIN
		SELECT @TemplateName=Name
		FROM EncounterTemplate
		WHERE EncounterTemplateID=@EncounterTemplateID
	END
	ELSE
		SET @TemplateName=''


	SELECT 	upper(Name) as PracticeName,
		dbo.fn_FormatAddress(AddressLine1, AddressLine2, City, State, ZipCode) 	as PracticeAddress, 
		'Tel: '+dbo.fn_FormatPhone(Phone)+', Fax: '+dbo.fn_FormatPhone(Fax) 	as PracticePhoneFax,
		'Tax ID: ' + left(EIN, 2) + '-' + right(EIN, len(EIN) - 2) 		as PracticeTaxID, 
		'ENCOUNTER FORM - ' + @TemplateName 					as TemplateName,
		@TemplateName + ' - ' + Name 						as FullPracticeName,
		dbo.fn_FormatAddress(AddressLine1, AddressLine2, City, State, ZipCode) + ' - ' +
			'Phone: '+dbo.fn_FormatPhone(Phone)+', Fax: '+dbo.fn_FormatPhone(Fax) + ' - ' + 
			'Tax ID: ' + left(EIN, 2) + '-' + right(EIN, len(EIN) - 2)	as FullPracticeAddress
							
	INTO #t_practiceinfo
	FROM Practice
	WHERE PracticeID=@PracticeID

/************************************************************************************************
	Handle Procedure Categories
************************************************************************************************/
	-- Get the procedure category association
	INSERT	#t_procedurecategoryassociation(
		ProcedureCategoryID,
		ProcedureCategoryName)
	SELECT	ProcedureCategoryID, 
		Name
	FROM	ProcedureCategory
	WHERE	EncounterTemplateID = @EncounterTemplateID

	-- Insert the categories into temp table that will be converted to xml
	INSERT	#t_procedurecategory(
		ProcedureCategoryName)
	SELECT	ProcedureCategoryName
	FROM	#t_procedurecategoryassociation
	ORDER BY
		TID

	INSERT	#t_procedurecode(
		ProcedureCategory,
		ProcedureCode,
		ProcedureName)
	SELECT	PCA.TID,
		PCD.ProcedureCode,
		ISNULL(PCD.LocalName,PCD.OfficialName) ProcedureName
	FROM	#t_procedurecategoryassociation PCA
	INNER JOIN
		ProcedureCategoryToProcedureCodeDictionary PC
	ON	   PC.ProcedureCategoryID = PCA.ProcedureCategoryID
	INNER JOIN
		ProcedureCodeDictionary PCD
	ON	   PCD.ProcedureCodeDictionaryID = PC.ProcedureCodeDictionaryID
	ORDER BY
		PCA.TID,
		PCD.ProcedureCode

/************************************************************************************************
	Handle Diagnosis Categories
************************************************************************************************/
	-- Get the diagnosis category association
	INSERT	#t_diagnosiscategoryassociation(
		DiagnosisCategoryID,
		DiagnosisCategoryName)
	SELECT	DiagnosisCategoryID, 
		Name
	FROM	DiagnosisCategory
	WHERE	EncounterTemplateID = @EncounterTemplateID

	-- Insert the categories into temp table that will be converted to xml
	INSERT	#t_diagnosiscategory(
		DiagnosisCategoryName)
	SELECT	DiagnosisCategoryName
	FROM	#t_diagnosiscategoryassociation
	ORDER BY
		TID

	INSERT	#t_diagnosiscode(
		DiagnosisCategory,
		DiagnosisCode,
		DiagnosisName)
	SELECT	DCA.TID,
		DCD.DiagnosisCode,
		ISNULL(DCD.LocalName,DCD.OfficialName) DiagnosisName
	FROM	#t_diagnosiscategoryassociation DCA
	INNER JOIN
		DiagnosisCategoryToDiagnosisCodeDictionary DC
	ON	   DC.DiagnosisCategoryID = DCA.DiagnosisCategoryID
	INNER JOIN
		DiagnosisCodeDictionary DCD
	ON	   DCD.DiagnosisCodeDictionaryID = DC.DiagnosisCodeDictionaryID
	ORDER BY
		DCA.TID, 
		ISNULL(DCD.LocalName,DCD.OfficialName)

/************************************************************************************************
	Handle Creation of XML depending on the Form Type
************************************************************************************************/
	DECLARE @ResultID int
	DECLARE @PrintingFormDetailsID int

	-- Create the xml and return data based on the encounter form chosen
	IF @EncounterFormTypeID = 1
	BEGIN
		-- Create the XML for the one page version with procedures and diagnoses
		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_practiceinfo', @DestinationName='#t_result', @FormID=@form_name, @ADDRoot=1, @CloseRoot=0
		SET @ResultID=@@IDENTITY

		IF @AppointmentID is NOT NULL
			EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_patientinfo', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=0

		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_procedurecategory', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=0

		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_procedurecode', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=0

		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_diagnosiscategory', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=0

		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_diagnosiscode', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=1

		INSERT INTO #ReturnData(PrintingFormID, PrintingFormDetailsID, XMLText)
		SELECT @PrintingFormID, @PrintingFormDetailsOnePageID, XMLText
		FROM #t_result

	END
	ELSE IF @EncounterFormTypeID IN(2, 4)
	BEGIN
		-- Create the XML for the two page version with procedures and diagnoses
		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_practiceinfo', @DestinationName='#t_result', @FormID=@form_name, @ADDRoot=1, @CloseRoot=0
		SET @ResultID=@@IDENTITY

		IF @AppointmentID is NOT NULL
			EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_patientinfo', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=0

		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_procedurecategory', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=0

		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_procedurecode', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=1

		-- Get the correct form details id to use
		IF @EncounterFormTypeID = 2
		BEGIN
			SET @PrintingFormDetailsID = @PrintingFormDetailsTwoPage1ID
		END
		ELSE IF @EncounterFormTypeID = 4
		BEGIN
			SET @PrintingFormDetailsID = @PrintingFormDetailsV2TwoPage1ID
		END

		INSERT INTO #ReturnData(PrintingFormID, PrintingFormDetailsID, XMLText)
		SELECT @PrintingFormID, @PrintingFormDetailsID, XMLText
		FROM #t_result
		WHERE TID=@ResultID	

		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_diagnosiscategory', @DestinationName='#t_result', @FormID=@form_name, @ADDRoot=1, @CloseRoot=0
		SET @ResultID=@@IDENTITY

		IF @AppointmentID is NOT NULL
			EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_patientinfo', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=0

		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_diagnosiscode', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=1

		-- Get the correct form details id to use
		IF @EncounterFormTypeID = 2
		BEGIN
			SET @PrintingFormDetailsID = @PrintingFormDetailsTwoPage2ID
		END
		ELSE IF @EncounterFormTypeID = 4
		BEGIN
			SET @PrintingFormDetailsID = @PrintingFormDetailsV2TwoPage2ID
		END

		INSERT INTO #ReturnData(PrintingFormID, PrintingFormDetailsID, XMLText)
		SELECT @PrintingFormID, @PrintingFormDetailsID, XMLText
		FROM #t_result
		WHERE TID=@ResultID

	END
	ELSE IF @EncounterFormTypeID IN(3, 5)
	BEGIN
		-- Create the XML for the one page version with procedures only
		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_practiceinfo', @DestinationName='#t_result', @FormID=@form_name, @ADDRoot=1, @CloseRoot=0
		SET @ResultID=@@IDENTITY

		IF @AppointmentID is NOT NULL
			EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_patientinfo', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=0

		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_procedurecategory', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=0

		EXEC BusinessRuleEngine_SVGXMLExtractor @TableName='#t_procedurecode', @DestinationName='#t_result', @FormID=@form_name, @DestinationID=@ResultID, @ADDRoot=0, @CloseRoot=1

		-- Get the correct form details id to use
		IF @EncounterFormTypeID = 3
		BEGIN
			SET @PrintingFormDetailsID = @PrintingFormDetailsTwoPage1ID
		END
		ELSE IF @EncounterFormTypeID = 5
		BEGIN
			SET @PrintingFormDetailsID = @PrintingFormDetailsV2TwoPage1ID
		END

		INSERT INTO #ReturnData(PrintingFormID, PrintingFormDetailsID, XMLText)
		SELECT @PrintingFormID, @PrintingFormDetailsID, XMLText
		FROM #t_result

	END

/************************************************************************************************
	Clean Up
************************************************************************************************/
/*	
	SELECT * FROM #t_result
	IF @AppointmentID is NOT NULL
		SELECT * FROM #t_patientinfo
	SELECT * FROM #t_practiceinfo
	SELECT * FROM #t_procedurecategory
	SELECT * FROM #t_procedurecode
	SELECT * FROM #t_diagnosiscategory
	SELECT * FROM #t_diagnosiscode
*/
	DROP TABLE #t_result
	DROP TABLE #t_practiceinfo
	DROP TABLE #t_procedurecategoryassociation
	DROP TABLE #t_procedurecategory
	DROP TABLE #t_procedurecode
	DROP TABLE #t_diagnosiscategoryassociation
	DROP TABLE #t_diagnosiscategory
	DROP TABLE #t_diagnosiscode

	IF @AppointmentID is NOT NULL
		DROP TABLE #t_patientinfo

END

