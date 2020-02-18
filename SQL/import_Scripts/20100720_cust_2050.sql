

/*
SELECT 
		15 as practiceId
		,[Practice]
      ,[code]
      ,[title]
      ,[firstname]
      ,[middle]
      ,[lastname]
      ,[sex]
      ,[status]
      ,[emp_stat]
      ,[birthdate]
      ,[ss]
      ,[address1]
      ,[address2]
      ,[city]
      ,[state]
      ,[zip]
      ,[phone_home]
      ,[phone]
      ,[email]
into zz_import_20100710_patient_master
  FROM [dbo].[zz_Import_20100710_patient_Advanced Vein Center (15)]

union all

SELECT 
		8 as practiceName
		,[Practice]
      ,[code]
      ,[title]
      ,[firstname]
      ,[middle]
      ,[lastname]
      ,[sex]
      ,[status]
      ,[emp_stat]
      ,[birthdate]
      ,[ss]
      ,[address1]
      ,[address2]
      ,[city]
      ,[state]
      ,[zip]
      ,[phone_home]
      ,[phone]
      ,[email]
  FROM dbo.[zz_Import_20100710_patient_Albert Vein Institute (8)]
  
  
union all

SELECT 
		13 as practiceName
		,[Practice]
      ,[code]
      ,[title]
      ,[firstname]
      ,[middle]
      ,[lastname]
      ,[sex]
      ,[status]
      ,[emp_stat]
      ,[birthdate]
      ,[ss]
      ,[address1]
      ,[address2]
      ,[city]
      ,[state]
      ,[zip]
      ,[phone_home]
      ,[phone]
      ,[email]
  FROM [zz_Import_20100710_patient_Ciao Bella Med Spa & Vein (13)]
  
  
union all

SELECT 
	14 as practiceName
		,[Practice]
      ,[code]
      ,[title]
      ,[firstname]
      ,[middle]
      ,[lastname]
      ,[sex]
      ,[status]
      ,[emp_stat]
      ,[birthdate]
      ,[ss]
      ,[address1]
      ,[address2]
      ,[city]
      ,[state]
      ,[zip]
      ,[phone_home]
      ,[phone]
      ,[email]
  FROM [zz_Import_20100710_patient_Destin Vein Center (14)]
  
  
union all

SELECT 
		12 as practiceName
		,[Practice]
      ,[code]
      ,[title]
      ,[firstname]
      ,[middle]
      ,[lastname]
      ,[sex]
      ,[status]
      ,[emp_stat]
      ,[birthdate]
      ,[ss]
      ,[address1]
      ,[address2]
      ,[city]
      ,[state]
      ,[zip]
      ,[phone_home]
      ,[phone]
      ,[email]
  FROM dbo.[zz_Import_20100710_patient_Elite Vein Specialists (12)]
  
  
union all

SELECT 
		11 as practiceName
		,[Practice]
      ,[code]
      ,[title]
      ,[firstname]
      ,[middle]
      ,[lastname]
      ,[sex]
      ,[status]
      ,[emp_stat]
      ,[birthdate]
      ,[ss]
      ,[address1]
      ,[address2]
      ,[city]
      ,[state]
      ,[zip]
      ,[phone_home]
      ,[phone]
      ,[email]
  FROM dbo.[zz_Import_20100710_patient_Lawrence P Presant DO PLLC (11)]
  
  -- drop table [zz_Import_20100710_patient_Lawrence P Presant DO PLLC (11)]
union all

SELECT 
		16 as practiceName
		,[Practice]
      ,[code]
      ,[title]
      ,[firstname]
      ,[middle]
      ,[lastname]
      ,[sex]
      ,[status]
      ,[emp_stat]
      ,[birthdate]
      ,[ss]
      ,[address1]
      ,[address2]
      ,[city]
      ,[state]
      ,[zip]
      ,[phone_home]
      ,[phone]
      ,[email]
  FROM dbo.[zz_Import_20100710_patient_The Center for Cosmetic Surg 16]
  
  
union all

SELECT 
		17 as practiceName
		,[Practice]
      ,[code]
      ,[title]
      ,[firstname]
      ,[middle]
      ,[lastname]
      ,[sex]
      ,[status]
      ,[emp_stat]
      ,[birthdate]
      ,[ss]
      ,[address1]
      ,[address2]
      ,[city]
      ,[state]
      ,[zip]
      ,[phone_home]
      ,[phone]
      ,[email]
  FROM dbo.[zz_Import_20100710_patient_The Center for Cosmetic Surg 17]
 */
 
 -- alter table zz_import_20100710_patient_master add rowid int identity(1,1)
 
 
 -- de-dup
select practiceId, lastName, ssn, min(rowid) as rowid
from zz_import_20100710_patient_master
group by  practiceId, lastName, ssn


 
select practiceid, lastName, firstName, ss, count(*)
from dbo.zz_import_20100710_patient_master
group by practiceId, lastName, firstName, ss
having count(*)>1


 
select practiceid, code, count(*)
from dbo.zz_import_20100710_patient_master
group by practiceId, code
having count(*)>1

 
select *
from zz_import_20100710_patient_master
where lastname='DUBYAK'
	and firstname='MICHAEL'
	and practiceID=15

delete zz_import_20100710_patient_master
where rowid=84
 
 
 






insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 123858')



declare  @vendorImportID int
select  @vendorImportID=2

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
		isnull(title,'') as prefix,
		'',
		isnull([Middle], '') as MI,
		practiceId as practiceID,
		isnull( [firstname], ''),
		isnull( [lastname], ''),
		left([Address1], 256),
		left([Address2], 256),
		i.[City],
		case when len( [state])>2 then null else [state] end,
		left( cast(cast(replace(zip, '-', '') as bigint) as varchar(32)), 9)as zip,
		cast( replace(replace(replace(replace(phone_home, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneHome,
		cast( replace(replace(replace(replace(phone, '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) as phoneWork,
		cast(null as bigint) as phone_work_ext,
		null as MobilePhone, 
		birthdate [Birthdate],
		nullif(replace(ss, '-', ''), '') SSN,
		sex,  
		rowid as [VendorID], -- vendorID
		Code as  MRN,
		@vendorImportID, -- vendorID
		1,
		null as serviceLocationID,
		null as primaryProviderID,
		email as Email,
		EmploymentStatus = null ,
		null EmployerID,
		null as MaritalStatus
	from dbo.zz_import_20100710_patient_master i
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
		'DEFAULT',
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





 
 