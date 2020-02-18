

select *
from dbo.zz_import_20100910_phyRef



alter table zz_import_20100910_phyRef add rowid int identity(1,1)
alter table zz_import_20100910_phyRef add firstName varchar(255)
alter table zz_import_20100910_phyRef add lastName varchar(255)
alter table zz_import_20100910_phyRef add MiddleName varchar(255)
alter table zz_import_20100910_phyRef add Degree varchar(255)
alter table zz_import_20100910_phyRef add TempName varchar(255)
alter table zz_import_20100910_phyRef add PracticeId INT



update zz_import_20100910_phyRef
set TempName=Referral_Source

update z
set FirstName=left(TempName, charindex(' ', TempName))
from dbo.zz_import_20100910_phyRef z

update z
set TempName=right(TempName, len(TempName)-len(FirstName)) 
from zz_import_20100910_phyRef z



update z
set lastName= left(TempName, charindex(',', TempName)-1)
from dbo.zz_import_20100910_phyRef z
where charindex(',', TempName) > 0

update z
set lastName= TempName
from dbo.zz_import_20100910_phyRef z
where charindex(',', TempName) = 0


update z
set TempName=right(TempName, len(TempName)-len(lastName)) 
from zz_import_20100910_phyRef z


update z
set Degree=replace(TempName, ',', '')
from dbo.zz_import_20100910_phyRef z


update z
set Degree=null
from dbo.zz_import_20100910_phyRef z


update z
set Degree=rtrim(ltrim(Degree))
	,FirstName=rtrim(ltrim(FirstName))
	,LastName=rtrim(ltrim(lastName))
from  zz_import_20100910_phyRef z



update z
set practiceId=1
from  zz_import_20100910_phyRef z


update zz_import_20100910_phyRef
set Phone= replace(replace(replace(replace( Phone, '-', ''), ')', ''), '(', ''), ' ', '')

update zz_import_20100910_phyRef
set Fax_Number= replace(replace(replace(replace( Fax_Number, '-', ''), ')', ''), '(', ''), ' ', '')



insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 140869')

declare @vendorImportId int
set @vendorImportId = 2
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
           ,WorkPhone
     )
     
select
			practiceId as [PracticeID]
           ,'' as [Prefix]
           ,firstName as FirstName
           ,'' as [MiddleName]
           ,lastName as [LastName]
           ,'' as [Suffix]
           , null as ssn
           ,'' as [AddressLine1]
           ,'' as [AddressLine2]
           ,'' as [City]
           ,'' as [State]
           ,'' as [Country]
           ,'' as [ZipCode]
           ,'Imported by Kareo 9/10/2010' as [Notes]
           ,1 as [ActiveDoctor]
           ,'0000000001' as [TaxonomyCode]
           ,null [DepartmentID]
           ,rowID as [VendorID]
           ,@vendorImportId as [VendorImportID]
           ,Fax_Number [FaxNumber]
           ,null [FaxNumberExt]
           ,null [OrigReferringPhysicianID]
           ,1 as [External]
           ,NPI as [NPI]
           ,1 as [ProviderTypeID]
           ,1 as [ProviderPerformanceReportActive]
           ,1 as [ProviderPerformanceScope]
           ,'D' [ProviderPerformanceFrequency]
           ,2 [ProviderPerformanceDelay]
           ,null [ProviderPerformanceCarbonCopyEmailRecipients]
           ,LEFT(degree, 8)
           ,Phone as WorkPhone
from zz_import_20100910_phyRef z
where not exists( select * from doctor d where d.vendorID=z.rowID and d.vendorImportID=@vendorImportId)


update d
set notes = 'Kareo Import: ' + cast(getdate() as varchar) + '
' + 'Referral_Address: ' + Referral_Address + '
' + 'UPIN: ' + UPIN
from doctor d
	inner join zz_import_20100910_phyRef z
		on z.rowId=vendorId
where vendorImportId=2
	
