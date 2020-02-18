/*
select *
from dbo.zz_import_20100826_patient

alter table dbo.zz_import_20100826_patient add rowid int identity(1,1)



insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 133002')

select * from vendorImport
select * from practice

*/

update zz_import_20100826_patient
set [homephone]= replace(replace(replace(replace( [homephone], '-', ''), ')', ''), '(', ''), ' ', '')
	,[officephone]=replace(replace(replace(replace( [officephone], '-', ''), ')', ''), '(', ''), ' ', '') 
	,MobilePhone=replace(replace(replace(replace( MobilePhone, '-', ''), ')', ''), '(', ''), ' ', '') 

update zz_import_20100826_patient
set [homephone]= case when isnumeric(left([homephone], 10))=1 then left([homephone], 10) else null end
	,[officephone]=case when isnumeric(left([officephone], 10))=1 then left([officephone], 10) else null end
	,MobilePhone=case when isnumeric(left(MobilePhone, 10))=1 then left(MobilePhone, 10) else null end
	
	select * from zz_import_20100826_patient
	
	
	
	
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
		left(suffix, 16) as suffix,
		left(isnull( middleName, ''), 64) as MI,
		@practiceID as practiceID,
		isnull( left([FirstName], 64) , ''),
		isnull( left([LastName], 64) , ''),
		isnull( left( [ADDRESSline1], 256), ''),
		isnull( left([ADDRESSline2], 256), '') as addr2,
		left([City], 128) ,
		case when len( ltrim(rtrim([State])) )=2 then ltrim(rtrim([State])) else '' end,
		left(replace( [Zipcode],'-', ''), 9) as zip,
		cast( replace(replace(replace(replace( [homephone], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) HomePhone,
		cast( replace(replace(replace(replace( [officephone], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) WorkPhone,
		null workExt,
		MobilePhone as MobilePhone, 
		cast([DateofBirth] as datetime),
		case when len(replace([SocialSecurityNumber], '-', ''))=9 then replace([SocialSecurityNumber], '-', '') else null end as SSN,
		case [gender]
			when 'M' then 'M'
			when 'F' then 'F'
			else null end,  
		rowid as [VendorID], -- vendorID
		left( nullif(PatientIdentifier, ''), 128)  as  MRN,
		@vendorImportID, -- vendorImportID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		left( [Email], 256) as Email,
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
	from dbo.zz_import_20100826_patient i
	where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=@vendorImportID)


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
	Note = Comments
	,0
	,1
	,0
from patient p
	inner join dbo.zz_import_20100826_patient z
		on p.vendorID=z.rowID
where vendorImportID=@vendorImportId
	and len(Comments)>0
	
