USE [superbill_2763_prod]
GO

drop table [zz_import_PayerList_20100112_Practice]

CREATE TABLE [dbo].[zz_import_PayerList_20100112_Practice](
	[practiceID] [int] NOT NULL,
	[InsuranceCompanyName] [nvarchar](255) NULL,
	[InsuranceCompanyAddressLine1] [nvarchar](255) NULL,
	[InsuranceCompanyAddressLine2] [nvarchar](255) NULL,
	[InsuranceCompanyCity] [nvarchar](255) NULL,
	[InsuranceCompanyState] [nvarchar](255) NULL,
	[InsuranceCompanyCountry] [nvarchar](255) NULL,
	[InsuranceCompanyZipCode] [nvarchar](255) NULL,
	[InsuranceCompanyContactPrefix] [nvarchar](255) NULL,
	[InsuranceCompanyContactFirstName] [nvarchar](255) NULL,
	[InsuranceCompanyContactMiddleName] [nvarchar](255) NULL,
	[InsuranceCompanyContactLastName] [nvarchar](255) NULL,
	[InsuranceCompanyContactSuffix] [nvarchar](255) NULL,
	[InsuranceCompanyPhone] [nvarchar](255) NULL,
	[InsuranceCompanyPhoneExt] [nvarchar](255) NULL,
	[InsuranceCompanyFax] [nvarchar](255) NULL,
	[InsuranceCompanyFaxExt] [nvarchar](255) NULL,
	[InsuranceProgramCode] [nvarchar](255) NULL,
	[Notes] [nvarchar](255) NULL,
	[PlanName] [nvarchar](255) NULL,
	[PlanAddressLine1] [nvarchar](255) NULL,
	[PlanAddressLine2] [nvarchar](255) NULL,
	[PlanCity] [nvarchar](255) NULL,
	[PlanState] [nvarchar](255) NULL,
	[PlanCountry] [nvarchar](255) NULL,
	[PlanZipCode] [nvarchar](255) NULL,
	[PlanContactPrefix] [nvarchar](255) NULL,
	[PlanContactFirstName] [nvarchar](255) NULL,
	[PlanContactMiddleName] [nvarchar](255) NULL,
	[PlanContactLastName] [nvarchar](255) NULL,
	[PlanContactSuffix] [nvarchar](255) NULL,
	[PlanPhone] [nvarchar](255) NULL,
	[PlanPhoneExt] [nvarchar](255) NULL,
	[PlanFax] [nvarchar](255) NULL,
	[PlanFaxExt] [nvarchar](255) NULL,
	[PlanNotes] [nvarchar](255) NULL,
	[PlanCopay] [nvarchar](255) NULL,
	[PlanDeductible] [nvarchar](255) NULL
) 


insert into dbo.zz_import_PayerList_20100112_Practice
SELECT 7 as practiceID
		,[InsuranceCompanyName]
      ,[InsuranceCompanyAddressLine1]
      ,[InsuranceCompanyAddressLine2]
      ,[InsuranceCompanyCity]
      ,[InsuranceCompanyState]
      ,[InsuranceCompanyCountry]
      ,cast( [InsuranceCompanyZipCode] as varchar(255)) as [InsuranceCompanyZipCode]
      ,[InsuranceCompanyContactPrefix]
      ,[InsuranceCompanyContactFirstName]
      ,[InsuranceCompanyContactMiddleName]
      ,[InsuranceCompanyContactLastName]
      ,[InsuranceCompanyContactSuffix]
      ,[InsuranceCompanyPhone]
      ,[InsuranceCompanyPhoneExt]
      ,[InsuranceCompanyFax]
      ,[InsuranceCompanyFaxExt]
      ,[InsuranceProgramCode]
      ,[Notes]
      ,[PlanName]
      ,[PlanAddressLine1]
      ,[PlanAddressLine2]
      ,[PlanCity]
      ,[PlanState]
      ,[PlanCountry]
      ,cast( [PlanZipCode] as varchar(255) ) as [PlanZipCode]
      ,[PlanContactPrefix]
      ,[PlanContactFirstName]
      ,[PlanContactMiddleName]
      ,[PlanContactLastName]
      ,[PlanContactSuffix]
      ,[PlanPhone]
      ,[PlanPhoneExt]
      ,[PlanFax]
      ,[PlanFaxExt]
      ,[PlanNotes]
      ,[PlanCopay]
      ,[PlanDeductible]
  FROM [dbo].[zz_Import_BlakehurstPayerSpecificList]


