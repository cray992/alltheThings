USE superbill_XXX_dev
GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO

--------------------------------------------------
--PATIENT TAB
--------------------------------------------------
SELECT DISTINCT
	PAT.PatientID AS 'ID',
	PAT.CreatedDate,
	PAT.ModifiedDate AS 'LastModifiedDate',
	PRA.Name AS 'PracticeName',
	PAT.FirstName + ' ' + PAT.MiddleName + ' ' + PAT.LastName AS 'PatientFullName',
	PAT.Prefix,
	PAT.FirstName,
	PAT.MiddleName,
	PAT.LastName,
	PAT.Suffix,
	PAT.SSN,
	PAT.DOB,
	dbo.fn_GetAge(PAT.DOB, GETDATE()) AS 'Age',
	PAT.Gender,
	PAT.MedicalRecordNumber,
	PAT.MaritalStatus,
	ES.StatusName AS 'EmploymentStatus',
	E.EmployerName,
	PRS.PatientReferralSourceCaption AS 'ReferralSource',
	PAT.AddressLine1,
	PAT.AddressLine2,
	PAT.City,
	PAT.State,
	PAT.Country,
	PAT.ZipCode,
	PAT.HomePhone,
	PAT.HomePhoneExt,
	PAT.WorkPhone,
	PAT.WorkPhoneExt,
	PAT.MobilePhone,
	PAT.MobilePhoneExt,
	PAT.EmailAddress,
	PAT.PracticeID,
	DefaultRenderingDoc.FirstName + ' ' + DefaultRenderingDoc.MiddleName + ' ' + DefaultRenderingDoc.LastName AS 'DefaultRenderingProviderFullName',
	DefaultRenderingDoc.DoctorID AS 'DefaultRenderingProviderId',
	PrimaryCareDoc.FirstName + ' ' + PrimaryCareDoc.MiddleName + ' ' + PrimaryCareDoc.LastName AS 'PrimaryCarePhysicianFullName',
	PrimaryCareDoc.DoctorID AS 'PrimaryCarePhysicianID',
	ReferringDoc.FirstName + ' ' + ReferringDoc.MiddleName + ' ' + ReferringDoc.LastName AS 'ReferringProviderFullName',
	ReferringDoc.DoctorID AS 'ReferringProviderID',
	SL.ServiceLocationID AS 'DefaultServiceLocationID',
	SL.Name AS 'DefaultServiceLocationName',
	SL.AddressLine1 AS 'DefaultServiceLocationNameAddressLine1',
	SL.AddressLine2 AS 'DefaultServiceLocationNameAddressLine2',
	SL.City AS 'DefaultServiceLocationNameCity',
	SL.State AS 'DefaultServiceLocationNameState',
	SL.Country AS 'DefaultServiceLocationNameCountry',
	SL.ZipCode AS 'DefaultServiceLocationNameZipCode',
	SL.BillingName AS 'DefaultServiceLocationBillingName',
	SL.Phone AS 'DefaultServiceLocationPhone',
	SL.PhoneExt AS 'DefaultServiceLocationPhoneExt',
	SL.FaxPhone AS 'DefaultServiceLocationFaxPhone',
	SL.FaxPhoneExt AS 'DefaultServiceLocationFaxPhoneExt',
	PAT.ResponsibleDifferentThanPatient AS 'GuarantorDifferentThanPatient',
	PAT.ResponsiblePrefix AS 'GuarantorPrefix',
	PAT.ResponsibleFirstName AS 'GuarantorFirstName',
	PAT.ResponsibleMiddleName AS 'GuarantorMiddleName',
	PAT.ResponsibleLastName AS 'GuarantorLastName',
	PAT.ResponsibleSuffix AS 'GuarantorSuffix',
	Note1.UserName AS 'MostRecentNote1User',
	Note1.CreatedDate AS 'MostRecentNote1Date',
	Note1.NoteMessage AS 'MostRecentNote1Message',
	Note2.UserName AS 'MostRecentNote2User',
	Note2.CreatedDate AS 'MostRecentNote2Date',
	Note2.NoteMessage AS 'MostRecentNote2Message',
	Note3.UserName AS 'MostRecentNote3User',
	Note3.CreatedDate AS 'MostRecentNote3Date',
	Note3.NoteMessage AS 'MostRecentNote3Message',
	Note4.UserName AS 'MostRecentNote4User',
	Note4.CreatedDate AS 'MostRecentNote4Date',
	Note4.NoteMessage AS 'MostRecentNote4Message',
	PC.PatientCaseID AS 'DefaultCaseID',	
	PC.[Name] AS 'DefaultCaseName',	
	CAST(PC.Notes AS VARCHAR) AS 'DefaultCaseDescription',
	PS.Name AS 'DefaultCasePayerScenario',
	PC.ReferringPhysicianID AS 'DefaultCaseReferringProviderID',
	CaseReferringDoc.FirstName + ' ' + CaseReferringDoc.MiddleName + ' ' + CaseReferringDoc.LastName AS 'DefaultCaseReferringProviderFullName',
	PC.StatementActive AS 'DefaultCaseSendPatientStatements',
	PC.AutoAccidentRelatedFlag AS 'DefaultCaseConditionRelatedToAutoAccident',
	PC.AutoAccidentRelatedState AS 'DefaultCaseConditionRelatedToAutoAccidentState',
	PC.EmploymentRelatedFlag AS 'DefaultCaseConditionRelatedToEmployment',
	PC.PregnancyRelatedFlag AS 'DefaultCaseConditionRelatedToPregnancy',
	PC.AbuseRelatedFlag AS 'DefaultCaseConditionRelatedToAbuse',
	PC.OtherAccidentRelatedFlag AS 'DefaultCaseConditionRelatedToOther',
	PC.EPSDT AS 'DefaultCaseConditionRelatedToEPSDT',
	PC.FamilyPlanning AS 'DefaultCaseConditionRelatedToFamilyPlanning',
	PC.EmergencyRelated AS 'DefaultCaseConditionRelatedToEmergency',
	PCDInjury.StartDate AS 'DefaultCaseDatesInjuryStartDate',
	PCDInjury.EndDate AS 'DefaultCaseDatesInjuryEndDate',
	PCDIllness.StartDate AS 'DefaultCaseDatesSameOrSimilarIllnessStartDate',	
	PCDIllness.EndDate AS 'DefaultCaseDatesSameOrSimilarIllnessEndDate',	
	PCDUnableWork.StartDate AS 'DefaultCaseDatesUnableToWorkStartDate',	
	PCDUnableWork.EndDate AS 'DefaultCaseDatesUnableToWorkEndDate',	
	PCDDisability.StartDate AS 'DefaultCaseDatesRelatedDisabilityStartDate',	
	PCDDisability.EndDate AS 'DefaultCaseDatesRelatedDisabilityEndDate',	
	PCDHospital.StartDate AS 'DefaultCaseDatesRelatedHospitalizationStartDate',	
	PCDHospital.EndDate AS 'DefaultCaseDatesRelatedHospitalizationEndDate',	
	PCDMenstrual.StartDate AS 'DefaultCaseDatesLastMenstrualPeriodDate',	
	PCDLastSeen.StartDate AS 'DefaultCaseDatesLastSeenDate',
	PCDReferralDate.StartDate AS 'DefaultCaseDatesReferralDate',
	PCDAcuteMan.StartDate AS 'DefaultCaseDatesAcuteManifestationDate',
	PCDXRay.StartDate AS 'DefaultCaseDatesLastXRayDate',
	PCDAccident.StartDate AS 'DefaultCaseDatesAccidentDate',
	InsPolicy1.InsuranceCompanyID AS 'PrimaryInsurancePolicyCompanyID', 
	InsPolicy1.InsuranceCompanyName AS 'PrimaryInsurancePolicyCompanyName', 
	InsPolicy1.InsuranceCompanyPlanID AS 'PrimaryInsurancePolicyPlanID', 
	InsPolicy1.PlanName AS 'PrimaryInsurancePolicyPlanName', 
	InsPolicy1.AddressLine1 AS 'PrimaryInsurancePolicyPlanAddressLine1', 
	InsPolicy1.AddressLine2 AS 'PrimaryInsurancePolicyPlanAddressLine2', 
	InsPolicy1.City AS 'PrimaryInsurancePolicyPlanCity', 
	InsPolicy1.[State] AS 'PrimaryInsurancePolicyPlanState', 
	InsPolicy1.Country AS 'PrimaryInsurancePolicyPlanCountry', 
	InsPolicy1.ZipCode AS 'PrimaryInsurancePolicyPlanZipCode', 
	InsPolicy1.AdjusterFullName AS 'PrimaryInsurancePolicyPlanAdjusterFullName', 
	InsPolicy1.Phone AS 'PrimaryInsurancePolicyPlanPhoneNumber', 
	InsPolicy1.PhoneExt AS 'PrimaryInsurancePolicyPlanPhoneNumberExt', 
	InsPolicy1.Fax AS 'PrimaryInsurancePolicyPlanFaxNumber', 
	InsPolicy1.Fax AS 'PrimaryInsurancePolicyPlanFaxNumberExt', 
	InsPolicy1.PolicyNumber AS 'PrimaryInsurancePolicyNumber', 
	InsPolicy1.GroupNumber AS 'PrimaryInsurancePolicyGroupNumber', 
	InsPolicy1.Copay AS 'PrimaryInsurancePolicyCopay', 
	InsPolicy1.Deductible AS 'PrimaryInsurancePolicyDeductible', 
	InsPolicy1.PolicyStartDate AS 'PrimaryInsurancePolicyEffectiveStartDate', 
	InsPolicy1.PolicyEndDate AS 'PrimaryInsurancePolicyEffectiveEndDate', 
	InsPolicy1.PatientRelationshipToInsured AS 'PrimaryInsurancePolicyPatientRelationshipToInsured', 
	InsPolicy1.InsuredFullName AS 'PrimaryInsurancePolicyInsuredFullName', 
	InsPolicy1.HolderAddressLine1 AS 'PrimaryInsurancePolicyInsuredAddressLine1', 
	InsPolicy1.HolderAddressLine2 AS 'PrimaryInsurancePolicyInsuredAddressLine2', 
	InsPolicy1.HolderCity AS 'PrimaryInsurancePolicyInsuredCity', 
	InsPolicy1.HolderState AS 'PrimaryInsurancePolicyInsuredState', 
	InsPolicy1.HolderCountry AS 'PrimaryInsurancePolicyInsuredCountry', 
	InsPolicy1.HolderZipCode AS 'PrimaryInsurancePolicyInsuredZipCode', 
	NULL AS 'PrimaryInsurancePolicyInsuredIDNumber', 
	InsPolicy1.HolderSSN AS 'PrimaryInsurancePolicyInsuredSocialSecurityNumber',
	InsPolicy1.HolderDOB AS 'PrimaryInsurancePolicyInsuredDateOfBirth', 
	InsPolicy1.HolderGender AS 'PrimaryInsurancePolicyInsuredGender', 
	NULL AS 'PrimaryInsurancePolicyInsuredNotes',
	InsPolicy2.InsuranceCompanyID AS 'SecondaryInsurancePolicyCompanyID', 
	InsPolicy2.InsuranceCompanyName AS 'SecondaryInsurancePolicyCompanyName', 
	InsPolicy2.InsuranceCompanyPlanID AS 'SecondaryInsurancePolicyPlanID', 
	InsPolicy2.PlanName AS 'SecondaryInsurancePolicyPlanName', 
	InsPolicy2.AddressLine1 AS 'SecondaryInsurancePolicyPlanAddressLine1', 
	InsPolicy2.AddressLine2 AS 'SecondaryInsurancePolicyPlanAddressLine2', 
	InsPolicy2.City AS 'SecondaryInsurancePolicyPlanCity', 
	InsPolicy2.[State] AS 'SecondaryInsurancePolicyPlanState', 
	InsPolicy2.Country AS 'SecondaryInsurancePolicyPlanCountry', 
	InsPolicy2.ZipCode AS 'SecondaryInsurancePolicyPlanZipCode', 
	InsPolicy2.AdjusterFullName AS 'SecondaryInsurancePolicyPlanAdjusterFullName', 
	InsPolicy2.Phone AS 'SecondaryInsurancePolicyPlanPhoneNumber', 
	InsPolicy2.PhoneExt AS 'SecondaryInsurancePolicyPlanPhoneNumberExt', 
	InsPolicy2.Fax AS 'SecondaryInsurancePolicyPlanFaxNumber', 
	InsPolicy2.Fax AS 'SecondaryInsurancePolicyPlanFaxNumberExt', 
	InsPolicy2.PolicyNumber AS 'SecondaryInsurancePolicyNumber', 
	InsPolicy2.GroupNumber AS 'SecondaryInsurancePolicyGroupNumber', 
	InsPolicy2.Copay AS 'SecondaryInsurancePolicyCopay', 
	InsPolicy2.Deductible AS 'SecondaryInsurancePolicyDeductible', 
	InsPolicy2.PolicyStartDate AS 'SecondaryInsurancePolicyEffectiveStartDate', 
	InsPolicy2.PolicyEndDate AS 'SecondaryInsurancePolicyEffectiveEndDate', 
	InsPolicy2.PatientRelationshipToInsured AS 'SecondaryInsurancePolicyPatientRelationshipToInsured', 
	InsPolicy2.InsuredFullName AS 'SecondaryInsurancePolicyInsuredFullName', 
	InsPolicy2.HolderAddressLine1 AS 'SecondaryInsurancePolicyInsuredAddressLine1', 
	InsPolicy2.HolderAddressLine2 AS 'SecondaryInsurancePolicyInsuredAddressLine2', 
	InsPolicy2.HolderCity AS 'SecondaryInsurancePolicyInsuredCity', 
	InsPolicy2.HolderState AS 'SecondaryInsurancePolicyInsuredState', 
	InsPolicy2.HolderCountry AS 'SecondaryInsurancePolicyInsuredCountry', 
	InsPolicy2.HolderZipCode AS 'SecondaryInsurancePolicyInsuredZipCode', 
	NULL AS 'SecondaryInsurancePolicyInsuredIDNumber', 
	InsPolicy2.HolderSSN AS 'SecondaryInsurancePolicyInsuredSocialSecurityNumber',
	InsPolicy2.HolderDOB AS 'SecondaryInsurancePolicyInsuredDateOfBirth', 
	InsPolicy2.HolderGender AS 'SecondaryInsurancePolicyInsuredGender', 
	NULL AS 'SecondaryInsurancePolicyInsuredNotes',
	InsPolicy1.AuthorizationNumber AS 'Authorization1Number',
	InsPolicy1.PlanName AS 'Authorization1InsurancePlanName',	
	InsPolicy1.AuthorizedNumberOfVisits AS 'Authorization1NumberOfVisits',	
	InsPolicy1.AuthorizedNumberOfVisitsUsed AS 'Authorization1NumberOfVisitsUsed',	
	InsPolicy1.AuthContactFullName AS 'Authorization1ContactFullName',	
	InsPolicy1.AuthContactPhone AS 'Authorization1ContactPhone',	
	InsPolicy1.AuthContactPhoneExt AS 'Authorization1ContactPhoneExt',	
	InsPolicy1.AuthNotes AS 'Authorization1Notes',	
	InsPolicy1.AuthStartDate AS 'Authorization1StartDate',	
	InsPolicy1.AuthEndDate AS 'Authorization1EndDate',
	InsPolicy2.AuthorizationNumber AS 'Authorization2Number',
	InsPolicy2.PlanName AS 'Authorization2InsurancePlanName',	
	InsPolicy2.AuthorizedNumberOfVisits AS 'Authorization2NumberOfVisits',	
	InsPolicy2.AuthorizedNumberOfVisitsUsed AS 'Authorization2NumberOfVisitsUsed',	
	InsPolicy2.AuthContactFullName AS 'Authorization2ContactFullName',	
	InsPolicy2.AuthContactPhone AS 'Authorization2ContactPhone',	
	InsPolicy2.AuthContactPhoneExt AS 'Authorization2ContactPhoneExt',	
	InsPolicy2.AuthNotes AS 'Authorization2Notes',	
	InsPolicy2.AuthStartDate AS 'Authorization2StartDate',	
	InsPolicy2.AuthEndDate AS 'Authorization2EndDate',
	NULL AS 'Authorization3Number',
	NULL AS 'Authorization3InsurancePlanName',	
	NULL AS 'Authorization3NumberOfVisits',	
	NULL AS 'Authorization3NumberOfVisitsUsed',	
	NULL AS 'Authorization3ContactFullName',	
	NULL AS 'Authorization3ContactPhone',	
	NULL AS 'Authorization3ContactPhoneExt',	
	NULL AS 'Authorization3Notes',	
	NULL AS 'Authorization3StartDate',	
	NULL AS 'Authorization3EndDate',
	CAST(PA.AlertMessage AS VARCHAR) AS 'AlertMessage',	
	PA.ShowInPatientFlag AS 'AlertShowWhenDisplayingPatientDetails',	
	PA.ShowInAppointmentFlag AS 'AlertShowWhenSchedulingAppointments',	
	PA.ShowInEncounterFlag AS 'AlertShowWhenEnteringEncounters',	
	PA.ShowInClaimFlag AS 'AlertShowWhenViewingClaimDetails',	
	PA.ShowInPaymentFlag AS 'AlertShowWhenPostingPayments',	
	PA.ShowInPatientStatementFlag AS 'AlertShowWhenPreparingPatientStatements',
	CC.CollectionCategoryName,
	PJN.NoteMessage AS StatementNote,
	DCD.DiagnosisCode + ' - ' + DCD.OfficialName AS 'LastDiagnosis',
	A.StartDate AS 'LastAppointmentDate',
	E2.DateOfService AS 'LastEncounterDate',
	PAT.EmergencyName,
	PAT.EmergencyPhone,
	PAT.EmergencyPhoneExt
