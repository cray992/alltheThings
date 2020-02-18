
select *
from dbo.zz_import_20100609_patient


alter table zz_import_20100609_patient add rowid int identity(1,1)
alter table zz_import_20100609_patient add firstName varchar(255)
alter table zz_import_20100609_patient add lastName varchar(255)
alter table zz_import_20100609_patient add middle varchar(255)
alter table zz_import_20100609_patient add suffix varchar(255)

update z
set lastname= substring(Patient,0,charindex(',',patient))
from dbo.zz_import_20100609_patient z


update z
set lastname= ltrim(rtrim(lastName))
from dbo.zz_import_20100609_patient z

update z
set firstName=replace(patient, lastName+',', '')
from dbo.zz_import_20100609_patient z


update z
set firstName=left(replace(patient, lastName+',', ''), charindex(' ', replace(patient, lastName+',', '')))
from dbo.zz_import_20100609_patient z

update z
set middle= 
	case when charindex(' ', reverse(firstname) )= 2 
		then right(firstname, 1)
		else '' 
		end
from dbo.zz_import_20100609_patient z




select * from vendorImport

insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 116876')



declare @practiceID int, @vendorImportID int
select @practiceID=15, @vendorImportID=1

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
		case when len([st])>2 then null else [st] end,
		left( cast(cast(replace([ZipCode], '-', '') as bigint) as varchar(32)), 9)as zip,
		cast( replace(replace(replace(replace([Home Phone], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneHome,
		cast( replace(replace(replace(replace([Office Phone], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneWork,
		cast(null as bigint) as phone_work_ext,
		null as MobilePhone, 
		null [Birthdate],
		nullif(replace([ssn], '-', ''), '') SSN,
		[Gender],  
		rowid as [VendorID], -- vendorID
		[Patient] as  MRN,
		@vendorImportID, -- vendorID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		null as Email,
		EmploymentStatus = null ,
		null EmployerID,
		null as MaritalStatus
	from dbo.zz_import_20100609_patient i
	where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=@vendorImportID)
		
		


update p
set dob=[Birthdate]
from patient p
	inner join zz_import_20100609_patient z
		on z.rowID=p.vendorId
where vendorImportId=1
	and dob is null



update p
set firstName= substring(firstName, 0, len(firstName)-1)
from patient p
where vendorImportID=1
	and len(middleName)>0
		
		
		
		
		

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




