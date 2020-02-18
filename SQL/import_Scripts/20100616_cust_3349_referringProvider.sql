


alter table zz_import_20100730_referring add rowid int identity(1,1)
alter table zz_import_20100730_referring add firstName varchar(255)
alter table zz_import_20100730_referring add lastName varchar(255)
alter table zz_import_20100730_referring add MiddleName varchar(255)
alter table zz_import_20100730_referring add Degree varchar(255)
alter table zz_import_20100730_referring add TempName varchar(255)

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
			1 as [PracticeID]
           ,'' as [Prefix]
           ,firstName as FirstName
           ,middleName as [MiddleName]
           ,lastName as [LastName]
           ,'' as [Suffix]
           , null as ssn
           ,'' as [AddressLine1]
           ,'' as [AddressLine2]
           ,'' as [City]
           ,'' as [State]
           ,'' as [Country]
           ,'' as [ZipCode]
           ,'Imported by Kareo 6/16/2010' as [Notes]
           ,1 as [ActiveDoctor]
           ,'0000000001' as [TaxonomyCode]
           ,null [DepartmentID]
           ,rowID as [VendorID]
           ,1 as [VendorImportID]
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
           ,degree
from zz_import_20100730_referring z
where not exists(select * from doctor d where d.vendorID=z.rowID and d.vendorImportID=1)


update d
set notes = 'Insurance Code:' + [Column 13]
from doctor d
	inner join zz_import_20100730_referring z
		on z.rowId=vendorId
where vendorImportId=1
	
	
	
	
	
select [Column 10], tempName, *
from dbo.zz_import_20100730_referring z
