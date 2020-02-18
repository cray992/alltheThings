


alter table zz_import_20100730_referring add rowid int identity(1,1)
alter table zz_import_20100730_referring add firstName varchar(255)
alter table zz_import_20100730_referring add lastName varchar(255)
alter table zz_import_20100730_referring add MiddleName varchar(255)
alter table zz_import_20100730_referring add Degree varchar(255)
alter table zz_import_20100730_referring add TempName varchar(255)
alter table zz_import_20100730_referring add PracticeId INT



update zz_import_20100730_referring
set TempName=[Column 10]


update z
set Degree= reverse(left(reverse(TempName), charindex(' ', reverse( TempName))))
from dbo.zz_import_20100730_referring z

update z
set TempName=left(TempName, len(TempName)-len(Degree)) 
from zz_import_20100730_referring z


update z
set lastName= reverse(left(reverse(TempName), charindex(' ', reverse( TempName))))
from dbo.zz_import_20100730_referring z

update z
set TempName=left(TempName, len(TempName)-len(lastName)) 
from zz_import_20100730_referring z


update z
set MiddleName= reverse(left(reverse(TempName), charindex(' ', reverse( TempName))))
from dbo.zz_import_20100730_referring z

update z
set TempName=left(TempName, len(TempName)-len(MiddleName)) 
from zz_import_20100730_referring z


update z
set FirstName=TempName
from dbo.zz_import_20100730_referring z

select distinct [Column 2], practiceID
from zz_import_20100730_referring

update z
set practiceId=p.practiceId
from zz_import_20100730_patientMaster_practice p
	inner join zz_import_20100730_referring z
		on p.name=z.[Column 2] 


declare @vendorImportId int
set @vendorImportId = 5
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
			practiceId as [PracticeID]
           ,'' as [Prefix]
           ,firstName as FirstName
           ,LEFT(middleName,1) as [MiddleName]
           ,lastName as [LastName]
           ,'' as [Suffix]
           , null as ssn
           ,'' as [AddressLine1]
           ,'' as [AddressLine2]
           ,'' as [City]
           ,'' as [State]
           ,'' as [Country]
           ,'' as [ZipCode]
           ,'Imported by Kareo 7/31/2010' as [Notes]
           ,1 as [ActiveDoctor]
           ,'0000000001' as [TaxonomyCode]
           ,null [DepartmentID]
           ,rowID as [VendorID]
           ,@vendorImportId as [VendorImportID]
           ,null [FaxNumber]
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
           ,LEFT(degree, 8)
from zz_import_20100730_referring z
where not exists( select * from doctor d where d.vendorID=z.rowID and d.vendorImportID=@vendorImportId)


update d
set notes = 'Insurance Code:' + [Column 13]
from doctor d
	inner join zz_import_20100730_referring z
		on z.rowId=vendorId
where vendorImportId=5
	
	
	
	
	
select [Column 10], tempName, *
from dbo.zz_import_20100730_referring z
