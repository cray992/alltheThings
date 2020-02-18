USE superbill_7268_dev
GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @PracticeID INT
SET @PracticeID = 1


-- Insurance / Insurance Plan Data
SELECT 
	IC.InsuranceCompanyID, 
	IC.InsuranceCompanyName, 
	IC.AddressLine1 AS 'AddressLine1', 
	IC.AddressLine2 AS 'AddressLine2', 
	IC.City AS 'City', 
	IC.[State] AS 'State',  
	IC.Country AS 'Country',  
	IC.ZipCode AS 'ZipCode',  
	CASE IC.ReviewCode 
		WHEN 'R' THEN 'FALSE' 
		ELSE 'TRUE'
	END AS 'InsuranceCompanyPracticeSpecific',
	IC.CreatedPracticeID AS 'InsuranceCompanyCreatedPracticeID',
	ICP.InsuranceCompanyPlanID,
	ICP.PlanName,
	ICP.AddressLine1 AS 'AddressLine11',
	ICP.AddressLine2 AS 'AddressLine21',
	ICP.City AS 'City1',
	ICP.[State] AS 'State1',
	ICP.Country AS 'Country1',
	ICP.ZipCode AS 'ZipCode1',
	ICP.InsuranceCompanyID AS 'InsuranceCompanyID1',
	CASE ICP.ReviewCode 
		WHEN 'R' THEN 'FALSE' 
		ELSE 'TRUE'
	END AS 'InsurancePlanPracticeSpecific',
	ICP.CreatedPracticeID
FROM dbo.InsuranceCompanyPlan AS ICP
FULL OUTER JOIN dbo.InsuranceCompany AS IC ON IC.InsuranceCompanyID = ICP.InsuranceCompanyID

-- Patient Data
SELECT 
	Pat.PatientID,	
	Pat.Prefix,
	Pat.FirstName,
	Pat.MiddleName,
	Pat.LastName,
	Pat.Suffix,
	Pat.AddressLine1,
	Pat.AddressLine2,
	Pat.City,
	Pat.STATE,
	Pat.Country,
	Pat.ZipCode,
	Pat.Gender,
	Pat.MaritalStatus,
	Pat.HomePhone,
	Pat.HomePhoneExt,
	Pat.WorkPhone,
	Pat.WorkPhoneExt,
	Pat.DOB,
	Pat.SSN,
	Pat.EmailAddress,
	Pat.ResponsibleDifferentThanPatient,
	Pat.ResponsiblePrefix,
	Pat.ResponsibleFirstName,
	Pat.ResponsibleMiddleName,
	Pat.ResponsibleLastName,
	Pat.ResponsibleSuffix,
	Pat.ResponsibleRelationshipToPatient,
	Pat.ResponsibleAddressLine1,
	Pat.ResponsibleAddressLine2,
	Pat.ResponsibleCity,
	Pat.ResponsibleState,
	Pat.ResponsibleCountry,
	Pat.ResponsibleZipCode,
	Pat.RecordTimeStamp,
	Pat.MedicalRecordNumber,
	Pat.MobilePhone,
	Pat.MobilePhoneExt,
	Pat.Active,
	Pat.CreatedDate,
	Pat.CreatedUserID,
	Pat.ModifiedDate,
	Pat.ModifiedUserID,
	Pat.PrimaryProviderID AS 'PrimaryProviderDoctorID',
	Pat.PrimaryCarePhysicianID AS 'PrimaryCarePhysicianDoctorID',
	Pat.ReferringPhysicianID AS 'ReferringPhysicianDoctorID'
FROM dbo.Patient Pat 
WHERE Pat.PracticeID = @PracticeID

-- Patient Journal Notes
SELECT 
	PJN.PatientJournalNoteID,
	PJN.PatientID,
	ISNULL(Pat.FirstName, '') + ISNULL( ' ' + Pat.LastName, '') + ISNULL( ', ' + dbo.fn_ZeroLengthStringToNull( Pat.Suffix ), '') AS PatientName,
	PJN.CreatedDate,
	PJN.CreatedUserID,
	PJN.ModifiedDate,
	PJN.ModifiedUserID,
	PJN.UserName,
	PJN.NoteMessage,
	PJN.LastNote
