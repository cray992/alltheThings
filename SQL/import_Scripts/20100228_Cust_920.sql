
--insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes )
--select 'kareo', 'sql', getdate(), 'sf 103372'


declare @vendorImportID INT, @newPracticeID int, @srcPracticeID int
select @vendorImportID=30, @srcPracticeID=11, @newPracticeID=14

/*
begin tran
INSERT INTO [dbo].[Patient](
	[PracticeID]
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
	,[CollectionCategoryID]
	)
select 
	@newPracticeID
	,null
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
	,getdate()
	,951 -- phong
	,getdate()
	,951 -- phong
	,[EmploymentStatus]
	,[InsuranceProgramCode]
	,[PatientReferralSourceID]
	,null
	,null
	,[EmployerID]
	,[MedicalRecordNumber]
	,[MobilePhone]
	,[MobilePhoneExt]
	,null
	,PatientID
	,@vendorImportID 
	,[CollectionCategoryID]
from patient
where practiceID=@srcPracticeID


INSERT INTO [dbo].[PatientCase]
           ([PatientID]
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
SELECT
			p.[PatientID]
           ,pc.[Name]
           ,[Active]
           ,[PayerScenarioID]
           ,null [ReferringPhysicianID]
           ,[EmploymentRelatedFlag]
           ,[AutoAccidentRelatedFlag]
           ,[OtherAccidentRelatedFlag]
           ,[AbuseRelatedFlag]
           ,[AutoAccidentRelatedState]
           ,[Notes]
           ,[ShowExpiredInsurancePolicies]
           ,p.[CreatedDate]
           ,p.[CreatedUserID]
           ,p.[ModifiedDate]
           ,p.[ModifiedUserID]
           ,p.[PracticeID]
           ,[CaseNumber]
           ,[WorkersCompContactInfoID]
           ,pc.PatientCaseID
           ,@vendorImportID
           ,[PregnancyRelatedFlag]
           ,[StatementActive]
           ,[EPSDT]
           ,[FamilyPlanning]
           ,[EPSDTCodeID]
           ,[EmergencyRelated]
from PatientCase pc
	inner join patient p
		on p.vendorID=pc.patientID
where p.vendorImportID=@vendorImportID



INSERT INTO [dbo].[InsurancePolicy]
   ([PatientCaseID]
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
	pc.[PatientCaseID]
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
   ,getdate()
   ,pc.[CreatedUserID]
   ,getdate()
   ,pc.[ModifiedUserID]
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
   ,ip.[Notes]
   ,[Phone]
   ,[PhoneExt]
   ,[Fax]
   ,[FaxExt]
   ,[Copay]
   ,[Deductible]
   ,[PatientInsuranceNumber]
   ,ip.[Active]
   ,pc.[PracticeID]
   ,[AdjusterPrefix]
   ,[AdjusterFirstName]
   ,[AdjusterMiddleName]
   ,[AdjusterLastName]
   ,[AdjusterSuffix]
   ,ip.insurancePolicyID as [VendorID]
   ,@vendorImportID as [VendorImportID]
   ,[InsuranceProgramTypeID]
FROM insurancePolicy ip
	inner join patientCase pc
		on ip.patientCaseID=pc.VendorID
where pc.vendorImportID=@VendorImportID
		


-- commit
*/



INSERT INTO [dbo].[Doctor](
	[PracticeID]
   ,[Prefix]
   ,[FirstName]
   ,[MiddleName]
   ,[LastName]
   ,[Suffix]
   ,[SSN]
   ,[AddressLine1]
   ,[AddressLine2]
   ,[City]
   ,[State]
   ,[Country]
   ,[ZipCode]
   ,[HomePhone]
   ,[HomePhoneExt]
   ,[WorkPhone]
   ,[WorkPhoneExt]
   ,[PagerPhone]
   ,[PagerPhoneExt]
   ,[MobilePhone]
   ,[MobilePhoneExt]
   ,[DOB]
   ,[EmailAddress]
   ,[Notes]
   ,[ActiveDoctor]
   ,[CreatedUserID]
   ,[ModifiedUserID]
   ,[UserID]
   ,[Degree]
   ,[DefaultEncounterTemplateID]
   ,[TaxonomyCode]
   ,[DepartmentID]
   ,[VendorID]
   ,[VendorImportID]
   ,[FaxNumber]
   ,[FaxNumberExt]
   ,[OrigReferringPhysicianID]
   ,[External]
   ,[NPI]
   ,[ProviderTypeID]
   ,[ProviderPerformanceReportActive]
   ,[ProviderPerformanceScope]
   ,[ProviderPerformanceFrequency]
   ,[ProviderPerformanceDelay]
   ,[ProviderPerformanceCarbonCopyEmailRecipients]
   )
select
	@newPracticeID as practiceID
   ,[Prefix]
   ,[FirstName]
   ,[MiddleName]
   ,[LastName]
   ,[Suffix]
   ,[SSN]
   ,[AddressLine1]
   ,[AddressLine2]
   ,[City]
   ,[State]
   ,[Country]
   ,[ZipCode]
   ,[HomePhone]
   ,[HomePhoneExt]
   ,[WorkPhone]
   ,[WorkPhoneExt]
   ,[PagerPhone]
   ,[PagerPhoneExt]
   ,[MobilePhone]
   ,[MobilePhoneExt]
   ,[DOB]
   ,[EmailAddress]
   ,[Notes]
   ,[ActiveDoctor]
   ,0 as [CreatedUserID]
   ,0 as [ModifiedUserID]
   ,[UserID]
   ,[Degree]
   ,[DefaultEncounterTemplateID]
   ,[TaxonomyCode]
   ,[DepartmentID]
   ,DoctorID
   ,@VendorImportID
   ,[FaxNumber]
   ,[FaxNumberExt]
   ,[OrigReferringPhysicianID]
   ,[External]
   ,[NPI]
   ,[ProviderTypeID]
   ,[ProviderPerformanceReportActive]
   ,[ProviderPerformanceScope]
   ,[ProviderPerformanceFrequency]
   ,[ProviderPerformanceDelay]
   ,[ProviderPerformanceCarbonCopyEmailRecipients]
from doctor
where practiceID=@srcPracticeID
	and [external]=1
	
	
	
	
	update p
	set referringPhysicianID=d.doctorID
	from patient p
	inner join patient v
		on p.vendorId=v.patientID
	inner join doctor vd
		on v.referringPhysicianID=vd.doctorID
	inner join doctor d
		on d.vendorID= cast(vd.doctorID as varchar(50))
		and d.practiceID=p.practiceID
	where p.vendorImportID=@vendorImportID
		and v.referringPhysicianID is not null
		
	