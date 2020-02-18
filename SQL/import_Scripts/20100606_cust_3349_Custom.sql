



/*
dbo.zz_import_20100606_patient


select 'alter table zz_import_20100606_patient drop column ' + c.name
from sys.columns c
	inner join sys.tables t
		on t.object_id=c.object_id
where t.name='zz_import_20100606_patient'
	and c.name like 'F%'
	

alter table zz_import_20100606_patient drop column F5
alter table zz_import_20100606_patient drop column F7
alter table zz_import_20100606_patient drop column F9
alter table zz_import_20100606_patient drop column F11
alter table zz_import_20100606_patient drop column F13
alter table zz_import_20100606_patient drop column F15
alter table zz_import_20100606_patient drop column F17
alter table zz_import_20100606_patient drop column F19
alter table zz_import_20100606_patient drop column F21
alter table zz_import_20100606_patient drop column F23
alter table zz_import_20100606_patient drop column F25
alter table zz_import_20100606_patient drop column F27
alter table zz_import_20100606_patient drop column F29
alter table zz_import_20100606_patient drop column F31
alter table zz_import_20100606_patient drop column F33
alter table zz_import_20100606_patient drop column F35
alter table zz_import_20100606_patient drop column F37
alter table zz_import_20100606_patient drop column F39
alter table zz_import_20100606_patient drop column F41
alter table zz_import_20100606_patient drop column F43
alter table zz_import_20100606_patient drop column F45
alter table zz_import_20100606_patient drop column F47
alter table zz_import_20100606_patient drop column F49
alter table zz_import_20100606_patient drop column F51
alter table zz_import_20100606_patient drop column F53
alter table zz_import_20100606_patient drop column F55
alter table zz_import_20100606_patient drop column F57
alter table zz_import_20100606_patient drop column F59
alter table zz_import_20100606_patient drop column F61
alter table zz_import_20100606_patient drop column F63
alter table zz_import_20100606_patient drop column F65
alter table zz_import_20100606_patient drop column F67
alter table zz_import_20100606_patient drop column F69
alter table zz_import_20100606_patient drop column F71
alter table zz_import_20100606_patient drop column F73
alter table zz_import_20100606_patient drop column F75
alter table zz_import_20100606_patient drop column F77
alter table zz_import_20100606_patient drop column F79
alter table zz_import_20100606_patient drop column F81
alter table zz_import_20100606_patient drop column F83
alter table zz_import_20100606_patient drop column F85
alter table zz_import_20100606_patient drop column F87
alter table zz_import_20100606_patient drop column F89
alter table zz_import_20100606_patient drop column F91
alter table zz_import_20100606_patient drop column F93
alter table zz_import_20100606_patient drop column F95
alter table zz_import_20100606_patient drop column F97
alter table zz_import_20100606_patient drop column F99
alter table zz_import_20100606_patient drop column F101
alter table zz_import_20100606_patient drop column F103
alter table zz_import_20100606_patient drop column F105
alter table zz_import_20100606_patient drop column F107
alter table zz_import_20100606_patient drop column F109
alter table zz_import_20100606_patient drop column F111
alter table zz_import_20100606_patient drop column F113
alter table zz_import_20100606_patient drop column F115
alter table zz_import_20100606_patient drop column F117
alter table zz_import_20100606_patient drop column F119
alter table zz_import_20100606_patient drop column F121
alter table zz_import_20100606_patient drop column F123
alter table zz_import_20100606_patient drop column F125
alter table zz_import_20100606_patient drop column F127
alter table zz_import_20100606_patient drop column F129
alter table zz_import_20100606_patient drop column F131
alter table zz_import_20100606_patient drop column F133
alter table zz_import_20100606_patient drop column F135
alter table zz_import_20100606_patient drop column F137
alter table zz_import_20100606_patient drop column F139
alter table zz_import_20100606_patient drop column F141
alter table zz_import_20100606_patient drop column F143
alter table zz_import_20100606_patient drop column F145
alter table zz_import_20100606_patient drop column F147
alter table zz_import_20100606_patient drop column F149
alter table zz_import_20100606_patient drop column F151
alter table zz_import_20100606_patient drop column F153
alter table zz_import_20100606_patient drop column F155
alter table zz_import_20100606_patient drop column F157
alter table zz_import_20100606_patient drop column F159
alter table zz_import_20100606_patient drop column F161
alter table zz_import_20100606_patient drop column F163
alter table zz_import_20100606_patient drop column F165
alter table zz_import_20100606_patient drop column F167
alter table zz_import_20100606_patient drop column F169
alter table zz_import_20100606_patient drop column F171
alter table zz_import_20100606_patient drop column F173
alter table zz_import_20100606_patient drop column F175
alter table zz_import_20100606_patient drop column F177
alter table zz_import_20100606_patient drop column F179
alter table zz_import_20100606_patient drop column F181
alter table zz_import_20100606_patient drop column F183
alter table zz_import_20100606_patient drop column F185
alter table zz_import_20100606_patient drop column F187
alter table zz_import_20100606_patient drop column F189
alter table zz_import_20100606_patient drop column F191
alter table zz_import_20100606_patient drop column F193
alter table zz_import_20100606_patient drop column F195
alter table zz_import_20100606_patient drop column F197
alter table zz_import_20100606_patient drop column F199
alter table zz_import_20100606_patient drop column F201
alter table zz_import_20100606_patient drop column F203
alter table zz_import_20100606_patient drop column F205
alter table zz_import_20100606_patient drop column F207
alter table zz_import_20100606_patient drop column F209
alter table zz_import_20100606_patient drop column F211
alter table zz_import_20100606_patient drop column F213
alter table zz_import_20100606_patient drop column F215
alter table zz_import_20100606_patient drop column F217
alter table zz_import_20100606_patient drop column F219
alter table zz_import_20100606_patient drop column F221
alter table zz_import_20100606_patient drop column F223
alter table zz_import_20100606_patient drop column F225
alter table zz_import_20100606_patient drop column F227
alter table zz_import_20100606_patient drop column F229
alter table zz_import_20100606_patient drop column F231
alter table zz_import_20100606_patient drop column F233
alter table zz_import_20100606_patient drop column F235
alter table zz_import_20100606_patient drop column F237
alter table zz_import_20100606_patient drop column F239
alter table zz_import_20100606_patient drop column F241
alter table zz_import_20100606_patient drop column F243
alter table zz_import_20100606_patient drop column F245
alter table zz_import_20100606_patient drop column F247
alter table zz_import_20100606_patient drop column F249
alter table zz_import_20100606_patient drop column F251
alter table zz_import_20100606_patient drop column F253
alter table zz_import_20100606_patient drop column F255



alter table zz_import_20100606_patient add rowid int identity(1,1)
alter table zz_import_20100606_patient add practiceID int
alter table zz_import_20100606_patient add patientID int


alter table zz_import_20100606_patient add firstname varchar(255)
alter table zz_import_20100606_patient add lastName varchar(255)
alter table zz_import_20100606_patient add MiddleInitial char(1)
alter table zz_import_20100606_patient add MedicalRecordNumber varchar(255)

*/

