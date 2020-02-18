use superbill_2039_prod
go



select *
from practice

select *
into zzPatient_20091227
from zzPatient_20091228

update dbo.zzPatient_20091228
set [UNIQUE PATIENT ID]=nullif( [UNIQUE PATIENT ID], '')
,[PATIENT NAME_FIRST NAME]=nullif( [PATIENT NAME_FIRST NAME], '')
,[PATIENT NAME_LAST NAME]=nullif( [PATIENT NAME_LAST NAME], '')
,[GENDER]=nullif( [GENDER], 'GENDER')
,[DATE OF BIRTH]=nullif( [DATE OF BIRTH], '')
,[PATIENT ADDRESS_LINE 1]=nullif( [PATIENT ADDRESS_LINE 1], '')
,[PATIENT ADDRESS_CITY]=nullif( [PATIENT ADDRESS_CITY], '')
,[PATIENT ADDRESS_STATE]=nullif( [PATIENT ADDRESS_STATE], '')
,[PATIENT ADDRESS_ZIPCODE]=nullif( [PATIENT ADDRESS_ZIPCODE], '')
,[HOME PHONE]=nullif( [HOME PHONE], '')



insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 99905, by Phong ')

select * from vendorImport

alter table zzPatient_20091228 add rowid int identity(1,1) primary key clustered



begin tran

declare @practiceID int, @vendorImportID int
select @practiceID=16, @vendorImportID=22

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
		'' as MI,
		@practiceID as practiceID,
		isnull([PATIENT NAME_FIRST NAME], ''),
		isnull([PATIENT NAME_LAST NAME], ''),
		left([PATIENT ADDRESS_LINE 1], 256),
		null as addr2,
		i.[PATIENT ADDRESS_CITY],
		left([PATIENT ADDRESS_STATE], 2),
		left([PATIENT ADDRESS_ZIPCODE], 9),
		replace(replace(replace(replace([HOME PHONE], '-', ''), '(', ''), ')', ''), ' ', ''),
		null as workphone,
		NULL,
		[DATE OF BIRTH],
		null SSN,
		[GENDER],  
		rowID as MRN, -- vendorID
		[UNIQUE PATIENT ID] as  MRN,
		@VendorImportID, -- vendorImportID
		1,
		null serviceLocationID,
		null primaryProviderID,
		NULL as Email,
		null as EmploymentStatus,
		null as EmployerID,
		null MaritalStatus
	from dbo.zzPatient_20091228 i
	where [UNIQUE PATIENT ID] is not null

	
	-- Self Pay
	INSERT INTO [PatientCase]
		([PatientID]
		,[Name]
		,[Active]
		,[PayerScenarioID] -- select * from payerScenario
		,[CreatedUserID]
		,[ModifiedUserID]
		,[PracticeID]
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
		@VendorImportID
	from Patient
	where VendorImportID = @VendorImportID

		
		
			
	-- commit;
	-- rollback tran
