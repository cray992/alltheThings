
use superbill_0875_prod
go

select * from practice

select top 100 * from impPatient15935

alter table 

select max( len( [column 6] ) ) from impPatient15935

select dob 
        , case when ltrim( rtrim( dob ) ) <> '' then convert( datetime , left( dob , 2 ) + '/' + substring(dob,3,2) + '/' + right(dob,4) )  end
    from impPatient15935

select top 1 dob from impPatient15935

select distinct [column 10] from impPatient15935

select distinct [column 11] from impPatient15935

select max( len( ssn ) ) from impPatient15935


select top 200 * from impPatient15935

select * from impPatient15935 where isnull( [Column 48] , '' ) <> '' or isnull( [Column 49] , '' ) <> '' or isnull( [Column 50] , '' ) <> '' or isnull( [Column 51] , '' ) <> '' or isnull( [Column 52] , '' ) <> '' or isnull( [Column 53] , '' ) <> ''

select * from impPatient15935

select * from impPatient15935 where isnull( ssn , '' ) = '000000000'

select * from impPatient15935 where isnull( [Column 20] , '' ) <> ''

select * from impResponsible15935

select * from impResponsible15935 where isnull( [Column 12] , '' ) <> '0'

select count(*) from impPatient15935
select count(*) from impResponsible15935

select distinct A.AccountNo
        , A.LastName As PatientLastName
        , A.FirstName As PatientFirstName
        , A.SSN
        , B.LastName
        , B.FirstName
        , B.SSN
    from impPatient15935 A
            inner join impResponsible15935 B On B.AccountNo = A.AccountNo
    -- where A.LastName <> B.LastName Or A.FirstName <> A.FirstName
    -- where A.SSN <> B.SSN
    order by A.LastName , A.FirstName

drop table #tmp1

select A.AccountNo , Count(*) as Count1 into #tmp1
    from impPatient15935 A
            inner join impResponsible15935 B On B.AccountNo = A.AccountNo
    group by A.AccountNo having count(*) > 1

select * from #tmp1

select A.AccountNo
        , A.LastName
        , A.FirstName
        , A.MiddleInitial
        , B.LastName
        , B.FirstName
        , B.AddressLine1
        , B.AddressLine2
        , B.City
        , B.State
        , B.ZipCode
        , B.ZipCodeExt
    from impPatient15935 A
            inner join impResponsible15935 B On B.AccountNo = A.AccountNo
            inner join #tmp1 C on C.AccountNo = A.AccountNo
    order by A.AccountNo

select A.AccountNo
        , A.LastName
        , A.FirstName
        , A.MiddleInitial
        , B.AddressLine1
        , B.AddressLine2
        , B.City
        , B.State
        , B.ZipCode
        , B.ZipCodeExt
        , A.BirthDate
        , A.Sex
        , A.Relation
        , A.SSN
        , B.AreaCode
        , B.Phone
        , A.EmployerName
        , A.EmployerAreaCode
        , A.EmployerPhone
        , A.DoctorNumber
        , A.ReferringDoctor
        , A.Carrier1
        , A.PolicyNumber1
        , A.GroupNumber1
        , A.InsuredParty1
        , A.InsuredDOB1
        , A.InsuredEmployer1
        , A.InsuredSex1
        , A.Carrier2
        , A.PolicyNumber2
        , A.GroupNumber2
        , A.InsuredParty2
        , A.InsuredDOB2
        , A.InsuredEmployer2
        , A.InsuredSex2
        , A.Carrier3
        , A.PolicyNumber3
        , A.GroupNumber3
        , A.InsuredParty3
        , A.InsuredDOB3
        , A.InsuredEmployer3
        , A.InsuredSex3
    from impPatient15935 A
            inner join impResponsible15935 B On B.AccountNo = A.AccountNo
    -- where A.employerareacode <> B.areacode
    --        and A.employerphone <> B.phone
    order by A.lastname , A.firstname

select A.*
    from impPatient15935 A
    where isnull( SSN , '' ) = '' or isnull( SSN , '' ) = '000000000'

select birthdate , 
        case 
            when isnull( birthdate , '' ) = '' then Null
            else convert( datetime , left( birthdate , 2 ) + '/' + substring( birthdate , 3 , 2 ) + '/' + right( birthdate , 4 ) ) 
        end
        from impPatient15935