FROM dbo.PatientJournalNote PJN 
INNER JOIN Patient Pat ON PJN.PatientID = Pat.PatientID
WHERE Pat.PracticeID = @PracticeID
ORDER BY PJN.PatientID

-- Case + Policy Data
SELECT
	PC.PatientCaseID,
	PC.[Name] AS 'CaseName',
	PC.PatientID,
	ISNULL(Pat.FirstName, '') + ISNULL( ' ' + Pat.LastName, '') + ISNULL( ', ' + dbo.fn_ZeroLengthStringToNull( Pat.Suffix ), '') AS PatientName,
	PC.Active,
	PC.PayerScenarioID,
	PS.[Name] AS 'PayerScenarioName',
	PC.ReferringPhysicianID,
	PC.EmploymentRelatedFlag,
	PC.AutoAccidentRelatedFlag,
	PC.OtherAccidentRelatedFlag,
	PC.AbuseRelatedFlag,
	PC.AutoAccidentRelatedState,
	PC.Notes,
	PC.ShowExpiredInsurancePolicies,
	PC.CreatedDate AS 'CaseCreatedDate',
	PC.CreatedUserID AS 'CaseCreatedUserID',
	PC.ModifiedDate AS 'CaseModifiedDate',
	PC.ModifiedUserID AS 'CaseModifiedUserID',
	PC.CaseNumber,
	PC.WorkersCompContactInfoID,
	PC.PregnancyRelatedFlag,
	PC.StatementActive,
	PC.EPSDT,
	PC.FamilyPlanning,
	PC.EPSDTCodeID,
	PC.EmergencyRelated,
	PC.HomeboundRelatedFlag,
	IP.InsurancePolicyID,
	IP.InsuranceCompanyPlanID,
	ICP.PlanName AS 'InsuranceCompanyPlanName',
	IP.Precedence,
	IP.PolicyNumber,
	IP.GroupNumber,
	IP.PolicyStartDate,
	IP.PolicyEndDate,
	IP.CardOnFile,
	IP.PatientRelationshipToInsured,
	IP.HolderPrefix,
	IP.HolderFirstName,
	IP.HolderMiddleName,
	IP.HolderLastName,
	IP.HolderSuffix,
	IP.HolderDOB,
	IP.HolderSSN,
	IP.HolderThroughEmployer,
	IP.HolderEmployerName,
	IP.PatientInsuranceStatusID,
	IP.CreatedDate AS 'InsurancePolicyCreatedDate',
	IP.CreatedUserID AS 'InsurancePolicyCreatedUserID',
	IP.ModifiedDate AS 'InsurancePolicyModifiedDate',
	IP.ModifiedUserID AS 'InsurancePolicyModifiedUserID',
	IP.HolderGender,
	IP.HolderAddressLine1,
	IP.HolderAddressLine2,
	IP.HolderCity,
	IP.HolderState,
	IP.HolderCountry,
	IP.HolderZipCode,
	IP.HolderPhone,
	IP.HolderPhoneExt,
	IP.DependentPolicyNumber,
	IP.Notes,
	IP.Phone,
	IP.PhoneExt,
	IP.Fax,
	IP.FaxExt,
	IP.Copay,
	IP.Deductible,
	IP.PatientInsuranceNumber,
	IP.Active,
	IP.GroupName,
	IP.ReleaseOfInformation
FROM PatientCase PC
INNER JOIN dbo.Patient Pat ON PC.PatientID = Pat.PatientID
INNER JOIN dbo.InsurancePolicy IP ON PC.PatientCaseID = IP.PatientCaseID
INNER JOIN dbo.InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
INNER JOIN dbo.PayerScenario PS ON PC.PayerScenarioID = PS.PayerScenarioID
WHERE PC.PracticeID = @PracticeID
ORDER BY PC.PatientID, PC.PatientCaseID, IP.Precedence

