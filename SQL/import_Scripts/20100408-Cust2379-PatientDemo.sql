




--============================================
-- Insert Insurance Company
--============================================
/*

	select distinct PrimaryInsurance,
	'exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]
		@name = ''' + replace(PrimaryInsurance, '', '''''') + ''',
		@street_1 = '''',
		@street_2 = '''',
		@city ='''',
		@state = '''',
		@country = '''',
		@zip = '''',
		@contact_prefix = NULL,
		@contact_first_name = NULL,
		@contact_middle_name = NULL,
		@contact_last_name = NULL,
		@contact_suffix = NULL,
		@phone = null,
		@phone_x = null,
		@fax = null,
		@fax_x = null,
		@notes = ''Imported by Kareo on Dec 27, 2009'',
		@practice_id = ''1'',
		@BillingFormID = 13,
		@SecondaryPrecedenceBillingFormID =13,
		@AcceptAssignment = 0,
		@UseSecondaryElectronicBilling = 0,
		@UseCoordinationOfBenefits = 1,
		@ExcludePatientPayment = 0,
		@bill_secondary_insurance = 0,
		@review_code=''R'',
		@UseFacilityID=''1'',
		@eclaims_disable=0	
	'
	from zzImport_20091226 z
	where [PrimaryInsurance] not in (select insuranceCompanyName from insuranceCompany icp )
	order by 1

	select distinct SecondaryInsurance,
	'exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]
		@name = ''' + replace(SecondaryInsurance, '', '''''') + ''',
		@street_1 = '''',
		@street_2 = '''',
		@city ='''',
		@state = '''',
		@country = '''',
		@zip = '''',
		@contact_prefix = NULL,
		@contact_first_name = NULL,
		@contact_middle_name = NULL,
		@contact_last_name = NULL,
		@contact_suffix = NULL,
		@phone = null,
		@phone_x = null,
		@fax = null,
		@fax_x = null,
		@notes = ''Imported by Kareo on Dec 27, 2009'',
		@practice_id = ''1'',
		@BillingFormID = 13,
		@SecondaryPrecedenceBillingFormID =13,
		@AcceptAssignment = 0,
		@UseSecondaryElectronicBilling = 0,
		@UseCoordinationOfBenefits = 1,
		@ExcludePatientPayment = 0,
		@bill_secondary_insurance = 0,
		@review_code=''R'',
		@UseFacilityID=''1'',
		@eclaims_disable=0	
	'
	from zzImport_20091226 z
	where [SecondaryInsurance] not in (select insuranceCompanyName from insuranceCompany icp )
	order by 1

*/



alter table zz_import_20100507_insurance add insuranceCompanyID int
update dbo.zz_import_20100507_insurance


--==========================================
-- Primary Insurance Plan
--==========================================

-- Primry
select distinct [PrimaryInsurance], [PrimaryPlan], ic.insuranceCompanyID,
	'exec InsurancePlanDataProvider_CreateInsurancePlan 
		@name=N''' + [PrimaryPlan] + '''
		,@street_1=N''' + isnull([Primary Insurance Address 1],'') + '''
		,@program_code=N''CI''
		,@street_2=N''' + isnull([Primary Insurance Address 2],'') + '''
		,@deductible=''' + cast(Deductible as varchar(32)) + '''
		,@company_id=' + cast(insuranceCompanyID as varchar(32)) + '
		,@fax_x=NULL
		,@phone='''+isnull([PrimaryInsuranceMainPhone], '')+'''
		,@contact_suffix=NULL
		,@review_code=N''''
		,@phone_x='''+isnull([PrimaryInsuranceMainPhoneExt], '')+'''
		,@contact_last_name=NULL
		,@city=N'''+isnull([Primary Insurance City],'')+'''
		,@fax=NULL
		,@state=N'''+isnull([PrimaryInsuranceState],'')+'''
		,@notes=N''Imported by Kareo''
		,@contact_prefix=NULL
		,@country=N''''
		,@contact_first_name=NULL
		,@copay=''' + cast(Copy as varchar(32)) + '''
		,@zip=N'''+isnull(left([Primary Insurance Postal Code],9),'')+'''
		,@EClaimsAccepts=0
		,@practice_id=1
		,@contact_middle_name=NULL'
from zzImport_20091226 z
	inner join insuranceCompany ic
		on ic.insuranceCompanyName=[PrimaryInsurance]
where NOT exists(select * from insuranceCompanyPlan icp where icp.planName=z.PrimaryPlan and icp.InsuranceCompanyID=ic.InsuranceCompanyID)
order by 1, 2

*/














--==========================================
--Secondary Plan
--==========================================

alter table zzImport_20091226 add SecondaryInsuranceMainPhone varchar(10)
alter table zzImport_20091226 add SecondaryInsuranceMainPhoneExt varchar(10)

