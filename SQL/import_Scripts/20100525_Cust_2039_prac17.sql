
insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 117786')


alter table zz_import_17_patientDemo_20100525 add rowid int identity(1,1)
-- begin tran

select * from vendorImport order by dateCreated

select * from zz_import_17_patientDemo_20100525
where isnumeric( replace(replace(replace(replace([HomePhone], '-', ''), ')', ''), '(', ''), ' ', '')) = 0
	and HomePhone is not null
	
	
	
select * from zz_import_17_patientDemo_20100525
where len( rtrim(ltrim(PatientAddress_State)))>2


update zz_import_17_patientDemo_20100525
set [HomePhone] = left(replace(replace(replace(replace([HomePhone], '-', ''), ')', ''), '(', ''), ' ', ''), 10)
where isnumeric( replace(replace(replace(replace([HomePhone], '-', ''), ')', ''), '(', ''), ' ', '')) = 0
	and HomePhone is not null
	
	
	
declare @practiceID int, @vendorImportID int
select @practiceID=17, @vendorImportID=35

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
		'' prefix,
		'' as suffix,
		isnull( PatientName_MiddleName, '') as MI,
		@practiceID as practiceID,
		isnull( left(PatientName_FirstName, 64) , ''),
		isnull( left(PatientName_LastName, 64) , ''),
		left( PatientAddress_Line1, 256),
		null as addr2,
		left(PatientAddress_City, 128) ,
		rtrim(ltrim( replace(PatientAddress_State, '.', '') )),
		left(replace( PatientAddress_Zip,'-', ''), 9) as zip,
		cast( replace(replace(replace(replace([HomePhone], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) HomePhone,
		null WorkPhone,
		null workExt,
		null as MobilePhone, 
		DateOfBirth ,
		null SSN,
		Gender,  
		rowid as [VendorID], -- vendorID
		null as  MRN,
		@vendorImportID, -- vendorID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		null as Email,
		null as EmploymentStatus,
		null EmployerID,
		null as MaritalStatus
	from dbo.zz_import_17_patientDemo_20100525 i
	where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=@vendorImportID)
		

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
	where VendorImportID in(35)
		and not exists(select * from patientCase pc where pc.patientID=p.patientID )