FROM dbo.Patient AS PAT
LEFT OUTER JOIN dbo.Practice PRA ON PRA.PracticeID = PAT.PracticeID
LEFT OUTER JOIN dbo.Employers E ON PAT.EmployerID = E.EmployerID
LEFT OUTER JOIN dbo.EmploymentStatus ES ON ES.EmploymentStatusCode = PAT.EmploymentStatus
LEFT OUTER JOIN dbo.PatientReferralSource PRS ON PRS.PatientReferralSourceID = PAT.PatientReferralSourceID
LEFT OUTER JOIN dbo.Doctor DefaultRenderingDoc ON DefaultRenderingDoc.DoctorID = PAT.PrimaryProviderID
LEFT OUTER JOIN dbo.Doctor PrimaryCareDoc ON PrimaryCareDoc.DoctorID = PAT.PrimaryCarePhysicianID
LEFT OUTER JOIN dbo.Doctor ReferringDoc ON ReferringDoc.DoctorID = PAT.ReferringPhysicianID
LEFT OUTER JOIN dbo.ServiceLocation SL ON SL.ServiceLocationID = PAT.DefaultServiceLocationID
LEFT OUTER JOIN dbo.PatientCase PC ON PC.PatientID = PAT.PatientID AND PC.Active = 1 AND PC.CreatedDate = (SELECT MAX(CreatedDate) FROM dbo.PatientCase WHERE PatientID = PAT.PatientID)
LEFT OUTER JOIN dbo.PayerScenario PS ON PS.PayerScenarioID = PC.PayerScenarioID
LEFT OUTER JOIN dbo.Doctor CaseReferringDoc ON CaseReferringDoc.DoctorID = PC.ReferringPhysicianID
LEFT OUTER JOIN dbo.PatientAlert PA ON PA.PatientID = PAT.PatientID
-- Grab most recent 4 note
LEFT OUTER JOIN (
	SELECT PatientID, PatientJournalNoteID, CreatedDate, UserName, NoteMessage, ROW_NUMBER() OVER(PARTITION BY PatientID ORDER BY PatientJournalNoteID DESC) AS NoteNum FROM dbo.PatientJournalNote WHERE NoteTypeCode = 1
) Note1 ON PAT.PatientID = Note1.PatientID AND Note1.NoteNum = 1
LEFT OUTER JOIN (
	SELECT PatientID, PatientJournalNoteID, CreatedDate, UserName, NoteMessage, ROW_NUMBER() OVER(PARTITION BY PatientID ORDER BY PatientJournalNoteID DESC) AS NoteNum FROM dbo.PatientJournalNote WHERE NoteTypeCode = 1
) Note2 ON PAT.PatientID = Note2.PatientID AND Note2.NoteNum = 2
LEFT OUTER JOIN (
	SELECT PatientID, PatientJournalNoteID, CreatedDate, UserName, NoteMessage, ROW_NUMBER() OVER(PARTITION BY PatientID ORDER BY PatientJournalNoteID DESC) AS NoteNum FROM dbo.PatientJournalNote WHERE NoteTypeCode = 1
) Note3 ON PAT.PatientID = Note3.PatientID AND Note3.NoteNum = 3
LEFT OUTER JOIN (
	SELECT PatientID, PatientJournalNoteID, CreatedDate, UserName, NoteMessage, ROW_NUMBER() OVER(PARTITION BY PatientID ORDER BY PatientJournalNoteID DESC) AS NoteNum FROM dbo.PatientJournalNote WHERE NoteTypeCode = 1
) Note4 ON PAT.PatientID = Note4.PatientID AND Note4.NoteNum = 4	
-- Case Date Type #2
LEFT OUTER JOIN (
	SELECT PatientCaseID, StartDate, EndDate FROM dbo.PatientCaseDate WHERE PatientCaseDateTypeID = 2
) PCDInjury ON PC.PatientCaseID = PCDInjury.PatientCaseID
-- Case Date Type #3
LEFT OUTER JOIN (
	SELECT PatientCaseID, StartDate, EndDate FROM dbo.PatientCaseDate WHERE PatientCaseDateTypeID = 3
) PCDIllness ON PC.PatientCaseID = PCDIllness .PatientCaseID
-- Case Date Type #4
LEFT OUTER JOIN (
	SELECT PatientCaseID, StartDate, EndDate FROM dbo.PatientCaseDate WHERE PatientCaseDateTypeID = 4
) PCDUnableWork ON PC.PatientCaseID = PCDUnableWork.PatientCaseID
-- Case Date Type #5
LEFT OUTER JOIN (
	SELECT PatientCaseID, StartDate, EndDate FROM dbo.PatientCaseDate WHERE PatientCaseDateTypeID = 5
) PCDDisability ON PC.PatientCaseID = PCDDisability.PatientCaseID
-- Case Date Type #6
LEFT OUTER JOIN (
	SELECT PatientCaseID, StartDate, EndDate FROM dbo.PatientCaseDate WHERE PatientCaseDateTypeID = 6
) PCDHospital ON PC.PatientCaseID = PCDHospital.PatientCaseID
-- Case Date Type #7
LEFT OUTER JOIN (
	SELECT PatientCaseID, StartDate, EndDate FROM dbo.PatientCaseDate WHERE PatientCaseDateTypeID = 7
) PCDMenstrual ON PC.PatientCaseID = PCDMenstrual.PatientCaseID
-- Case Date Type #8
LEFT OUTER JOIN (
	SELECT PatientCaseID, StartDate, EndDate FROM dbo.PatientCaseDate WHERE PatientCaseDateTypeID = 8
) PCDLastSeen ON PC.PatientCaseID = PCDLastSeen.PatientCaseID
-- Case Date Type #9
LEFT OUTER JOIN (
	SELECT PatientCaseID, StartDate, EndDate FROM dbo.PatientCaseDate WHERE PatientCaseDateTypeID = 9
) PCDReferralDate ON PC.PatientCaseID = PCDReferralDate.PatientCaseID
-- Case Date Type #10
LEFT OUTER JOIN (
	SELECT PatientCaseID, StartDate, EndDate FROM dbo.PatientCaseDate WHERE PatientCaseDateTypeID = 10
) PCDAcuteMan ON PC.PatientCaseID = PCDAcuteMan.PatientCaseID
-- Case Date Type #11
LEFT OUTER JOIN (
	SELECT PatientCaseID, StartDate, EndDate FROM dbo.PatientCaseDate WHERE PatientCaseDateTypeID = 11
) PCDXRay ON PC.PatientCaseID = PCDXRay.PatientCaseID
-- Case Date Type #12
LEFT OUTER JOIN (
	SELECT PatientCaseID, StartDate, EndDate FROM dbo.PatientCaseDate WHERE PatientCaseDateTypeID = 12
) PCDAccident ON PC.PatientCaseID = PCDAccident.PatientCaseID
-- Primary Insurance Policy
LEFT OUTER JOIN (
	SELECT 
		IP.PatientCaseID, ROW_NUMBER() OVER(PARTITION BY PatientCaseID ORDER BY Precedence ASC) AS PolicyOrder,
		IC.InsuranceCompanyID, IC.InsuranceCompanyName,
		ICP.InsuranceCompanyPlanID, ICP.PlanName, ICP.AddressLine1, ICP.AddressLine2, ICP.City, ICP.[State], ICP.Country, ICP.ZipCode,
		IP.AdjusterFirstName + ' ' + IP.AdjusterMiddleName + ' ' + IP.AdjusterLastName AS AdjusterFullName,
		ICP.Phone, ICP.PhoneExt, ICP.Fax, ICP.FaxExt,
		IP.PolicyNumber, IP.GroupNumber, IP.Copay, IP.Deductible, IP.PolicyStartDate, IP.PolicyEndDate, IP.PatientRelationshipToInsured,
		IP.HolderFirstName + ' ' + IP.HolderMiddleName + ' ' + IP.HolderLastName AS InsuredFullName,
		IP.HolderAddressLine1, IP.HolderAddressLine2, IP.HolderCity, IP.HolderState, IP.HolderCountry, IP.HolderZipCode,
		IP.HolderSSN, IP.HolderDOB, IP.HolderGender,
		IPA.AuthorizationNumber, IPA.AuthorizedNumberOfVisits, IPA.AuthorizedNumberOfVisitsUsed, IPA.ContactFullName AS 'AuthContactFullName',
		IPA.ContactPhone AS 'AuthContactPhone', IPA.ContactPhoneExt AS 'AuthContactPhoneExt', CAST(IPA.Notes AS VARCHAR) AS 'AuthNotes', IPA.StartDate AS 'AuthStartDate', IPA.EndDate AS 'AuthEndDate'
	FROM dbo.InsurancePolicy IP
	LEFT OUTER JOIN dbo.InsurancePolicyAuthorization IPA ON IP.InsurancePolicyID = IPA.InsurancePolicyID AND GETDATE() BETWEEN IPA.StartDate AND IPA.EndDate
	INNER JOIN dbo.InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
	INNER JOIN dbo.InsuranceCompany IC ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
	WHERE IP.Active = 1
) InsPolicy1 ON PC.PatientCaseID = InsPolicy1.PatientCaseID AND InsPolicy1.PolicyOrder = 1