-- Doctor Data
SELECT 
	DoctorID,
	CASE WHEN [EXTERNAL] = 1 THEN 'True' ELSE 'False' END AS ReferringPhysician,
	NPI,
	Prefix,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	SSN,
	AddressLine1,
	AddressLine2,
	City,
	STATE,
	Country,
	ZipCode,
	HomePhone,
	HomePhoneExt,
	WorkPhone,
	WorkPhoneExt,
	FaxNumber,
	FaxNumberExt,
	PagerPhone,
	PagerPhoneExt,
	MobilePhone,
	MobilePhoneExt,
	DOB,
	EmailAddress,
	Notes,
	ActiveDoctor,
	CreatedDate,
	ModifiedDate,
	Degree,
	TaxonomyCode
FROM dbo.Doctor
WHERE PracticeID = @PracticeID


DECLARE @BeginDate Datetime
DECLARE @EndDate DateTime
DECLARE @PatientCaseID INT
DECLARE @ProviderID INT
DECLARE @ReportType CHAR(1)
DECLARE @UnappliedAmount MONEY

SET @BeginDate = NULL
SET @EndDate = NULL
SET @PatientCaseID = NULL
SET @ProviderID = NULL
SET @ReportType = 'A' --'O' Open service lines only (Default), 'A' All Service Lines, 'S' Settled Service Lines Only
SET @UnappliedAmount = 0


IF OBJECT_ID('tempdb..#AR') IS NOT NULL DROP TABLE #AR
CREATE TABLE #AR 
(
	ClaimID INT, 
	Amount MONEY
)

IF @ReportType <> 'A' and @ReportType IS NOT NULL
BEGIN
	INSERT INTO #AR(ClaimID, Amount)

	SELECT ClaimID, SUM(Amount)
	FROM (
		SELECT ClaimID, SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE Amount*-1 END) as Amount
		FROM ClaimAccounting
		WHERE PracticeID=@PracticeID 
			AND ClaimTransactionTypeCode IN ('CST', 'ADJ', 'PAY')
		GROUP BY ClaimID, Status
		HAVING ( @ReportType <> 'O' OR SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END) <> 0)
					AND ( @ReportType <> 'S' OR Status = 1 OR SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END) = 0 )
		) as v
	GROUP BY ClaimID
END


IF OBJECT_ID('tempdb..#ASN') IS NOT NULL DROP TABLE #ASN
CREATE TABLE #ASN 
(
	ClaimID INT, 
	PatientID INT, 
	TypeGroup INT, 
	InsuranceCompanyPlanID INT
)


INSERT INTO #ASN(ClaimID, PatientID, TypeGroup, InsuranceCompanyPlanID)
SELECT CAA.ClaimID, CAA.PatientID,
	CASE WHEN ICP.InsuranceCompanyPlanID IS NULL THEN 2 ELSE 1 END TypeGroup,
	ICP.InsuranceCompanyPlanID
FROM ClaimAccounting_Assignments CAA 
	LEFT JOIN #AR ar on caa.ClaimID = ar.ClaimID
	LEFT JOIN InsuranceCompanyPlan ICP ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
WHERE CAA.PracticeID=@PracticeID 
	AND ( ISNULL(@ReportType, 'A') = 'A' OR ar.ClaimID is not null )
	AND  LastAssignment = 1


SELECT ClaimId
INTO #TN
FROM ClaimTransaction
WHERE Practiceid=@PracticeID 
GROUP BY ClaimId
HAVING count(CASE WHEN ClaimTransactionTypeCode='MEM' THEN 1 ELSE NULL END)>0