insert into dbo.zz_import_PayerList_20100112_Practice
SELECT 9 as practiceID
		,[InsuranceCompanyName]
      ,[InsuranceCompanyAddressLine1]
      ,[InsuranceCompanyAddressLine2]
      ,[InsuranceCompanyCity]
      ,[InsuranceCompanyState]
      ,[InsuranceCompanyCountry]
      ,[InsuranceCompanyZipCode]
      ,[InsuranceCompanyContactPrefix]
      ,[InsuranceCompanyContactFirstName]
      ,[InsuranceCompanyContactMiddleName]
      ,[InsuranceCompanyContactLastName]
      ,[InsuranceCompanyContactSuffix]
      ,[InsuranceCompanyPhone]
      ,[InsuranceCompanyPhoneExt]
      ,[InsuranceCompanyFax]
      ,[InsuranceCompanyFaxExt]
      ,[InsuranceProgramCode]
      ,[Notes]
      ,[PlanName]
      ,[PlanAddressLine1]
      ,[PlanAddressLine2]
      ,[PlanCity]
      ,[PlanState]
      ,[PlanCountry]
      ,[PlanZipCode]
      ,[PlanContactPrefix]
      ,[PlanContactFirstName]
      ,[PlanContactMiddleName]
      ,[PlanContactLastName]
      ,[PlanContactSuffix]
      ,[PlanPhone]
      ,[PlanPhoneExt]
      ,[PlanFax]
      ,[PlanFaxExt]
      ,[PlanNotes]
      ,[PlanCopay]
      ,[PlanDeductible]
  FROM dbo.zz_Import_CarillonPayerSpecificList



insert into dbo.zz_import_PayerList_20100112_Practice
SELECT 5 as practiceID
		,[InsuranceCompanyName]
      ,[InsuranceCompanyAddressLine1]
      ,[InsuranceCompanyAddressLine2]
      ,[InsuranceCompanyCity]
      ,[InsuranceCompanyState]
      ,[InsuranceCompanyCountry]
      ,[InsuranceCompanyZipCode]
      ,[InsuranceCompanyContactPrefix]
      ,[InsuranceCompanyContactFirstName]
      ,[InsuranceCompanyContactMiddleName]
      ,[InsuranceCompanyContactLastName]
      ,[InsuranceCompanyContactSuffix]
      ,[InsuranceCompanyPhone]
      ,[InsuranceCompanyPhoneExt]
      ,[InsuranceCompanyFax]
      ,[InsuranceCompanyFaxExt]
      ,[InsuranceProgramCode]
      ,[Notes]
      ,[PlanName]
      ,[PlanAddressLine1]
      ,[PlanAddressLine2]
      ,[PlanCity]
      ,[PlanState]
      ,[PlanCountry]
      ,[PlanZipCode]
      ,[PlanContactPrefix]
      ,[PlanContactFirstName]
      ,[PlanContactMiddleName]
      ,[PlanContactLastName]
      ,[PlanContactSuffix]
      ,[PlanPhone]
      ,[PlanPhoneExt]
      ,[PlanFax]
      ,[PlanFaxExt]
      ,[PlanNotes]
      ,[PlanCopay]
      ,[PlanDeductible]
  FROM dbo.zz_Import_CroasdailePayerSpecificList


insert into dbo.zz_import_PayerList_20100112_Practice
SELECT 6 as practiceID
		,[InsuranceCompanyName]
      ,[InsuranceCompanyAddressLine1]
      ,[InsuranceCompanyAddressLine2]
      ,[InsuranceCompanyCity]
      ,[InsuranceCompanyState]
      ,[InsuranceCompanyCountry]
      ,[InsuranceCompanyZipCode]
      ,[InsuranceCompanyContactPrefix]
      ,[InsuranceCompanyContactFirstName]
      ,[InsuranceCompanyContactMiddleName]
      ,[InsuranceCompanyContactLastName]
      ,[InsuranceCompanyContactSuffix]
      ,[InsuranceCompanyPhone]
      ,[InsuranceCompanyPhoneExt]
      ,[InsuranceCompanyFax]
      ,[InsuranceCompanyFaxExt]
      ,[InsuranceProgramCode]
      ,[Notes]
      ,[PlanName]
      ,[PlanAddressLine1]
      ,[PlanAddressLine2]
      ,[PlanCity]
      ,[PlanState]
      ,[PlanCountry]
      ,[PlanZipCode]
      ,[PlanContactPrefix]
      ,[PlanContactFirstName]
      ,[PlanContactMiddleName]
      ,[PlanContactLastName]
      ,[PlanContactSuffix]
      ,[PlanPhone]
      ,[PlanPhoneExt]
      ,[PlanFax]
      ,[PlanFaxExt]
      ,[PlanNotes]
      ,[PlanCopay]
      ,[PlanDeductible]
  FROM dbo.zz_Import_CypressPayerSpecificList
  

