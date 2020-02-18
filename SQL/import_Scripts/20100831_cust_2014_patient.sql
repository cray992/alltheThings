/*
select *
from zz_import_20100801_patient

alter table zz_import_20100801_patient add rowid int identity(1,1)



insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 126832')

select * from vendorImport
select * from practice

alter table zz_import_20100801_patient add rowid int identity(1,1)
alter table zz_import_20100801_patient add lastName varchar(50)
alter table zz_import_20100801_patient add firstName varchar(50)

update zz_import_20100801_patient
set lastName =substring( [LAST NAME, FIRST NAME], 1, charindex( ',', [LAST NAME, FIRST NAME])-1 )

update zz_import_20100801_patient
set firstName=substring( [LAST NAME, FIRST NAME], charindex( ',', [LAST NAME, FIRST NAME])+1, 255 )

select [LAST NAME, FIRST NAME], 
	substring( [LAST NAME, FIRST NAME], 1, charindex( ',', [LAST NAME, FIRST NAME])-1 ),
from zz_import_20100801_patient

select * from zz_import_20100801_patient
*/


declare @practiceID int, @vendorImportID int
select @practiceID=1, @vendorImportID=2

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
		isnull( left([FirstName], 64) , ''),
		isnull( left([LastName], 64) , ''),
		isnull( left( [ADDRESS_1], 256), ''),
		[ADDRESS_2] as addr2,
		left([City], 128) ,
		case when len( ltrim(rtrim([State])) )=2 then ltrim(rtrim([State])) else '' end,
		left(replace( [Zip],'-', ''), 9) as zip,
		cast( replace(replace(replace(replace( [TELE# #], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) HomePhone,
		cast( replace(replace(replace(replace( [TELE# #1], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) WorkPhone,
		null workExt,
		null as MobilePhone, 
		[dob:] ,
		[SS#] SSN,
		case [SEX]
			when 'M' then 'M'
			when 'F' then 'F'
			else null end,  
		rowid as [VendorID], -- vendorID
		[ACT#] as  MRN,
		@vendorImportID, -- vendorID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		[EMAIL ADDRESS:] as Email,
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
	from dbo.zz_import_20100801_patient i
	where not exists(select * from patient p where p.vendorID=i.rowID and p.vendorImportID=@vendorImportID)



	declare @vendorImportId int
	set @vendorImportId = 2
	
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

update p
set firstName=ltrim(rtrim(firstName))
	,lastName=ltrim(rtrim(lastName))
from patient p
where vendorImportId=2