SELECT C.ClaimID, ProcedureDateOfService, ProcedureCode,  ISNULL( PCD.LocalName, PCD.OfficialName) ProcedureName, 
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END) Charges,
	SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN Amount*-1 ELSE 0 END) Adjustments,

	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='I' THEN Amount*-1 ELSE 0 END) InsPay,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' THEN Amount*-1 ELSE 0 END) PatPay,

	SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE Amount*-1 END) TotalBalance,

	SUM(CASE WHEN PayerTypeCode = 'P' AND ClaimTransactionTypeCode = 'PAY'
				THEN 0
			WHEN TypeGroup=1 
				THEN case when ClaimTransactionTypeCode='CST' THEN Amount ELSE -1* Amount END
			ELSE 0
			END) PendingIns,
	SUM(CASE WHEN PayerTypeCode = 'P' AND ClaimTransactionTypeCode = 'PAY'
				THEN -1 * Amount
			WHEN TypeGroup=2
				THEN case when ClaimTransactionTypeCode='CST' THEN Amount ELSE -1* Amount END
			ELSE 0
			END) PendingPat,
	E.LocationID,
	InsuranceCompanyPlanID,
	Pat.Gender, 
	Cast( 0 AS MONEY) as ExpectedReimbursement,
	ProcedureModifier1,
	ep.ProcedureCodeDictionaryID,
	ISNULL(EP.ServiceUnitCount,0) ServiceUnitCount,
	pat.PatientID,
	ISNULL(pat.FirstName, '') + ISNULL( ' ' + LastName, '') + ISNULL( ', ' + dbo.fn_ZeroLengthStringToNull( pat.Suffix ), '') AS PatientName
	,CASE WHEN SUM(CASE WHEN T.ClaimID IS NULL THEN NULL ELSE 1 END)>0 THEN 1 ELSE 0 END AS ClaimHasNotes
INTO #Procedure	
FROM #ASN A 
	INNER JOIN ClaimAccounting CAA ON A.PatientID=CAA.PatientID AND A.ClaimID=CAA.ClaimID
	LEFT JOIN Payment P ON caa.PaymentID=P.PaymentID
	INNER JOIN Claim C ON A.ClaimID=C.ClaimID
	LEFT JOIN #TN T ON C.ClaimID = T.ClaimID
	INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
	INNER JOIN ProcedureCodeDictionary PCD ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
	INNER JOIN Encounter e on e.PracticeID = ep.PracticeID AND ep.EncounterID = e.EncounterID
	INNER JOIN Patient pat on pat.PatientID = e.patientID 
WHERE CAA.PracticeID=@PracticeID 
	AND ( CAA.ClaimTransactionTypeCode in ('CST', 'ADJ', 'PAY') )
	AND ( @BeginDate IS NULL OR ProcedureDateOfService >= @BeginDate ) AND (@EndDate IS NULL OR ProcedureDateOfService <= @EndDate )
	AND ( @ProviderID IS NULL OR @ProviderID = e.DoctorID )
	AND ( @PatientCaseID IS NULL OR @PatientCaseID = e.PatientCaseID )

GROUP BY C.ClaimID, ProcedureDateOfService, ProcedureCode, 
	ISNULL( PCD.LocalName, PCD.OfficialName), E.LocationID, InsuranceCompanyPlanID, Pat.Gender, 
	ProcedureModifier1, ep.ProcedureCodeDictionaryID, ISNULL(EP.ServiceUnitCount,0), pat.PatientID,
	ISNULL(pat.FirstName, '') + ISNULL( ' ' + LastName, '') + ISNULL( ', ' + dbo.fn_ZeroLengthStringToNull( pat.Suffix ), '')



update pr
set pr.PendingIns = PendingIns - Amount,
	pr.PendingPat = PendingPat + Amount
from #Procedure pr
	INNER JOIN (select ClaimID, sum(Amount) Amount from ClaimAccounting where PracticeID = @PracticeID AND ClaimTransactionTypeCode = 'PRC' group by claimID) as ca ON pr.ClaimID = ca.ClaimID
	INNER JOIN #ASN asn ON asn.ClaimID = pr.CLaimID AND asn.TypeGroup = 1




-- Calculate Expected Reimbursement
IF OBJECT_ID('tempdb..#StandardContract') IS NOT NULL DROP TABLE #StandardContract
CREATE TABLE #StandardContract
(
	ClaimID INT, 
	ContractID INT
)
	
