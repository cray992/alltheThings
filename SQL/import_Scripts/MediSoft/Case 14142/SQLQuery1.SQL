
select * from superbill_shared.dbo.customer

use superbill_0720_dev

select * from practice

select * from patient

select * from doctor

select * from impMWPHY14142

select * from impMWRPH14142

select * from doctor
select * from iDoctor
select * from iRefPhy

select distinct * into #tmp1 from iRefPhy
truncate table impMWRPH14142
insert into impMWRPH14142
select * from #tmp1

select distinct referringprovider from iPatientCase where isnull( referringprovider , '' ) <> ''

usp_columns impMWPHY14142

select * from vendorimport order by vendorimportid desc

usp_DeleteImport 2

select object_name( object_id ) , * from sys.columns 
    where object_name( object_id ) = 'employers'


select * from vendorimport order by vendorimportid desc

select count(*) from iPatient

select count(*) 
    from iPatient A
    where A.patienttype <> 'Guarantor'
            and not exists
            ( select * from patient B
                where isnull( B.vendorimportid , 0 ) = 0
                        and A.firstname = B.firstname
                        and A.lastname = B.lastname )

select A.*
    from iPatient A
    where A.patienttype <> 'Guarantor'
            and exists
            ( select * from patient B
                where isnull( B.vendorimportid , 0 ) = 0
                        and A.firstname = B.firstname
                        and A.lastname = B.lastname )

select * from patient where isnull( vendorimportid , 0 ) = 0

select chartnumber , max( casenumber ) as casenumber into #tmp1
    from ipatientcase
    group by chartnumber

select distinct A.chartnumber , A.referringprovider
    from ipatientcase A
            inner join #tmp1 B on A.chartnumber = B.chartnumber and A.casenumber = B.casenumber
            inner join iPatient C on A.chartnumber = C.chartnumber and B.chartnumber = C.chartnumber
            inner join patient D on A.chartnumber = D.vendorid
    where isnull( A.referringprovider , '' ) <> ''
            and C.patienttype <> 'Guarantor'

select A.chartnumber , A.referringprovider
    from ipatientcase A
            inner join #tmp1 B on A.chartnumber = B.chartnumber and A.casenumber = B.casenumber
            inner join patient C on A.chartnumber = C.vendorid
    where isnull( A.referringprovider , '' ) <> ''
            and A.referringprovider = 'BEA00'

select * from doctor

select distinct C.chartnumber , D.referringprovider
    from iPatient A
          -- inner join Patient B on A.chartnumber = B.vendorid
          inner join #tmp1 C on A.chartnumber = C.chartnumber -- and C.chartnumber = B.vendorid
          inner join iPatientCase D on C.chartnumber = D.chartnumber and C.casenumber = D.casenumber
    where -- B.vendorimportid = 3
            A.patienttype <> 'Guarantor'
            and Isnull( D.referringprovider , '' ) <> ''
            -- and D.referringprovider = 'AKR00'

select count(*) from patient
    where vendorimportid = 3
            and isnull( referringphysicianid , 0 ) <> 0

select distinct B.vendorid , B.doctorid
    from patient A
            inner join doctor B on A.referringphysicianid = B.doctorid
    where A.vendorimportid = 3

select count(*) from patient where referringphysicianid = 1 and vendorimportid = 3
select count(*) from patient where referringphysicianid = 6 and vendorimportid = 3

select distinct A.chartnumber , A.referringprovider into #tmp2
    from iPatientCase A
            inner join ipatient B on A.chartnumber = B.chartnumber
            inner join patient C on A.chartnumber = C.vendorid
    Where IsNull( A.ReferringProvider , '' ) <> ''
            and B.patienttype <> 'Guarantor'
            

select A.chartnumber , count(*)
    from #tmp2 A
    group by A.chartnumber having count(*) > 1

select * from #tmp2 where chartnumber in ( '00000167' )

usp_columns 'impMWCAS14142'

usp_deleteimport 3

select vendorid , lastname , firstname
    from patient
    where vendorimportid = 4
    order by lastname , firstname

select vendorid , vendorimportid , lastname , firstname
    from patient
    where lastname = 'SMITH'
            and firstname like 'CHRI%'
    order by lastname , firstname

drop table #tmp1

select lastname , firstname , count(*) as c1 into #tmp1
    from impMWPAT14142
    group by lastname, firstname having count(*) > 1

select * from #tmp1 order by lastname , firstname

select A.vendorid , A.vendorimportid , A.lastname , A.firstname , B.lastname , B.firstname
    from patient A
            inner join #tmp1 B on A.lastname = B.lastname and A.firstname = B.firstname
    where isnull( vendorimpo
    order by A.lastname , A.firstname

