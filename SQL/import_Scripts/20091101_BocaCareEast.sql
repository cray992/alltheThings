
/*
-- sp_rename 'Sheet1$', 'zz_import_Bocare_East'

select top 10 * 
from zz_import_Bocare_East
where race is not null


alter table zz_import_Bocare_East add practiceID INT
alter table zz_import_Bocare_East add serviceLocationID INT
alter table zz_import_Bocare_East add primaryProviderID INT
alter table zz_import_Bocare_East add DayOfBirth datetime
alter table zz_import_Bocare_East add EmploymentStatus char(1)
alter table zz_import_Bocare_East add MaritalStatus char(1)

update zz_import_Bocare_East
set practiceID=2

--update zz_import_Bocare_East
--set serviceLocationID=1


update zz_import_Bocare_East
set dayOfBirth = 

	 substring( dob, 1, 2) + '/' +
	 substring( dob, 4, 2) + '/' +
		case when substring( dob, 7, 2) between 00 and 09 
		then '20' + substring( dob, 7, 2)
		else '19' + substring( dob, 7, 2)
		end
		

update zz_import_Bocare_East
set EmploymentStatus = 'E'
where ltrim(rtrim([empl status])) in ('YES', 'E', 'Y' )


update zz_import_Bocare_East
set EmploymentStatus = 'U'
where [Employer Name] IS NOT NULL
	and EmploymentStatus IS NULL

update i
SET MaritalStatus=m.MaritalStatus
FROM zz_import_Bocare_East i
	inner join MaritalStatus m
		on m.MaritalStatus=i.marital

		
update i
SET MaritalStatus='U'
FROM zz_import_Bocare_East i
WHERE MaritalStatus IS NULL
	and Marital IS NOT NULL
*/


begin tran


INSERT INTO [dbo].[Employers] (
	[EmployerName]
	,[AddressLine1]
	,[AddressLine2]
	,[City]
	,[State]
	,[Country]
	,[ZipCode]
	,[CreatedDate]
	,[CreatedUserID]
	,[ModifiedDate]
	,[ModifiedUserID]
)
         
select distinct 
	[Employer Name],
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	getdate(),
	951,
	getdate(),
	951
from zz_import_Bocare_East
where [Employer Name] is not null
	and [Employer Name] not in (select employerName from Employers)

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
		   isnull(MI, ''),
			1 as practiceID,
		   isnull([First Name], ''),
		   isnull([Last Name], ''),
		   left([Addr1], 256),
		   left([Addr2], 256),
		   i.[City],
		   left([ST], 2),
		   left([Zip], 9),
		   replace(replace(replace(replace([Phone], '-', ''), '(', ''), ')', ''), ' ', ''),
			replace(replace(replace(replace([Work Phone], '-', ''), '(', ''), ')', ''), ' ', ''),
			NULL,
		   DayOfBirth,
			replace([SS#], '-', '') SSN,
		   [Sex],  
		   Account as MRN, -- vendorID
			Account as  MRN,
		   20, -- vendorID
			1,
			serviceLocationID,
			primaryProviderID,
			NULL as Email,
			i.EmploymentStatus as EmploymentStatus,
			e.EmployerID,
			i.MaritalStatus
	from zz_import_Bocare_East i
		LEFT JOIN  [Employers] e
			on e.EmployerName=i.[Employer Name]
		
	
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
		VendorImportID
	from Patient
	where VendorImportID = 20

		
		
			
	commit;
rollback tran