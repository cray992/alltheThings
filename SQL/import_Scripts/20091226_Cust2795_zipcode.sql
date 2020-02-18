



select * from dbo.zzImport_20091225

select * from dbo.zzImport_20091225_archive


sp_rename 'zzImport_20091225', 'zzImport_20091225_archive'
select * from patient 
where patientID=22730

alter table zz_import_20100110_a add rowid int


update n
set rowid=i.rowid
from dbo.zzImport_20091226 i
	inner join zz_import_20100110_a n
		on n.[Patient name]=i.[Patient Name]
		and isnull(n.SSN, '')= isnulL(i.SSN, '')
		and isnull(n.[Medical Record #], '') = isnull(i.[Medical Record #], '')
		and isnull(n.[Home Address 1], '') = isnull(i.[Home Address 1], '')
		and isnull(n.[Date of Birth], '') = isnull(i.[Date of Birth], '')
		and isnull(n.[Home Phone], '') = isnull(i.[Home Phone], '')
		and isnull(n.[Business Phone], '') = isnulL(i.[Business Phone], '')
		and isnull(n.[Home Address 1], '') = isnull(i.[Home Address 1], '')
		and isnull(n.[Home Address 2], '') = isnulL(i.[Home Address 2], '')
		and isnull(n.[Home City], '') = isnull(i.[Home City], '')		and isnull(n.[Business Address 1], '') = isnull(i.[Business Address 1], '')
		and isnull(n.[Business Address 2], '') = isnull(i.[Business Address 2], '')
		and isnull(n.[Business City], '') = isnull(i.[Business City], '')
		and isnull(n.[Secondary Insurance], '') = isnull(i.[Secondary Insurance], '')
		and isnull(n.[Primary Insurance], '') = isnull(i.[Primary Insurance], '')
		and isnull(n.[Comments], '') = isnull(i.[Comments], '')
group by i.[Patient Name]
having count(*)>1







update n
set rowid=i.rowid
from dbo.zzImport_20091226 i
	inner join zz_import_20100110_a n
		on n.[Patient name]=i.[Patient Name]
where i.[Patient Name] in (
	select [Patient Name]
	from zzImport_20091226
	group by [Patient Name]
	having count(1)=1
	)
	and n.rowid is null






select n.[Home Zip/Postal Code], i.[Home Zip/Postal Code], isnull(n.[Home Phone], ''), isnull(i.[Home Phone], ''), *
from dbo.zzImport_20091226 i
	inner join zz_import_20100110_a n
		on n.[Patient name]=i.[Patient Name]
		and isnull(n.SSN, '')= isnulL(i.SSN, '')
		and isnull(n.[Medical Record #], '') = isnull(i.[Medical Record #], '')
		and isnull(n.[Date of Birth], '') = isnull(i.[Date of Birth], '')
/*		and isnull(n.[Home Phone], '') = isnull(i.[Home Phone], '')
		and isnull(n.[Business Phone], '') = isnulL(i.[Business Phone], '')
		and isnull(n.[Home Address 1], '') = isnull(i.[Home Address 1], '')
		and isnull(n.[Home Address 2], '') = isnulL(i.[Home Address 2], '')
		and isnull(n.[Home City], '') = isnull(i.[Home City], '')		and isnull(n.[Business Address 1], '') = isnull(i.[Business Address 1], '')
		and isnull(n.[Business Address 2], '') = isnull(i.[Business Address 2], '')
		and isnull(n.[Business City], '') = isnull(i.[Business City], '')
		and isnull(n.[Secondary Insurance], '') = isnull(i.[Secondary Insurance], '')
		and isnull(n.[Primary Insurance], '') = isnull(i.[Primary Insurance], '')
		and isnull(n.[Comments], '') = isnull(i.[Comments], '')
		*/
where n.[Patient Name]='Desapio, Dominic'



select *
from dbo.zzImport_20091225_archive i
	inner join zz_import_20100110_a n
		on n.[Patient name]=i.[Patient Name]
		and isnull(n.SSN, '')= isnulL(i.SSN, '')
where  i.[Patient Name] = 'Calderon, Ismael'

		
select * from dbo.zz_import_20100110_a
where [Patient Name] = 'Calderon, Ismael'


select * from dbo.zzImport_20091225_archive
where [Patient Name] = 'Calderon, Ismael'

select * from dbo.zz_import_20100110_a
where [Patient Name] = 'Calderon, Ismael'


select  rowid, count(*)
from zz_import_20100110_a
group by rowID
having count(*)>1


select count(*)
from zzImport_20091226

select count(*)
from zz_import_20100110_a
where rowid is null

begin tran

create table zz_import_FizPatientZip_20090110_a( PatientID int, ZipCode varchar(9) )

update p
set ZipCode = replace(a.[Home Zip/Postal Code], '-', '')
output inserted.patientID, inserted.zipcode
into zz_import_FizPatientZip_20090110_a( patientID, zipcode )
from patient p
	inner join zz_import_20100110_a a
		on a.rowid=p.vendorid
where vendorImportID=1
	and isnull ( replace(a.[Home Zip/Postal Code], '-', ''), 0) <> isnull(cast(p.Zipcode as nvarchar(255)), 0)
	and len(replace(a.[Home Zip/Postal Code], '-', ''))=9

commit;

	select * from patient
	where patientID=22730

-- drop table zz_import_20100110_a

select * from zz_import_FizPatientZip_20090110_a (nolock)



select patientID
from patient p
	inner join zz_import_20100110_a a
		on a.rowid=p.vendorid
where vendorImportID=1
	and isnull ( replace(a.[Home Zip/Postal Code], '-', ''), 0) <> isnull(cast(p.Zipcode as nvarchar(255)), 0)
	and len(replace(a.[Home Zip/Postal Code], '-', ''))<>9
	




--- ==========================
-- FIX Insurance


select * from insuranceCompanyPlan
where notes like 'Imported by Kareo%'
	and zipCode = ''
	
select * from insuranceCompanyPlan
where notes like 'Imported by Kareo%'
	and PlanName like '%MCR-PART A&B%'
	
