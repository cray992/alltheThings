


alter table zz_import_20100625_referringProvider add rowid int identity(1,1)
alter table zz_import_20100625_referringProvider add firstName varchar(255)
alter table zz_import_20100625_referringProvider add lastName varchar(255)
alter table zz_import_20100625_referringProvider add MiddleName varchar(255)
alter table zz_import_20100625_referringProvider add Degree varchar(255)
alter table zz_import_20100625_referringProvider add TempName varchar(255)
alter table zz_import_20100625_referringProvider add practiceId int

update z
set practiceId= p.practiceId
from zz_import_20100625_referringProvider z
	inner join zz_import_20100625_master_practice p
		on z.[Column 2]=p.name
where p.practiceID > 0

	
/*

	update zz_import_20100625_referringProvider
	set firstName=null, lastName=null,degree=null, middleName=null, TempName=null
*/

update zz_import_20100625_referringProvider
set TempName=[Column 10]


update z
set Degree= reverse(left(reverse(TempName), charindex(' ', reverse( TempName))))
from dbo.zz_import_20100625_referringProvider z
where len( ltrim(rtrim(reverse(left(reverse(TempName), charindex(' ', reverse( TempName))))) ))=2

update z
set TempName=left(TempName, len(TempName)-len(Degree)) 
from zz_import_20100625_referringProvider z
where Degree is not null


update z
set lastName= reverse(left(reverse(TempName), charindex(' ', reverse( TempName))))
from dbo.zz_import_20100625_referringProvider z

update z
set TempName=left(TempName, len(TempName)-len(lastName)) 
from zz_import_20100625_referringProvider z


update z
set MiddleName= reverse(left(reverse(TempName), charindex(' ', reverse( TempName))))
from dbo.zz_import_20100625_referringProvider z

update z
set TempName=left(TempName, len(TempName)-len(MiddleName)) 
from zz_import_20100625_referringProvider z


update z
set FirstName=TempName
from dbo.zz_import_20100625_referringProvider z



declare @vendorImportId int
set @vendorImportId=3

INSERT INTO [dbo].[Doctor]
           ([PracticeID]
           ,[Prefix]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[SSN]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[Country]
           ,[ZipCode]
           ,[Notes]
           ,[ActiveDoctor]
           ,[TaxonomyCode]
           ,[DepartmentID]
           ,[VendorID]
           ,[VendorImportID]
           ,WorkPhone
           ,[FaxNumber]
           ,[FaxNumberExt]
           ,[OrigReferringPhysicianID]
           ,[External]
           ,[NPI]
           ,[ProviderTypeID]
           ,[ProviderPerformanceReportActive]
           ,[ProviderPerformanceScope]
           ,[ProviderPerformanceFrequency]
           ,[ProviderPerformanceDelay]
           ,[ProviderPerformanceCarbonCopyEmailRecipients]
           ,Degree
     )
select
			[PracticeID]
           ,'' as [Prefix]
           ,ltrim(rtrim(firstName)) as FirstName
           ,ltrim(rtrim(middleName)) as [MiddleName]
           ,ltrim(rtrim(lastName)) as [LastName]
           ,'' as [Suffix]
           , null as ssn
           ,'' as [AddressLine1]
           ,'' as [AddressLine2]
           ,'' as [City]
           ,'' as [State]
           ,'' as [Country]
           ,'' as [ZipCode]
           ,'Imported by Kareo 6/25/2010' as [Notes]
           ,1 as [ActiveDoctor]
           ,'0000000001' as [TaxonomyCode]
           ,null [DepartmentID]
           ,min(rowID) as [VendorID]
           ,@vendorImportId as [VendorImportID]
           ,case when len(replace(replace(replace(replace([Column 11], '-', ''), ')', ''), '(', ''), ' ', '') ) > 10 then null else cast( replace(replace(replace(replace([Column 11], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) end [workNumber]
           ,case when len(replace(replace(replace(replace([Column 12], '-', ''), ')', ''), '(', ''), ' ', '') ) > 10 then null else cast( replace(replace(replace(replace([Column 12], '-', ''), ')', ''), '(', ''), ' ', '')  as varchar(max) ) end [FaxNumber]
           ,null [FaxNumberExt]
           ,null [OrigReferringPhysicianID]
           ,1 as [External]
           ,[Column 14] as [NPI]
           ,1 as [ProviderTypeID]
           ,1 as [ProviderPerformanceReportActive]
           ,1 as [ProviderPerformanceScope]
           ,'D' [ProviderPerformanceFrequency]
           ,2 [ProviderPerformanceDelay]
           ,null [ProviderPerformanceCarbonCopyEmailRecipients]
           ,degree
from zz_import_20100625_referringProvider z
where not exists(select * from doctor d where d.vendorID=z.rowID and d.vendorImportID=@vendorImportId)
	and practiceId is not null
group by [Column 14], [PracticeID], firstName, middleName, lastName, [Column 11], [Column 12], degree
GO



declare @vendorImport int
set @vendorImport=3

update d
set notes = cast(
'Provider''s Name:' + [Column 10] +'
'+ char(10)+char(13) +
'Insurance Code:' + [Column 13]
		as text )
from doctor d
	inner join zz_import_20100625_referringProvider z
		on z.rowId=vendorId
where vendorImportId=@vendorImport




INSERT INTO [dbo].[ClaimSettings](
	[DoctorID]
   ,[ClaimSettingsTaxIDTypeID]
   ,[ClaimSettingsNPITypeID]
   ,[ShowAdvancedSettings]
   ,[EligibilityOverride]
   ,[EligibilityNPITypeID]
   ,[EligibilityTaxIDTypeID]
           )
select [DoctorID]
   ,1 [ClaimSettingsTaxIDTypeID]
   ,1 [ClaimSettingsNPITypeID]
   ,0 [ShowAdvancedSettings]
   ,0 [EligibilityOverride]
   ,1 [EligibilityNPITypeID]
   ,1 [EligibilityTaxIDTypeID]
from doctor d
where vendorImportId=3
	and not exists (select * from [ClaimSettings] cs
		where cs.doctorId=d.doctorId
	)
	
	
	/*
		delete cs
		from claimSettings cs
		where doctorId in (
			select doctorId from doctor where vendorImportId=3
		)

		delete from doctor where vendorImportId=3
	*/

select [Column 10], tempName, firstName, lastName, Degree, middleName, *
from dbo.zz_import_20100625_referringProvider z