-- Secondary Insurance Policy
LEFT OUTER JOIN (
	SELECT 
		IP.PatientCaseID, ROW_NUMBER() OVER(PARTITION BY PatientCaseID ORDER BY Precedence ASC) AS PolicyOrder,
		IC.InsuranceCompanyID, IC.InsuranceCompanyName,
		ICP.InsuranceCompanyPlanID, ICP.PlanName, ICP.AddressLine1, ICP.AddressLine2, ICP.City, ICP.[State], ICP.Country, ICP.ZipCode,
		IP.AdjusterFirstName + ' ' + IP.AdjusterMiddleName + ' ' + IP.AdjusterLastName AS AdjusterFullName,
		ICP.Phone, ICP.PhoneExt, ICP.Fax, ICP.FaxExt,
		IP.PolicyNumber, IP.GroupNumber, IP.Copay, IP.Deductible, IP.PolicyStartDate, IP.PolicyEndDate, IP.PatientRelationshipToInsured,
		IP.HolderFirstName + ' ' + IP.HolderMiddleName + ' ' + IP.HolderLastName AS InsuredFullName,
		IP.HolderAddressLine1, IP.HolderAddressLine2, IP.HolderCity, IP.HolderState, IP.HolderCountry, IP.HolderZipCode,
		IP.HolderSSN, IP.HolderDOB, IP.HolderGender,
		IPA.AuthorizationNumber, IPA.AuthorizedNumberOfVisits, IPA.AuthorizedNumberOfVisitsUsed, IPA.ContactFullName AS 'AuthContactFullName',
		IPA.ContactPhone AS 'AuthContactPhone', IPA.ContactPhoneExt AS 'AuthContactPhoneExt', CAST(IPA.Notes AS VARCHAR) AS 'AuthNotes', IPA.StartDate AS 'AuthStartDate', IPA.EndDate AS 'AuthEndDate'
	FROM dbo.InsurancePolicy IP
	LEFT OUTER JOIN dbo.InsurancePolicyAuthorization IPA ON IP.InsurancePolicyID = IPA.InsurancePolicyID AND GETDATE() BETWEEN IPA.StartDate AND IPA.EndDate
	INNER JOIN dbo.InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
	INNER JOIN dbo.InsuranceCompany IC ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
	WHERE IP.Active = 1
) InsPolicy2 ON PC.PatientCaseID = InsPolicy2.PatientCaseID AND InsPolicy2.PolicyOrder = 2
			
