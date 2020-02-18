/*

select top 1000 *
from dbo.zz_import_20100901_patient
where comment3 is not null

alter table dbo.zz_import_20100901_patient add rowid int identity(1,1)

insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 133622')

select * from vendorImport
select * from practice

*/

update zz_import_20100901_patient
set Phone_No= replace(replace(replace(replace( Phone_No, '-', ''), ')', ''), '(', ''), ' ', '')

select * from zz_import_20100901_patient where isdate(DOB)=0

update patient 
set SSN=null
where vendorImportId = 1
	and SSN=000000000
	
	
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
		left( '', 16) as suffix,
		left(isnull( Middle, ''), 64) as MI,
		@practiceID as practiceID,
		isnull( left(fName, 64) , ''),
		isnull( left(LName, 64) , ''),
		isnull( left( Address1, 256), ''),
		isnull( left( null, 256), '') as addr2,
		left([City], 128) ,
		case when len( ltrim(rtrim([State])) )=2 then ltrim(rtrim([State])) else '' end,
		left(replace( Zip,'-', ''), 9) as zip,
		cast( replace(replace(replace(replace( Phone_No, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) HomePhone,
		cast( replace(replace(replace(replace( null, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) WorkPhone,
		null workExt,
		null as MobilePhone, 
		cast( DOB as datetime),
		case when len(replace(SSN, '-', ''))=9 then replace( SSN, '-', '') else null end as SSN,
		case Sex
			when 'M' then 'M'
			when 'F' then 'F'
			else null end,  
		rowid as [VendorID], -- vendorID
		left( nullif( AcctNo, ''), 128)  as  MRN,
		@vendorImportID, -- vendorImportID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		left( null, 256) as Email,
		null as EmploymentStatus,
		null EmployerID,
		null as MaritalStatus
		
		,isnull( G_FName, '') as ResponsibleFirstName,
		G_Middle as ResponsibleMiddleName,
		isnull( G_LName, '') as ResponsibleLastName,
		left( isnull( null, ''), 256) as ResponsibleAddressLine1,
		isnull( null, '') as ResponsibleCity,
		rtrim(ltrim( isnull( null, '') )) as ResponsibleState,
		isnull( left(replace(  null,'-', ''), 9), '') as ResponsibleZipCode
	from dbo.zz_import_20100901_patient i
	where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=@vendorImportID)
		AND isdate(DOB)=1




	declare @vendorImportId int
	set @vendorImportId = 1
	
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





declare @vendorImportId int
set @vendorImportId = 1


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
	getdate() as CreatedDate,
	'Kareo',
	'K',
	0,
	Note = Comment3
	,0
	,1
	,0
from patient p
	inner join dbo.zz_import_20100901_patient z
		on p.vendorID=z.rowID
where vendorImportID=@vendorImportId
	and len(Comment3)>0
	