insert into dbo.zz_import_PayerList_20100112_Practice
SELECT 4 as practiceID
		,[InsuranceCompanyName]
      ,[InsuranceCompanyAddressLine1]
      ,[InsuranceCompanyAddressLine2]
      ,[InsuranceCompanyCity]
      ,[InsuranceCompanyState]
      ,[InsuranceCompanyCountry]
      ,[InsuranceCompanyZipCode]
      ,[InsuranceCompanyContactPrefix]
      ,[InsuranceCompanyContactFirstName]
      ,[InsuranceCompanyContactMiddleName]
      ,[InsuranceCompanyContactLastName]
      ,[InsuranceCompanyContactSuffix]
      ,[InsuranceCompanyPhone]
      ,[InsuranceCompanyPhoneExt]
      ,[InsuranceCompanyFax]
      ,[InsuranceCompanyFaxExt]
      ,[InsuranceProgramCode]
      ,[Notes]
      ,[PlanName]
      ,[PlanAddressLine1]
      ,[PlanAddressLine2]
      ,[PlanCity]
      ,[PlanState]
      ,[PlanCountry]
      ,[PlanZipCode]
      ,[PlanContactPrefix]
      ,[PlanContactFirstName]
      ,[PlanContactMiddleName]
      ,[PlanContactLastName]
      ,[PlanContactSuffix]
      ,[PlanPhone]
      ,[PlanPhoneExt]
      ,[PlanFax]
      ,[PlanFaxExt]
      ,[PlanNotes]
      ,[PlanCopay]
      ,[PlanDeductible]
  FROM dbo.zz_Import_ParkSpringsPayerSpecificList



insert into dbo.zz_import_PayerList_20100112_Practice
SELECT 10 as practiceID
		,[InsuranceCompanyName]
      ,[InsuranceCompanyAddressLine1]
      ,[InsuranceCompanyAddressLine2]
      ,[InsuranceCompanyCity]
      ,[InsuranceCompanyState]
      ,[InsuranceCompanyCountry]
      ,[InsuranceCompanyZipCode]
      ,[InsuranceCompanyContactPrefix]
      ,[InsuranceCompanyContactFirstName]
      ,[InsuranceCompanyContactMiddleName]
      ,[InsuranceCompanyContactLastName]
      ,[InsuranceCompanyContactSuffix]
      ,[InsuranceCompanyPhone]
      ,[InsuranceCompanyPhoneExt]
      ,[InsuranceCompanyFax]
      ,[InsuranceCompanyFaxExt]
      ,[InsuranceProgramCode]
      ,[Notes]
      ,[PlanName]
      ,[PlanAddressLine1]
      ,[PlanAddressLine2]
      ,[PlanCity]
      ,[PlanState]
      ,[PlanCountry]
      ,[PlanZipCode]
      ,[PlanContactPrefix]
      ,[PlanContactFirstName]
      ,[PlanContactMiddleName]
      ,[PlanContactLastName]
      ,[PlanContactSuffix]
      ,[PlanPhone]
      ,[PlanPhoneExt]
      ,[PlanFax]
      ,[PlanFaxExt]
      ,[PlanNotes]
      ,[PlanCopay]
      ,[PlanDeductible]
  FROM dbo.zz_Import_SandhillCovePayerSpecificList



  
insert into dbo.zz_import_PayerList_20100112_Practice
SELECT 8 as practiceID
		,[InsuranceCompanyName]
      ,[InsuranceCompanyAddressLine1]
      ,[InsuranceCompanyAddressLine2]
      ,[InsuranceCompanyCity]
      ,[InsuranceCompanyState]
      ,[InsuranceCompanyCountry]
      ,[InsuranceCompanyZipCode]
      ,[InsuranceCompanyContactPrefix]
      ,[InsuranceCompanyContactFirstName]
      ,[InsuranceCompanyContactMiddleName]
      ,[InsuranceCompanyContactLastName]
      ,[InsuranceCompanyContactSuffix]
      ,[InsuranceCompanyPhone]
      ,[InsuranceCompanyPhoneExt]
      ,[InsuranceCompanyFax]
      ,[InsuranceCompanyFaxExt]
      ,[InsuranceProgramCode]
      ,[Notes]
      ,[PlanName]
      ,[PlanAddressLine1]
      ,[PlanAddressLine2]
      ,[PlanCity]
      ,[PlanState]
      ,[PlanCountry]
      ,[PlanZipCode]
      ,[PlanContactPrefix]
      ,[PlanContactFirstName]
      ,[PlanContactMiddleName]
      ,[PlanContactLastName]
      ,[PlanContactSuffix]
      ,[PlanPhone]
      ,[PlanPhoneExt]
      ,[PlanFax]
      ,[PlanFaxExt]
      ,[PlanNotes]
      ,[PlanCopay]
      ,[PlanDeductible]
  FROM dbo.zz_Import_VantagePayerSpecificList
  
  