update w
set SecondaryInsuranceMainPhone = replace(replace(replace(replace(left([Secondary Insurance Main Phone], charindex( 'x', [Secondary Insurance Main Phone])-1), '-', ''), '(', ''), ')', ''), ' ', '')
from zzImport_20091226 w
where ( charindex( 'x', [Secondary Insurance Main Phone]) > 1 )
	and 1=isnumeric( replace(replace(replace(replace(left([Secondary Insurance Main Phone], charindex( 'x', [Secondary Insurance Main Phone])-1), '-', ''), '(', ''), ')', ''), ' ', '') ) 
	
update w
set SecondaryInsuranceMainPhone = replace(replace(replace(replace([Secondary Insurance Main Phone], '-', ''), '(', ''), ')', ''), ' ', '')
from zzImport_20091226 w
where ( charindex( 'x', [Secondary Insurance Main Phone]) = 0   )
	and 1=isnumeric( replace(replace(replace(replace([Secondary Insurance Main Phone], '-', ''), '(', ''), ')', ''), ' ', ''))
	and len( replace(replace(replace(replace([Secondary Insurance Main Phone], '-', ''), '(', ''), ')', ''), ' ', '') ) = 10
	and SecondaryInsuranceMainPhone is null

update w
set SecondaryInsuranceMainPhoneExt = replace(replace(replace(replace( right([Secondary Insurance Main Phone], len([Secondary Insurance Main Phone]) - charindex( 'x', [Secondary Insurance Main Phone])) , '-', ''), '(', ''), ')', ''), ' ', '')
from zzImport_20091226 w
where 1=isnumeric( replace(replace(replace(replace( right([Secondary Insurance Main Phone], len([Secondary Insurance Main Phone]) - charindex( 'x', [Secondary Insurance Main Phone])) , '-', ''), '(', ''), ')', ''), ' ', '') ) 
	and ( charindex( 'x', [Secondary Insurance Main Phone]) > 1 )



/*
-- Secondary


select distinct [SecondaryInsurance], [SecondaryPlan], ic.insuranceCompanyID,
	'exec InsurancePlanDataProvider_CreateInsurancePlan 
		@name=N''' + [SecondaryPlan] + '''
		,@street_1=N''' + isnull([Secondary Insurance Address 1],'') + '''
		,@program_code=N''CI''
		,@street_2=N''' + isnull([Secondary Insurance Address 2],'') + '''
		,@deductible=0
		,@company_id=' + cast(insuranceCompanyID as varchar(32)) + '
		,@fax_x=NULL
		,@phone='''+isnull([SecondaryInsuranceMainPhone], '')+'''
		,@contact_suffix=NULL
		,@review_code=N''''
		,@phone_x='''+isnull([SecondaryInsuranceMainPhoneExt], '')+'''
		,@contact_last_name=NULL
		,@city=N'''+isnull([Secondary Insurance City],'')+'''
		,@fax=NULL
		,@state=N'''+isnull([SecondaryInsuranceState],'')+'''
		,@notes=N''Imported by Kareo''
		,@contact_prefix=NULL
		,@country=N''''
		,@contact_first_name=NULL
		,@copay=0
		,@zip=N'''+isnull(left([Secondary Insurance Postal Code],9),'')+'''
		,@EClaimsAccepts=0
		,@practice_id=1
		,@contact_middle_name=NULL'
from zzImport_20091226 z
	inner join insuranceCompany ic
		on ic.insuranceCompanyName=[SecondaryInsurance]
where NOT exists(
		select * 
		from insuranceCompanyPlan icp 
		where icp.planName=z.SecondaryPlan 
			and icp.InsuranceCompanyID=ic.InsuranceCompanyID
			and isnull(icp.AddressLine1, '')=isnull([Secondary Insurance Address 1], '')
			and isnull(icp.AddressLine2, '')=isnull([Secondary Insurance Address 2], '')
			and isnull(icp.City, '')=isnull([Secondary Insurance City], '')
			and isnull(icp.ZipCode, '')=isnull(left([Secondary Insurance Postal Code],9), '')
			and isnull(icp.Phone, '')=isnull(SecondaryInsuranceMainPhone, '')
			and isnull(icp.PhoneExt, '')=isnull(SecondaryInsuranceMainPhoneExt, '')
		)
order by 1, 2
*/


alter table dbo.zz_import_PatientDemo_20100408 add dob datetime

update z
set dob= cast(
		substring( cast( cast([Date of Birth] as int) as varchar(10)) , 5,2) -- mo
			+ '/' + substring( cast( cast([Date of Birth] as int) as varchar(10)) , 7,2) -- day
			+ '/' + substring( cast( cast([Date of Birth] as int) as varchar(10)) , 1,4) -- year
	as datetime)
