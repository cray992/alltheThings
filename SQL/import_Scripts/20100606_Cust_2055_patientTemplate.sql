select * 
from dbo.zz_Import_20100606_Patient




--==========================================
-- Insert Patient
--==========================================

insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 118647')


alter table zz_import_20100606_Patient add rowid int identity(1,1)
-- begin tran

select * from practice order by name




begin tran

declare @practiceID int, @vendorImportID int
select @practiceID=10, @vendorImportID=1

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
		isnull([Middle], '') as MI,
		@practiceID as practiceID,
		isnull( [firstname], ''),
		isnull( [lastname], ''),
		left([Address1], 256),
		left([Address2], 256),
		i.[City],
		case when len(state)>2 then null else [State] end,
		left( cast(cast(replace([Zip], '-', '') as bigint) as varchar(32)), 9)as zip,
		cast( replace(replace(replace(replace(phone_home, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneHome,
		cast( replace(replace(replace(replace(phone_work, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneWork,
		cast(null as bigint) as phone_work_ext,
		null as MobilePhone, 
		null dob,
		replace([ss], '-', '') SSN,
		[Sex],  
		rowid as [VendorID], -- vendorID
		[patient code] as  MRN,
		@vendorImportID, -- vendorID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		email as Email,
		EmploymentStatus = null ,
		null EmployerID,
		null as MaritalStatus
	from dbo.zz_import_20100606_Patient i
	where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=@vendorImportID)
		

-- rollback tran


alter table zz_import_20100606_insurance add rowID int identity(1,1)

select distinct
	company,
	address1,
	address2,
	city,
	state,
	zip
from dbo.zz_import_20100606_insurance


	select distinct 
	'exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]
		@name = ''' + replace(company, '''', '''''') + ''',
		@street_1 = ''' + isnull(address1, '') + ''',
		@street_2 = ''' + isnull(address2, '') + ''',
		@city =''' + isnull(city, '') + ''',
		@state = ''' + isnull(state, '') + ''',
		@country = '''+isnull(null, '')+''',
		@zip = ''' + isnull(cast(zip as varchar(32)), '')+ ''',
		@contact_prefix = NULL,
		@contact_first_name = NULL,
		@contact_middle_name = NULL,
		@contact_last_name = NULL,
		@contact_suffix = NULL,
		@phone = null,
		@phone_x = null,
		@fax = null,
		@fax_x = null,
		@notes = ''Kareo Import'',
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
	from dbo.zz_import_20100606_insurance z

exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AARP / UHC HEALTH CARE OPTIONS',    @street_1 = 'P O BOX 740819',    @street_2 = '',    @city ='ATLANTA',    @state = 'GA',    @country = '',    @zip = '30374',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AETNA - POS',    @street_1 = 'P O BOX 14089',    @street_2 = '',    @city ='LEXINGTON',    @state = 'KY',    @country = '',    @zip = '40512',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AETNA PPO',    @street_1 = 'P O BOX 14586',    @street_2 = '',    @city ='LEXINGTON',    @state = 'KY',    @country = '',    @zip = '40512',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AMA INSURANCE AGENCY INC',    @street_1 = '200 N LASALLE ST',    @street_2 = 'STE 400',    @city ='CHICAGO',    @state = 'IL',    @country = '',    @zip = '60601',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AMERIBEN SOLUTION',    @street_1 = 'P O BOX 7186',    @street_2 = '',    @city ='BOISE',    @state = 'ID',    @country = '',    @zip = '83707',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AMERICAN NATIONAL',    @street_1 = 'P.O. BOX 1800',    @street_2 = '',    @city ='GALVESTON',    @state = 'TX',    @country = '',    @zip = '77553-1800',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AMERICAN REPUBLIC CORP',    @street_1 = 'PO BOX 21670',    @street_2 = '',    @city ='EAGAN',    @state = 'MN',    @country = '',    @zip = '55121',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AMERICAN REPUBLIC INSURANCE COMPANY',    @street_1 = 'PO BOX 2975',    @street_2 = '',    @city ='CLINTON',    @state = 'IA',    @country = '',    @zip = '52733',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AZ ANTHEM',    @street_1 = 'P O BOX 5747',    @street_2 = '',    @city ='DENVER',    @state = 'CO',    @country = '',    @zip = '80217',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'AZ MEDICARE',    @street_1 = 'PO BOX 6704',    @street_2 = '',    @city ='FARGO',    @state = 'ND',    @country = '',    @zip = '58108',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BANKERS LIFE AND CASUALTY',    @street_1 = 'P O BOX 1935',    @street_2 = '',    @city ='CARMEL',    @state = 'IN',    @country = '',    @zip = '46082-1935',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BLUE CROSS BLUE SHIELD ARIZONA',    @street_1 = 'P.O. BOX 2924',    @street_2 = '',    @city ='PHOENIX',    @state = 'AZ',    @country = '',    @zip = '85062-2924',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'CHESTERFIELD RESOURCES,INC',    @street_1 = 'PO BOX 1884',    @street_2 = '',    @city ='AKRON',    @state = 'OH',    @country = '',    @zip = '44309',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'CIGNA HMO',    @street_1 = 'PO BOX 182223',    @street_2 = '',    @city ='CHATTANOOGA',    @state = 'TN',    @country = '',    @zip = '37422',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'CIGNA PPO',    @street_1 = 'P O BOX 2546',    @street_2 = '',    @city ='SHERMAN',    @state = 'TX',    @country = '',    @zip = '75091',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'CO BLUE SHIELD FEDERAL',    @street_1 = 'P O BOX 36310',    @street_2 = '',    @city ='LOUISVILLE',    @state = 'KY',    @country = '',    @zip = '40233',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'FIRST HEALTH UMR',    @street_1 = 'PO BOX 2838',    @street_2 = '',    @city ='CLINTON',    @state = 'IA',    @country = '',    @zip = '52733',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'FIRST HEALTH',    @street_1 = 'P.O. BOX 2700',    @street_2 = '',    @city ='BLOOMINGTON',    @state = 'IL',    @country = '',    @zip = '61702',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'GEHA PPO',    @street_1 = 'P O BOX 4665',    @street_2 = '',    @city ='INDEPENDENCE',    @state = 'MO',    @country = '',    @zip = '64051',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'GOLDEN RULE',    @street_1 = '712 ELEVENTH ST',    @street_2 = '',    @city ='LAWRENCEVILLE',    @state = 'IL',    @country = '',    @zip = '62439',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'HEALTH CHOICE',    @street_1 = 'PO BOX 24870',    @street_2 = '',    @city ='OKLAHOMA CITY',    @state = 'OK',    @country = '',    @zip = '73124',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'HEALTH NET PPO AND MEDICARE',    @street_1 = 'P.O. BOX 14225',    @street_2 = '',    @city ='LEXINGTON',    @state = 'KY',    @country = '',    @zip = '40512-1225',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'MAILHANDLERS',    @street_1 = 'PO BOX 8402',    @street_2 = '',    @city ='LONDON',    @state = 'KY',    @country = '',    @zip = '40742',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'MEDICAL MUTUAL OF OHIO',    @street_1 = 'PO BOX 94648',    @street_2 = '',    @city ='CLEVELAND',    @state = 'OH',    @country = '',    @zip = '44101',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'MUTUAL OF OMAHA PPO',    @street_1 = '3200 OKLAHOMA AVE',    @street_2 = '',    @city ='WOODWARD',    @state = 'OK',    @country = '',    @zip = '73801-4000',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'PACIFICARE PPO',    @street_1 = 'P O BOX 30970',    @street_2 = '',    @city ='SALT LAKE CITY',    @state = 'UT',    @country = '',    @zip = '84130',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'PACIFICARE RETIREE PLAN',    @street_1 = 'PO BOX 6099',    @street_2 = '',    @city ='CYPRESS',    @state = 'CA',    @country = '',    @zip = '90630',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'PHYSICIANS MUTUAL',    @street_1 = 'PO BOX 2018',    @street_2 = '',    @city ='OMAHA',    @state = 'NE',    @country = '',    @zip = '68103',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'PROVIDENT LIFE AND ACCIDENT INSURANCE CO',    @street_1 = 'PO BOX 171821',    @street_2 = '',    @city ='MEMPHIS',    @state = 'TN',    @country = '',    @zip = '38187',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'ROYAL NEIGHBORS AMERICA',    @street_1 = 'PO BOX 10851',    @street_2 = '',    @city ='CLEARWATER',    @state = 'FL',    @country = '',    @zip = '33757',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'RRW MEDICARE',    @street_1 = 'P O BOX 10066',    @street_2 = '',    @city ='AUGUSTA',    @state = 'GA',    @country = '',    @zip = '30999',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'STATE FARM HEALTH INSURANCE',    @street_1 = 'P.O.BOX 339403',    @street_2 = '',    @city ='GREELEY',    @state = 'CO',    @country = '',    @zip = '80663',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'TIME INSURANCE COMPANY',    @street_1 = 'P O BOX 42033',    @street_2 = '',    @city ='HAZELWOOD',    @state = 'MO',    @country = '',    @zip = '63042',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'TRICARE FOR LIFE',    @street_1 = 'P O BOX 7890',    @street_2 = '',    @city ='MADISON',    @state = 'WI',    @country = '',    @zip = '53707',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'UNIFORM MEDICAL PLAN',    @street_1 = 'PO BOX 34850',    @street_2 = '',    @city ='SEATTLE',    @state = 'WA',    @country = '',    @zip = '98124',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'UNITED COMMERCIAL TRAVELERS',    @street_1 = 'PO BOX159019',    @street_2 = '',    @city ='COLUMBUS',    @state = 'OH',    @country = '',    @zip = '43215',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'UNITED HEALTHCARE HMO',    @street_1 = 'P O BOX 740800',    @street_2 = '',    @city ='ATLANTA',    @state = 'GA',    @country = '',    @zip = '30374',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'UNITED HEALTHCARE PPO',    @street_1 = 'P.O.BOX 30555',    @street_2 = '',    @city ='SALT LAKE CITY',    @state = 'UT',    @country = '',    @zip = '84130',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'USAA LIFE INSURANCE COMPANY',    @street_1 = '9800 FREDRICKSBURG ROAD',    @street_2 = '',    @city ='SAN ANTONIO',    @state = 'TX',    @country = '',    @zip = '78288',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'VA HEALTH ADMINISTRATION CENTER',    @street_1 = 'P.O.BOX 65024',    @street_2 = '',    @city ='DENVER',    @state = 'CO',    @country = '',    @zip = '80206',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'WINCONSIN PHYSICIAN SERVICE INS CORP',    @street_1 = 'PO BOX 8190',    @street_2 = '',    @city ='MADISON',    @state = 'WI',    @country = '',    @zip = '53708',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = null,    @phone_x = null,    @fax = null,    @fax_x = null,    @notes = 'Kareo Import',    @practice_id = '1',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='R',    @UseFacilityID='1',    @eclaims_disable=0    


update i
set vendorImportID=1
from insuranceCompany i
where cast(notes as varchar(max))='Kareo Import'

alter table zz_import_20100606_insurance add insuranceCompanyID int 

update z
set insuranceCompanyID=null
from zz_import_20100606_insurance z



update z
set insuranceCompanyID=i.insuranceCompanyID
from zz_import_20100606_insurance z
	inner join insuranceCompany i
		on isnull(z.company, '')=isnull(insuranceCompanyName, '')
		and isnull(z.address1, '')=isnull(addressLine1, '')
		and isnull(z.address2, '')=isnull(addressLine2, '')
		and isnull(z.city, '')=isnull(i.city, '')
		and isnull(z.state, '')=isnull(i.state, '')
		and isnull(left(z.zip, 5), '')=isnull( left(i.zipCode, 5), '')
where cast(notes as varchar(max))='Kareo Import'






-- Primry
select distinct company,
	'exec InsurancePlanDataProvider_CreateInsurancePlan 
		@name = ''' + replace(company, '''', '''''') + ''',
		@street_1 = ''' + isnull(address1, '') + ''',
		@street_2 = ''' + isnull(address2, '') + ''',
		@city =''' + isnull(city, '') + ''',
		@state = ''' + isnull(state, '') + ''',
		@zip = ''' + isnull(cast(zip as varchar(32)), '')+ '''
		
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



exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AARP / UHC HEALTH CARE OPTIONS',    @street_1 = 'P O BOX 740819',    @street_2 = '',    @city ='ATLANTA',    @state = 'GA',    @zip = '30374'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='163'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AETNA - POS',    @street_1 = 'P O BOX 14089',    @street_2 = '',    @city ='LEXINGTON',    @state = 'KY',    @zip = '40512'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='164'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AETNA PPO',    @street_1 = 'P O BOX 14586',    @street_2 = '',    @city ='LEXINGTON',    @state = 'KY',    @zip = '40512'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='165'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AMA INSURANCE AGENCY INC',    @street_1 = '200 N LASALLE ST',    @street_2 = 'STE 400',    @city ='CHICAGO',    @state = 'IL',    @zip = '60601'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='166'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AMERIBEN SOLUTION',    @street_1 = 'P O BOX 7186',    @street_2 = '',    @city ='BOISE',    @state = 'ID',    @zip = '83707'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='167'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AMERICAN NATIONAL',    @street_1 = 'P.O. BOX 1800',    @street_2 = '',    @city ='GALVESTON',    @state = 'TX',    @zip = '77553-1800'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='168'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AMERICAN REPUBLIC CORP',    @street_1 = 'PO BOX 21670',    @street_2 = '',    @city ='EAGAN',    @state = 'MN',    @zip = '55121'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='169'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AMERICAN REPUBLIC INSURANCE COMPANY',    @street_1 = 'PO BOX 2975',    @street_2 = '',    @city ='CLINTON',    @state = 'IA',    @zip = '52733'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='170'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AZ ANTHEM',    @street_1 = 'P O BOX 5747',    @street_2 = '',    @city ='DENVER',    @state = 'CO',    @zip = '80217'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='171'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'AZ MEDICARE',    @street_1 = 'PO BOX 6704',    @street_2 = '',    @city ='FARGO',    @state = 'ND',    @zip = '58108'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='172'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'BANKERS LIFE AND CASUALTY',    @street_1 = 'P O BOX 1935',    @street_2 = '',    @city ='CARMEL',    @state = 'IN',    @zip = '46082-1935'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='173'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'BLUE CROSS BLUE SHIELD ARIZONA',    @street_1 = 'P.O. BOX 2924',    @street_2 = '',    @city ='PHOENIX',    @state = 'AZ',    @zip = '85062-2924'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='174'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'CHESTERFIELD RESOURCES,INC',    @street_1 = 'PO BOX 1884',    @street_2 = '',    @city ='AKRON',    @state = 'OH',    @zip = '44309'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='175'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'CIGNA HMO',    @street_1 = 'PO BOX 182223',    @street_2 = '',    @city ='CHATTANOOGA',    @state = 'TN',    @zip = '37422'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='176'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'CIGNA PPO',    @street_1 = 'P O BOX 2546',    @street_2 = '',    @city ='SHERMAN',    @state = 'TX',    @zip = '75091'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='177'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'CO BLUE SHIELD FEDERAL',    @street_1 = 'P O BOX 36310',    @street_2 = '',    @city ='LOUISVILLE',    @state = 'KY',    @zip = '40233'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='178'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'FIRST HEALTH',    @street_1 = 'P.O. BOX 2700',    @street_2 = '',    @city ='BLOOMINGTON',    @state = 'IL',    @zip = '61702'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='180'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'FIRST HEALTH UMR',    @street_1 = 'PO BOX 2838',    @street_2 = '',    @city ='CLINTON',    @state = 'IA',    @zip = '52733'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='179'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'GEHA PPO',    @street_1 = 'P O BOX 4665',    @street_2 = '',    @city ='INDEPENDENCE',    @state = 'MO',    @zip = '64051'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='181'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'GOLDEN RULE',    @street_1 = '712 ELEVENTH ST',    @street_2 = '',    @city ='LAWRENCEVILLE',    @state = 'IL',    @zip = '62439'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='182'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'HEALTH CHOICE',    @street_1 = 'PO BOX 24870',    @street_2 = '',    @city ='OKLAHOMA CITY',    @state = 'OK',    @zip = '73124'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='183'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'HEALTH NET PPO AND MEDICARE',    @street_1 = 'P.O. BOX 14225',    @street_2 = '',    @city ='LEXINGTON',    @state = 'KY',    @zip = '40512-1225'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='184'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'MAILHANDLERS',    @street_1 = 'PO BOX 8402',    @street_2 = '',    @city ='LONDON',    @state = 'KY',    @zip = '40742'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='185'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'MEDICAL MUTUAL OF OHIO',    @street_1 = 'PO BOX 94648',    @street_2 = '',    @city ='CLEVELAND',    @state = 'OH',    @zip = '44101'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='186'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'MUTUAL OF OMAHA PPO',    @street_1 = '3200 OKLAHOMA AVE',    @street_2 = '',    @city ='WOODWARD',    @state = 'OK',    @zip = '73801-4000'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='187'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'PACIFICARE PPO',    @street_1 = 'P O BOX 30970',    @street_2 = '',    @city ='SALT LAKE CITY',    @state = 'UT',    @zip = '84130'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='188'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'PACIFICARE RETIREE PLAN',    @street_1 = 'PO BOX 6099',    @street_2 = '',    @city ='CYPRESS',    @state = 'CA',    @zip = '90630'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='189'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'PHYSICIANS MUTUAL',    @street_1 = 'PO BOX 2018',    @street_2 = '',    @city ='OMAHA',    @state = 'NE',    @zip = '68103'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='190'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'PROVIDENT LIFE AND ACCIDENT INSURANCE CO',    @street_1 = 'PO BOX 171821',    @street_2 = '',    @city ='MEMPHIS',    @state = 'TN',    @zip = '38187'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='191'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'ROYAL NEIGHBORS AMERICA',    @street_1 = 'PO BOX 10851',    @street_2 = '',    @city ='CLEARWATER',    @state = 'FL',    @zip = '33757'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='192'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'RRW MEDICARE',    @street_1 = 'P O BOX 10066',    @street_2 = '',    @city ='AUGUSTA',    @state = 'GA',    @zip = '30999'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='193'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'STATE FARM HEALTH INSURANCE',    @street_1 = 'P.O.BOX 339403',    @street_2 = '',    @city ='GREELEY',    @state = 'CO',    @zip = '80663'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='194'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'TIME INSURANCE COMPANY',    @street_1 = 'P O BOX 42033',    @street_2 = '',    @city ='HAZELWOOD',    @state = 'MO',    @zip = '63042'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='195'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'TRICARE FOR LIFE',    @street_1 = 'P O BOX 7890',    @street_2 = '',    @city ='MADISON',    @state = 'WI',    @zip = '53707'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='196'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'UNIFORM MEDICAL PLAN',    @street_1 = 'PO BOX 34850',    @street_2 = '',    @city ='SEATTLE',    @state = 'WA',    @zip = '98124'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='197'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'UNITED COMMERCIAL TRAVELERS',    @street_1 = 'PO BOX159019',    @street_2 = '',    @city ='COLUMBUS',    @state = 'OH',    @zip = '43215'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='198'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'UNITED HEALTHCARE HMO',    @street_1 = 'P O BOX 740800',    @street_2 = '',    @city ='ATLANTA',    @state = 'GA',    @zip = '30374'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='199'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'UNITED HEALTHCARE PPO',    @street_1 = 'P.O.BOX 30555',    @street_2 = '',    @city ='SALT LAKE CITY',    @state = 'UT',    @zip = '84130'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='200'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'USAA LIFE INSURANCE COMPANY',    @street_1 = '9800 FREDRICKSBURG ROAD',    @street_2 = '',    @city ='SAN ANTONIO',    @state = 'TX',    @zip = '78288'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='201'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'VA HEALTH ADMINISTRATION CENTER',    @street_1 = 'P.O.BOX 65024',    @street_2 = '',    @city ='DENVER',    @state = 'CO',    @zip = '80206'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='202'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name = 'WINCONSIN PHYSICIAN SERVICE INS CORP',    @street_1 = 'PO BOX 8190',    @street_2 = '',    @city ='MADISON',    @state = 'WI',    @zip = '53708'        ,@program_code=N'CI'    ,@deductible='0'    ,@company_id='203'    ,@fax_x=NULL    ,@phone=null    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=null    ,@contact_last_name=NULL    ,@fax=NULL    ,@notes=N'Imported by Kareo June 6, 2010'    ,@contact_prefix=NULL    ,@country=N''    ,@contact_first_name=NULL    ,@copay='0'      ,@EClaimsAccepts=0    ,@practice_id=10    ,@contact_middle_name=NULL



alter table dbo.zz_import_20100606_insurance add insuranceCompanyPlanId int


update z
set insuranceCompanyPlanId=ip.insuranceCompanyPlanId
from insuranceCompanyPlan ip
	inner join zz_import_20100606_insurance z
		on z.insuranceCompanyId=ip.insuranceCompanyId
where cast(notes as varchar(max))='Imported by Kareo June 6, 2010'





alter table zz_import_20100606_insurance add patientID int


update z
set patientID=p.patientId
from zz_import_20100606_insurance z
	inner join patient p
		 on p.MedicalRecordNumber=[patient code]
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
		and medicalRecordNumber in ( select [patient code] from dbo.zz_import_20100606_insurance where InsuranceCompanyPlanId is not null)
	
	
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
	,ins1_id as Policy
	,ins1_group as [Group]
	,0 as CardOnFile
	,'S' as PatientRelationshipToInsured
	,0 as HolderThroughEmployer
	,0 as PatientInsuranceStatusID
	,i.rowID as VendorID
	,1 as VendorImportID
	,p.PracticeID
	from Patient p
		inner join dbo.zz_Import_20100606_Patient zp
			on zp.rowID=p.vendorID
		inner join dbo.zz_import_20100606_insurance i
			on i.[patient code]=zp.[patient code]
		inner join PatientCase pc (nolock)
			on pc.patientID=p.patientID
where p.vendorImportID=1
	and InsuranceCompanyPlanId is not null
order by pc.PatientCaseID, Precedence


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




