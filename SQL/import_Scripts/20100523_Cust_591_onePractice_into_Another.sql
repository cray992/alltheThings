select * from patient where practiceID=12



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
	12 as [PracticeID]
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
	,patientID as [VendorID]
	,1 as [VendorImportID]
	,[CollectionCategoryID]
FROM patient
where practiceID=10



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

select pjn.[CreatedDate]
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
from dbo.PatientJournalNote pjn
	inner join patient p
		on p.vendorID=pjn.patientID
where vendorImportId=1



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
	
	
--	delete patientCase where vendorImportID=1
select
	p.[PatientID]
	,pc.[Name]
	,pc.[Active]
	,pc.[PayerScenarioID]
	,pc.[ReferringPhysicianID]
	,pc.[EmploymentRelatedFlag]
	,pc.[AutoAccidentRelatedFlag]
	,pc.[OtherAccidentRelatedFlag]
	,pc.[AbuseRelatedFlag]
	,pc.[AutoAccidentRelatedState]
	,pc.[Notes]
	,pc.[ShowExpiredInsurancePolicies]
	,p.[PracticeID]
	,pc.[CaseNumber]
	,pc.[WorkersCompContactInfoID]
	,pc.patientCaseID as [VendorID]
	,p.[VendorImportID]
	,pc.[PregnancyRelatedFlag]
	,[StatementActive]
	,[EPSDT]
	,[FamilyPlanning]
	,[EPSDTCodeID]
	,[EmergencyRelated]
from patientCase pc           
     inner join patient p
		on p.vendorId=pc.patientID
where p.vendorImportID=1



  

INSERT INTO [superbill_0591_prod].[dbo].[InsurancePolicy](
	[PatientCaseID]
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
	,[GroupName]
	,[ReleaseOfInformation]
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
	,1 as [VendorImportID]
	,[InsuranceProgramTypeID]
	,[GroupName]
	,[ReleaseOfInformation]
from insurancePolicy ip
	inner join patientCase pc
		on pc.vendorID=ip.patientCaseID


alter table appointment add vendorImportId int
alter table appointment add vendorId int
alter table serviceLocation add vendorId int
alter table serviceLocation add vendorImportId int




INSERT INTO [ServiceLocation]
           ([PracticeID]
           ,[Name]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Country]
           ,[ZipCode]
           ,[PlaceOfServiceCode]
           ,[BillingName]
           ,[Phone]
           ,[PhoneExt]
           ,[FaxPhone]
           ,[FaxPhoneExt]
           ,[HCFABox32FacilityID]
           ,[CLIANumber]
           ,[RevenueCode]
           ,[VendorImportID]
           ,[VendorID]
           ,[NPI]
           ,[FacilityIDType]
           ,[TimeZoneID]
           ,[PayToName]
           ,[PayToAddressLine1]
           ,[PayToAddressLine2]
           ,[PayToCity]
           ,[PayToState]
           ,[PayToCountry]
           ,[PayToZipCode]
           ,[PayToPhone]
           ,[PayToPhoneExt]
           ,[PayToFax]
           ,[PayToFaxExt]
           ,[EIN]
           ,[BillTypeID])

select
	12 as [PracticeID]
   ,[Name]
   ,[AddressLine1]
   ,[AddressLine2]
   ,[City]
   ,[State]
   ,[Country]
   ,[ZipCode]
   ,[PlaceOfServiceCode]
   ,[BillingName]
   ,[Phone]
   ,[PhoneExt]
   ,[FaxPhone]
   ,[FaxPhoneExt]
   ,[HCFABox32FacilityID]
   ,[CLIANumber]
   ,[RevenueCode]
   ,1 as [VendorImportID]
   ,serviceLocationID as [VendorID]
   ,[NPI]
   ,[FacilityIDType]
   ,[TimeZoneID]
   ,[PayToName]
   ,[PayToAddressLine1]
   ,[PayToAddressLine2]
   ,[PayToCity]
   ,[PayToState]
   ,[PayToCountry]
   ,[PayToZipCode]
   ,[PayToPhone]
   ,[PayToPhoneExt]
   ,[PayToFax]
   ,[PayToFaxExt]
   ,[EIN]
   ,[BillTypeID]
from serviceLocation
where practiceID=10






-- delete [Appointment] where vendorImportId=1

INSERT INTO [dbo].[Appointment]
           ([PatientID]
           ,[PracticeID]
           ,[ServiceLocationID]
           ,[StartDate]
           ,[EndDate]
           ,[AppointmentType]
           ,[Subject]
           ,[Notes]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[AppointmentResourceTypeID]
           ,[AppointmentConfirmationStatusCode]
           ,[AllDay]
           ,[InsurancePolicyAuthorizationID]
           ,[PatientCaseID]
           ,[Recurrence]
           ,[RecurrenceStartDate]
           ,[RangeEndDate]
           ,[RangeType]
           ,[StartDKPracticeID]
           ,[EndDKPracticeID]
           ,[StartTm]
           ,[EndTm]
           ,[SendAppointmentReminder]
           ,[vendorId]
           ,[vendorImportId])

