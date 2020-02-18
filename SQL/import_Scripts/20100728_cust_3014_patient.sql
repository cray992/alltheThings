/*
alter table zz_import_20100728_patient add rowid int identity(1,1)

insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 126832')

*/


declare @practiceID int, @vendorImportID int
select @practiceID=1, @vendorImportID=1

	--INSERT INTO [dbo].[Patient](
	--	prefix,
	--	Suffix,
	--	MiddleName,
	--	[PracticeID],
	--	[FirstName],
	--	[LastName],
	--	[AddressLine1],
	--	[AddressLine2],
	--	[City],
	--	[State],
	--	[ZipCode],
	--	[HomePhone],
	--	WorkPhone,
	--	WorkPhoneExt,
	--	MobilePhone,
	--	[DOB],
	--	SSN,
	--	[Gender],
	--	[VendorID],
	--	MedicalRecordNumber,
	--	VendorImportID,
	--	CollectionCategoryID,
	--	DefaultServiceLocationID,
	--	PrimaryProviderID,
	--	EmailAddress,
	--	EmploymentStatus,
	--	EmployerID,
	--	MaritalStatus
			
	--	,ResponsibleFirstName,
	--	ResponsibleMiddleName,
	--	ResponsibleLastName,
	--	ResponsibleAddressLine1,
	--	ResponsibleCity,
	--	ResponsibleState,
	--	ResponsibleZipCode
	--	)
	    
	SELECT 
		'' prefix,
		'' as suffix,
		isnull( null, '') as MI,
		@practiceID as practiceID,
		isnull( left([FIRST NAME], 64) , ''),
		isnull( left([LAST NAME], 64) , ''),
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
	from dbo.zz_import_20100728_patient i
	where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=@vendorImportID)
		and [Patient ID] <> 3601
		
	/*	
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
*/