insert into dbo.zz_import_PayerList_20100112_Practice
SELECT 11 as practiceID
		,[InsuranceCompanyName]
      ,[InsuranceCompanyAddressLine1]
      ,[InsuranceCompanyAddressLine2]
      ,[InsuranceCompanyCity]
      ,[InsuranceCompanyState]
      ,[InsuranceCompanyCountry]
      ,[InsuranceCompanyZipCode]
      ,[InsuranceCompanyContactPrefix]
      ,[InsuranceCompanyContactFirstName]
      ,[InsuranceCompanyContactMiddleName]
      ,[InsuranceCompanyContactLastName]
      ,[InsuranceCompanyContactSuffix]
      ,[InsuranceCompanyPhone]
      ,[InsuranceCompanyPhoneExt]
      ,[InsuranceCompanyFax]
      ,[InsuranceCompanyFaxExt]
      ,[InsuranceProgramCode]
      ,[Notes]
      ,[PlanName]
      ,[PlanAddressLine1]
      ,[PlanAddressLine2]
      ,[PlanCity]
      ,[PlanState]
      ,[PlanCountry]
      ,[PlanZipCode]
      ,[PlanContactPrefix]
      ,[PlanContactFirstName]
      ,[PlanContactMiddleName]
      ,[PlanContactLastName]
      ,[PlanContactSuffix]
      ,[PlanPhone]
      ,[PlanPhoneExt]
      ,[PlanFax]
      ,[PlanFaxExt]
      ,[PlanNotes]
      ,[PlanCopay]
      ,[PlanDeductible]
  FROM dbo.zz_Import_WestminsterPayerSpecificListt
  
   
  delete zz_import_PayerList_20100112_Practice
  where InsuranceCompanyName is null
  
  alter table zz_import_PayerList_20100112_Practice add rowid int identity(1,1) primary key clustered
  
  update zz_import_PayerList_20100112_Practice
  set InsuranceCompanyPhone = replace( InsuranceCompanyPhone, '-', '')
  update zz_import_PayerList_20100112_Practice
  set InsuranceCompanyPhone = replace( InsuranceCompanyPhone, '(', '')
  update zz_import_PayerList_20100112_Practice
  set InsuranceCompanyPhone = replace( InsuranceCompanyPhone, ')', '')
  update zz_import_PayerList_20100112_Practice
  set InsuranceCompanyPhone = replace( InsuranceCompanyPhone, ' ', '')
  
  update zz_import_PayerList_20100112_Practice
  set PlanPhone = replace( PlanPhone, '-', '')
  update zz_import_PayerList_20100112_Practice
  set PlanPhone = replace( PlanPhone, '(', '')
  update zz_import_PayerList_20100112_Practice
  set PlanPhone = replace( PlanPhone, ')', '')
  update zz_import_PayerList_20100112_Practice
  set PlanPhone = replace( PlanPhone, ' ', '')
  
  
	select
	'exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]
		@name = ''' + replace(InsuranceCompanyName, '', '''''') + ''',
		@street_1 = ''' + isnull(InsuranceCompanyAddressLine1, '') + ''',
		@street_2 = ''' +isnull(InsuranceCompanyAddressLine2, '')+ ''',
		@city =''' + isnull(InsuranceCompanyCity, '')+ ''',
		@state = ''' + isnull(InsuranceCompanyState, '')+ ''',
		@country = ''' + isnull(InsuranceCompanyCountry, '')+ ''',
		@zip = ''' + isnull(InsuranceCompanyZipCode, '')+ ''',
		@contact_prefix = NULL,
		@contact_first_name = NULL,
		@contact_middle_name = NULL,
		@contact_last_name = NULL,
		@contact_suffix = NULL,
		@phone = ''' + isnull(InsuranceCompanyPhone, '')+ ''',
		@phone_x = ''' + isnull(InsuranceCompanyPhoneExt, '')+ ''',
		@fax = null,
		@fax_x = null,
		@program_code = ''' + isnull(InsuranceProgramCode, '') + ''',
		@notes = ''Id:' + cast(rowid as varchar(32)) + ''',
		@practice_id = ''' + cast( practiceID as varchar(32))+ ''',
		@BillingFormID = 13,
		@SecondaryPrecedenceBillingFormID =13,
		@AcceptAssignment = 0,
		@UseSecondaryElectronicBilling = 0,
		@UseCoordinationOfBenefits = 1,
		@ExcludePatientPayment = 0,
		@bill_secondary_insurance = 0,
		@review_code='''',
		@UseFacilityID=''1'',
		@eclaims_disable=0	
	'
	from dbo.zz_import_PayerList_20100112_Practice z
	where InsuranceCompanyName is not null
		-- and not exists( select * from insuranceCompany icp where z.InsuranceCompanyName=icp.insuranceCompanyName and icp.practiceID=z.practiceID)
	order by 1
	
	
	
	
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = ' BCBS of North Carolina',    @street_1 = 'PO BOX 35',    @street_2 = '',    @city =' DURHAM',    @state = ' NC',    @country = 'USA',    @zip = '27702',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8772583334',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:9',    @practice_id = '5',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS Federal Employee Program',    @street_1 = 'PO BOX 600601',    @street_2 = '',    @city ='COLUMBIA',    @state = 'SC',    @country = 'USA',    @zip = '29260',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8889302345',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:12',    @practice_id = '6',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS Federal Plans',    @street_1 = 'PO BOX 1798',    @street_2 = '',    @city ='JACKSONVILLE ',    @state = 'FL',    @country = 'USA',    @zip = '32231',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8003332227',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:16',    @practice_id = '10',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS Federal Plans',    @street_1 = 'PO BOX 66044',    @street_2 = '',    @city ='DALLAS',    @state = 'TX',    @country = 'USA',    @zip = '75266-004',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:24',    @practice_id = '11',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS Federal Plans',    @street_1 = 'PO BOX 66044',    @street_2 = '',    @city ='DALLAS',    @state = 'TX',    @country = 'USA',    @zip = '75266-004',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:4',    @practice_id = '9',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS FEP Program',    @street_1 = 'PO BOX 14113',    @street_2 = '',    @city ='LEXINGTON',    @state = 'KY',    @country = 'USA',    @zip = '40512',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8008545256',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:2',    @practice_id = '7',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS FEP Program',    @street_1 = 'PO BOX 14113',    @street_2 = '',    @city ='LEXINGTON',    @state = 'KY',    @country = 'USA',    @zip = '40512',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8008545256',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:21',    @practice_id = '8',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS Florida',    @street_1 = 'PO BOX 1798',    @street_2 = '',    @city ='JACKSONVILLE ',    @state = 'FL',    @country = 'USA',    @zip = '32231',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8003332227',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:17',    @practice_id = '10',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS of Georgia',    @street_1 = 'PO BOX 9907',    @street_2 = '',    @city ='COLUMBUS',    @state = 'GA',    @country = 'USA',    @zip = '31908',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8002417475',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:14',    @practice_id = '4',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS of South Carolina',    @street_1 = 'PIEDMONT SERVICE CENTER',    @street_2 = 'PO BOX 6000',    @city ='GREENVILLE',    @state = 'SC',    @country = 'USA',    @zip = '29606',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8008102583',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:10',    @practice_id = '6',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS of South Carolina',    @street_1 = 'PO BOX 100300',    @street_2 = '',    @city ='COLUMBIA',    @state = 'SC',    @country = 'USA',    @zip = '',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8008682510',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:11',    @practice_id = '6',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS of Texas',    @street_1 = 'PO BOX 66044',    @street_2 = '',    @city ='DALLAS',    @state = 'TX',    @country = 'USA',    @zip = '75266-004',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:26',    @practice_id = '11',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS of Texas',    @street_1 = 'PO BOX 66044',    @street_2 = '',    @city ='DALLAS',    @state = 'TX',    @country = 'USA',    @zip = '75266-004',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:6',    @practice_id = '9',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'BCBS Out of State Plans',    @street_1 = 'PO BOX 1798',    @street_2 = '',    @city ='JACKSONVILLE ',    @state = 'FL',    @country = 'USA',    @zip = '32231',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8003332227',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:18',    @practice_id = '10',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Carefirst BCBS',    @street_1 = 'PO BOX 14115',    @street_2 = '',    @city ='LEXINGTON',    @state = 'KY',    @country = 'USA',    @zip = '40512',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8004372332',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:1',    @practice_id = '7',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Carefirst BCBS',    @street_1 = 'PO BOX 14115',    @street_2 = '',    @city ='LEXINGTON',    @state = 'KY',    @country = 'USA',    @zip = '40512',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8004372332',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:20',    @practice_id = '8',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Carefirst',    @street_1 = 'PO BOX 13303',    @street_2 = '',    @city ='BALTIMORE',    @state = 'MD',    @country = 'USA',    @zip = '21203',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '80036081865',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:22',    @practice_id = '8',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Cigna Medicare ',    @street_1 = 'P O BOX 671',    @street_2 = '',    @city =' NASHVILLE',    @state = ' TN',    @country = 'USA',    @zip = '37202',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8662389651',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'MB',    @notes = 'Id:8',    @practice_id = '5',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Florida Medicare',    @street_1 = 'PO BOX 2711',    @street_2 = '',    @city ='JACKSONVILLE ',    @state = 'FL',    @country = 'USA',    @zip = '32231',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8664549007',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'MB',    @notes = 'Id:19',    @practice_id = '10',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Highmark Medicare',    @street_1 = 'PO BOX 890413',    @street_2 = '',    @city ='CAMP HILL',    @state = 'PA',    @country = 'USA',    @zip = '17089',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8772358073',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'MB',    @notes = 'Id:3',    @practice_id = '7',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Maryland Medicare',    @street_1 = 'PO BOX 890401',    @street_2 = '',    @city ='CAMP HILL',    @state = 'PA',    @country = 'USA',    @zip = '17089',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8772358073',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'MB',    @notes = 'Id:23',    @practice_id = '8',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Medicare Of Texas',    @street_1 = 'PO BOX 650706',    @street_2 = '',    @city ='DALLAS',    @state = 'TX',    @country = 'USA',    @zip = '75265-0706',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8775679230',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'MB',    @notes = 'Id:27',    @practice_id = '11',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Medicare Of Texas',    @street_1 = 'PO BOX 650706',    @street_2 = '',    @city ='DALLAS',    @state = 'TX',    @country = 'USA',    @zip = '75265-0706',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8775679230',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'MB',    @notes = 'Id:7',    @practice_id = '9',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Medicare Part B',    @street_1 = 'PO BOX 3076',    @street_2 = '',    @city ='SAVANNAH',    @state = 'GA',    @country = 'USA',    @zip = '31402',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8775677271',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'MB',    @notes = 'Id:15',    @practice_id = '4',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Out of State Plans',    @street_1 = 'PO BOX 66044',    @street_2 = '',    @city ='DALLAS',    @state = 'TX',    @country = 'USA',    @zip = '75266-004',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:25',    @practice_id = '11',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Out of State Plans',    @street_1 = 'PO BOX 66044',    @street_2 = '',    @city ='DALLAS',    @state = 'TX',    @country = 'USA',    @zip = '75266-004',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'BL',    @notes = 'Id:5',    @practice_id = '9',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    
exec [dbo].[InsurancePlanDataProvider_CreateInsuranceCompany]    @name = 'Palmetto Medicare',    @street_1 = 'GM220',    @street_2 = 'PO BOX 100190',    @city ='COLUMBIA',    @state = 'SC',    @country = 'USA',    @zip = '29202',    @contact_prefix = NULL,    @contact_first_name = NULL,    @contact_middle_name = NULL,    @contact_last_name = NULL,    @contact_suffix = NULL,    @phone = '8662389654',    @phone_x = '',    @fax = null,    @fax_x = null,    @program_code = 'MB',    @notes = 'Id:13',    @practice_id = '6',    @BillingFormID = 13,    @SecondaryPrecedenceBillingFormID =13,    @AcceptAssignment = 0,    @UseSecondaryElectronicBilling = 0,    @UseCoordinationOfBenefits = 1,    @ExcludePatientPayment = 0,    @bill_secondary_insurance = 0,    @review_code='',    @UseFacilityID='1',    @eclaims_disable=0    

	
	
select * from insuranceCompany

update insuranceCompany
set vendorID=replace( cast(notes as varchar(255)), 'Id:', '')
where notes like 'Id:%'

select * from dbo.zz_import_PayerList_20100112_Practice order by 2
	

-- Primry
select 
	'exec InsurancePlanDataProvider_CreateInsurancePlan 
		@name=N''' + PlanName + '''
		,@street_1=N''' + isnull( PlanAddressLine1,'') + '''
		,@program_code=N'''+ic.InsuranceProgramCode+'''
		,@street_2=N''' + isnull( PlanAddressLine2,'') + '''
		,@deductible=0
		,@company_id=' + cast(insuranceCompanyID as varchar(32)) + '
		,@fax_x=NULL
		,@phone='''+isnull( PlanPhone, '')+'''
		,@contact_suffix=NULL
		,@review_code=N''''
		,@phone_x='''+isnull( PlanPhoneExt, '')+'''
		,@contact_last_name=NULL
		,@city=N'''+isnull( PlanCity,'')+'''
		,@fax=NULL
		,@state=N'''+isnull( PlanState,'')+'''
		,@notes=N''Imported by Kareo Jan 12, 2010''
		,@contact_prefix=NULL
		,@country=N''USA''
		,@contact_first_name=NULL
		,@copay=0
		,@zip=N'''+isnull(left( PlanZipCode ,9),'')+'''
		,@EClaimsAccepts=0
		,@practice_id=''' + cast(practiceID as varchar(255))+ '''
		,@contact_middle_name=NULL'
