
-- 13	BRADLEY S. KURGIS, DO
select * from practice order by name




select * from dbo.zz_PatientDemo_Prac13



SET ANSI_WARNINGS OFF


set ANSI_NULLS ON
GO

/*
alter table zz_PatientDemo_Prac13 add practiceID INT

alter table zz_PatientDemo_Prac13 add serviceLocationID INT

alter table zz_PatientDemo_Prac13 add practiceID INT

alter table zz_PatientDemo_Prac13 add primaryProviderID INT


update i
SET practiceID=13
from zz_PatientDemo_Prac13 i


update i
SET dob=NULL
from zz_PatientDemo_Prac13 i
where isDate(dob)=0



update i
SET [state]=NULL
from zz_PatientDemo_Prac13 i
where [state]=''


update i
set serviceLocationID=16
from zz_PatientDemo_Prac13 i


update i
set primaryProviderID=1775
from zz_PatientDemo_Prac13 i

select * from doctor where practiceID=13

select * from vendorImport order by 1


	declare @vendorImportID int

	insert into vendorImport (VendorName,VendorFormat, DateCreated,Notes)
	values(  'Custom Excel', 'Excel', getdate(), 'by Phong Le sf 87041' )
	set @vendorImportID = @@identity


*/

BEGIN TRAN


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
		EmailAddress
		)
	    
	SELECT 
		   '',
		   '',
		   isnull(MiddleName, ''),
			practiceID,
		   isnull([FirstName], ''),
		   isnull([LastName], ''),
		   [Address1],
		   [Address2],
		   [City],
		   [State],
		   [Zip],
		   replace(replace(replace(replace([HomePhone], '-', ''), '(', ''), ')', ''), ' ', ''),
			replace(replace(replace(replace(WorkPhone, '-', ''), '(', ''), ')', ''), ' ', ''),
			WorkPhoneExt,
		   [DOB],
			replace(SSN, '-', '') SSN,
		   [Gender],  
		   MRN, -- vendorID
			MRN,
		   19, -- vendorID
			1,
			serviceLocationID,
			primaryProviderID,
			Email
	from zz_PatientDemo_Prac13



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
	where VendorImportID = 19

-- COMMIT TRAN
-- 22391
select count(*) from patient where VendorImportID = 19



GO


alter table dbo.zz_Kurgis_Commercial_Fee_Schedule add procedureCodeDictionaryID int
alter table dbo.zz_Kurgis_Medicare_Fee_Schedule add procedureCodeDictionaryID int

update zz_Kurgis_Commercial_Fee_Schedule

update i
set procedureCodeDictionaryID = pcd.procedureCodeDictionaryID
from dbo.zz_Kurgis_Commercial_Fee_Schedule i
	left join procedureCodeDictionary pcd 
		on pcd.procedureCode=cast(i.code as varchar(max))

update i
set procedureCodeDictionaryID = pcd.procedureCodeDictionaryID
from dbo.zz_Kurgis_Medicare_Fee_Schedule i
	left join procedureCodeDictionary pcd 
		on pcd.procedureCode=cast(i.code as varchar(max))

select top 50 * from ContractFeeSchedule


-- MEDICARE = 15
begin tran

INSERT INTO ContractFeeSchedule(ContractID, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID, practiceRVU, malpracticeRVU, VendorImportID )
SELECT 15, 'B', Fee, 0, 0, 0, ProcedureCodeDictionaryID, 0, 0, 19
FROM zz_Kurgis_Medicare_Fee_Schedule
-- rollback tran
--commit tran


-- GENERAL FEE SCHEDULE = 16
INSERT INTO ContractFeeSchedule(ContractID, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID, practiceRVU, malpracticeRVU, VendorImportID )
SELECT 16, 'B', Fee, 0, 0, 0, ProcedureCodeDictionaryID, 0, 0, 19
FROM zz_Kurgis_Commercial_Fee_Schedule
