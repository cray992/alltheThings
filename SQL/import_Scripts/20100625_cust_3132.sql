
select *
from dbo.zz_import_20100624_advmd




select * from vendorImport

insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 116876, zz_import_20100625_rehana')


alter table zz_import_20100624_advmd add practiceId int

alter table zz_import_20100624_advmd add rowID int identity(1,1)


update z
set practiceId=p.practiceID
from practice p
	inner join zz_import_20100624_advmd z
		on z.practiceName=p.name
		
update z
set practiceID=23
from zz_import_20100624_advmd z
where practiceName='ADELE M ASIMOW PHD'
		
		
update z
set practiceID=36
from zz_import_20100624_advmd z
where practiceName='PATRICIA VANCE PHD'
		
		
update z
set practiceID=28
from zz_import_20100624_advmd z
where practiceName='CYNTHIA POST, PHD'
		
		
update z
set practiceID=24
from zz_import_20100624_advmd z
where practiceName='DR PHILIP L BRILEY'
		
		
update z
set practiceID=25
from zz_import_20100624_advmd z
where practiceName='MARY ANN BLOTZER LCSW'
update z
set practiceID=27
from zz_import_20100624_advmd z
where practiceName='JEAN RATNER LCSWC'
update z
set practiceID=26
from zz_import_20100624_advmd z
where practiceName='DR WILLIAM SHORE'
update z
set practiceID=31
from zz_import_20100624_advmd z
where practiceName='CAROL A BLIMLINE PHD'
update z
set practiceID=21
from zz_import_20100624_advmd z
where practiceName='ALBERT P GALDI MD'
update z
set practiceID=29
from zz_import_20100624_advmd z
where practiceName='RICHARD J. KLIMEK, ED.D'

update z
set practiceID=30
from zz_import_20100624_advmd z
where practiceName='CHARLENE LETCHFORD MD PA AND P MICHAEL P'
		
		
update z
set SSN=null
from zz_import_20100624_advmd z
where ssn=0	
		