from zz_import_PayerList_20100112_Practice z
	inner join insuranceCompany ic
		on ic.vendorID=z.rowID
order by z.InsuranceCompanyName



exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS of North Carolina'    ,@street_1=N'PO BOX 35'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=16    ,@fax_x=NULL    ,@phone='8772583334'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N' DURHAM'    ,@fax=NULL    ,@state=N' NC'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'27702'    ,@EClaimsAccepts=0    ,@practice_id='5'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS Federal Employee Program'    ,@street_1=N'PO BOX 600601'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=17    ,@fax_x=NULL    ,@phone='8889302345'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'COLUMBIA'    ,@fax=NULL    ,@state=N'SC'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'29260'    ,@EClaimsAccepts=0    ,@practice_id='6'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS Federal Plans'    ,@street_1=N'PO BOX 1798'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=18    ,@fax_x=NULL    ,@phone='8003332227'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'JACKSONVILLE '    ,@fax=NULL    ,@state=N'FL'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'32231'    ,@EClaimsAccepts=0    ,@practice_id='10'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS Federal Plans'    ,@street_1=N'PO BOX 66044'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=20    ,@fax_x=NULL    ,@phone=''    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'DALLAS'    ,@fax=NULL    ,@state=N'TX'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'75266-004'    ,@EClaimsAccepts=0    ,@practice_id='9'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS Federal Plans'    ,@street_1=N'PO BOX 66044'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=19    ,@fax_x=NULL    ,@phone=''    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'DALLAS'    ,@fax=NULL    ,@state=N'TX'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'75266-004'    ,@EClaimsAccepts=0    ,@practice_id='11'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS FEP Program'    ,@street_1=N'PO BOX 14113'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=22    ,@fax_x=NULL    ,@phone='8008545256'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'LEXINGTON'    ,@fax=NULL    ,@state=N'KY'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'40512'    ,@EClaimsAccepts=0    ,@practice_id='8'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS FEP Program'    ,@street_1=N'PO BOX 14113'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=21    ,@fax_x=NULL    ,@phone='8008545256'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'LEXINGTON'    ,@fax=NULL    ,@state=N'KY'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'40512'    ,@EClaimsAccepts=0    ,@practice_id='7'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS Florida'    ,@street_1=N'PO BOX 1798'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=23    ,@fax_x=NULL    ,@phone='8003332227'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'JACKSONVILLE '    ,@fax=NULL    ,@state=N'FL'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'32231'    ,@EClaimsAccepts=0    ,@practice_id='10'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS of Georgia'    ,@street_1=N'PO BOX 9907'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=24    ,@fax_x=NULL    ,@phone='8002417475'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'COLUMBUS'    ,@fax=NULL    ,@state=N'GA'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'31908'    ,@EClaimsAccepts=0    ,@practice_id='4'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS of South Carolina'    ,@street_1=N'PIEDMONT SERVICE CENTER'    ,@program_code=N'BL'    ,@street_2=N'PO BOX 6000'    ,@deductible=0    ,@company_id=25    ,@fax_x=NULL    ,@phone='8008102583'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'GREENVILLE'    ,@fax=NULL    ,@state=N'SC'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'29606'    ,@EClaimsAccepts=0    ,@practice_id='6'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS of South Carolina'    ,@street_1=N'PO BOX 100300'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=26    ,@fax_x=NULL    ,@phone='8008682510'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'COLUMBIA'    ,@fax=NULL    ,@state=N'SC'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N''    ,@EClaimsAccepts=0    ,@practice_id='6'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS of Texas'    ,@street_1=N'PO BOX 66044'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=28    ,@fax_x=NULL    ,@phone=''    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'DALLAS'    ,@fax=NULL    ,@state=N'TX'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'75266-004'    ,@EClaimsAccepts=0    ,@practice_id='9'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS of Texas'    ,@street_1=N'PO BOX 66044'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=27    ,@fax_x=NULL    ,@phone=''    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'DALLAS'    ,@fax=NULL    ,@state=N'TX'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'75266-004'    ,@EClaimsAccepts=0    ,@practice_id='11'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'BCBS Out of State Plans'    ,@street_1=N'PO BOX 1798'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=29    ,@fax_x=NULL    ,@phone='8003332227'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'JACKSONVILLE '    ,@fax=NULL    ,@state=N'FL'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'32231'    ,@EClaimsAccepts=0    ,@practice_id='10'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Carefirst'    ,@street_1=N'PO BOX 13303'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=32    ,@fax_x=NULL    ,@phone='80036081865'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'BALTIMORE'    ,@fax=NULL    ,@state=N'MD'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'21203'    ,@EClaimsAccepts=0    ,@practice_id='8'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Carefirst BCBS'    ,@street_1=N'PO BOX 14115'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=31    ,@fax_x=NULL    ,@phone='8004372332'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'LEXINGTON'    ,@fax=NULL    ,@state=N'KY'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'40512'    ,@EClaimsAccepts=0    ,@practice_id='8'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Carefirst BCBS'    ,@street_1=N'PO BOX 14115'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=30    ,@fax_x=NULL    ,@phone='8004372332'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'LEXINGTON'    ,@fax=NULL    ,@state=N'KY'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'40512'    ,@EClaimsAccepts=0    ,@practice_id='7'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Cigna Medicare '    ,@street_1=N'P O BOX 671'    ,@program_code=N'MB'    ,@street_2=N''    ,@deductible=0    ,@company_id=33    ,@fax_x=NULL    ,@phone='8662389651'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N' NASHVILLE'    ,@fax=NULL    ,@state=N' TN'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'37202'    ,@EClaimsAccepts=0    ,@practice_id='5'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Florida Medicare'    ,@street_1=N'PO BOX 2711'    ,@program_code=N'MB'    ,@street_2=N''    ,@deductible=0    ,@company_id=34    ,@fax_x=NULL    ,@phone='8664549007'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'JACKSONVILLE '    ,@fax=NULL    ,@state=N'FL'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'32231'    ,@EClaimsAccepts=0    ,@practice_id='10'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Highmark Medicare'    ,@street_1=N'PO BOX 890413'    ,@program_code=N'MB'    ,@street_2=N''    ,@deductible=0    ,@company_id=35    ,@fax_x=NULL    ,@phone='8772358073'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'CAMP HILL'    ,@fax=NULL    ,@state=N'PA'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'17089'    ,@EClaimsAccepts=0    ,@practice_id='7'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Maryland Medicare'    ,@street_1=N'PO BOX 890401'    ,@program_code=N'MB'    ,@street_2=N''    ,@deductible=0    ,@company_id=36    ,@fax_x=NULL    ,@phone='8772358073'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'CAMP HILL'    ,@fax=NULL    ,@state=N'PA'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'17089'    ,@EClaimsAccepts=0    ,@practice_id='8'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Medicare Of Texas'    ,@street_1=N'PO BOX 650706'    ,@program_code=N'MB'    ,@street_2=N''    ,@deductible=0    ,@company_id=37    ,@fax_x=NULL    ,@phone='8775679230'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'DALLAS'    ,@fax=NULL    ,@state=N'TX'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'75265-070'    ,@EClaimsAccepts=0    ,@practice_id='11'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Medicare Of Texas'    ,@street_1=N'PO BOX 650706'    ,@program_code=N'MB'    ,@street_2=N''    ,@deductible=0    ,@company_id=38    ,@fax_x=NULL    ,@phone='8775679230'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'DALLAS'    ,@fax=NULL    ,@state=N'TX'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'75265-070'    ,@EClaimsAccepts=0    ,@practice_id='9'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Medicare Part B'    ,@street_1=N'PO BOX 3076'    ,@program_code=N'MB'    ,@street_2=N''    ,@deductible=0    ,@company_id=39    ,@fax_x=NULL    ,@phone='8775677271'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'SAVANNAH'    ,@fax=NULL    ,@state=N'GA'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'31402'    ,@EClaimsAccepts=0    ,@practice_id='4'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Out of State Plans'    ,@street_1=N'PO BOX 66044'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=40    ,@fax_x=NULL    ,@phone=''    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'DALLAS'    ,@fax=NULL    ,@state=N'TX'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'75266-004'    ,@EClaimsAccepts=0    ,@practice_id='11'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Out of State Plans'    ,@street_1=N'PO BOX 66044'    ,@program_code=N'BL'    ,@street_2=N''    ,@deductible=0    ,@company_id=41    ,@fax_x=NULL    ,@phone=''    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'DALLAS'    ,@fax=NULL    ,@state=N'TX'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'75266-004'    ,@EClaimsAccepts=0    ,@practice_id='9'    ,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan     @name=N'Palmetto Medicare'    ,@street_1=N'GM220'    ,@program_code=N'MB'    ,@street_2=N'PO BOX 100190'    ,@deductible=0    ,@company_id=42    ,@fax_x=NULL    ,@phone='8662389654'    ,@contact_suffix=NULL    ,@review_code=N''    ,@phone_x=''    ,@contact_last_name=NULL    ,@city=N'COLUMBIA'    ,@fax=NULL    ,@state=N'SC'    ,@notes=N'Imported by Kareo Jan 12, 2010'    ,@contact_prefix=NULL    ,@country=N'USA'    ,@contact_first_name=NULL    ,@copay=0    ,@zip=N'29202'    ,@EClaimsAccepts=0    ,@practice_id='6'    ,@contact_middle_name=NULL



insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 100310')


update icp
set vendorID=ic.vendorID, vendorImportID=1
from insuranceCompanyPlan icp
	inner join insuranceCompany ic
		on ic.insuranceCompanyID=icp.insuranceCompanyID
where ic.VendorID is not null

update insuranceCompany
set VendorImportID=1
where vendorID is not null

