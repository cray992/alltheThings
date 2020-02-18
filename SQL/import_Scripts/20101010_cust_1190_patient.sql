alter table zz_import_20101010_patient add rowId int identity(1,1)




--insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
--values( 'Custom', 'xls', getdate(), 'sf 147162')


-- select * from vendorImport

declare @practiceID int, @vendorImportID int
select @practiceID=29, @vendorImportID=2




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
	--	[HomePhone],
	--	WorkPhone,
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
		left(isnull( [MI], ''), 64) as MI,
		@practiceId as practiceID,
		isnull( left([First Name], 64) , ''),
		isnull( left([Last Name], 64) , ''),
		isnull( left( [street 1], 256), ''),
		isnull( null, '') as addr2,
		left([City], 128) ,
		case when len( ltrim(rtrim([State])) )=2 then ltrim(rtrim([State])) else '' end,
		left(replace( [Zip],'-', ''), 9) as zip,
	--	cast( replace(replace(replace(replace( [Phone 1], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) HomePhone,
	--	cast( replace(replace(replace(replace( [Phone 2], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) WorkPhone,
		null workExt,
		null as MobilePhone, 
		DOB,
		case when len( replace( convert(varchar(max), cast([SS#] as bigint)), '-', '')) =9 then replace( convert(varchar(max), cast([SS#] as bigint)), '-', '') else null end SSN,
		case null
			when 'M' then 'M'
			when 'F' then 'F'
			else null end,  
		rowid as [VendorID], -- vendorID
		left([Chart#], 128) as  MRN,
		@vendorImportID, -- vendorID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		null as Email,
		null as EmploymentStatus,
		null EmployerID,
		null as MaritalStatus
		
		,isnull( null, '') as ResponsibleFirstName,
		null as ResponsibleMiddleName,
		isnull( null, '') as ResponsibleLastName,
		left( isnull( null, ''), 256) as ResponsibleAddressLine1,
		isnull( null, '') as ResponsibleCity,
		rtrim(ltrim( isnull( null, '') )) as ResponsibleState,
		isnull( left(replace(  null,'-', ''), 9), '') as ResponsibleZipCode
	from dbo.zz_import_20101010_patient i
	where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=1)
		and [chart#] is not null





	declare @vendorImportId int
	set @vendorImportId = 2
	
	
update p
set HomePhone = cast( replace(replace(replace(replace( [Phone 1], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) )
from zz_import_20101010_patient z
	inner join patient p
		on p.vendorId=z.rowId
where vendorImportId=2
	and 10 = len( cast( replace(replace(replace(replace( [Phone 1], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) )



update p
set WorkPhone = cast( replace(replace(replace(replace( [Phone 2], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) )
from zz_import_20101010_patient z
	inner join patient p
		on p.vendorId=z.rowId
where vendorImportId=2
	and 10 = len( cast( replace(replace(replace(replace( [Phone 2], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) )

	
	
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


update patient
set firstname=ltrim(rtrim(firstName)),
	lastName = ltrim(rtrim( lastName )),
	MiddleName = ltrim(rtrim( MiddleName )),
	Addressline1 = ltrim(rtrim( Addressline1 )),
	City = ltrim(rtrim( city )),
	State = ltrim(rtrim( state )),
	zipCode = ltrim(rtrim( zipCode )),
	MedicalRecordNumber = ltrim(rtrim( MedicalRecordNumber ))
where vendorImportID=2


update p
set gender = case Left(sex,1)
			when 'M' then 'M'
			when 'F' then 'F'
			else null end
from patient p
	inner join zz_import_20101010_patient z
		on z.rowId=p.vendorId
where vendorImportId=2