LEFT OUTER JOIN dbo.CollectionCategory CC ON PAT.CollectionCategoryID = CC.CollectionCategoryID
LEFT OUTER JOIN dbo.PatientJournalNote PJN ON PAT.PatientID = PJN.PatientID AND PJN.PatientJournalNoteID = (SELECT MAX(PatientJournalNoteID) FROM dbo.PatientJournalNote WHERE PatientID = PAT.PatientID AND NoteTypeCode = 2)

-- Grab most recent encounter
LEFT OUTER JOIN dbo.Encounter E2 ON E2.PatientID = PAT.PatientID AND E2.DateOfService = (SELECT MAX(DateOfService) FROM dbo.Encounter WHERE PatientID = PAT.PatientID)
LEFT OUTER JOIN dbo.EncounterProcedure EP ON EP.EncounterID = E2.EncounterID AND EP.EncounterProcedureID = (SELECT MAX(EncounterProcedureID) FROM dbo.EncounterProcedure WHERE EncounterID = E2.EncounterID)
LEFT OUTER JOIN dbo.DiagnosisCodeDictionary DCD ON DCD.DiagnosisCodeDictionaryID = EP.EncounterDiagnosisID1

-- Grab most recent appointment
LEFT OUTER JOIN dbo.Appointment A ON A.PatientID = PAT.PatientID AND A.StartDate = (SELECT MAX(StartDate) FROM dbo.Appointment WHERE PatientID = PAT.PatientID)


--------------------------------------------------
--INSURANCE TAB
--------------------------------------------------
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
LEFT OUTER JOIN dbo.InsuranceCompany AS IC ON IC.InsuranceCompanyID = ICP.InsuranceCompanyID




--------------------------------------------------
--REFERRING TAB
--------------------------------------------------
SELECT
	D.DoctorID,
	D.Degree,
	D.FirstName,
	D.MiddleName,
	D.LastName,
	D.AddressLine1,
	D.AddressLine2,
	D.City,
	D.[State],
	D.ZipCode,
	D.WorkPhone,
	D.FaxNumber,
	D.NPI	
FROM dbo.Doctor AS D
WHERE [External] = 1