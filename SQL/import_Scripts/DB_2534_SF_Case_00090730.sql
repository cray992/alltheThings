

-- begin tran
/*
-- delete [Employers]
-- select * from employers

SET IDENTITY_INSERT [Employers] ON 


INSERT INTO [dbo].[Employers](
			EmployerID
			,[EmployerName]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Country]
           ,[ZipCode]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID])
SELECT
			EmployerID
			,[EmployerName]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Country]
           ,[ZipCode]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
FROM [kprod-db09].superbill_2156_prod.dbo.Employers

SET IDENTITY_INSERT [Employers] OFF
*/



/*

-- delete Patient
SET IDENTITY_INSERT Patient ON 

INSERT INTO [Patient]
           ([PracticeID]
			,PatientID
           ,[ReferringPhysicianID]
           ,[Prefix]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Country]
           ,[ZipCode]
           ,[Gender]
           ,[MaritalStatus]
           ,[HomePhone]
           ,[HomePhoneExt]
           ,[WorkPhone]
           ,[WorkPhoneExt]
           ,[DOB]
           ,[SSN]
           ,[EmailAddress]
           ,[ResponsibleDifferentThanPatient]
           ,[ResponsiblePrefix]
           ,[ResponsibleFirstName]
           ,[ResponsibleMiddleName]
           ,[ResponsibleLastName]
           ,[ResponsibleSuffix]
           ,[ResponsibleRelationshipToPatient]
           ,[ResponsibleAddressLine1]
           ,[ResponsibleAddressLine2]
           ,[ResponsibleCity]
           ,[ResponsibleState]
           ,[ResponsibleCountry]
           ,[ResponsibleZipCode]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[EmploymentStatus]
           ,[InsuranceProgramCode]
           ,[PatientReferralSourceID]
           ,[PrimaryProviderID]
           ,[DefaultServiceLocationID]
           ,[EmployerID]
           ,[MedicalRecordNumber]
           ,[MobilePhone]
           ,[MobilePhoneExt]
           ,[PrimaryCarePhysicianID]
           ,[VendorID]
           ,[VendorImportID]
           ,[CollectionCategoryID])
SELECT
			[PracticeID]
			,PatientID
           ,NULL as [ReferringPhysicianID]
           ,[Prefix]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Country]
           ,[ZipCode]
           ,[Gender]
           ,[MaritalStatus]
           ,[HomePhone]
           ,[HomePhoneExt]
           ,[WorkPhone]
           ,[WorkPhoneExt]
           ,[DOB]
           ,[SSN]
           ,[EmailAddress]
           ,[ResponsibleDifferentThanPatient]
           ,[ResponsiblePrefix]
           ,[ResponsibleFirstName]
           ,[ResponsibleMiddleName]
           ,[ResponsibleLastName]
           ,[ResponsibleSuffix]
           ,[ResponsibleRelationshipToPatient]
           ,[ResponsibleAddressLine1]
           ,[ResponsibleAddressLine2]
           ,[ResponsibleCity]
           ,[ResponsibleState]
           ,[ResponsibleCountry]
           ,[ResponsibleZipCode]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,getdate() [ModifiedDate]
           ,0 as [ModifiedUserID]
           ,[EmploymentStatus]
           ,[InsuranceProgramCode]
           ,NULL AS [PatientReferralSourceID]
           ,NULL AS [PrimaryProviderID]
           ,NULL AS [DefaultServiceLocationID]
           ,[EmployerID]
           ,[MedicalRecordNumber]
           ,[MobilePhone]
           ,[MobilePhoneExt]
           ,NULL as [PrimaryCarePhysicianID]
           ,PatientID as [VendorID]
           ,1 as [VendorImportID]
           ,[CollectionCategoryID]
FROM [kprod-db09].superbill_2156_prod.dbo.Patient
WHERE practiceID IN (select practiceID from practice)

SET IDENTITY_INSERT Patient OFF

-- select @@trancount



SET IDENTITY_INSERT [PayerScenario] ON

-- select * from payerScenario

INSERT INTO [PayerScenario]
           ([Name]
           ,[Description]
           ,[PayerScenarioTypeID]
           ,[StatementActive]
			,PayerScenarioID)

select [Name]
           ,[Description]
           ,[PayerScenarioTypeID]
           ,[StatementActive]
			,PayerScenarioID
from [kprod-db09].superbill_2156_prod.dbo.payerScenario pp
WHERE pp.PayerScenarioID NOT in (select ps.PayerScenarioID FROM payerScenario ps )
	OR pp.Name NOT in (select ps.Name FROM payerScenario ps )


SET IDENTITY_INSERT [PayerScenario] OFF


-- delete [PatientCase]
-- select * from patientCase

SET IDENTITY_INSERT [PatientCase] ON

INSERT INTO [PatientCase]
           (PatientCaseID
			,[PatientID]
           ,[Name]
           ,[Active]
           ,[PayerScenarioID]
           ,[ReferringPhysicianID]
           ,[EmploymentRelatedFlag]
           ,[AutoAccidentRelatedFlag]
           ,[OtherAccidentRelatedFlag]
           ,[AbuseRelatedFlag]
           ,[AutoAccidentRelatedState]
           ,[Notes]
           ,[ShowExpiredInsurancePolicies]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[PracticeID]
           ,[CaseNumber]
           ,[WorkersCompContactInfoID]
           ,[VendorID]
           ,[VendorImportID]
           ,[PregnancyRelatedFlag]
           ,[StatementActive]
           ,[EPSDT]
           ,[FamilyPlanning]
           ,[EPSDTCodeID]
           ,[EmergencyRelated])

select
			PatientCaseID
			,[PatientID]
           ,[Name]
           ,[Active]
           ,[PayerScenarioID]
           ,NULL as [ReferringPhysicianID]
           ,[EmploymentRelatedFlag]
           ,[AutoAccidentRelatedFlag]
           ,[OtherAccidentRelatedFlag]
           ,[AbuseRelatedFlag]
           ,[AutoAccidentRelatedState]
           ,[Notes]
           ,[ShowExpiredInsurancePolicies]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[PracticeID]
           ,[CaseNumber]
           ,[WorkersCompContactInfoID]
           ,patientCaseID as [VendorID]
           ,1 as [VendorImportID]
           ,[PregnancyRelatedFlag]
           ,[StatementActive]
           ,[EPSDT]
           ,[FamilyPlanning]
           ,[EPSDTCodeID]
           ,[EmergencyRelated]
from [kprod-db09].superbill_2156_prod.dbo.PatientCase
WHERE patientID in (select patientID from patient)
	AND patientCaseID NOT IN (select patientCaseID from patientCase)

SET IDENTITY_INSERT [PatientCase] OFF




INSERT INTO [ClearinghousePayersList]
           ([ClearinghousePayerID]
           ,[ClearinghouseID]
           ,[PayerNumber]
           ,[Name]
           ,[Notes]
           ,[StateSpecific]
           ,[IsPaperOnly]
           ,[IsGovernment]
           ,[IsCommercial]
           ,[IsParticipating]
           ,[IsProviderIdRequired]
           ,[IsEnrollmentRequired]
           ,[IsAuthorizationRequired]
           ,[IsTestRequired]
           ,[ResponseLevel]
           ,[IsNewPayer]
           ,[DateNewPayerSince]
           ,[CreatedDate]
           ,[ModifiedDate]
           ,[Active]
           ,[IsModifiedPayer]
           ,[DateModifiedPayerSince]
           ,[KareoClearinghousePayersListID]
           ,[KareoLastModifiedDate]
           ,[NameTransmitted]
           ,[SupportsPatientEligibilityRequests]
           ,[SupportsSecondaryElectronicBilling]
           ,[SupportsCoordinationOfBenefits]
           ,[B2BPayerID])


select 
[ClearinghousePayerID]
           ,[ClearinghouseID]
           ,[PayerNumber]
           ,[Name]
           ,[Notes]
           ,[StateSpecific]
           ,[IsPaperOnly]
           ,[IsGovernment]
           ,[IsCommercial]
           ,[IsParticipating]
           ,[IsProviderIdRequired]
           ,[IsEnrollmentRequired]
           ,[IsAuthorizationRequired]
           ,[IsTestRequired]
           ,[ResponseLevel]
           ,[IsNewPayer]
           ,[DateNewPayerSince]
           ,[CreatedDate]
           ,[ModifiedDate]
           ,[Active]
           ,[IsModifiedPayer]
           ,[DateModifiedPayerSince]
           ,[KareoClearinghousePayersListID]
           ,[KareoLastModifiedDate]
           ,[NameTransmitted]
           ,[SupportsPatientEligibilityRequests]
           ,[SupportsSecondaryElectronicBilling]
           ,[SupportsCoordinationOfBenefits]
           ,[B2BPayerID]
from [kprod-db09].superbill_2156_prod.dbo.ClearinghousePayersList pp 
WHERE NOT EXISTS(SELECT * 
				FROM dbo.ClearinghousePayersList ps
				WHERE ps.clearinghousePayerID=pp.clearinghousePayerID
					AND ps.[PayerNumber]=pp.[PayerNumber]
				)





-- select * from insuranceCompany
-- delete [InsuranceCompany]

SET IDENTITY_INSERT [InsuranceCompany] ON


INSERT INTO [InsuranceCompany]
           (
			InsuranceCompanyID
			,[InsuranceCompanyName]
           ,[Notes]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Country]
           ,[ZipCode]
           ,[ContactPrefix]
           ,[ContactFirstName]
           ,[ContactMiddleName]
           ,[ContactLastName]
           ,[ContactSuffix]
           ,[Phone]
           ,[PhoneExt]
           ,[Fax]
           ,[FaxExt]
           ,[BillSecondaryInsurance]
           ,[EClaimsAccepts]
           ,[BillingFormID]
           ,[InsuranceProgramCode]
           ,[HCFADiagnosisReferenceFormatCode]
           ,[HCFASameAsInsuredFormatCode]
           ,[LocalUseFieldTypeCode]
           ,[ReviewCode]
           ,[ProviderNumberTypeID]
           ,[GroupNumberTypeID]
           ,[LocalUseProviderNumberTypeID]
           ,[CompanyTextID]
           ,[ClearinghousePayerID]
           ,[CreatedPracticeID]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[KareoInsuranceCompanyID]
           ,[KareoLastModifiedDate]
           ,[SecondaryPrecedenceBillingFormID]
           ,[VendorID]
           ,[VendorImportID]
           ,[DefaultAdjustmentCode]
           ,[ReferringProviderNumberTypeID]
           ,[NDCFormat]
           ,[UseFacilityID]
           ,[AnesthesiaType])

SELECT 
			InsuranceCompanyID
			,[InsuranceCompanyName]
           ,[Notes]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Country]
           ,[ZipCode]
           ,[ContactPrefix]
           ,[ContactFirstName]
           ,[ContactMiddleName]
           ,[ContactLastName]
           ,[ContactSuffix]
           ,[Phone]
           ,[PhoneExt]
           ,[Fax]
           ,[FaxExt]
           ,[BillSecondaryInsurance]
           ,[EClaimsAccepts]
           ,[BillingFormID]
           ,[InsuranceProgramCode]
           ,[HCFADiagnosisReferenceFormatCode]
           ,[HCFASameAsInsuredFormatCode]
           ,[LocalUseFieldTypeCode]
           ,[ReviewCode]
           ,[ProviderNumberTypeID]
           ,[GroupNumberTypeID]
           ,[LocalUseProviderNumberTypeID]
           ,[CompanyTextID]
           ,[ClearinghousePayerID]
           ,[CreatedPracticeID]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[KareoInsuranceCompanyID]
           ,[KareoLastModifiedDate]
           ,[SecondaryPrecedenceBillingFormID]
           ,insuranceCompanyID as [VendorID]
           ,1 as [VendorImportID]
           ,[DefaultAdjustmentCode]
           ,[ReferringProviderNumberTypeID]
           ,[NDCFormat]
           ,[UseFacilityID]
           ,[AnesthesiaType]
FROM [kprod-db09].superbill_2156_prod.dbo.insuranceCompany ic
WHERE ic.insuranceCompanyID NOT in (select insuranceCompanyID from insuranceCompany)

SET IDENTITY_INSERT [InsuranceCompany] OFF




-- select * from insuranceCompanyPlan
-- delete [InsuranceCompanyPlan]
SET IDENTITY_INSERT [InsuranceCompanyPlan] ON


INSERT INTO [InsuranceCompanyPlan]
           (InsuranceCompanyPlanID
			,[PlanName]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Country]
           ,[ZipCode]
           ,[ContactPrefix]
           ,[ContactFirstName]
           ,[ContactMiddleName]
           ,[ContactLastName]
           ,[ContactSuffix]
           ,[Phone]
           ,[PhoneExt]
           ,[Notes]
           ,[MM_CompanyID]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[ReviewCode]
           ,[CreatedPracticeID]
           ,[Fax]
           ,[FaxExt]
           ,[KareoInsuranceCompanyPlanID]
           ,[KareoLastModifiedDate]
           ,[InsuranceCompanyID]
           ,[ADS_CompanyID]
           ,[Copay]
           ,[Deductible]
           ,[VendorID]
           ,[VendorImportID])


select
InsuranceCompanyPlanID
			,[PlanName]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Country]
           ,[ZipCode]
           ,[ContactPrefix]
           ,[ContactFirstName]
           ,[ContactMiddleName]
           ,[ContactLastName]
           ,[ContactSuffix]
           ,[Phone]
           ,[PhoneExt]
           ,[Notes]
           ,[MM_CompanyID]
           ,getdate() as [CreatedDate]
           ,0 as [CreatedUserID]
           ,getdate() as [ModifiedDate]
           ,[ModifiedUserID]
           ,[ReviewCode]
           ,[CreatedPracticeID]
           ,[Fax]
           ,[FaxExt]
           ,[KareoInsuranceCompanyPlanID]
           ,[KareoLastModifiedDate]
           ,[InsuranceCompanyID]
           ,[ADS_CompanyID]
           ,[Copay]
           ,[Deductible]
           ,insuranceCompanyID as [VendorID]
           ,1 as [VendorImportID]
from [kprod-db09].superbill_2156_prod.dbo.insuranceCompanyPlan
where insuranceCompanyPlanID NOT IN (select insuranceCompanyPlanID from insuranceCompanyPlan)

SET IDENTITY_INSERT [InsuranceCompanyPlan] OFF



-- select * from insurancePolicy
-- delete [InsurancePolicy]
SET IDENTITY_INSERT [InsurancePolicy] ON

INSERT INTO [InsurancePolicy]
           (
			InsurancePolicyID
			,[PatientCaseID]
           ,[InsuranceCompanyPlanID]
           ,[Precedence]
           ,[PolicyNumber]
           ,[GroupNumber]
           ,[PolicyStartDate]
           ,[PolicyEndDate]
           ,[CardOnFile]
           ,[PatientRelationshipToInsured]
           ,[HolderPrefix]
           ,[HolderFirstName]
           ,[HolderMiddleName]
           ,[HolderLastName]
           ,[HolderSuffix]
           ,[HolderDOB]
           ,[HolderSSN]
           ,[HolderThroughEmployer]
           ,[HolderEmployerName]
           ,[PatientInsuranceStatusID]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[HolderGender]
           ,[HolderAddressLine1]
           ,[HolderAddressLine2]
           ,[HolderCity]
           ,[HolderState]
           ,[HolderCountry]
           ,[HolderZipCode]
           ,[HolderPhone]
           ,[HolderPhoneExt]
           ,[DependentPolicyNumber]
           ,[Notes]
           ,[Phone]
           ,[PhoneExt]
           ,[Fax]
           ,[FaxExt]
           ,[Copay]
           ,[Deductible]
           ,[PatientInsuranceNumber]
           ,[Active]
           ,[PracticeID]
           ,[AdjusterPrefix]
           ,[AdjusterFirstName]
           ,[AdjusterMiddleName]
           ,[AdjusterLastName]
           ,[AdjusterSuffix]
           ,[VendorID]
           ,[VendorImportID]
           ,[InsuranceProgramTypeID])
SELECT
InsurancePolicyID
			,[PatientCaseID]
           ,[InsuranceCompanyPlanID]
           ,[Precedence]
           ,[PolicyNumber]
           ,[GroupNumber]
           ,[PolicyStartDate]
           ,[PolicyEndDate]
           ,[CardOnFile]
           ,[PatientRelationshipToInsured]
           ,[HolderPrefix]
           ,[HolderFirstName]
           ,[HolderMiddleName]
           ,[HolderLastName]
           ,[HolderSuffix]
           ,[HolderDOB]
           ,[HolderSSN]
           ,[HolderThroughEmployer]
           ,[HolderEmployerName]
           ,[PatientInsuranceStatusID]
           ,getdate() as [CreatedDate]
           ,0 as [CreatedUserID]
           ,getdate() as [ModifiedDate]
           ,0 as [ModifiedUserID]
           ,[HolderGender]
           ,[HolderAddressLine1]
           ,[HolderAddressLine2]
           ,[HolderCity]
           ,[HolderState]
           ,[HolderCountry]
           ,[HolderZipCode]
           ,[HolderPhone]
           ,[HolderPhoneExt]
           ,[DependentPolicyNumber]
           ,[Notes]
           ,[Phone]
           ,[PhoneExt]
           ,[Fax]
           ,[FaxExt]
           ,[Copay]
           ,[Deductible]
           ,[PatientInsuranceNumber]
           ,[Active]
           ,[PracticeID]
           ,[AdjusterPrefix]
           ,[AdjusterFirstName]
           ,[AdjusterMiddleName]
           ,[AdjusterLastName]
           ,[AdjusterSuffix]
           ,insurancePolicyID as [VendorID]
           ,1 as [VendorImportID]
           ,[InsuranceProgramTypeID]
FROM [kprod-db09].superbill_2156_prod.dbo.InsurancePolicy
WHERE insurancePolicyID NOT IN ( select insurancePolicyID FROM InsurancePolicy )
	and patientCaseID in (select patientCaseID from patientCase)
	
SET IDENTITY_INSERT [InsurancePolicy] OFF


commit tran
*/