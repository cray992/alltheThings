-- drop table [zz_import_20100806_patient]

select distinct practice from zz_import_20100806_patient

select distinct [Column 2] from dbo.zz_import_20100806_patient
select practiceId, name from practice order by name

select 'James Anarella DPM' name,'52' practiceId 
into zz_import_20100806_patient_practice
union all select 'Spanish American Foot Assc','61','Centerock Podiatry PC' union all

select * from practice where name like '%Anarella%'



/*


update zz_import_20100806_patient
set practiceId=null


select 'alter table zz_import_20100806_patient drop column ' + c.name
from sys.columns c
	inner join sys.tables t
		on t.object_id=c.object_id
where t.name='zz_import_20100806_patient'
	and c.name like 'F%'
	select * from zz_import_20100806_patient

alter table zz_import_20100806_patient drop column F5
alter table zz_import_20100806_patient drop column F7
alter table zz_import_20100806_patient drop column F9
alter table zz_import_20100806_patient drop column F11
alter table zz_import_20100806_patient drop column F13
alter table zz_import_20100806_patient drop column F15
alter table zz_import_20100806_patient drop column F17
alter table zz_import_20100806_patient drop column F19
alter table zz_import_20100806_patient drop column F21
alter table zz_import_20100806_patient drop column F23
alter table zz_import_20100806_patient drop column F25
alter table zz_import_20100806_patient drop column F27
alter table zz_import_20100806_patient drop column F29
alter table zz_import_20100806_patient drop column F31
alter table zz_import_20100806_patient drop column F33
alter table zz_import_20100806_patient drop column F35
alter table zz_import_20100806_patient drop column F37
alter table zz_import_20100806_patient drop column F39
alter table zz_import_20100806_patient drop column F41
alter table zz_import_20100806_patient drop column F43
alter table zz_import_20100806_patient drop column F45
alter table zz_import_20100806_patient drop column F47
alter table zz_import_20100806_patient drop column F49
alter table zz_import_20100806_patient drop column F51
alter table zz_import_20100806_patient drop column F53
alter table zz_import_20100806_patient drop column F55
alter table zz_import_20100806_patient drop column F57
alter table zz_import_20100806_patient drop column F59
alter table zz_import_20100806_patient drop column F61
alter table zz_import_20100806_patient drop column F63
alter table zz_import_20100806_patient drop column F65
alter table zz_import_20100806_patient drop column F67
alter table zz_import_20100806_patient drop column F69
alter table zz_import_20100806_patient drop column F71
alter table zz_import_20100806_patient drop column F73
alter table zz_import_20100806_patient drop column F75
alter table zz_import_20100806_patient drop column F77
alter table zz_import_20100806_patient drop column F79
alter table zz_import_20100806_patient drop column F81
alter table zz_import_20100806_patient drop column F83
alter table zz_import_20100806_patient drop column F85
alter table zz_import_20100806_patient drop column F87
alter table zz_import_20100806_patient drop column F89
alter table zz_import_20100806_patient drop column F91
alter table zz_import_20100806_patient drop column F93
alter table zz_import_20100806_patient drop column F95
alter table zz_import_20100806_patient drop column F97
alter table zz_import_20100806_patient drop column F99
alter table zz_import_20100806_patient drop column F101
alter table zz_import_20100806_patient drop column F103
alter table zz_import_20100806_patient drop column F105
alter table zz_import_20100806_patient drop column F107
alter table zz_import_20100806_patient drop column F109
alter table zz_import_20100806_patient drop column F111
alter table zz_import_20100806_patient drop column F113
alter table zz_import_20100806_patient drop column F115
alter table zz_import_20100806_patient drop column F117
alter table zz_import_20100806_patient drop column F119
alter table zz_import_20100806_patient drop column F121
alter table zz_import_20100806_patient drop column F123
alter table zz_import_20100806_patient drop column F125
alter table zz_import_20100806_patient drop column F127
alter table zz_import_20100806_patient drop column F129
alter table zz_import_20100806_patient drop column F131
alter table zz_import_20100806_patient drop column F133
alter table zz_import_20100806_patient drop column F135
alter table zz_import_20100806_patient drop column F137
alter table zz_import_20100806_patient drop column F139
alter table zz_import_20100806_patient drop column F141
alter table zz_import_20100806_patient drop column F143
alter table zz_import_20100806_patient drop column F145
alter table zz_import_20100806_patient drop column F147
alter table zz_import_20100806_patient drop column F149
alter table zz_import_20100806_patient drop column F151
alter table zz_import_20100806_patient drop column F153
alter table zz_import_20100806_patient drop column F155
alter table zz_import_20100806_patient drop column F157
alter table zz_import_20100806_patient drop column F159
alter table zz_import_20100806_patient drop column F161
alter table zz_import_20100806_patient drop column F163
alter table zz_import_20100806_patient drop column F165
alter table zz_import_20100806_patient drop column F167
alter table zz_import_20100806_patient drop column F169
alter table zz_import_20100806_patient drop column F171
alter table zz_import_20100806_patient drop column F173
alter table zz_import_20100806_patient drop column F175
alter table zz_import_20100806_patient drop column F177
alter table zz_import_20100806_patient drop column F179
alter table zz_import_20100806_patient drop column F181
alter table zz_import_20100806_patient drop column F183
alter table zz_import_20100806_patient drop column F185
alter table zz_import_20100806_patient drop column F187
alter table zz_import_20100806_patient drop column F189
alter table zz_import_20100806_patient drop column F191
alter table zz_import_20100806_patient drop column F193
alter table zz_import_20100806_patient drop column F195
alter table zz_import_20100806_patient drop column F197
alter table zz_import_20100806_patient drop column F199
alter table zz_import_20100806_patient drop column F201
alter table zz_import_20100806_patient drop column F203
alter table zz_import_20100806_patient drop column F205
alter table zz_import_20100806_patient drop column F207
alter table zz_import_20100806_patient drop column F209
alter table zz_import_20100806_patient drop column F211
alter table zz_import_20100806_patient drop column F213
alter table zz_import_20100806_patient drop column F215
alter table zz_import_20100806_patient drop column F217
alter table zz_import_20100806_patient drop column F219
alter table zz_import_20100806_patient drop column F221
alter table zz_import_20100806_patient drop column F223
alter table zz_import_20100806_patient drop column F225
alter table zz_import_20100806_patient drop column F227
alter table zz_import_20100806_patient drop column F229
alter table zz_import_20100806_patient drop column F231
alter table zz_import_20100806_patient drop column F233
alter table zz_import_20100806_patient drop column F235
alter table zz_import_20100806_patient drop column F237
alter table zz_import_20100806_patient drop column F239
alter table zz_import_20100806_patient drop column F241
alter table zz_import_20100806_patient drop column F243
alter table zz_import_20100806_patient drop column F245
alter table zz_import_20100806_patient drop column F247
alter table zz_import_20100806_patient drop column F249
alter table zz_import_20100806_patient drop column F251
alter table zz_import_20100806_patient drop column F253
alter table zz_import_20100806_patient drop column F255



alter table zz_import_20100806_patient add rowid int identity(1,1)
alter table zz_import_20100806_patient add practiceID int
alter table zz_import_20100806_patient add patientID int


alter table zz_import_20100806_patient add firstname varchar(255)
alter table zz_import_20100806_patient add lastName varchar(255)
alter table zz_import_20100806_patient add MiddleInitial char(1)
alter table zz_import_20100806_patient add MedicalRecordNumber varchar(255)

*/
select * from zz_import_20100806_patient
select * from zz_import_20100806_patient_practice