usp_columns impPatient15935
usp_columns impResponsible15935

select A.* 
    from impPatient15935 A
    where isnull( A.AccountNo2 , '' ) <> isnull( A.AccountNo3 , '' )

-- ===============================
-- Referring Physician Processing.
-- ===============================

select * from impRefPhy15935

select * from impRefPhy15935

update impRefPhy15935
    set zipcode = ''
    where zipcode = '0'

update impRefPhy15935
    set zipcodeext = ''
    where zipcodeext = '0'

update impRefPhy15935
    set areacode = ''
    where areacode = '0'

update impRefPhy15935
    set phone = ''
    where phone = '0'

select * from impRefPhy15935
    where isnull( lastname , '' ) = ''
            and isnull( firstname , '' ) = ''

delete from impRefPhy15935
    where isnull( lastname , '' ) = ''
            and isnull( firstname , '' ) = ''

update impRefPhy15935
    set lastname2 = replace( lastname2 , ',' , '' )
    where lastname2 like '%,%'

select *
    from impRefPhy15935
    where lastname2 like 'ATTY%'

select doctorid into #tmp2
    from impRefPhy15935
    where lastname2 like 'ATTY%'

select * from #tmp2

select *
    from impPatient15935
    where referringdoctor in ( select doctorid from #tmp2 )

delete from impRefPhy15935 where lastname2 like 'ATTY%'

select * from impRefPhy15935 where isnull( firstname , '' ) = ''

drop table #tmp2

select doctorid into #tmp2 from impRefPhy15935 where isnull( firstname , '' ) = ''

select * from impPatient15935
    where referringdoctor in ( select doctorid from #tmp2 )

select distinct referringdoctor from impPatient15935
    where referringdoctor in ( select doctorid from #tmp2 )

delete from impRefPhy15935 where isnull( firstname , '' ) = ''

select distinct A.DoctorNumber
    from impPatient15935 A

select count(*) from impPatient15935 where doctornumber = '2'

select A.LastName
        , A.FirstName
        , A.AccountNo
        , A.ReferringDoctor
        , B.LastName
        , B.FirstName
    from impPatient15935 A
            inner join impRefPhy15935 B on A.ReferringDoctor = B.DoctorID
    where isnull( A.referringdoctor , '' ) <> '0'

alter table impRefPhy15935
    add Degree varchar(15)

usp_columns impRefPhy15935

alter table impRefPhy15935
    add LastName2 nvarchar(100)

select LastName , Replace( lastname , 'MD' , '' ) As LastName2 , FirstName , Degree from impRefPhy15935

update impRefPhy15935
    set degree = 'MD'
    where lastname like '% MD%'

update impRefPhy15935
    set lastname2 = lastname

select LastName , LastName2 , FirstName , Degree from impRefPhy15935

update impRefPhy15935
    set lastname2 = replace( lastname , 'MD' , '' )

select lastname2 as ln2 , firstname as fn , * 
    from impRefPhy15935 
    where isnull( lastname2 , '' ) <> '' and isnull( firstname , '' ) <> ''
    order by lastname2 , firstname

drop table #tmp1

select lastname2 , firstname , count(*) as rows into #tmp1
    from impRefPhy15935
    group by lastname2 , firstname having count(*) > 1
    order by lastname2 , firstname

select * from #tmp1

select A.* 
    from impRefPhy15935 A
            inner join #tmp1 B on B.lastname2 = A.lastname2 and B.firstname = A.firstname
    order by A.lastname2 , A.firstname

select A.*
    from impPatient15935 A
    where A.referringdoctor in ( 708 , 714 , 868 , 57 , 518 , 996 , 843 , 661 , 261 , 489 , 684 , 1169 , 477 , 639 )

select distinct A.referringdoctor
    from impPatient15935 A
    where A.referringdoctor in ( 708 , 714 , 868 , 57 , 518 , 996 , 843 , 661 , 261 , 489 , 684 , 1169 , 477 , 639 )

update impPatient15935
    set referringdoctor = 733
    where referringdoctor = 518

update impPatient15935
    set referringdoctor = 168
    where referringdoctor = 639

delete from impRefPhy15935
    where doctorid in ( 708 , 714 , 868 , 57 , 518 , 996 , 843 , 661 , 261 , 489 , 684 , 1169 , 477 , 639 )

select * from impRefPhy15935 where isnull( degree , '' ) = ''

select doctorid , lastname2 , firstname from impRefPhy15935 order by lastname2 , firstname

delete from impRefPhy15935 where doctorid in ( 1096 , 740 , 625 , 398 , 1036 , 285 , 1053 , 1012 , 403 , 203 , 939 , 997 , 1059 , 739 , 811 , 1154 , 756 , 1087 , 825 , 166 , 409 , 1120 , 715 , 385 , 1015 )

select doctorid , lastname2 , firstname 
    from impRefPhy15935 
    where firstname like '%MD%'
    order by lastname2 , firstname

update impRefPhy15935
    set degree = 'MD'
    where firstname like '%MD%'

update impRefPhy15935
    set firstname = replace( firstname , 'MD' , '' )
    where firstname like '%MD%'

select doctorid , lastname2 , firstname 
    from impRefPhy15935 
    where firstname like '%M.D%'
    order by lastname2 , firstname

select doctorid , lastname2 , firstname 
    from impRefPhy15935 
    where lastname like '%M.D%'
    order by lastname2 , firstname

update impRefPhy15935
    set degree = 'MD'
    where lastname like '%M.D%'

update impRefPhy15935
    set lastname = replace( lastname , 'M.D' , '' )
    where lastname like '%M.D%'

update impRefPhy15935
    set lastname2 = replace( lastname2 , 'M.D' , '' )
    where lastname2 like '%M.D%'

delete from impRefPhy15935 where doctorid in ( 591 , 1093 , 894 , 927 , 969 , 596 )

select doctorid , lastname2 , firstname
    from impRefPhy15935 
    where lastname like '%.%'
    order by lastname2 , firstname

update impRefPhy15935
    set lastname = replace( lastname , '.' , '' )
        , lastname2 = replace( lastname2 , '.' , '' )
    where lastname like '%.%'

select doctorid , lastname2 , firstname
    from impRefPhy15935 
    where firstname like '%.%'
    order by lastname2 , firstname

update impRefPhy15935
    set firstname = replace( firstname , '.' , '' )
    where firstname like '%.%'

select * from impPatient15935 where referringdoctor = 81

select doctorid , lastname2 , firstname , dbo.fn_GetName2( RTRIM( lastname2 ) + ' ' + firstname , 'M' , 'LFM' )
    from impRefPhy15935 order by lastname2 , firstname

select doctorid , lastname2 , firstname 
        , CharIndex( ' ' , firstname )
        , dbo.fn_GetName2( firstname , 'F' , 'FM' ) As FirstName2
        , dbo.fn_GetName2( firstname , 'M' , 'FM' ) As MiddleInitial
    from impRefPhy15935
    where CharIndex( ' ' , firstname ) = 2
    order by lastname2 , firstname

select dbo.fn_GetName2( 'MARC A' , 'M' , 'FM' )
select dbo.fn_GetName2( 'M RIAZ' , 'M' , 'FM' )

usp_columns doctor
go
usp_columns impRefPhy15935

-- =============================
-- Insurance Company Processing.
-- =============================

select * from insurancecompany
select * from insurancecompanyplan

select * from impCarrier15935

update impCarrier15935
    set zipcodeext = ''
    where zipcodeext = '0'

update impCarrier15935
    set areacode = ''
    where areacode = '0'

update impCarrier15935
    set phone = ''
    where phone = '0'

update impPatient15935
    set carrier1 = ''
    where carrier1 = '0'

update impPatient15935
    set carrier2 = ''
    where carrier2 = '0'

update impPatient15935
    set carrier3 = ''
    where carrier3 = '0'

select max( len( carrierid ) ) from impCarrier15935

select A.LastName
        , A.FirstName
        , A.AccountNo
        , A.Carrier1
        , A.Carrier2
        , A.Carrier3
        , B.CarrierName
    from impPatient15935 A
            left outer join impCarrier15935 B on A.Carrier1 = B.CarrierID

select distinct Carrier1 
        , replicate( '0' , 5 - ( datalength( carrier1 ) / 2 ) ) + carrier1 as NewCarrier1
    into #tmp2
    from impPatient15935 
    where carrier1 <> '0'
    order by carrier1

drop table #tmp2

select distinct Carrier1 As CarrierID , replicate( '0' , 5 - ( datalength( carrier1 ) / 2 ) ) + carrier1 as NewCarrierID
    into #tmp2
    from impPatient15935 
    where carrier1 <> '0'
union
select distinct Carrier2 As CarrierID , replicate( '0' , 5 - ( datalength( carrier2 ) / 2 ) ) + carrier2 as NewCarrierID
    from impPatient15935 
    where carrier2 <> '0'
union
select distinct Carrier3 As CarrierID , replicate( '0' , 5 - ( datalength( carrier3 ) / 2 ) ) + carrier3 as NewCarrierID
    from impPatient15935 
    where carrier3 <> '0'
    order by NewCarrierID


usp_columns impPatient15935

select A.*
        , B.CarrierName
    from #tmp2 A
            inner join impCarrier15935 B on A.NewCarrierID = B.CarrierID

alter table impPatient15935
    add NewCarrierID1 Varchar(5)

alter table impPatient15935
    add NewCarrierID2 Varchar(5)

alter table impPatient15935
    add NewCarrierID3 Varchar(5)

-- Carrier 1.
update A
    set NewCarrierID1 = replicate( '0' , 5 - ( datalength( carrier1 ) / 2 ) ) + Carrier1
    from impPatient15935 A
    where isnull( A.carrier1 , '' ) <> '' And isnull( carrier1 , '' ) <> '0'

select A.carrier1 , A.NewCarrierID1 from impPatient15935 A

select count(*) from impPatient15935 A where isnull( carrier1 , '' ) <> '' and isnull( carrier1 , '' ) <> '0'
select count(*) 
    from impPatient15935 A 
            inner join impCarrier15935 B on A.NewCarrierID1 = B.CarrierID
    where isnull( A.carrier1 , '' ) <> '' and isnull( A.carrier1 , '' ) <> '0'

-- Carrier 2.
update A
    set NewCarrierID2 = replicate( '0' , 5 - ( datalength( carrier2 ) / 2 ) ) + Carrier2
    from impPatient15935 A
    where isnull( A.carrier2 , '' ) <> '' And isnull( carrier2 , '' ) <> '0'

select A.carrier2 , A.NewCarrierID2 from impPatient15935 A

select count(*) from impPatient15935 A where isnull( carrier2 , '' ) <> '' and isnull( carrier2 , '' ) <> '0'
select count(*) 
    from impPatient15935 A 
            inner join impCarrier15935 B on A.NewCarrierID2 = B.CarrierID
    where isnull( A.carrier2 , '' ) <> '' and isnull( A.carrier2 , '' ) <> '0'

-- Carrier 3.
update A
    set NewCarrierID3 = replicate( '0' , 5 - ( datalength( carrier3 ) / 2 ) ) + Carrier3
    from impPatient15935 A
    where isnull( A.carrier3 , '' ) <> '' And isnull( carrier3 , '' ) <> '0'

select A.carrier3 , A.NewCarrierID3 from impPatient15935 A where isnull( carrier3 , '' ) <> '0'

select count(*) from impPatient15935 A where isnull( carrier3 , '' ) <> '' and isnull( carrier3 , '' ) <> '0'
select count(*) 
    from impPatient15935 A 
            inner join impCarrier15935 B on A.NewCarrierID3 = B.CarrierID
    where isnull( A.carrier3 , '' ) <> '' and isnull( A.carrier3 , '' ) <> '0'

select A.* from impCarrier15935 A
select A.* from InsuranceCompany A

select A.* from impCarrier15935 A where isnull( A.ContactName , '' ) <> ''

usp_columns impCarrier15935
usp_columns InsuranceCompany

select A.* from impCarrier15935 A
        inner join superbill_0001_prod.dbo.InsuranceCompany B On A.CarrierName = B.InsuranceCompanyName
    where A.ZipCode = B.ZipCode And A.AddressLine1 = B.AddressLine1

-- ==================
-- Insurance Policies
-- ==================

select accountno , count(*) from impPatient15935 group by accountno having count(*) > 1

select A.AccountNo
        , A.LastName
        , A.FirstName
        , A.InsuredParty1
        , A.NewCarrierID1
        , A.PolicyNumber1
        , A.GroupNumber1
        , A.InsuredDOB1
        , A.InsuredSex1
    from impPatient15935 A
        inner join ( select accountno from impPatient15935 group by accountno having count(*) > 1 ) B on B.accountno = A.accountno
    order by A.accountno , A.lastname , A.firstname

select A.AccountNo
        , A.LastName
        , A.FirstName
        , A.InsuredParty1
        , A.NewCarrierID1
        , A.PolicyNumber1
        , A.GroupNumber1
        , A.InsuredDOB1
        , A.InsuredSex1
    from impPatient15935 A
    where isnull( A.NewCarrierID1 , '' ) <> ''
    order by A.accountno , A.lastname , A.firstname

select * from vendorimport

usp_columns impPatient15935

Select A.LastName
        , A.FirstName
    From Patient A
            Inner Join impPatient15935 B On B.Account
    Where A.VendorImportID = 9
        
    

-- =================

select * from superbill_0001_prod.dbo.practice

select * from superbill_0001_prod.dbo.doctor where practiceid = 124

select * from superbill_0001_prod.dbo.patient where practiceid = 124

select * from practice

insert into practice
( [Name] )
values
( 'Dr Gary Ray' )

select * from patient order by lastname , firstname

select * from vendorimport

select lastname , firstname , count(*) 
    from patient
    where vendorimportid = 3
    group by lastname , firstname having count(*) > 1

drop table #tmp1

select lastname , firstname , count(*) as count1 into #tmp1
    from impPatient15935
    group by lastname , firstname having count(*) > 1

select * from #tmp1

select A.accountno , A.lastname , A.firstname , A.*
    from impPatient15935 A
    where A.lastname = 'ROBINSON' and A.firstname = 'ANNETTE'

select *
    from impRefPhy15935

select lastname2 , firstname
    from impRefPhy15935
    where isnull( firstname , '' ) = ''

select lastname2 , firstname , count(*) as c1
    from impRefPhy15935
    where isnull( firstname , '' ) <> ''
    group by lastname2 , firstname having count(*) > 1

-- ==============
-- Data Cleaning.
-- ==============
select * from impPatient15935

update impPatient15935
    set referringdoctor = ''
    where referringdoctor = '0'

update impPatient15935
    set employerphone = ''
    where employerphone = '0'

select * from impResponsible15935

update impResponsible15935
    set zipcodeext = ''
    where zipcodeext = '0'

update impResponsible15935
    set phone = ''
    where phone = '0'

update impResponsible15935
    set ssn = ''
    where ssn = '0'

update impPatient15935
    set ssn = ''
    where ssn = '000000000'

update impPatient15935
    set employername = ''
    where ltrim( rtrim( isnull( employername , '' ) ) ) = '.'

-- ==============

select * from vendorimport order by vendorimportid desc

usp_deleteimport 5

usp_columns patient

select * from doctor where [external] = 0

select * from impRefPhy15935 where doctorid = '2'

select distinct A.lastname , A.firstname , A.accountno , A.referringdoctor , C.lastname2 as DrLastName , C.firstname as DrFirstName
    from impPatient15935 A
            inner join patient B on B.vendorid = A.accountno
            inner join impRefPhy15935 C on C.doctorid = A.referringdoctor
    where B.vendorimportid = 6
            and isnull( A.referringdoctor , '' ) <> ''
    order by A.lastname , A.firstname

select count(*) from impPatient15935 where isnull( referringdoctor , '' ) <> ''

-- ===
select * from vendorimport

usp_deleteimport 18

select * from insurancecompany where vendorimportid = 7

usp_columns insurancecompanyplan

select A.accountno , A.lastname , A.firstname , A.patientnumber , A.carrier1 , A.newcarrierid1 , A.newcarrierid2 , A.newcarrierid3
    from impPatient15935 A
    -- where isnull( A.newcarrierid1 , '' ) <> ''
    -- where isnull( A.newcarrierid2 , '' ) <> ''
    where isnull( A.newcarrierid3 , '' ) <> ''
    order by A.accountno , A.lastname , A.firstname

drop table #tmp1

select A.patientcaseid , count(*) as c1 into #tmp1
    from insurancepolicy A
    where A.vendorimportid = 16
    group by A.patientcaseid having count(*) > 1

select * from #tmp1

select A.lastname
        , A.firstname
        , A.vendorid
    from patient A
            inner join patientcase B on B.patientid = A.patientid
            inner join #tmp1 C on C.patientcaseid = B.patientcaseid
    order by A.lastname , A.firstname

select * from impPatient15935 where accountno in (  '14408' , '16530' , '19535' , '5392' )
select * from impPatient15935 where accountno in (  '14409' )

update impPatient15935
    set patientnumber = 2
    where accountno = '14409'
            and [column 1] = '21'

select A.lastname
        , A.firstname
        , A.accountno
    from impPatient15935 A
            inner join patient B on B.vendorid = A.accountno
            inner join patientcase C on C.patientid = B.patientid
            inner join #tmp1 D on D.patientcaseid = C.patientcaseid
    order by A.lastname , A.firstname


drop table #tmp2

select A.AccountNo , Count(*) as Count1 into #tmp2
    from impPatient15935 A
            -- inner join impResponsible15935 B On B.AccountNo = A.AccountNo
    group by A.AccountNo having count(*) > 1

select * from #tmp2

select A.accountno
        , A.patientnumber
        , A.firstname
        , A.lastname
        , A.newcarrierid1
        , A.newcarrierid2
        , A.newcarrierid3
    from impPatient15935 A
            inner join #tmp2 B on B.accountno = A.accountno
    order by A.accountno

select distinct A.AccountNo
        , A.[Column 1]
        , A.LastName
        , A.FirstName
        , A.MiddleInitial
        , B.LastName
        , B.FirstName
        , B.AddressLine1
        , B.AddressLine2
        , B.City
        , B.State
        , B.ZipCode
        , B.ZipCodeExt
    from impPatient15935 A
            inner join impResponsible15935 B On B.AccountNo = A.AccountNo and B.[Column 1] = A.[Column 1]
            -- inner join #tmp2 C on C.AccountNo = A.AccountNo
    order by A.AccountNo

select A.vendorid , count(*) as c1
    from patient A
    where vendorimportid = 18
    group by A.vendorid having count(*) > 1

select A.*
    from impPatient15935 A
    where A.accountno in ( '14409' , '144092' )

select A.*
    from impResponsible15935 A
    where A.accountno in ( '14409' , '144092' )

select distinct patientcaseid from insurancepolicy

select * from vendorimport order by vendorimportid desc

select A.lastname
        , A.firstname
        , A.medicalrecordnumber
        , A.vendorid
    from patient A
    where A.vendorimportid = 22
        
Select C.VendorID
        , B.Name
		, C.LastName
		, C.FirstName
		, C.MiddleName
		, E.InsuranceCompanyName
		, D.PlanName As PlanName
		, A.PolicyNumber
		, A.GroupNumber
		, Convert( Char(10) , A.PolicyStartDate , 101 ) As PolicyStartDate
		, Convert( Char(10) , A.PolicyEndDate , 101 ) As PolicyEndDate
	From InsurancePolicy A
			Inner Join PatientCase B On A.PatientCaseID = B.PatientCaseID
			Inner Join Patient C On B.PatientID = C.PatientID
			Inner Join InsuranceCompanyPlan D On A.InsuranceCompanyPlanID = D.InsuranceCompanyPlanID
			Inner Join InsuranceCompany E On D.InsuranceCompanyID = E.InsuranceCompanyID
	Where A.VendorImportID = 23
			And Precedence = 2
   Order By C.LastName , C.FirstName

usp_deleteimport 22


select * from impRefPhy15935 where isnull( zipcode , '' ) <> ''

select *
    from impPatient15935
    where isnull( employername , '' ) <> ''
    order by lastname , firstname

usp_columns impCarrier15935

select A.lastname , A.firstname , A.newcarrierid1 , B.carriername , A.policynumber1 , A.groupnumber1 , A.employername
    from impPatient15935 A
            inner join impCarrier15935 B on B.carrierid = A.newcarrierid1
    where isnull( newcarrierid1 , '' ) <> ''
    order by B.carriername
    order by A.lastname , A.firstname


select A.lastname , A.firstname , A.newcarrierid2 , B.carriername , A.policynumber2 , A.groupnumber2
    from impPatient15935 A
            inner join impCarrier15935 B on B.carrierid = A.newcarrierid2
    where isnull( newcarrierid2 , '' ) <> ''
    order by B.carriername
    order by A.lastname , A.firstname

select A.lastname , A.firstname , A.newcarrierid3 , B.carriername , A.policynumber3 , A.groupnumber3
    from impPatient15935 A
            inner join impCarrier15935 B on B.carrierid = A.newcarrierid3
    where isnull( newcarrierid3 , '' ) <> ''
    order by A.lastname , A.firstname


select distinct employername from impPatient15935

usp_columns impPatient15935

select * from vendorimport

usp_deleteimport 26

select * from employers

select * from impPatient15935 where ltrim( rtrim( isnull( employername , '' ) ) ) = '.'

usp_deleteimport 101

select * from vendorimport

    Update A
        Set PrimaryProviderID = C.DoctorID
        From Patient A
                Inner Join impPatient15935 B On B.AccountNo + B.PatientNumber = A.VendorID
                Inner Join Doctor C On C.VendorID = B.DoctorNumber
        Where IsNull( B.DoctorNumber , '' ) <> ''
                And A.VendorImportID = 27

    Update A
        Set ReferringPhysicianID = C.DoctorID
        From Patient A
                Inner Join impPatient15935 B On B.AccountNo + B.PatientNumber = A.VendorID
                Inner Join Doctor C On C.VendorID = B.ReferringDoctor
        Where IsNull( B.ReferringDoctor , '' ) <> ''
                And A.VendorImportID = 27


-- Deployment into production.
use superbill_0001_prod

select * from practice order by practiceid

select * from vendorimport order by vendorimportid desc

select * from doctor where practiceid = 124

update doctor
    set vendorid = '2'
    where doctorid = 21257

select * into #tmp1 from impCarrier15935 where isnull( carriername , '' ) = ''

select A.*
    from impPatient15935 A
            inner join #tmp1 B on B.carrierid = A.newcarrierid3

select * from impCarrier15935 where isnull( carriername , '' ) = ''

delete from impCarrier15935 where isnull( carriername , '' ) = ''

select count(*) from impPatient15935
select count(*) from impResponsible15935
select count(*) from impRefPhy15935

select * from superbill_shared.dbo.customer

    Select Distinct 
            A.EmployerName 
        into #tmp2
        From impPatient15935 A
        Where IsNull( A.EmployerName , '' ) <> ''

Select A.*
    from #tmp2 A
            inner join employers B on B.employername = A.employername

usp_deleteimport 101

alter table employers
    add VendorImportID INt

alter table contractfeeschedule
    add VendorImportID Int

select count(*) from impPatient15935 where isnull( referringdoctor , '' ) <> ''

select A.lastname , A.firstname , A.newcarrierid1 , B.carriername , A.policynumber1 , A.groupnumber1 , A.employername
    from impPatient15935 A
            inner join impCarrier15935 B on B.carrierid = A.newcarrierid1
    where isnull( newcarrierid1 , '' ) <> ''
    order by A.lastname , A.firstname


select A.lastname , A.firstname , A.newcarrierid2 , B.carriername , A.policynumber2 , A.groupnumber2
    from impPatient15935 A
            inner join impCarrier15935 B on B.carrierid = A.newcarrierid2
    where isnull( newcarrierid2 , '' ) <> ''
    order by A.lastname , A.firstname

select A.lastname , A.firstname , A.newcarrierid3 , B.carriername , A.policynumber3 , A.groupnumber3
    from impPatient15935 A
            inner join impCarrier15935 B on B.carrierid = A.newcarrierid3
    where isnull( newcarrierid3 , '' ) <> ''
    order by A.lastname , A.firstname


drop procedure usp_deleteimport

drop function dbo.fn_getname2