select
	 p.[PatientID]
	,p.[PracticeID]
	,s.[ServiceLocationID]
	,[StartDate]
	,[EndDate]
	,[AppointmentType]
	,[Subject]
	,a.[Notes]
	,getdate() [CreatedDate]
	,0 [CreatedUserID]
	,getdate() [ModifiedDate]
	,0 [ModifiedUserID]
	,[AppointmentResourceTypeID]
	,[AppointmentConfirmationStatusCode]
	,[AllDay]
	,[InsurancePolicyAuthorizationID]
	,pc.[PatientCaseID]
	,[Recurrence]
	,[RecurrenceStartDate]
	,[RangeEndDate]
	,[RangeType]
	,[StartDKPracticeID]
	,[EndDKPracticeID]
	,[StartTm]
	,[EndTm]
	,[SendAppointmentReminder]
	,a.appointmentId
	,1 as vendorImportId
from dbo.Appointment a
	left join  patient p
		on p.vendorID=a.patientID
	left join serviceLocation s
		on s.vendorId=a.serviceLocationID
	left join patientCase pc
		on pc.vendorId=a.patientCaseID
where p.vendorImportID=1



alter table [AppointmentReason] add vendorImportId int
alter table [AppointmentReason] add vendorId int


-- delete AppointmentReason where vendorImportId=1
INSERT INTO [dbo].[AppointmentReason]
           ([PracticeID]
           ,[Name]
           ,[DefaultDurationMinutes]
           ,[DefaultColorCode]
           ,[Description]
           ,[ModifiedDate]
           ,VendorId
           ,VendorImportId
           )

select 
			12 [PracticeID]
			,[Name]
			,[DefaultDurationMinutes]
			,[DefaultColorCode]
			,[Description]
			,getdate() as [ModifiedDate]
			,AppointmentReasonID
			,1 
from dbo.AppointmentReason
where practiceID=10




alter table [AppointmentToResource] add vendorId int
alter table [AppointmentToResource] add vendorImportId int

-- delete [AppointmentToResource] where [PracticeID]=12
INSERT INTO [dbo].[AppointmentToResource]
           ([AppointmentID]
           ,[AppointmentResourceTypeID]
           ,[ResourceID]
           ,[ModifiedDate]
           ,[PracticeID]
           ,vendorId
           ,vendorImportId
           )
select 
			a.[AppointmentID]
           ,ar.[AppointmentResourceTypeID]
           ,555 as [ResourceID]
           ,getdate() as [ModifiedDate]
           ,a.[PracticeID]
           ,[AppointmentToResourceID]
           ,1
from [AppointmentToResource] ar
	inner join appointment a
		on a.vendorId=ar.appointmentId
		and ar.AppointmentResourceTypeID=1
where ar.practiceID=10
	and resourceID=414



INSERT INTO [dbo].[AppointmentToResource]
           ([AppointmentID]
           ,[AppointmentResourceTypeID]
           ,[ResourceID]
           ,[ModifiedDate]
           ,[PracticeID]
           ,vendorId
           ,vendorImportId
           )
select 
			a.[AppointmentID]
           ,ar.[AppointmentResourceTypeID]
           ,14 as [ResourceID]
           ,getdate() as [ModifiedDate]
           ,a.[PracticeID]
           ,[AppointmentToResourceID]
           ,1
from [AppointmentToResource] ar
	inner join appointment a
		on a.vendorId=ar.appointmentId
		and ar.AppointmentResourceTypeID=2
where ar.practiceID=10
	and resourceID=11

select * from doctor where practiceID=12
select * from PracticeResource


alter table dbo.AppointmentToAppointmentReason add vendorId int
alter table dbo.AppointmentToAppointmentReason add vendorImportId int

INSERT INTO [dbo].[AppointmentToAppointmentReason]
           ([AppointmentID]
           ,[AppointmentReasonID]
           ,[PrimaryAppointment]
           ,[ModifiedDate]
           ,[PracticeID]
           ,[vendorId]
           ,[vendorImportId]
           )
select
			a.[AppointmentID]
           ,ar.[AppointmentReasonID]
           ,[PrimaryAppointment]
           ,getdate() [ModifiedDate]
           ,a.[PracticeID]
           ,AppointmentToAppointmentReasonID [vendorId]
           ,1 [vendorImportId]
from [AppointmentToAppointmentReason] aar
	inner join appointment a
		on aar.appointmentId=a.vendorId
	inner join AppointmentReason ar
		on ar.vendorid=aar.[AppointmentReasonID]
where a.vendorImportId=1




alter table AppointmentRecurrence add vendorId int
alter table AppointmentRecurrence add vendorImportId int

select * 
from dbo.AppointmentRecurrence ar
	inner join appointment a
		on a.vendorId=ar.appointmentId
		