from zz_import_PatientDemo_20100408 z
where [Date of Birth] between 19000000 and 99991231

update zz_import_PatientDemo_20100408
set [Middle Initial]=''
where [Middle Initial] is null



--==========================================
-- Insert Patient
--==========================================

insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 109794')

update zz_import_PatientDemo_20100408
set [Marital Status]=null
where [Marital Status]='X'


alter table zz_import_PatientDemo_20100408 add rowid int identity(1,1)
-- begin tran

select * from practice order by name

declare @practiceID int, @vendorImportID int
select @practiceID=43, @vendorImportID=3

	INSERT INTO [dbo].[Patient](
		prefix,
		Suffix,
		MiddleName,
		[PracticeID],
		[FirstName],
		[LastName],
		[AddressLine1],
		[AddressLine2],
		[City],
		[State],
		[ZipCode],
		[HomePhone],
		WorkPhone,
		WorkPhoneExt,
		MobilePhone,
		[DOB],
		SSN,
		[Gender],
		[VendorID],
		MedicalRecordNumber,
		VendorImportID,
		CollectionCategoryID,
		DefaultServiceLocationID,
		PrimaryProviderID,
		EmailAddress,
		EmploymentStatus,
		EmployerID,
		MaritalStatus
		)
	    
	SELECT 
		'',
		'',
		[Middle Initial] as MI,
		@practiceID as practiceID,
		isnull( [First Name], ''),
		isnull( [Last Name], ''),
		left([Address 1], 256),
		left([Address 2], 256),
		i.[City],
		State,
		left( cast(cast([Zip Code] as bigint) as varchar(32)), 9)as zip,
		cast( [Home Phone] as bigint),
		cast([Work Phone] as bigint),
		cast([Work Extension] as bigint),
		null as MobilePhone, 
		dob,
		replace([Social Security Number], '-', '') SSN,
		[Sex],  
		rowid as [VendorID], -- vendorID
		[Chart Number] as  MRN,
		@vendorImportID, -- vendorID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		null as Email,
		EmploymentStatus = null ,
		null EmployerID,
		[Marital Status] as MaritalStatus
	from dbo.zz_import_PatientDemo_20100408 i
	where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=@vendorImportID)
		

-- rollback tran




	-- Self Pay
	INSERT INTO [PatientCase]
		([PatientID]
		,[Name]
		,[Active]
		,[PayerScenarioID] -- select * from payerScenario
		,[CreatedUserID]
		,[ModifiedUserID]
		,[PracticeID]
		,VendorID
		,VendorImportID
		   )

	select
		patientID,	
		'DEFAULT CASE',
		1,
		11,
		951,
		951,
		practiceID,
		VendorID,
		VendorImportID
	from Patient p
	where VendorImportID in( 1,2,3)
		and not exists(select * from patientCase pc where pc.patientID=p.patientID )




begin tran


insert into PatientJournalNote( PatientID, UserName, SoftwareApplicationID
	, Hidden
	, NoteMessage
	, AccountStatus
	, NoteTypeCode, LastNote )

select p.patientID, 'Kareo Import', 'K'
	, 0
	, Comments
	, 0
	, 1
	, 0
from zzImport_20091226 i
	inner join patient p 
		on p.vendorID=i.rowID
where VendorImportID=1
	and Comments is not null



-- rollback tran
-- commit;

INSERT INTO [dbo].[PatientJournalNote](
   [PatientID]
	,CreatedDate
   ,[UserName]
   ,[SoftwareApplicationID]
   ,[Hidden]
   ,[NoteMessage]
   ,[AccountStatus]
   ,[NoteTypeCode]
   ,[LastNote]
)


select
	p.patientID,
	'5/16/2010 11:10 pm',
	'Kareo',
	'K',
	0,
	Note =
	    'InsCode1:' + isnull([Insurance Code 1], '')+char(10)+char(13)
      +'InsGroupNum1' + isnull(cast([Insurance Group Number 1] as varchar(32)), '')+char(10)+char(13)
      +'InsInsuredId1:' + isnull([Insurance Insured ID 1], '')+char(10)+char(13)
      +'InsAuth1:' + isnull(cast([Insurance Authorization 1] as varchar(32)), '')+char(10)+char(13)
      +'InsCode2:' + isnull([Insurance Code 2], '')+char(10)+char(13)
      +'InsType2:' + isnull([Insurance Type 2], '')+char(10)+char(13)
      +'InsGroupNum2:' + isnull([Insurance Group Number 2], '')+char(10)+char(13)
      +'InsInsuredId2:' + isnull([Insurance Insured ID 2], '')+char(10)+char(13)
	,0
	,1
	,0
from patient p
	inner join [zz_import_PatientDemo_20100408] z
		on p.vendorID=z.rowID
where vendorImportID=1