declare @vendorImportID int
select @vendorImportID=2

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
		isnull(left(MiddleName,1), '') as MI,
		practiceID,
		isnull( [firstname], ''),
		isnull( [lastname], ''),
		left([Address1], 256),
		left([Address2], 256),
		i.[City],
		case when len([state])>2 then null else [state] end,
		left( cast(cast(replace([ZipCode], '-', '') as bigint) as varchar(32)), 9)as zip,
		cast( replace(replace(replace(replace( null, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneHome,
		cast( replace(replace(replace(replace( null, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneWork,
		cast(null as bigint) as phone_work_ext,
		null as MobilePhone, 
		DOB [Birthdate],
		nullif(replace([ssn], '-', ''), '') SSN,
		[Gender],  
		rowid as [VendorID], -- vendorID
		null as  MRN,
		@vendorImportID, -- vendorID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		null as Email,
		EmploymentStatus = null ,
		null EmployerID,
		null as MaritalStatus
	from dbo.zz_import_20100624_advmd i
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
		'DEFAULT SELF-PAY CASE',
		1,
		11,
		951,
		951,
		practiceID,
		VendorID,
		VendorImportID
	from Patient p
	where VendorImportID = 2
		and not exists(select * from patientCase pc where pc.patientID=p.patientID )





alter table dbo.zz_import_20100625_rehana add practiceId int

alter table dbo.zz_import_20100625_rehana add rowID int identity(1,1)

update zz_import_20100625_rehana
set practiceId=33





declare @vendorImportID int
select @vendorImportID=3

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
		isnull(left(MI,1), '') as MI,
		practiceID as practiceID,
		isnull( FName, ''),
		isnull( LName, ''),
		left([Address1], 256),
		left([Address2], 256),
		i.[City],
		case when len( [state])>2 then null else [state] end,
		left( cast(cast(replace([ZipCode], '-', '') as bigint) as varchar(32)), 9)as zip,
		cast( replace(replace(replace(replace( null, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneHome,
		cast( replace(replace(replace(replace( null, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneWork,
		cast(null as bigint) as phone_work_ext,
		null as MobilePhone, 
		dateOfBirth [Birthdate],
		nullif( case when len(replace([ssn], '-', ''))=9 then replace([ssn], '-', '') else null end, '') SSN,
		sex [Gender],  
		rowid as [VendorID], -- vendorID
		null as  MRN,
		@vendorImportID, -- vendorID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		null as Email,
		EmploymentStatus = null ,
		null EmployerID,
		null as MaritalStatus
	from dbo.zz_import_20100625_rehana i
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
		'DEFAULT SELF-PAY CASE',
		1,
		11,
		951,
		951,
		practiceID,
		VendorID,
		VendorImportID
	from Patient p
	where VendorImportID = 3
		and not exists(select * from patientCase pc where pc.patientID=p.patientID )











select * from vendorImport

insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 116876, zz_import_20100625_boyd')


alter table dbo.zz_import_20100625_boyd add practiceId int

alter table dbo.zz_import_20100625_boyd add rowID int identity(1,1)

update zz_import_20100625_boyd
set practiceId=16

select * from zz_import_20100625_boyd

select * from practice order by name





declare @vendorImportID int
select @vendorImportID=4

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
		isnull(left(MI,1), '') as MI,
		practiceID as practiceID,
		isnull( FName, ''),
		isnull( LName, ''),
		left([Address1], 256),
		left([Address2], 256),
		i.[City],
		case when len( [state])>2 then null else [state] end,
		left( cast(cast(replace([ZipCode], '-', '') as bigint) as varchar(32)), 9)as zip,
		cast( replace(replace(replace(replace( null, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneHome,
		cast( replace(replace(replace(replace( null, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneWork,
		cast(null as bigint) as phone_work_ext,
		null as MobilePhone, 
		dateOfBirth [Birthdate],
		nullif( case when len(replace([ssn], '-', ''))=9 then replace([ssn], '-', '') else null end, '') SSN,
		sex [Gender],  
		rowid as [VendorID], -- vendorID
		null as  MRN,
		@vendorImportID, -- vendorID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		null as Email,
		EmploymentStatus = null ,
		null EmployerID,
		null as MaritalStatus
	from dbo.zz_import_20100625_boyd i
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
		'DEFAULT SELF-PAY CASE',
		1,
		11,
		951,
		951,
		practiceID,
		VendorID,
		VendorImportID
	from Patient p
	where VendorImportID = 4
		and not exists(select * from patientCase pc where pc.patientID=p.patientID )








select * from vendorImport

insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 116876, zz_import_20100625_pritch')


alter table dbo.zz_import_20100625_pritch add practiceId int

alter table dbo.zz_import_20100625_pritch add rowID int identity(1,1)

update zz_import_20100625_pritch
set practiceId=34

select * from zz_import_20100625_pritch

select * from practice order by name


declare @vendorImportID int
select @vendorImportID=5

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
		isnull(left(MI,1), '') as MI,
		practiceID as practiceID,
		isnull( FName, ''),
		isnull( LName, ''),
		left([Address1], 256),
		left([Address2], 256),
		i.[City],
		case when len( [state])>2 then null else [state] end,
		left( cast(cast(replace([ZipCode], '-', '') as bigint) as varchar(32)), 9)as zip,
		cast( replace(replace(replace(replace( null, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneHome,
		cast( replace(replace(replace(replace( null, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneWork,
		cast(null as bigint) as phone_work_ext,
		null as MobilePhone, 
		dateOfBirth [Birthdate],
		nullif( case when len(replace([ssn], '-', ''))=9 then replace([ssn], '-', '') else null end, '') SSN,
		sex [Gender],  
		rowid as [VendorID], -- vendorID
		null as  MRN,
		@vendorImportID, -- vendorID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		null as Email,
		EmploymentStatus = null ,
		null EmployerID,
		null as MaritalStatus
	from dbo.zz_import_20100625_pritch i
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
		'DEFAULT SELF-PAY CASE',
		1,
		11,
		951,
		951,
		practiceID,
		VendorID,
		VendorImportID
	from Patient p
	where VendorImportID = 5
		and not exists(select * from patientCase pc where pc.patientID=p.patientID )




