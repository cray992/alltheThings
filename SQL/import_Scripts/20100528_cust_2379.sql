select *
from dbo.zz_import_20100528_patientDemo



alter table dbo.zz_import_20100528_patientDemo add dob datetime


alter table dbo.zz_import_20100528_patientDemo add rowid int identity(1,1)

update z
set dob= cast(
		substring( cast( cast([Date of Birth] as int) as varchar(10)) , 5,2) -- mo
			+ '/' + substring( cast( cast([Date of Birth] as int) as varchar(10)) , 7,2) -- day
			+ '/' + substring( cast( cast([Date of Birth] as int) as varchar(10)) , 1,4) -- year
	as datetime)
from zz_import_20100528_patientDemo z
where [Date of Birth] between 19000000 and 99991231

update zz_import_20100528_patientDemo
set [Middle Initial]=''
where [Middle Initial] is null



--==========================================
-- Insert Patient
--==========================================

insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 116842')

select distinct vendorImportID from patient

update zz_import_20100528_patientDemo
set [Marital Status]=null
where [Marital Status]='X'

select * from practice order by 1

select * from vendorImport order by 1




declare @practiceID int, @vendorImportID int
select @practiceID=43, @vendorImportID=4

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
		cast(null as bigint) as [Work Extension],
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
	from dbo.zz_import_20100528_patientDemo i
	where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=@vendorImportID and p.practiceID=@practiceID)
		

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
	where VendorImportID in( 4)
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


delete pj
from [PatientJournalNote] pj
	inner join patient p
		on p.patientID=pj.patientID
where vendorImportID=4


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
	'5/28/2010 9:20 am',
	'Kareo',
	'K',
	0,
	Note =
	    'InsCode1: ' + isnull([Insurance Code 1], '')+char(10)+char(13)
      +'InsGroupNum1: ' + isnull(cast([Insurance Group Number 1] as varchar(32)), '')+char(10)+char(13)
      +'InsInsuredId1: ' + isnull([Insurance Insured ID 1], '')+char(10)+char(13)
      +'InsCode2: ' + isnull([Insurance Code 2], '')+char(10)+char(13)
      +'InsGroupNum2: ' + isnull([Insurance Group Number 2], '')+char(10)+char(13)
      +'InsInsuredId2: ' + isnull( cast([Insurance Insured ID 2] as varchar(255)) , '')+char(10)+char(13)
      +'Provider: ' + isnull( cast([Provider] as varchar(255)) , '')+char(10)+char(13)
      +'ReferringProvider: ' + isnull( cast([Referring Physician] as varchar(255)) , '')+char(10)+char(13)
	,0
	,1
	,0
from patient p
	inner join [zz_import_20100528_patientDemo] z
		on p.vendorID=z.rowID
where vendorImportID=4
