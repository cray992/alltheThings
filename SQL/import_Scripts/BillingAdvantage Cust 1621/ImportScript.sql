
SET ANSI_WARNINGS OFF


set ANSI_NULLS ON
GO

/*

-- drop table Import_Cust1621_PatDemo
CREATE TABLE [dbo].[Import_Cust1621_PatDemo](
	[practicename] [nvarchar](255) NULL,
	[mrn] [nvarchar](255) NULL,
	[firstname] [nvarchar](255) NULL,
	[lastname] [nvarchar](255) NULL,
	SSN nvarchar(255),
	[midinit] [nvarchar](255) NULL,
	[address1] [nvarchar](255) NULL,
	[address2] [nvarchar](255) NULL,
	[city] [nvarchar](255) NULL,
	[state] [nvarchar](255) NULL,
	[zip] [nvarchar](255) NULL,
	[phone] [nvarchar](255) NULL,
	[workPhone] [nvarchar](255) NULL,
	[dob] [nvarchar](255) NULL,
	[gender] [nvarchar](255) NULL,
	[guarFirstName] [nvarchar](255) NULL,
	[guarLastName] [nvarchar](255) NULL,
	[guaraddr1] [nvarchar](255) NULL,
	[guaraddr2] [nvarchar](255) NULL,
	[guarcity] [nvarchar](255) NULL,
	[guarstate] [nvarchar](255) NULL,
	[guarzip] [nvarchar](255) NULL,
	[guargender] [nvarchar](255) NULL,
	[guardob] [nvarchar](255) NULL,
	[rendprov] [nvarchar](255) NULL,
	[location] [nvarchar](255) NULL,
	[practiceID] [int] NULL,
	[serviceLocationID] [int] NULL,
	[primaryProviderID] [int] NULL
) 





update i
SET practiceID=11
from Import_Cust1621_PatDemo i

update i
SET dob=NULL
from Import_Cust1621_PatDemo i
where isDate(dob)=0



update i
SET guardob=NULL
from Import_Cust1621_PatDemo i
where isDate(guardob)=0



update i
SET [state]=NULL
from Import_Cust1621_PatDemo i
where [state]=''


update i
set serviceLocationID=s.ServiceLocationID
from Import_Cust1621_PatDemo i
	inner join serviceLocation s
		on s.name=i.location
		and s.practiceID=i.practiceID
where i.serviceLocationID IS NULL


update i
set primaryProviderID=d.doctorID
from Import_Cust1621_PatDemo i
	inner join doctor d on i.rendProv=d.FirstName + ' ' + d.LastName
		and d.practiceID=i.practiceID
where i.primaryProviderID IS NULL



update Import_Cust1621_PatDemo
SET Gender=NULL
where NOT( GENDER in ('F', 'M'))

update Import_Cust1621_PatDemo
SET SSN=REPLACE(SSN, '-', '')


update Import_Cust1621_PatDemo
SET Phone=REPLACE(Phone, '-', '')
	,WorkPhone=REPLACE(WorkPhone, '-', '')

update Import_Cust1621_PatDemo
SET Phone=REPLACE(Phone, '(', '')
	,WorkPhone=REPLACE(WorkPhone, '(', '')
	
	
update Import_Cust1621_PatDemo
SET Phone=REPLACE(Phone, ')', '')
	,WorkPhone=REPLACE(WorkPhone, ')', '')

*/

BEGIN TRAN

	declare @vendorImportID int

	insert into vendorImport (VendorName,VendorFormat, DateCreated,Notes)
	values(  'Custom Excel', 'Excel', getdate(), 'by Phong Le' )
	set @vendorImportID = @@identity


	INSERT INTO [dbo].[Patient]
		(
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
		[DOB],
		[Gender],
		[ResponsibleDifferentThanPatient],
		[ResponsibleFirstName],
		[ResponsibleLastName],
		[ResponsibleAddressLine1],
		[ResponsibleAddressLine2],
		[ResponsibleCity],
		[ResponsibleState],
		[ResponsibleZipCode],
		[VendorID],
		MedicalRecordNumber,
		VendorImportID,
		CollectionCategoryID,
		DefaultServiceLocationID,
		PrimaryProviderID,
		SSN,
		WorkPhone,
		ResponsibleDifferentThanPatient
		)
	    
	SELECT distinct			
		   '',
		   '',
		   '',
			practiceID,
		   ISNULL([FirstName], ''),
		   ISNULL([LastName], ''),
		   [Address1],
		   [Address2],
		   [City],
		   [State],
		   [Zip],
		   [Phone],
		   [DOB],
		   [Gender],  
		   0,
		   GuarFirstName = [GuarFirstName],
		   GuarLastName = [GuarLastName], 
		   [GuarAddr1],
		   [GuarAddr2],
		   [GuarCity],
		   [GuarState],
		   [GuarZip],
		   [MRN],
		   [MRN],
		   @vendorImportID,
			1,
			serviceLocationID,
			primaryProviderID,
			SSN,
			WorkPhone,
			case when len([GuarFirstName]) > 0 OR len([GuarLastName])>0 then 1 else 0 end
	from Import_Cust1621_PatDemo
	where practiceID IS NOT NULL


	update Patient
	set ResponsibleDifferentThanPatient = 1
	where VendorImportID = @VendorImportID
			and (firstName <> ResponsibleFirstName or ResponsibleLastName <> LastName)





	-- Self Pay
	INSERT INTO [PatientCase]
		([PatientID]
		,[Name]
		,[Active]
		,[PayerScenarioID]
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
	where VendorID is not null




rollback tran
-- COMMIT TRAN

/*



select min(patientID), max(patientID) from patient
where vendorImportID = 1

select count(1) from Import_Cust1621_PatDemo

select  distinct practiceName, rendProv from Import_Cust1621_PatDemo
where primaryProviderID is null and rendProv <> ''


select distinct practiceName, rendProv, d.firstName, d.lastName
from Import_Cust1621_PatDemo i
	inner join doctor d on d.practiceID=i.practiceID
where primaryProviderID is null and rendProv <> ''
order by rendProv, d.firstname


select count(1) from Import_Cust1621_PatDemo
where practiceID IS NULL


select * from serviceLocation
order by Name

begin tran myTran

BEGIN TRY

	       
	SELECT distinct
		   '',
		   '',
		   '',
			1,
		   [FirstName],
		   [LastName],
		   [Address1],
		   [Address2],
		   [City],
		   [State],
		   [Zip],
		   [Phone],
		   [DOB],
		   [Gender],  
		   0,
		   GuarFirstName = case when charindex(',', [GuarName]) > 0 then RIGHT(guarName, len(GuarName) - charindex(',', [GuarName])) else NULL END,
		   GuarLastName = case when charindex(',', [GuarName]) > 0 then left(guarName, charindex(',', [GuarName])-1) else NULL END,
		   [GuarAddr1],
		   [GuarAddr2],
		   [GuarCity],
		   [GuarState],
		   [GuarZip],
		   [MRN],
		   [MRN],
		   @vendorImportID,
			1
	from tempdb.dbo.Prasad_PatientDemoImport





	-- Self Pay
	INSERT INTO [PatientCase]
			   ([PatientID]
			   ,[Name]
			   ,[Active]
			   ,[PayerScenarioID]
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
	1,
	@VendorImportID
	from Patient
	where VendorID is not null







rollback tran



*/