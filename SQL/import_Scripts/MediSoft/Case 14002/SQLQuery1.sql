
use superbill_0649_prod
go

Use superbill_0649_dev
go

select * from practice

Insert Into Practice
( Name )
Values
( 'Dr. Rajat Prakash' )

select * from iRefPhy

select distinct referringprovider
    from ipatientcase
    where isnull( referringprovider , '' ) <> ''

select * from patient

select * from practice

select * from iPatient

select count(*) from iPatient where patienttype <> 'Guarantor'

select count( distinct A.chartnumber )
    from iPatientCase A
            inner join iPatient B on A.chartnumber = B.chartnumber
    where isnull( referringprovider , '' ) <> ''
            and B.patienttype <> 'Guarantor'

select count(*) from impMWPRO14002

select top 1000 * from iFeeSchedule

select count(*) from iFeeSchedule
    where code1 <> code2

select * from iFeeSchedule
    where code1 <> code2

update iFeeSchedule
    set code1 = code2
    where code1 <> code2
    
select count(*) from iFeeSchedule
    where code2 <> code3

select count(*) from iFeeSchedule
    where code1 = code2 and code2 = code3 and code1 = code3

select * from iFeeSchedule
    where code1 <> code2

select code1 , count(*) 
    from iFeeSchedule
    group by code1
    having count(*) > 1

select code2 , count(*) 
    from iFeeSchedule
    group by code2
    having count(*) > 1

select code3 , count(*) 
    from iFeeSchedule
    group by code3
    having count(*) > 1

select count(*) from iFeeSchedule
    where isnull( defaultmodifier1 , '' ) <> ''
select count(*) from iFeeSchedule
    where isnull( defaultmodifier2 , '' ) <> ''
select count(*) from iFeeSchedule
    where isnull( defaultmodifier3 , '' ) <> ''
select count(*) from iFeeSchedule
    where isnull( defaultmodifier4 , '' ) <> ''

select *
    from iFeeSchedule
    where isnull( defaultmodifier1 , '' ) <> ''

select count(*) from iFeeSchedule
    where isnull( amountA , 0 ) <> 0
select count(*) from iFeeSchedule
    where isnull( amountB , 0 ) <> 0
select count(*) from iFeeSchedule
    where isnull( amountC , 0 ) <> 0
select count(*) from iFeeSchedule
    where isnull( amountD , 0 ) <> 0

select *
    from iFeeSchedule
    where isnull( amountA , 0 ) <> 0

select count(*)
    from iFeeSchedule

select top 100 * from procedurecodedictionary

select Count(*)
    from iFeeSchedule A
            inner join ProcedureCodeDictionary B on A.Code1 = B.ProcedureCode

select A.Code1
        , A.Description
        , B.ProcedureCode
        , B.OfficialName
    from iFeeSchedule A
            left outer join ProcedureCodeDictionary B on A.Code1 = B.ProcedureCode
    where B.ProcedureCode is null
    order by A.Code1

select replace( '11900*' , '*' , '' )

update iFeeSchedule
    set code1 = replace( code1 , '*' , '' )

select code1 , count(*) as count1 into #tmp1
    from iFeeSchedule
    group by code1 having count(*) > 1

-- ==============
-- Delete Duplicate Rows.
alter table impMWPRO14002
    add RowNumber Int Identity(1,1)

select * from iFeeSchedule A
    where A.RowNumber > 
        ( Select Min( RowNumber ) from iFeeSchedule B Where A.Code1 = B.Code1 ) 

delete A from iFeeSchedule A
    where A.RowNumber > 
        ( Select Min( RowNumber ) from iFeeSchedule B Where A.Code1 = B.Code1 ) 
-- ==============

select top 100 * from iFeeSchedule

select A.Code1
        , A.Description
        , A.AmountA
        , A.AmountB
        , A.DefaultModifier1
        , A.DefaultModifier2
        , A.DefaultModifier3
        , A.DefaultModifier4
    from iFeeSchedule A
    where IsNull( AmountA , '0' ) <> '0'
            And IsNull( AmountB , '0' ) <> '0'
            And Convert( Money , AmountB ) >= Convert( Money , AmountA ) 

usp_columns impMWPRO14002
usp_columns ContractFeeSchedule

select distinct DefaultModifier1 As ProcedureCodeModifier from iFeeSchedule where isnull( DefaultModifier1 , '' ) <> ''
select distinct DefaultModifier2 As ProcedureCodeModifier from iFeeSchedule where isnull( DefaultModifier1 , '' ) <> ''
select distinct DefaultModifier3 As ProcedureCodeModifier from iFeeSchedule where isnull( DefaultModifier1 , '' ) <> ''
select distinct DefaultModifier4 As ProcedureCodeModifier from iFeeSchedule where isnull( DefaultModifier1 , '' ) <> ''

select count(*) from iFeeSchedule Where isnull( DefaultModifier1 , '' ) = '62'
select * from ProcedureModifier

select * from iFeeSchedule Where IsNull( AmountZ , '0' ) <> '0'

select * from practice

select * from vendorimport

select * from superbill_shared.dbo.customer

select * from vendorimport

delete from contractfeeschedule where contractid = 2

select * from contract

delete from contract where contractid = 2

dbcc checkident( 'contract' , 'reseed' , 0 )

select * from contract

select * from contractfeeschedule where contractid = 1

usp_columns contractfeeschedule

select * from patient where vendorimportid = 4
select * from patient where isnull( vendorimportid , 0 ) = 0

select * from contractfeeschedule where contractid = 1 and isnull( standardfee , 0 ) > 0 and isnull( allowable , 0 ) > 0

select * from vendorimport

select lastname , firstname from patient where vendorimportid = 4
    order by lastname , firstname

select * from doctor

select lastname , firstname , referringphysicianid
    from patient
    where vendorimportid = 7
            and isnull( referringphysicianid , 0 ) <> 0


select * from iDoctor
select * from doctor

update patient set referringphysicianid = null where vendorimportid = 4 and referringphysicianid = 2
delete from doctor where vendorimportid = 4
delete from patient where vendorimportid = 4

select count(*) from iPatientCase
select count( distinct chartnumber ) from iPatientCase
select chartnumber , max( casenumber ) as casenumber into #tmp1
    from iPatientCase
    group by chartnumber

select distinct A.chartnumber , A.referringprovider
    from iPatientCase A
            inner join iPatient B on A.chartnumber = B.chartnumber
    where isnull( A.referringprovider , '' ) <> ''
            and B.patienttype <> 'Guarantor'


select lastname , firstname , responsiblelastname , responsiblefirstname from patient
    where vendorimportid = 7
            and ResponsibleDifferentThanPatient = 1
    order by lastname , firstname

select * from iPatient
    where patienttype = 'Guarantor'

select A.lastname , A.firstname , A.chartnumber
    from iPatient A
    where A.chartnumber <> A.guarantor

select distinct A.chartnumber
    from iPatientCase A
    where A.chartnumber <> A.guarantor

select * from vendorimport

select * from contract

select * from contractfeeschedule where contractid = 1

select * from vendorimport