update z
set practiceId= 57
from zz_import_20100806_patient z
where practice='Spanish American Foot Assc'


select distinct practice from zz_import_20100806_patient
where practiceId is null


update z
set MedicalRecordNumber = ltrim(rtrim(substring( PatientCode, 1, charindex(' (', PatientCode) )))
from zz_import_20100806_patient z


update z
set firstName = rtrim(ltrim(substring( PatientCode
				,charindex('(', PatientCode)+1
				,charindex( ' ', PatientCode, charindex('(', PatientCode)) - charindex('(', PatientCode)
				)))
from zz_import_20100806_patient z
where charindex( ' ', PatientCode, charindex('(', PatientCode)) - charindex('(', PatientCode) > 0



Update z
SET LastName= ltrim(rtrim(reverse(substring( reverse( patientCode ), 2, charindex(' ', reverse( patientCode ))-1 ))  ))
from zz_import_20100806_patient z


update z
set MiddleInitial=
	LEFT(
		replace(replace(replace(
			replace( 
				replace( 
					replace( patientCode
							, MedicalRecordNumber, '')
						, firstname, '')
					, lastName, '')
			,'(', ''), ')', ''), ' ', '')
		, 1)
from zz_import_20100806_patient z


insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 122335')


/*
select * from vendorImport order by 1

select count(*) from patient where vendorImportId=3
select count(*) from insurancePolicy where vendorImportId=3
select count(*) from patientCase where vendorImportId=3


delete from insurancePolicy where vendorImportId=5
delete from patientCase where vendorImportId=5
delete pjn from patientJournalNote pjn
	inner join patient p on p.patientId=pjn.patientId 
	where vendorImportId=5
delete from patient where vendorImportId=5
*/