update z
set MedicalRecordNumber = ltrim(rtrim(substring( PatientCode, 1, charindex(' (', PatientCode) )))
from zz_import_20100606_patient z


update z
set firstName = rtrim(ltrim(substring( PatientCode
				,charindex('(', PatientCode)+1
				,charindex( ' ', PatientCode, charindex('(', PatientCode)) - charindex('(', PatientCode)
				)))
from zz_import_20100606_patient z


Update z
SET LastName= ltrim(rtrim(reverse(substring( reverse( patientCode ), 2, charindex(' ', reverse( patientCode ))-1 ))  ))
from zz_import_20100606_patient z


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
from zz_import_20100606_patient z





insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 116078')


declare @practiceID int, @vendorImportID int
select @practiceID=1, @vendorImportID=1


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
	@practiceID as practiceID,
	left(isnull([firstname], 64), ''),
	left(isnull( [lastname], 64), ''),
	left([Address_1], 256),
	left([Address_2], 256),
	left(i.[City], 128),
	case when len(state)>2 then null else [State] end,
	left( cast(cast(replace([Zip_Code], '-', '') as bigint) as varchar(32)), 9)as zip,
	case when len(replace(replace(replace(replace([Home_Phone], '-', ''), ')', ''), '(', ''), ' ', '') ) > 10 then null else cast( replace(replace(replace(replace([Home_Phone], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) end as phoneHome,
	case when len(replace(replace(replace(replace(Work_Phone, '-', ''), ')', ''), '(', ''), ' ', '') ) > 10 then null else cast( replace(replace(replace(replace(Work_Phone, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) end  as phoneWork,
	cast(null as bigint) as phone_work_ext,
	case when len(replace(replace(replace(replace(Mobile_Phone, '-', ''), ')', ''), '(', ''), ' ', '') ) > 10 then null else cast( replace(replace(replace(replace(Mobile_Phone, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) end  as phoneWork,
	[Birth_Date] dob,
	cast(replace([Social_Security_#], '-', '') as bigint) SSN,
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
from dbo.zz_import_20100606_Patient i
where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=@vendorImportID)
	

update p
set ssn=null
from patient p
where vendorImportId=@vendorImportId
	and ssn=0
	

-- drop table zz_import_20100606_Insurance

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
into zz_import_20100606_Insurance
FROM zz_import_20100606_Patient

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
FROM zz_import_20100606_Patient

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
FROM zz_import_20100606_Patient
    



	select distinct 
	'exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]
		@name = ''' + replace([Primary_Insurance], '''', '''''') + ''',
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
		@notes = ''Kareo Import June 6, 2010'',
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
	from dbo.zz_import_20100606_Insurance z




exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Affinity Health Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Beech Street Corp Ridge',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'TransAmerica',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Alicare Inc',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Special Agent Mutual',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Allstate 888 Vets Hwy',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Evercare Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'ISLAND GROUP ADM',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'SecureHorizon',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Oxford NY NJ CT DE',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Sheet Metal Workers',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Tri Care Ins',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AIG',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'HIP Health Ins NY',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'PHCS CBCA Admin Inc',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Maloney Associates',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Lumenos Ins',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'International Benefit Admin',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'NALC Health Benefit',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Allied Wellfare Fnd Crossrds',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'C and R Consulting',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AARP',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Carpenters Union Ins',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Wellcare of New York',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Pathway',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Neighborhood Health NY',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Multi Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Workers'' Compensation Board',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'UMR',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'MDNY Healthcare',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'MVP',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Local 804',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Health Net of North East',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS Empire',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Local 1430 Health Fund',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'APWU Health Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'HealthCare Partners',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Local 1102',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS Empire 1407',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Suffolk Health Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'PerfectHealth Multiplan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'GHI Medicare Replacement Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Physicians Mutual Insurance Co.',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Amalgamated Life',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Fidelis',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'State Insurance Fund',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AmeriHealth Administrators',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Rail Road Medicare',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Local 282',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Aetna',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Great West Life',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Local 14',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Horizon Healthcare of NY',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Chesterfield Resourse',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Meritain Health',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Champ VA',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'GHI PPO',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Principal Financial Group',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Humana Claims',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Christian Brothers Benifit',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Magellin Behavior Hlth',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Comprehensive Benefits',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Colonial Penn Life Ins',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Health Plan InCo',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Behavioral Health',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'SDS',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Vytra Healthcare',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Fidelis Care of New York',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'American Grp Administrators',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'The Empire Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Cigna',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Unicare Multiplan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Empire Health Choice HMO',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Group Health Inc',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Life Benefit Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Local 365',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Aftra Health fund',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Local 1500',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Mutual of Omaha',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'American Pioneer',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Health Plus',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Bricklayers Insurance & Welfare Fund',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = '1199 National Benefit Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'United Healthcare',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'State Farm Mutual',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Local 295/851',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Magnacare Ins',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Definity Health',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Helth Market Care',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Local 463',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Americhoice by UHC',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'UMR - Lexington',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'GEHA',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'National Benefits',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Healthfirst New York',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Sieba',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Alicare Ins',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Mail Handlers Benefit Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Group Resources',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'First Health',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Medicaid NY',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Horizon B/C B/S',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Medicare Empire',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @country = '',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import June 6, 2010',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    

declare @vendorImportId int
set @vendorImportId=1

update insuranceCompany
set VendorImportId=@vendorImportId
where cast(notes as varchar(max))='Kareo Import June 6, 2010'


GO


alter table zz_import_20100606_insurance add insuranceCompanyID int 



declare @vendorImportId int
set @vendorImportId=1


update z
set insuranceCompanyID=i.insuranceCompanyID
from zz_import_20100606_insurance z
	inner join insuranceCompany i
		on isnull(z.[Primary_Insurance], '')=isnull(insuranceCompanyName, '')
where VendorImportId=@vendorImportId







-- Primry
select distinct [Primary_Insurance],
	'exec InsurancePlanDataProvider_CreateInsurancePlan 
		@name = ''' + replace([Primary_Insurance], '''', '''''') + ''',
		@street_1 = ''' + isnull(null, '') + ''',
		@street_2 = ''' + isnull(null, '') + ''',
		@city =''' + isnull(null, '') + ''',
		@state = ''' + isnull(null, '') + ''',
		@zip = ''' + isnull(cast( null as varchar(32)), '')+ '''
		
		,@program_code=N''CI''
		,@deductible=''' + cast( isnull(null, 0) as varchar(32)) + '''
		,@company_id=''' + cast(insuranceCompanyID as varchar(32)) + '''
		,@fax_x=NULL
		,@phone=null
		,@contact_suffix=NULL
		,@review_code=N''''
		,@phone_x=null
		,@contact_last_name=NULL
		,@fax=NULL
		,@notes=N''Imported by Kareo June 6, 2010''
		,@contact_prefix=NULL
		,@country=N''''
		,@contact_first_name=NULL
		,@copay=''' + cast( isnull(null, 0) as varchar(32)) + '''

		,@EClaimsAccepts=0
		,@practice_id=10
		,@contact_middle_name=NULL'
	from dbo.zz_import_20100606_insurance z
where insuranceCompanyID is not null


exec InsurancePlanDataProvider_CreateInsurancePlan     @name = '1199 National Benefit Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='609'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AARP',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='548'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Aetna',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='576'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Affinity Health Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='527'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Aftra Health fund',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='603'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AIG',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='539'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Alicare Inc',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='530'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Alicare Ins',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='623'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Allied Wellfare Fnd Crossrds',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='546'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Allstate 888 Vets Hwy',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='532'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Amalgamated Life',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='570'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'American Grp Administrators',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='595'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'American Pioneer',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='606'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Americhoice by UHC',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='617'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AmeriHealth Administrators',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='573'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'APWU Health Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='562'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'BCBS Empire',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='560'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'BCBS Empire 1407',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='565'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Beech Street Corp Ridge',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='528'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Behavioral Health',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='591'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Bricklayers Insurance & Welfare Fund',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='608'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'C and R Consulting',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='547'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Carpenters Union Ins',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='549'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Champ VA',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='582'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Chesterfield Resourse',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='580'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Christian Brothers Benifit',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='586'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Cigna',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='597'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Colonial Penn Life Ins',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='589'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Comprehensive Benefits',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='588'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Definity Health',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='614'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Empire Health Choice HMO',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='599'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Evercare Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='533'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Fidelis',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='571'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Fidelis Care of New York',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='594'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'First Health',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='626'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'GEHA',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='619'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'GHI Medicare Replacement Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='568'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'GHI PPO',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='583'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Great West Life',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='577'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Group Health Inc',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='600'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Group Resources',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='625'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Health Net of North East',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='559'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Health Plan InCo',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='590'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Health Plus',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='607'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'HealthCare Partners',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='563'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Healthfirst New York',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='621'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Helth Market Care',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='615'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'HIP Health Ins NY',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='540'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Horizon B/C B/S',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='628'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Horizon Healthcare of NY',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='579'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Humana Claims',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='585'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'International Benefit Admin',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='544'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'ISLAND GROUP ADM',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='534'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Life Benefit Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='601'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Local 1102',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='564'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Local 14',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='578'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Local 1430 Health Fund',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='561'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Local 1500',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='604'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Local 282',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='575'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Local 295/851',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='612'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Local 365',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='602'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Local 463',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='616'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Local 804',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='558'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Lumenos Ins',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='543'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Magellin Behavior Hlth',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='587'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Magnacare Ins',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='613'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Mail Handlers Benefit Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='624'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Maloney Associates',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='542'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'MDNY Healthcare',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='556'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Medicaid NY',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='627'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Medicare Empire',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='629'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Meritain Health',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='581'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Multi Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='553'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Mutual of Omaha',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='605'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'MVP',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='557'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'NALC Health Benefit',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='545'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'National Benefits',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='620'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Neighborhood Health NY',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='552'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Oxford NY NJ CT DE',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='536'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Pathway',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='551'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'PerfectHealth Multiplan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='567'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'PHCS CBCA Admin Inc',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='541'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Physicians Mutual Insurance Co.',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='569'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Principal Financial Group',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='584'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Rail Road Medicare',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='574'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'SDS',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='592'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'SecureHorizon',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='535'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Sheet Metal Workers',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='537'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Sieba',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='622'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Special Agent Mutual',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='531'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'State Farm Mutual',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='611'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'State Insurance Fund',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='572'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Suffolk Health Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='566'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'The Empire Plan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='596'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'TransAmerica',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='529'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Tri Care Ins',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='538'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'UMR',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='555'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'UMR - Lexington',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='618'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Unicare Multiplan',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='598'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'United Healthcare',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='610'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Vytra Healthcare',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='593'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Wellcare of New York',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='550'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'Workers'' Compensation Board',    @street_1 = '',    @street_2 = '',    @city ='',    @state = '',    @zip = ''        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='554'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL



alter table dbo.zz_import_20100606_insurance add insuranceCompanyPlanId int


update z
set insuranceCompanyPlanId=ip.insuranceCompanyPlanId
from insuranceCompanyPlan ip
	inner join zz_import_20100606_insurance z
		on z.insuranceCompanyId=ip.insuranceCompanyId
where cast(notes as varchar(max))='Imported by Kareo June 6, 2010'


update z
set patientID=p.patientId
from zz_import_20100606_patient z
	inner join patient p
		 on p.vendorId=z.rowID
where p.vendorImportID=1




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
	where p.VendorImportID = 1
		and vendorId in ( select rowId from dbo.zz_import_20100606_insurance where InsuranceCompanyPlanId is not null)
	
	
		
	
	
	
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
	,1 as VendorImportID
	,p.PracticeID
	from Patient p
		inner join dbo.zz_import_20100606_insurance i
			on i.rowId=p.vendorId
		inner join PatientCase pc (nolock)
			on pc.patientID=p.patientID
where p.vendorImportID=1
	and InsuranceCompanyPlanId is not null
order by pc.PatientCaseID, Precedence




	
SELECT [Patient_Statistics]
      ,[Customer]
      ,[Practice]
		,[Responsible]
		,
		,
		,
		,
		,[Main_Phone]
		,
		,[Fax_Phone]
      ,[Active/Inactive]
      ,[Next_Recall_Date]
      
      
      ,[Employer]
      ,[Employer_Address_1]
      ,[Employer_Address_2]
      ,[Employer_City]
      ,[Employer_State]
      ,[Employer_Zip_Code]
      ,[Provider]
      ,
      
      ,[Co-Pay]
      ,[Patient_Code]
      ,[Patient_Type]
      ,[Managed_Care_Plan]
      ,[Managed_Care_Payment]
      ,[New_Pat#_Date]
      ,[Pager_Phone]
      ,[Other_Phone]
     
      ,[Facility]
      ,[Referring_Pysician]
      ,[Referring_Patient]
      ,[Referral_Date]
      ,[Attorney]
      ,[Primary_Care_Provider_(PCP)]
      ,[Date_Last_Seen_PCP]
      ,[Supervising_Physician]
      ,[Symptom_Type]
      ,[Symptom_Date]
      ,[Similar_Symptom]
      ,[Similar_Symptom_Date]
      ,[Status]
      ,[Date_of_Death]
      ,[Lab_Charges]
      ,[Lab_Charges_Amount]
      ,[Emergency_Contact_Name]
      ,[Emergency_Contact_Phone]
      ,[Emergency_Contact_Note]
      ,[Date_of_Last_Visit]
      ,[Months_Treated]
      ,[Return_to_Work]
      ,[Return_to_Work_Date]
      ,[Last_Worked_Date]
      ,[Accident_Type]
      ,[Accident_Date]
      ,[Accident_State]
      ,[Employment_Related]
      ,[Emergency]
      ,[EPSDT]
      ,[Family_Planning]
      ,[Ambulatory_Surgery_Req#]
      ,[Homebound]
      ,[Notes_Reminder_Code]
      ,[Third-Party_Liability]
      ,[Levels_of_Subluxation]
      ,[Percent_Permanent_Disability]
      ,[Branch_of_Service]
      ,[Service_Status]
      ,[Service_Grade]
      ,[Service_Card_Effective]
      ,[Non-Available_Statment]
      ,[Student_Status]
      ,[Signature_on_File]
      ,[Release_Information_Auth#]
      ,[Date_of_Last_X-Ray]
      ,[Consultation_Dates]
      ,[Total_Disability]
      ,[Partial_Disability]
      ,[Hospitalization]
      ,[Assumed_-_Relinquished_Care]
      ,[Prescription_Date]
      ,[Nature_of_Condition]
      ,[Complication_Indicator]
      ,[Podiatry_Therapy_Type]
      ,[Podiatry_Systemic_Condition]
      ,[Podiatry_Class_Findings]
      ,[IDE_Number]
      ,[Birth_Weight]
      ,[Handicapped_Program]
      ,[Release_Information_Date]
      ,[Permanent_Diagnosis_Code_1]
      ,[Permanent_Diagnosis_Code_2]
      ,[rowid]
      ,[practiceID]
      ,[patientID]
  FROM [superbill_3349_prod].[dbo].[zz_import_20100606_patient]





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
	where VendorImportID = 1
		and not exists(select * from patientCase pc where pc.patientID=p.patientID )




update p
set firstName=z.firstName,
	lastName=z.lastName
from patient p
	inner join zz_import_20100606_patient z
		on z.rowId=p.vendorId
