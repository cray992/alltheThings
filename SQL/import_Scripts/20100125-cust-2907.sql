use superbill_2907_prod
GO


--insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
--values( 'Custom', 'xls', getdate(), 'sf 101884 ')


declare @vendorImportID int, @practiceID int
select @vendorImportID=1, @practiceID =2

/*
INSERT INTO [dbo].[Patient]
   ([PracticeID]
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
@practiceID [PracticeID]
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
,getdate() as [CreatedDate]
,0 as [CreatedUserID]
,getdate() as [ModifiedDate]
,0 as [ModifiedUserID]
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
,PatientID
,@vendorImportID
,[CollectionCategoryID]
from Patient
where practiceID=1




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
   
   
select
	p.[PatientID]
   ,[Name]
   ,[Active]
   ,[PayerScenarioID]
   ,pc.[ReferringPhysicianID]
   ,[EmploymentRelatedFlag]
   ,[AutoAccidentRelatedFlag]
   ,[OtherAccidentRelatedFlag]
   ,[AbuseRelatedFlag]
   ,[AutoAccidentRelatedState]
   ,[Notes]
   ,[ShowExpiredInsurancePolicies]
   ,getdate() as [CreatedDate]
   ,0 as [CreatedUserID]
   ,getdate() as [ModifiedDate]
   ,0 as [ModifiedUserID]
   ,p.[PracticeID]
   ,[CaseNumber]
   ,[WorkersCompContactInfoID]
   ,pc.patientCaseID as [VendorID]
   ,p.[VendorImportID]
   ,[PregnancyRelatedFlag]
   ,[StatementActive]
   ,[EPSDT]
   ,[FamilyPlanning]
   ,[EPSDTCodeID]
   ,[EmergencyRelated]
from dbo.PatientCase pc
	inner join patient p
		on p.vendorID=pc.patientID
		and p.vendorImportID=@VendorImportID




   
INSERT INTO [InsurancePolicy]
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
   ,[InsuranceProgramTypeID]
   )
   
select
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
   ,ip.InsurancePolicyID as [VendorID]
   ,pc.[VendorImportID]
   ,[InsuranceProgramTypeID]
FROM dbo.InsurancePolicy ip
	inner join patientCase pc
		on pc.vendorID=ip.patientCaseID
		and pc.VendorImportID=@VendorImportID



INSERT INTO [dbo].[PatientJournalNote]
           ([CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[PatientID]
           ,[UserName]
           ,[SoftwareApplicationID]
           ,[Hidden]
           ,[NoteMessage]
           ,[AccountStatus]
           ,[NoteTypeCode]
           ,[LastNote])
select
	pjn.[CreatedDate]
	,pjn.[CreatedUserID]
	,pjn.[ModifiedDate]
	,pjn.[ModifiedUserID]
	,p.[PatientID]
	,pjn.[UserName]
	,pjn.[SoftwareApplicationID]
	,pjn.[Hidden]
	,pjn.[NoteMessage]
	,pjn.[AccountStatus]
	,pjn.[NoteTypeCode]
	,pjn.[LastNote]
FROM [PatientJournalNote] pjn
	inner join patient p
		on p.vendorID=pjn.patientID
		and p.vendorImportID=1
		
           
*/

INSERT INTO [dbo].[PatientCaseDate](
	[PracticeID]
	,[PatientCaseID]
	,[PatientCaseDateTypeID]
	,[StartDate]
	,[EndDate]
	,[CreatedDate]
	,[CreatedUserID]
	,[ModifiedDate]
	,[ModifiedUserID]
	)
select
	pc.[PracticeID]
	,pc.[PatientCaseID]
	,pcd.[PatientCaseDateTypeID]
	,pcd.[StartDate]
	,pcd.[EndDate]
	,pcd.[CreatedDate]
	,pcd.[CreatedUserID]
	,pcd.[ModifiedDate]
	,pcd.[ModifiedUserID]
FROM [PatientCaseDate] pcd
	inner join PatientCase pc
		on pc.VendorID=pcd.PatientCaseID
		and pc.vendorImportID=1


INSERT INTO [dbo].[InsurancePolicyAuthorization]
   ([InsurancePolicyID]
   ,[AuthorizationNumber]
   ,[AuthorizedNumberOfVisits]
   ,[StartDate]
   ,[EndDate]
   ,[ContactFullname]
   ,[ContactPhone]
   ,[ContactPhoneExt]
   ,[AuthorizationStatusID]
   ,[Notes]
   ,[CreatedDate]
   ,[CreatedUserID]
   ,[ModifiedDate]
   ,[ModifiedUserID]
   ,[AuthorizedNumberOfVisitsUsed]
   ,[VendorID]
   ,[VendorImportID])
SELECT
	ip.[InsurancePolicyID]
   ,[AuthorizationNumber]
   ,[AuthorizedNumberOfVisits]
   ,[StartDate]
   ,[EndDate]
   ,[ContactFullname]
   ,[ContactPhone]
   ,[ContactPhoneExt]
   ,[AuthorizationStatusID]
   ,ipa.[Notes]
   ,getdate() as [CreatedDate]
   ,0 as [CreatedUserID]
   ,getdate() as [ModifiedDate]
   ,0 as [ModifiedUserID]
   ,[AuthorizedNumberOfVisitsUsed]
   ,InsurancePolicyAuthorizationID as [VendorID]
   ,ip.VendorImportID as [VendorImportID]
FROM [InsurancePolicyAuthorization] ipa
	inner join insurancePolicy ip
		on ip.VendorID=ipa.[InsurancePolicyID]
		and ip.VendorImportID=1
           

	
	