update zz_import_20100806_patient
set [Zip_Code] = null
where  isnull(isnumeric( replace([Zip_Code], '-', '')), 0)=0


update zz_import_20100806_patient
set [Zip_Code] = null
where  len(replace([Zip_Code], '-', ''))>9


declare @vendorImportID int
select @vendorImportID=6


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
	left(isnull([MiddleInitial], ''), 1) as MI,
	practiceID,
	left(isnull([firstname], '') , 64),
	left(isnull( [lastname], ''), 64),
	left([Address_1], 256),
	left([Address_2], 256),
	left(i.[City], 128),
	case when len(state)>2 then null else [State] end,
	zip = left( cast(
					cast(
							case when isnumeric( replace([Zip_Code], '-', ''))= 1 then replace([Zip_Code], '-', '')  else null end
						as bigint) 
					as varchar(32))
				, 9
			),
	case when len(replace(replace(replace(replace([Home_Phone], '-', ''), ')', ''), '(', ''), ' ', '') ) > 10 then null else cast( replace(replace(replace(replace([Home_Phone], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) end as phoneHome,
	case when len(replace(replace(replace(replace(Work_Phone, '-', ''), ')', ''), '(', ''), ' ', '') ) > 10 then null else cast( replace(replace(replace(replace(Work_Phone, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) end  as phoneWork,
	cast(null as bigint) as phone_work_ext,
	case when len(replace(replace(replace(replace(Mobile_Phone, '-', ''), ')', ''), '(', ''), ' ', '') ) > 10 then null else cast( replace(replace(replace(replace(Mobile_Phone, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) end  as phoneWork,
	[Birth_Date] dob,
	SSN = case when isnumeric( replace([Social_Security_#], '-', ''))=0 then null else replace([Social_Security_#], '-', '') end,
	LEFT([Sex], 1),  
	rowid as [VendorID], -- vendorID
	left([MedicalRecordNumber], 128) as  MRN,
	@vendorImportID, -- vendorID
	1,
	null as serviceLocationID,
	null as primaryProviderID,
	left(isnull([Home_E-Mail], [Work_E-Mail]), 256) as Email,
	EmploymentStatus = left([Employment_Status],1) ,
	null EmployerID,
	LEFT([Marital_Status], 1) as MaritalStatus
from dbo.zz_import_20100806_patient i
where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=@vendorImportID)
	and i.practiceID > 0
	
	
	

-- drop table zz_import_20100806_Insurance
select [Primary_Insurance]
      ,[Primary_Type]
      ,[Primary_Group_Number]
      ,[Primary_ID]
      ,[Primary_Authorization]
      ,[Primary_Accept_Assign]
      ,[Primary_Insured]
      ,[Primary_Insured_Relation]
      ,[Primary_Claim_Number]
      ,rowID
      ,'primaryInsurance' as type
      ,1 as precedence
into zz_import_20100806_Insurance
FROM zz_import_20100806_patient

union all 

select
	[Secondary_Insurance]
      ,[Secondary_Type]
      ,[Secondary_Group_Number]
      ,[Secondary_ID]
      ,[Secondary_Authorization]
      ,[Secondary_Accept_Assign]
      ,[Secondary_Insured]
      ,[Secondary_Insured_Relation]
      ,[Secondary_Claim_Number]
      ,rowID
      ,'secondaryInsurance'
      ,2 as precedence
FROM zz_import_20100806_patient

union all

select
	[Tertiary_Insurance]
      ,[Tertiary_Type]
      ,[Tertiary_Group_Number]
      ,[Tertiary_ID]
      ,[Tertiary_Authorization]
      ,[Tertiary_Accept_Assign]
      ,[Tertiary_Insured]
      ,[Tertiary_Insured_Relation]
      ,[Tertiary_Claim_Number]
      ,rowID
      ,'tertiaryInsurance'
      ,3 as precedence
FROM zz_import_20100806_patient




alter table zz_import_20100806_Insurance add insuranceCompanyID int 



update z
set insuranceCompanyID=i.insuranceCompanyID
from zz_import_20100806_Insurance z
	inner join insuranceCompany i
		on isnull(z.[Primary_Insurance], '')=isnull(insuranceCompanyName, '')
		

	select  
	'exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]
		@name = ''' + replace(z.[Primary_Insurance], '''', '''''') + ''',
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
		@notes = ''Kareo Import July 30, 2010'',
		@practice_id =' + cast( min(practiceID) as varchar(255) ) + ',
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
	from dbo.zz_import_20100806_Insurance z
		inner join zz_import_20100806_patient p
			on z.rowId=p.rowID
	where  insuranceCompanyId is null
	group by z.[Primary_Insurance]
	order by z.[Primary_Insurance]





alter table dbo.zz_import_20100806_Insurance add insuranceCompanyPlanId int

update icp
set VendorImportId=5
from insuranceCompanyPlan icp
where cast(notes as varchar(max))='Imported by Kareo July 31, 2010'
	and VendorImportId is null


update z
set insuranceCompanyPlanId=ip.insuranceCompanyPlanId
from insuranceCompanyPlan ip
	inner join zz_import_20100806_Insurance z
		on z.insuranceCompanyId=ip.insuranceCompanyID
where primary_insurance=ip.planName




declare @vendorImportId int
set @vendorImportId=6

update z
set patientID=p.patientId
from zz_import_20100806_patient z
	inner join patient p
		 on p.vendorId=z.rowID
where p.vendorImportID=@vendorImportId






declare @vendorImportId int
set @vendorImportId=6

	-- delete [PatientCase] where vendorImportID=1
	-- Primary
	INSERT INTO [PatientCase]
		([PatientID]
		,[Name]
		,[Active]
		,[PayerScenarioID] -- select * from payerScenario
		,[CreatedUserID]
		,[ModifiedUserID]
		,[PracticeID]
		,VendorImportID
		,VendorID
		   )
	select
		patientID,	
		'Default Insurance Case',
		1,
		5,
		951,
		951,
		practiceID,
		VendorImportID,
		p.vendorID
	from Patient p
	where p.VendorImportID = @vendorImportId
		and vendorId in ( select rowId from dbo.zz_import_20100806_Insurance where InsuranceCompanyPlanId is not null)
	
	
		
	
	
	

declare @vendorImportId int
set @vendorImportId=6

-- delete InsurancePolicy where vendorImportID=1
insert into dbo.InsurancePolicy(
	PatientCaseID
	,InsuranceCompanyPlanID
	,Precedence
	,PolicyNumber
	,GroupNumber

	,CardOnFile
	,PatientRelationshipToInsured
	,HolderThroughEmployer
	,PatientInsuranceStatusID
	,VendorID
	,VendorImportID
	,PracticeID
)
select 
	pc.PatientCaseID
	,i.InsuranceCompanyPlanId
	,Precedence
	,Primary_ID as Policy
	,Primary_Group_Number as [Group]
	,0 as CardOnFile
	,'S' as PatientRelationshipToInsured
	,0 as HolderThroughEmployer
	,0 as PatientInsuranceStatusID
	,i.rowID as VendorID
	,p.vendorImportId as VendorImportID
	,p.PracticeID
from Patient p
	inner join dbo.zz_import_20100806_Insurance i
		on i.rowId=p.vendorId
	inner join PatientCase pc (nolock)
		on pc.patientID=p.patientID
where p.vendorImportID=@vendorImportId
	and InsuranceCompanyPlanId is not null
order by pc.PatientCaseID, Precedence


GO





	declare @vendorImportId int
	set @vendorImportId=6
	
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
		'DEFAULT SELF-PAY CASE',
		1,
		11,
		951,
		951,
		practiceID,
		VendorID,
		VendorImportID
	from Patient p
	where VendorImportID = @vendorImportId
		and not exists(select * from patientCase pc where pc.patientID=p.patientID )





declare @vendorImportId int
set @vendorImportId=6

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
	'8/6/2010 0:00 am',
	'Kareo',
	'K',
	0,
	Note =
	    'PatientCode: ' + isnull(PatientCode, '')+char(10)+char(13)
      +'Responsible: ' + isnull( cast( isnull(responsible,0) as varchar(255)) , '')+char(10)+char(13)
      +'Facility: ' + isnull( cast( isnull(facility,0) as varchar(255)) , '')+char(10)+char(13)
      +'Copay: ' + isnull( cast( isnull([co-Pay],'') as varchar(255)) , '')
	,0
	,1
	,0
from patient p
	inner join dbo.zz_import_20100806_patient z
		on p.vendorID=z.rowID
where vendorImportID=@vendorImportId



	
	select practice, patientCode, count(*) c, min(rowid) as rowid, max(rowid) as deleterowId
	into #toDelete
	from zz_import_20100806_patient
	group by practice, patientCode
	having count(*) = 2

		
		
alter table zz_import_20100806_patient add suffix varchar(32)

alter table zz_import_20100806_patient add tmpName varchar(255)

update z
set suffix=lastName
from zz_import_20100806_patient z
where lastName in (
'Sr',
'Sr,',
'Sr.',
'Jr',
'Jr.',
'II',
'III'
)



update z
set tmpName=PatientCode
from zz_import_20100806_patient z
where lastName in (
'Sr',
'Sr,',
'Sr.',
'Jr',
'Jr.',
'II',
'III'
)

update zz_import_20100806_patient
set tmpName=replace(tmpName, MedicalRecordNumber+' (', '')
from zz_import_20100806_patient
where lastName in (
'Sr',
'Sr,',
'Sr.',
'Jr',
'Jr.',
'II',
'III'
)


update zz_import_20100806_patient
set tmpName= substring( tmpName, charindex(' ', tmpName),  len(tmpNAme) )
from zz_import_20100806_patient
where lastName in (
'Sr',
'Sr,',
'Sr.',
'Jr',
'Jr.',
'II',
'III'
)

update zz_import_20100806_patient
set tmpName= rtrim(ltrim(tmpName))
from zz_import_20100806_patient
where lastName in (
'Sr',
'Sr,',
'Sr.',
'Jr',
'Jr.',
'II',
'III'
)


update zz_import_20100806_patient
set MiddleInitial = substring( tmpName, 1,  charindex(' ', tmpName) )
from zz_import_20100806_patient
where lastName in (
'Sr',
'Sr,',
'Sr.',
'Jr',
'Jr.',
'II',
'III'
)
and len(substring( tmpName, 1,  charindex(' ', tmpName) ))=1



update zz_import_20100806_patient
set tmpName = substring( tmpName, 2,  charindex(' ', tmpName) )
from zz_import_20100806_patient
where lastName in (
'Sr',
'Sr,',
'Sr.',
'Jr',
'Jr.',
'II',
'III'
)
and len(substring( tmpName, 1,  charindex(' ', tmpName) ))=1



update zz_import_20100806_patient
set LastName = substring( tmpName, 2,  charindex(' ', tmpName, 3)-1 )
from zz_import_20100806_patient
where lastName in (
'Sr',
'Sr,',
'Sr.',
'Jr',
'Jr.',
'II',
'III'
)
and charindex(' ', tmpName, 3)>0

update zz_import_20100806_patient
set LastName = rtrim(ltrim(lastName))


update zz_import_20100806_patient
set suffix = replace(replace(suffix, '.', ''), ',', '')


select tmpName, patientCode, firstName, lastName, MiddleInitial, suffix, medicalRecordNumber
	, substring( tmpName, 2,  charindex(' ', tmpName, 3)-1 )
from zz_import_20100806_patient
where suffix in (
'Sr',
'Sr,',
'Sr.',
'Jr',
'Jr.',
'II',
'III'
)
and charindex(' ', tmpName, 3) > 0


update p
set suffix=z.suffix
	,lastName=z.lastName
	,MiddleName=isnull(z.middleinitial, '')
from patient p
	inner join zz_import_20100806_patient z
		on p.vendorId=z.rowId
where p.vendorImportId=4
and z.suffix in (
'Sr',
'Sr,',
'Sr.',
'Jr',
'Jr.',
'II',
'III'
)	


select * from zz_import_20100806_patient
where patientId = 628808

select distinct practice from zz_import_20100806_patient


select * from patient where vendorImportId=6
