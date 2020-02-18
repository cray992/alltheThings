/*
select *
from zz_import_20100717_patient

alter table zz_import_20100717_patient add rowid int identity(1,1)



insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 126290')

delete patientcase where vendorImportId=39
delete patient where vendorImportId=39
*/


declare @practiceID int, @vendorImportID int
select @practiceID=18, @vendorImportID=39

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
			
		,ResponsibleFirstName,
		ResponsibleMiddleName,
		ResponsibleLastName,
		ResponsibleAddressLine1,
		ResponsibleCity,
		ResponsibleState,
		ResponsibleZipCode
		)
	    
	SELECT 
		'' prefix,
		'' as suffix,
		isnull( null, '') as MI,
		@practiceID as practiceID,
		isnull( left([Patient First Name], 64) , ''),
		isnull( left([Patient Last Name], 64) , ''),
		isnull( left( [Patient Address Line 1], 256), ''),
		'' as addr2,
		left([Patient City], 128) ,
		case when len( ltrim(rtrim([Patient State])) )=2 then ltrim(rtrim([Patient State])) else '' end,
		left(replace( [Patient Zip],'-', ''), 9) as zip,
		cast( replace(replace(replace(replace( null, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) HomePhone,
		null WorkPhone,
		null workExt,
		null as MobilePhone, 
		[Patient Date of Birth] ,
		null SSN,
		case [Patient Gender]
			when 'M' then 'M'
			when 'F' then 'F'
			else null end,  
		rowid as [VendorID], -- vendorID
		[Patient ID] as  MRN,
		@vendorImportID, -- vendorID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		null as Email,
		null as EmploymentStatus,
		null EmployerID,
		null as MaritalStatus
		
		,isnull([Patient Guarantor First], '') as ResponsibleFirstName,
		null as ResponsibleMiddleName,
		isnull([Patient Guarantor Last], '') as ResponsibleLastName,
		left( isnull([Patient Guarnator Address Line 1], ''), 256) as ResponsibleAddressLine1,
		isnull([Patient Guarantor City], '') as ResponsibleCity,
		rtrim(ltrim( isnull([Patient Guarantor State], '') )) as ResponsibleState,
		isnull( left(replace(  [Patient Guarnator Zip],'-', ''), 9), '') as ResponsibleZipCode
	from dbo.zz_import_20100717_patient i
	where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=@vendorImportID)
		and [Patient ID] <> 3601
		
		
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
	where VendorImportID = @vendorImportId
		and not exists(select * from patientCase pc where pc.patientID=p.patientID )


declare @t table( contractId int, procedureCode varchar(255), Fee float )

insert into @t
select 56, [Procedure Code], [Medicare Fee]
from dbo.[zz_import_20100717_fee_56]

insert into @t
select 57, [Procedure Code], [Commercial Fee]
from dbo.zz_import_20100717_fee_57

select *
into dbo.zz_import_20100717_fee_master_2 
from @t


alter table zz_import_20100717_fee_master_2 add rowid int identity(1,1)
alter table zz_import_20100717_fee_master_2 add amount money

update zz_import_20100717_fee_master_2
set Amount = round(fee, 2)

begin tran

	-- MEDICARE - 2010
	declare @vendorImportID int
	select @vendorImportID=39
	

	insert into dbo.ProcedureCodeDictionary(
		ProcedureCode
		,CreatedDate
		,CreatedUserID
		,ModifiedDate
		,ModifiedUserID
		,TypeOfServiceCode
		,Active
		,OfficialName
		,VendorImportID
	)
	select distinct 
		i.procedureCode
		,getdate()
		,0
		,getdate()
		,0
		,9
		,1
		,i.procedureCode
		,@vendorImportID
	from zz_import_20100717_fee_master_2 i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.procedureCode
	where pcd.ProcedureCodeDictionaryID is null


	INSERT INTO dbo.ContractFeeSchedule(
		CreatedDate
		,CreatedUserID
		,ModifiedDate
		,ModifiedUserID
		,ContractID
		,Gender
		,StandardFee
		,Allowable
		,ExpectedReimbursement
		,RVU
		,ProcedureCodeDictionaryID
		,PracticeRVU
		,MalpracticeRVU
		,VendorImportID
		,VendorID
		,Modifier
		)
	select 
		getdate() CreatedDate
		,0 as CreatedUserID
		,getdate() ModifiedDate
		,0 ModifiedUserID
		,i.contractID
		,'B' Gender
		,cast(amount as money) StandardFee
		,0 as Allowable
		,0 as ExpectedReimbursement
		,0 as RVU
		,pcd.ProcedureCodeDictionaryID
		,0 as PracticeRVU
		,0 as MalpracticeRVU
		,@VendorImportID as VendorImportID
		,rowID
		,null Modifier
	from zz_import_20100717_fee_master_2 i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.procedureCode

	commit;
	
	