
use superbill_0524_dev
go


select * from vendorimport

select * from practice

select * from impMWPHY

select * from impMWRPH

select count( distinct casenumber ) from impMWCAS

select count(*) from impMWPAT

select * from patient where isnull( vendorimportid , 0 ) = 0

select count(*) from patient where vendorimportid = 39
select count(*) from insurancepolicy where vendorimportid = 39

select * from insurancepolicy where vendorimportid = 39
        and isnull( policynumber , '' ) = '' and isnull( groupnumber , '' ) = ''

select * from vendorimport order by vendorimportid desc
declare @vendorimportid int
select @vendorimportid = 39
update patient set referringphysicianid = null where vendorimportid = @vendorimportid
update patient set PrimaryProviderID = null where vendorimportid = @vendorimportid
delete N
	from patientjournalnote N
			inner join patient P On N.PatientID = P.PatientID
	where P.vendorimportid = @vendorimportid
delete from insurancepolicy where vendorimportid = @vendorimportid
delete from patientcase where vendorimportid = @vendorimportid
delete from patient where vendorimportid = @vendorimportid
delete from doctor where vendorimportid = @vendorimportid
delete from insurancecompanyplan where vendorimportid = @vendorimportid
delete from insurancecompany where vendorimportid = @vendorimportid
delete from vendorimport where vendorimportid = @vendorimportid
dbcc checkident( 'vendorimport' , 'RESEED' , 5 )

select * from impMWPHY

select * from practice

select * from doctor where practiceid = 1

select * from practice

-- Original : DRPEN
update doctor
    set [external] = 0
        , vendorid = 'PENIR'
    where doctorid = 3

select * from impMWPHY

drop table #tmp1

select distinct referringprovider into #tmp1
    from impMWCAS
    where isnull( referringprovider , '' ) <> ''

select vendorid , vendorimportid , [external] , * from doctor where practiceid = 2

select * from impMWPHY
select * from impMWRPH

select A.referringprovider
        , B.firstname
        , B.lastname
    from #tmp1 A
            left outer join impMWRPH B on A.referringprovider = B.code

select A.chartnumber , A.casenumber , A.referringprovider , B.patienttype
    from impMWCAS A
            inner join impMWPAT B on A.chartnumber = B.chartnumber
    where isnull( A.referringprovider , '' ) = 'CRAIG'

select * from impMWINS where isnull( code , '' ) = ''

select * from impMWPAT where patienttype = 'Patient'

select distinct employmentstatus from impMWPAT

-- RE-RUN
select * from vendorimport order by vendorimportid desc
declare @vendorimportid int
select @vendorimportid = 7
update patient set referringphysicianid = null where vendorimportid = @vendorimportid
update patient set PrimaryProviderID = null where vendorimportid = @vendorimportid
delete N
	from patientjournalnote N
			inner join patient P On N.PatientID = P.PatientID
	where P.vendorimportid = @vendorimportid
delete from insurancepolicy where vendorimportid = @vendorimportid
delete from patientcase where vendorimportid = @vendorimportid
delete from patient where vendorimportid = @vendorimportid
delete from doctor where vendorimportid = @vendorimportid
delete from insurancecompanyplan where vendorimportid = @vendorimportid
delete from insurancecompany where vendorimportid = @vendorimportid
delete from vendorimport where vendorimportid = @vendorimportid
dbcc checkident( 'vendorimport' , 'RESEED' , 5 )

select firstname , lastname , employmentstatus
    from patient
    where vendorimportid = 6
            and employmentstatus = 'R'

select * from iPatient where employmentstatus = 'Retired'

select UPIN , * from impMWRPH

-- delete from providernumber where providernumberid = 5
select * from providernumber
select * from doctor 

select * from vendorimport order by vendorimportid desc

select *
    from patient
    where medicalrecordnumber = 'ALLCH000'

select A.*
    from insurancepolicy A
    where A.vendorimportid = 6
            and A.precedence = 1

select A.*
    from insurancecompany A
    where A.vendorid = 'BLU06'

select A.*
    from insurancecompanyplan A
    where A.vendorid = 'BLU06'

select * from vendorimport order by vendorimportid desc

select A.patientcaseid into #tmp2
    from insurancepolicy A
    where A.vendorimportid = 6
            and A.precedence = 1
    group by A.patientcaseid having count(*) > 1
    order by A.patientcaseid

select A.*
    from insurancepolicy A
            inner join #tmp2 B on A.patientcaseid = B.patientcaseid
    where A.vendorimportid = 6
            and A.precedence = 1
    order by A.patientcaseid

select vendorid
    from patient
    group by vendorid having count(*) > 1

select * from vendorimport order by vendorimportid desc

-- =======================
alter table insurancepolicy
    add RowNumber Int Identity(1,1)

select * from insurancepolicy A
    where A.insurancepolicyid >
        ( Select Min( insurancepolicyid ) from insurancepolicy B Where A.patientcaseid = B.patientcaseid )
        and A.vendorimportid = 7
        and A.precedence = 2

delete A from insurancepolicy A
    where A.insurancepolicyid >
        ( Select Min( insurancepolicyid ) from insurancepolicy B Where A.patientcaseid = B.patientcaseid )
        and A.vendorimportid = 7
        and A.precedence = 2
-- =========================

select * from insurancecompany where vendorimportid = 99
delete from insurancecompany where vendorimportid = 99

select * from insurancecompanyplan where vendorimportid = 99
delete from insurancecompany where vendorimportid = 99

drop table impMWCAS13830

select * from impMWINS13830

select [external] , doctorid , lastname , firstname 
    from doctor
    where practiceid = 2

select * from providernumber

-- delete from providernumber where providernumberid in ( 7 , 8 )

select * from impMWPAT where chartnumber = 'REIMI000'

select * from impMWPAT where patienttype = 'Guarantor'

use superbill_0524_prod
go

select * from vendorimport

select * from practice

select * from patient where practiceid = 2

select * from doctor where practiceid = 2

select * from iPatient
select * from iPatientCase
select * from iDoctor
select * from iRefPhy
select * from iInsCompany

select * from doctor where practiceid = 2