INSERT INTO #StandardContract(ClaimID, ContractID)
SELECT ClaimID, C.ContractID
FROM #Procedure P 
	INNER JOIN Contract C ON C.PracticeID = @PracticeID AND C.ContractType='S'
	INNER JOIN ContractToServiceLocation CTSL ON C.ContractID=CTSL.ContractID AND P.LocationID=ServiceLocationID 
				AND ((P.ProcedureDateOfService BETWEEN C.EffectiveStartDate AND C.EffectiveEndDate) OR (C.EffectiveStartDate IS NULL))
WHERE C.PracticeID = @PracticeID AND C.ContractType='S'

IF OBJECT_ID('tempdb..#PayerContract') IS NOT NULL DROP TABLE #PayerContract
CREATE TABLE #PayerContract
(
	ClaimID INT, 
	ContractID INT
)

INSERT INTO #PayerContract(ClaimID, ContractID)
SELECT P.ClaimID, C.ContractID
FROM #Procedure P 
	INNER JOIN Contract C ON C.ContractType='P'
	INNER JOIN ContractToServiceLocation CTSL ON C.ContractID=CTSL.ContractID AND P.LocationID=ServiceLocationID 
				AND ((P.ProcedureDateOfService BETWEEN C.EffectiveStartDate AND C.EffectiveEndDate) OR (C.EffectiveStartDate IS NULL))
	INNER JOIN ContractToInsurancePlan CTIP ON C.ContractID=CTIP.ContractID AND p.InsuranceCompanyPlanID=CTIP.PlanID
WHERE C.PracticeID = @PracticeID


UPDATE P SET ExpectedReimbursement= [dbo].[fn_RoundUpToPenny]( CFS.ExpectedReimbursement* ServiceUnitCount )
FROM #Procedure P INNER JOIN #StandardContract SC
ON P.ClaimID =SC.ClaimID
INNER JOIN ContractFeeSchedule CFS ON SC.ContractID=CFS.ContractID 
	AND P.ProcedureCodeDictionaryID=CFS.ProcedureCodeDictionaryID
	AND ((P.Gender=CFS.Gender) OR CFS.Gender='B')
	AND ((ISNULL(P.ProcedureModifier1,'')=ISNULL(CFS.Modifier,'')) OR CFS.Modifier IS NULL)

UPDATE P SET ExpectedReimbursement= [dbo].[fn_RoundUpToPenny]( CFS.ExpectedReimbursement*ServiceUnitCount )
FROM #Procedure P INNER JOIN #PayerContract PC
ON P.ClaimID=PC.ClaimID
INNER JOIN ContractFeeSchedule CFS
ON PC.ContractID=CFS.ContractID AND P.ProcedureCodeDictionaryID=CFS.ProcedureCodeDictionaryID
AND ((P.Gender=CFS.Gender) OR CFS.Gender='B')
AND ((ISNULL(P.ProcedureModifier1,'')=ISNULL(CFS.Modifier,'')) OR CFS.Modifier IS NULL)



select PatientID, PatientName, convert(varchar, ProcedureDateOfService, 101) as ProcedureDateOfService, ProcedureCode + ' - ' + ProcedureName as ProcedureDescription, 
		ClaimID, ExpectedReimbursement, Charges, Adjustments, InsPay + PatPay AS Receipts, PendingPat, PendingIns, Totalbalance,
		@UnappliedAmount as UnappliedAmount
from #Procedure
ORDER BY PatientID, cast( ProcedureDateOfService as datetime)


-- Cleanup temp tables
IF OBJECT_ID('tempdb..#AR') IS NOT NULL DROP TABLE #AR
IF OBJECT_ID('tempdb..#ASN') IS NOT NULL DROP TABLE #ASN
IF OBJECT_ID('tempdb..#StandardContract') IS NOT NULL DROP TABLE #StandardContract
IF OBJECT_ID('tempdb..#PayerContract') IS NOT NULL DROP TABLE #PayerContract

-- Non explicitly declared temp tables
DROP TABLE #Procedure
DROP TABLE #TN
